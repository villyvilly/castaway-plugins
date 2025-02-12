#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Voting Bans",
	author = "random",
	description = "Disable specific player's ability to vote",
	version = "1.0",
	url = "https://github.com/rsedxcftvgyhbujnkiqwe/castaway-plugins"
};

bool g_VotingBan[MAXPLAYERS];

/*
	This plugin is a niche use case.
	As such, to preserve minimalism
	there is no user interaction, this
	merely reads off manually input SQL.
*/

Database hDatabase;

public void OnPluginStart()
{
	AddCommandListener(Cmd_Callvote, "callvote");
	Database.Connect(GotDatabase,"voteban");
}

Action Cmd_Callvote(int client, const char[] command, int argc) {
    return g_VotingBan[client] ? Plugin_Stop : Plugin_Continue;
}

public void GotDatabase(Database db, const char[] error, any data)
{
	if (!db || error[0]) SetFailState("Database connection failure: %s",error);

	hDatabase = db;

	char query[256];
	hDatabase.Format(query,sizeof(query), "CREATE TABLE IF NOT EXISTS votebans (steamid INT PRIMARY KEY, expiry TIMESTAMP NOT NULL, name TEXT, reason TEXT);");
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
	g_VotingBan[client] = true;
}

public void OnClientDisconnect(int client)
{
	g_VotingBan[client] = false;
}