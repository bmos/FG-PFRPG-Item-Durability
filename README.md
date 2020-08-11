# PFRPG Item Durability
This extension adds hardness, hitpoints, and damage fields to item sheets. It also does most of the work for you in calculating these values, although most items will need their 'substance' and 'thickness' fields filled in. For the list of accepted substances, see the items listed in brackets after "aSubstances" [here](https://github.com/bmos/FG-PFRPG-Item-Durability/blob/7b2ce3a53e6572a14e1dc0d3b60ffb08e118dbf9/campaign/scripts/item__generatehhd.lua#L9). Thickness is in inches and can be any number (including non-whole numbers). A good starting point for a light bladed weapon is 0.125 inches, while a greatsword would be around .33 inches. Just use your best judgement on how thick the structure of an item is, and feel free to check your results against the reference table [here](https://www.d20pfsrd.com/equipment/damaging-objects/#).
Damage rolled can be dragged to the item damage field to have most applicable reductions performed, hardness subtracted, and the resulting damage added to the previous field contents.
If the damage is at least 50% of the total item hitpoints, the broken condition is applied. If the damage is at least 100%, the item is unequipped or deleted, depending on the option configured.
If the item is a weapon, any attacks made with the item suffer a –2 penalty on attack and damage rolls. Such weapons only score a critical hit on a natural 20 and only deal ×2 damage on a confirmed critical hit.
If the item is a suit of armor or a shield, the bonus it grants to AC is halved, rounding down. Broken armor doubles its armor check penalty on skills.

# Compatibility
This extension has been tested with [FantasyGrounds Classic](https://www.fantasygrounds.com/home/FantasyGroundsClassic.php) 3.3.11 and [FantasyGrounds Unity](https://www.fantasygrounds.com/home/FantasyGroundsUnity.php) 4.0.0 (2020-08-05). It should be compatible with both of [rmilmine](https://www.fantasygrounds.com/forums/member.php?215591-rmilmine)'s item extensions and Llisandur's [Enhanced Items v4.21](https://www.fantasygrounds.com/forums/showthread.php?40602-Extension-Enhanced-Items-v4).

# Features
* Simplifies tracking hitpoints of weapons, armor, and equipment.
* Provides visual indication of item damage by color coding the number proportionately to damage.
* Automate penalties for damaged armor and/or weapons and unequip or delete it if totally destroyed.
* Calculate/guess hardness and hitpoints based on item type, properties, name, character size, and more. Many items require you to enter 'thickness' to get the final value.

# Video Demonstration (click for video)
[<img src="https://i.ytimg.com/vi_webp/2tm-t8s18VY/hqdefault.webp">](https://www.youtube.com/watch?v=2tm-t8s18VY)
