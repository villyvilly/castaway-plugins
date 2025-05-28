//This plugin only has gamedata for linux for the time being
//it will NOT work on windows!!!!!!!!

#include <sourcemod>
#include <sourcescramble>

public Plugin myinfo = {
    name = "Force Stalemate",
    author = "random, VerdiusArcana",
	description = "Force stalemates when map time runs out",
	version = "1.0",
	url = "https://castaway.tf"
};

MemoryPatch patch_ForceAlways_StalemateOrOvertime;

public void OnPluginStart() {
	Handle conf;
	conf = LoadGameConfigFile("stalemate");
	if (conf == null) SetFailState("Failed to load stalemate conf");
	patch_ForceAlways_StalemateOrOvertime = 
		MemoryPatch.CreateFromConf(conf,
		"ForceAlways_StalemateOrOvertime");
	if (!ValidateAndNullCheck(patch_ForceAlways_StalemateOrOvertime)) SetFailState("Failed to create ForceAlways_StalemateOrOvertime");
	delete conf;
	patch_ForceAlways_StalemateOrOvertime.Enable();
}

bool ValidateAndNullCheck(MemoryPatch patch) {
	return (patch.Validate() && patch != null);
}
