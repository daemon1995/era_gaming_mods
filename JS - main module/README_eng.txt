The mod is a set of templates, plugins, options, fixes, and improvements configurable via json:
/Lang/jsmainmodule_settings.json


For proper operation, the mod requires:
- Era Erm Framework
- Game Enhancement Mod
- Wog Fix Lite


List of new templates for random maps:
- M TestTempl (for testing)
- XL Slater Ring
- XXL Big Ring (requires XXL mod)


List of plugins:
- Accumulate_Creatures_In_Dwellings.dll – if an external dwelling is captured, it accumulates creatures from week to week
- always_3_army_stack_and_2_lvl_creature_building_built.dll – the player always starts with a full army, and the player's starting castle has the level 2 creature building constructed
- ConfluxDwellingType20.era – external dwelling of Conflux creatures with 4 slots grants +1 Conflux bonus to all four elementals for the player, not just air elementals
- HotA_Pathfinding_and_WayfarersBoots.era – Pathfinding works as in HotA; added artifact from HotA – Wayfarer's Boots (requires JS submodule – emerald)
- HotA_SpecBonus.era – hero specializations for creatures and spells work as in HotA
- InstantAnim.dll – adds continuous animation to creatures in battle, as in HotA
- RMG_MapGenerationFixes.era – sets the width of all passages between zones on random maps to one cell


List of new graphics for objects:
- AVSutop5.def – Dragon Utopia for swamp terrain
- AVSutop8.def – Dragon Utopia for lava terrain
- AVXfyth7.def – Fountain of Youth for underground terrain
- AVTmystd.def – Mystic Garden for mud terrain
- avtprosp.def – Mystic Garden for sand and underground terrain
- AVXstbl7.def – Stables for lava and underground terrain
- AVXtrek2.def – Tree of Wisdom for sand terrain
- AVXtrek5.def – Tree of Wisdom for swamp terrain
- AVXtrek3.def – Tree of Wisdom for rocky terrain (taken from WoG base build)
- AVXtrek7.def – Tree of Wisdom for lava and underground terrain
- HAExit01.def – Gates of the Underworld for underground terrain
- avmoilpm.def – Water Wheel for underground terrain


List of options:
- see jsmainmodule_settings.json: the list contains over 30 options, each with a description of its effect and compatibility with WoG options
- to disable an option, change the "value" key from true to false, and vice versa


Configurable WoG-ification of artifacts and banners:
- see jsmainmodule_wogify.json: WoG-ification of artifacts and banners is organized and customizable; you can specify which artifact types to replace and with what chance


Other changes:
- AI_Value of monsters adjusted according to HotA
- value, density, and zone restrictions of objects adjusted according to HotA
- added ability for controlled area shot on creatures with MON_FLAG_SPLASH_SHOOTER by pressing G
- necromancy forbidden for elementals and mechanical creatures
- "water" artifacts, spells, and Navigation are forbidden on "land" maps; Heroes with the Navigation specialization are replaced by HotA heroes (Beatrice, Kinkeria)
- Hourglass of Unfavorable Hour neutralizes luck only if it is positive
- added sounds for partial and full block abilities
- added animation for full block
- minefield spell animation sped up
- explosion spell animation replaced with HotA version
