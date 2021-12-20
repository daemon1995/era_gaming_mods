**Spell Trainer**
Readme Updated on Mai 2021

Let me explain some of the internal mechanics of the Spell Trainer mod with some examples.

Damage spells receive +3%** damage for every enemy stack killed with that spell. So your spell has to deal the lethal blow. Chain Lightning, Death Ripple and Armageddon have a 1 out of 4 chance to level up with each cast.
Some spells can not level up when killing low-level tier units. E.g. to level up Implosion don't kill imps, better kill level 3 and upwards.
Spells can be leveled equally to hero level with 100% success rate. For every level higher then hero level chances are decreasing for level up.
Example: Your hero has level 10 and you want to level your implosion to level 11 you only have 90% chance to level up.
If your spell is level 11 and you want to reach 12 your chance is only 80%... and so on. So your spell can never be 10 levels ahead from your hero level. Also, your hero has to be an expert in the corresponding magic school. You cannot level basic Haste for example.

**To change the value open the script with ERM editor and change the value in line: !#SN:W^Damage_Spells_Increment^/3;  [Change the Increment for Damage Spells in this Line e.g. change 3 to 2 or 3 to 5]

Level-ups are set individually for every spell.
It mostly follows this pattern: Level ups at 3,6,15,25,40,70 ect... uses
There is no restriction for level up buff spells except that you will need a lot of casts if you want to reach very high levels.
Protection from Elements and Summoning Elements level up together!
Note: When the last unit killed with a spell and combat ends this will still add to your cast count!

Chance to perform a spell upgrade during Combat:

Warrior Class:10%
Adventurer Class:25%
Mage Clas:50%
Scholar:+25%
Mage Class Points:+x%
Ring of Conjuring Artifact:+15%

Remember there are three different hero classes in ACM mod and not two. Eg.: Solmyr=Mage Class, Kyrre=Adventurer class, Crag Hack=Warrior class. To check the current chance right click your spellbook or right-click the Knowledge icon in the Hero screen.

Example:
Solmyr with 20 Mage Class points and the Colar of Conjuring artifact equipped and expert Air Magic would have a (50%+17%+15%) 82% chance that when casting Haste in combat his counter for Haste casts increased by 1. If Solymr does that 10 times successfully and his counter reaches 10 casts his Haste spell will improve by +1 and the effect is improved by 1 speed.
That means he used 1 spell upgrade per combat. If Solymr is able to perform 2 spell upgrades per combat he could also increase the effectiveness of his Lightning Bolt spell by 3% by killing some enemies. That would mean he has used 2 spell upgrades this combat.


The number of possible Spell Upgrades per Combat determines as follows:
Warrior Class:0
Adventurer Class:0
Mage Class:+1
Scholar Basic:+1
Scholar Expert:+1
Scholar Grandmaster:+1
Collar of Conjuring:+1
Druid:+1
Battlemage:+1
Grandmaster Mage:+1

To increase your Haste spell to the next level you will need to perform more casts than the previous level required. There is no limit but to reach from level 9 to 10 you will need over 100 extra casts.

What does that mean for Crag Hack when he casts Haste and is Expert Air Magic. He only has a low (10%+some Mage class points%)=20% chance that his casts add to his cast counter because it only has a 20% chance to succeed. So on average, he needs to perform 5 times more casts than a good Wizard to get the same result and level up his Haste spell.

This system will ensure that mainly the Mage class can perform spell upgrades. But with a little bit of investment Warriors and Adventurers can also perform Spell Upgrades, especially when picking Scholar or wearing artifacts.
 


The artifacts for upgrading are the following:
[Collar of Conjuring] allows + 1 spell upgrade per combat
[Ring of Conjuring] +15% chance for spell upgrade
[Cape of Conjuring] increases the maximal level for your damage spells by 5!
[Ring of the Magi] Damage Spells Upgrade twice as fast! + all of the other bonuses



Supported Spells:

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




