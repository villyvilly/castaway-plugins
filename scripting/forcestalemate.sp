#include <sourcemod>
#include <sourcescramble>

public Plugin myinfo = {
    name = "Force Stalemate",
    author = "random",
	description = "Force stalemates when map time runs out",
	version = "1.0",
	url = "https://castaway.tf"
};

MemoryPatch patch_Force_bTeamsAreDrawn_Always_True;

public void OnPluginStart() {
	Handle conf;
	conf = LoadGameConfigFile("stalemate");
	if (conf == null) SetFailState("Failed to load stalemate conf");
	patch_Force_bTeamsAreDrawn_Always_True = 
		MemoryPatch.CreateFromConf(conf,
		"Force_bTeamsAreDrawn_Always_True");
	if (!ValidateAndNullCheck(patch_Force_bTeamsAreDrawn_Always_True)) SetFailState("Failed to create Force_bTeamsAreDrawn_Always_True");
	delete conf;
	patch_Force_bTeamsAreDrawn_Always_True.Enable();
}

bool ValidateAndNullCheck(MemoryPatch patch) {
	return (patch.Validate() && patch != null);
}
