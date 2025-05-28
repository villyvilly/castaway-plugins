#define PLUGIN_NAME         "Force Stalemate"
#define PLUGIN_VERSION      "1.0"
#define PLUGIN_AUTHOR       "random"
#define PLUGIN_DESCRIPTION  "Force stalemates when map time runs out"

#include <sourcemod>
#include <sourcescramble>

public Plugin myinfo = {
    name = PLUGIN_NAME,
    author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
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
