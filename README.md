## Introduction
Repository for plugins used on [castaway.tf](https://castaway.tf/)

The only entirely custom plugins here are ones credited to random (chat-adverts, votingbans, etc.). Everything else is a plugin made by someone else. The credits for said plugins can be found unmodified at the top of each plugin's .sp file.

This is not a comprehensive list of all plugins used on the server, however it does include all the most relevant ones to the player experience such as the map voting, team scrambling, and weapon revert plugins. 

## Compiling

To compile the plugins, download a recent Sourcemod stable version and merge the scripting directory into the scripting directory of this repo, then use `./compile.sh <plugin_name>` to compile each plugin. 

The reverts plugin has the following dependencies:
- [TF2Items](https://github.com/nosoop/SMExt-TF2Items)
- [TF2Attributes](https://github.com/FlaminSarge/tf2attributes)
- [TF2Utils](https://github.com/nosoop/SM-TFUtils)

No other plugins have any external dependencies, and the include files for the above dependencies are within this repo.

## Additional Credits
Some or all of these plugins have been modified in some way, sometimes in major ways. I do not claim credit for these plugins and all credit goes to their original creators.

* reverts.sp - This plugin is mostly a modification of bakugo's [weapon revert plugin](https://github.com/bakugo/sourcemod-plugins), however in order to add onto it I have occasionally taken some code from NotnHeavy's gun mettle revert plugin. It has since been deleted from github, however a copy of the code can be found unmodified in the scripting/legacy directory, and the gamedata in gamedata/legacy.
* votescramble - This plugin comes from the [uncletopia plugin repo](https://github.com/leighmacdonald/uncletopia) 
* nativevotes-* - This is sapphonie's [nativevotes-updates](https://github.com/sapphonie/sourcemod-nativevotes-updated), with some small modifications and bug fixes.