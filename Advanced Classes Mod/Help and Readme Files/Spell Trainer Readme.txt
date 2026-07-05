Spell Trainer
Readme updated October 2022

Let me explain some of the internal mechanics of the Spell Trainer mod using examples.

In order to level up spells, your hero must have mastered the relevant magic school. You cannot level up basic Haste or basic Lightning Bolt.
Damage spells deal an additional 3% damage for every enemy stack killed with that spell. Therefore, your spell must deal the lethal blow to the entire stack! AOE spells such as Chain Lightning, Death Ripple and Armageddon have a one in four chance of levelling up with each cast.
Some spells cannot level up when killing low-level tier units. For example, to level up Implosion, your spell must kill a stack of level 3 units. For level 4 spells, killing a stack of level 2 units is enough.
Spells can be levelled up to the hero level with a 100% success rate. The chances of levelling up decrease for every level higher than the hero level. To check the level of your spell, look in your spell book, or right-click your spell book to see an overview of all your spells.

Example: If your hero is level 10 and you want to level up your Implosion spell to level 11, there is only a 90% chance of success.
If your spell is level 11 and you want to reach level 12, you only have an 80% chance of success, and so on. Therefore, your spell can never be more than 10 levels higher than your hero level. 


Level-ups are set individually for every buff/debuff spell.
They mostly follow this pattern: Level-ups at 3, 6, 15, 25, 40, 70, etc.
There are no restrictions on levelling up buff spells, except that you will need to cast them many times if you want to reach very high levels.
Protection from Elements and Summoning Elements level up together!
Note: killing the last unit with a spell and ending combat will still add to your cast count!

To check your current chance of levelling up spells, right-click the experience icon on the hero screen.
Chance to perform a spell upgrade during combat:

Warrior Class: +10%
Adventurer Class: +25%
Mage Class: +40%
Scholar Class: +25%
Mage Class Points: +x%
Ring of Conjuring Artifact: +15%

Remember that there are three different hero classes in the ACM mod, not two. Example: Solmyr = Mage class, Kyrre = Adventurer class, Crag Hack = Warrior class. To check your current chance, right-click your spellbook or the Knowledge icon on the Hero screen.

Example:
If Solymr has 20 Mage Class points, the Colar of Conjuring artefact equipped, and is an expert in Air Magic, he would have an 82% chance of increasing his Haste cast counter by 1 when casting Haste in combat. If he does this successfully 10 times and his counter reaches 10 casts, his Haste spell will improve by +1 and the effect will be improved by 1 speed.
This means he has used one spell upgrade per combat. If Solymr can perform two spell upgrades per combat, he can also increase the effectiveness of his Lightning Bolt spell by 3% by killing enemies. This would mean that he has used two spell upgrades in this combat.


The number of possible Spell Upgrades per Combat is determined as follows:
Warrior Class: 0
Adventurer Class: 0
Mage Class: +1
Scholar Basic: +1
Scholar Expert: +1
Scholar Grandmaster: +1
Collar of Conjuring: +1
Druid: +1
Battlemage: +1
Grandmaster Mage: +1

To increase your Haste spell to the next level, you will need to cast more than at the previous level. There is no limit, but to reach level 10 from level 9, you will need over 100 extra casts.

What does this mean for Crag Hack when he casts Haste as an Expert in Air Magic? He only has a 20% chance (10% + some Mage class points) that his casts will add to his cast counter because it only has a 20% chance of succeeding. Therefore, on average, he needs to perform five times more casts than a skilled wizard to achieve the same result and level up his Haste spell.

This system ensures that the Mage class can mainly perform spell upgrades. However, with a little investment, Warriors and Adventurers can also perform spell upgrades, particularly if they choose the Scholar specialisation or wear artefacts.


The artefacts for upgrading are as follows:
Collar of Conjuring: +1 spell upgrade per combat
Ring of Conjuring: +15% chance for spell upgrade
Cape of Conjuring: increases the maximum level for your damage spells by 5!
The Ring of the Magi upgrades damage spells twice as fast! + all of the other bonuses.



Supported spells:

Damage Spells:

Magic Arrow
Lightning Bolt
Frost Bolt
Fireball
Meteor Shower
Implosion
Chain Lightning
Inferno
Frost Ring
Destroy Undead
Death Ripple
Fire Wall
Land Mine
Armageddon

Buffs/Debuffs:

Shield
Air Shield
Fire Shield
Bless
Curse
Stoneskin
Weakness
Precision
Bloodlust
Slow
Haste
Protection from Elements
Summoning Elements
Animate Dead
Resurrection
Disrupting Ray
Prayer
Slayer
Frenzy
Mirth
Sorrow
Fortune
Misfortune
Cure



Update version 1.1:
- AOE spell now also level up when hitting more than 1 target
- fixed level up, when creature was not killed with a spell
- fixed random Upgrade for AI at the beginning of battle 
- fixed wrong value calculation for Death Ripple, Destroy Undead, Ressurection and Animate Dead
- Replaced 2 flags which were used by other mods
- added few more levels for some buffs


Update version 1.3:
- removed/replaced all Hero Vars (wxxx) 
- added Spell Upgrade List

Update version 1.4:
- expanded max levels of buffs
- if wearing ring of magi it will now say the correct 8% damage increase in battle log
- fixed weakness not leveling up


Update version 1.5:
- removed the mandatory for Scholar to level up Spells*
- reduced the gain for damage spells from 4% to 3% per level
- added option for you to easily change the % value with ERM editor, so no more whining about imbalance and more customization YEAH
- changed the level up for Chain Lightning, now chance is 25% to level up, regardless of which monster you kill (before it was very unreliable)
- added a message at game start if mod is run together with Scaling Magic Mod. While they do work together spells can become very strong later on.


Update version 1.6:
- added several missing spells like Fortune,Cure,Land Mine ...
- slightly changed level up mechanics. Now we have Might and Magic class heroes who have different chance to level spells. See rules.

Update version 1.62:
- Removed Functions numbers higher than 30000 to restore compatibility with ERA Scripts 1.37

Update version 1.63:
- Better compatibility with Advanced Classes Mod

**To change the value open the script with ERM editor and change the value in line: !#SN:W^Damage_Spells_Increment^/3;  [Change the Increment for Damage Spells in this Line e.g. change 3 to 2 or 3 to 5]
