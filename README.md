# PFRPG Item Durability
This extension adds hardness, hitpoints, and damage fields to item sheets.
Damage rolled can be dragged to the item damage field to have most applicable reductions performed, hardness subtracted, and the resulting damage added to the previous field contents.
If the damage is at least 50% of the total item hitpoints, the broken condition is applied. If the damage is at least 100%, the item is unequipped.
If the item is a weapon, any attacks made with the item suffer a –2 penalty on attack and damage rolls. Such weapons only score a critical hit on a natural 20 and only deal ×2 damage on a confirmed critical hit.
If the item is a suit of armor or a shield, the bonus it grants to AC is halved, rounding down. Broken armor doubles its armor check penalty on skills.

# Compatibility
This extension has been tested with [FantasyGrounds Classic](https://www.fantasygrounds.com/home/FantasyGroundsClassic.php) 3.3.11 and [FantasyGrounds Unity](https://www.fantasygrounds.com/home/FantasyGroundsUnity.php) 4.0.0 (2020-07-16).
It's not compatible with rmilmine's [Advanced Character Inventory Manager](https://www.fantasygrounds.com/forums/showthread.php?57819-Advanced-Character-Iventory-Manager-for-3-5E-and-Pathfinder) or [Customised Item Generator](https://www.fantasygrounds.com/forums/showthread.php?57818-Customized-Item-Generator-for-3-5E-and-Pathfinder). It's not compatible with any other extension that replaced item_main.lua. This may change in the future, but for now I wouldn't recommend mixing and matching these.

# Features
* Simplifies tracking hitpoints of weapons, armor, and equipment.
* Provides visual indication of item damage by color coding the number proportionately to damage.
* Automate penalties for damaged armor and/or weapons. 

# Example Image
<img src="https://i.imgur.com/QTdNW9j.png" alt="item durablity UI example image"/>
