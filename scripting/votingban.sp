#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Voting Bans",
	author = "random",
	description = "Disable specific player's ability to votekick",
	version = "1.0",
	url = "https://github.com/rsedxcftvgyhbujnkiqwe/castaway-plugins"
};

#undef REQUIRE_PLUGIN
#include <nativevotes>
#define REQUIRE_PLUGIN

#define LIBRARY "nativevotes"

/*
	This plugin is a niche use case.
	As such, to preserve minimalism
	there is no user interaction, this
	merely reads off manually input SQL.
*/

Database hDatabase;
bool g_VotingBan[MAXPLAYERS];
bool g_NativeVotes;
bool g_Listener;

public void OnPluginStart()
{
	Database.Connect(GotDatabase,"voteban");
}

public void OnAllPluginsLoaded()
{
	g_NativeVotes = LibraryExists(LIBRARY) && NativeVotes_IsVoteTypeSupported(NativeVotesType_Kick);
	if(!g_NativeVotes)
	{
		AddCommandListener(Cmd_Callvote, "callvote");
		g_Listener = true;
	}
}

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, LIBRARY, false) && NativeVotes_IsVoteTypeSupported(NativeVotesType_Kick))
	{
		g_NativeVotes = true;
		if(g_Listener) RemoveCommandListener(Cmd_Callvote, "callvote");
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, LIBRARY, false))
	{
		g_NativeVotes = false;
		if(!g_Listener) AddCommandListener(Cmd_Callvote, "callvote");
	}
}

public Action KickVoteHandler(int client, NativeVotesOverride overrideType, const char[] voteArgument, NativeVotesKickType kickType, int target) {
	return (kickType == NativeVotesKickType_None) ? Plugin_Continue : (g_VotingBan[client] ? Plugin_Stop : Plugin_Continue);
}

Action Cmd_Callvote(int client, const char[] command, int argc) {
	return g_VotingBan[client] ? Plugin_Stop : Plugin_Continue;
}

public void GotDatabase(Database db, const char[] error, any data)
{
	if (!db || error[0]) SetFailState("Database connection failure: %s",error);

	hDatabase = db;

	char query[256];
	hDatabase.Format(query,sizeof(query), "CREATE TABLE IF NOT EXISTS votebans (steamid INT, expiry TIMESTAMP NOT NULL, name TEXT, reason TEXT);");
	hDatabase.Query(QueryResult_GotDatabase,query);
}

stock bool QueryErrored(Database db, DBResultSet results, const char[] error)
{
	return !db || !results || error[0];
}

public void QueryResult_GotDatabase(Database db, DBResultSet results, const char[] error, any data)
{
	if(QueryErrored(db,results,error)) SetFailState("Database creation failure: %s",error);
}

public void OnClientAuthorized(int client, const char[] auth)
{
	if(hDatabase==null) return;

	//steam32 ID
	int steamId = GetSteamAccountID(client);
	char query[256];
	hDatabase.Format(query,sizeof(query),"SELECT * FROM votebans WHERE steamid = %d AND expiry > CURRENT_TIMESTAMP",steamId);
	hDatabase.Query(QueryResult_GetBans,query,GetClientSerial(client));
}

public void QueryResult_GetBans(Database db, DBResultSet results, const char[] error, int serial)
{
	int client = GetClientFromSerial(serial);
	if(QueryErrored(db,results,error)) LogError("Error querying ban for %N",client);
	if (!client || !results.FetchRow()) return;
	PrintToServer("Client %N banned from voting",client)
	g_VotingBan[client] = true;
}

public void OnClientDisconnect(int client)
{
	g_VotingBan[client] = false;
}