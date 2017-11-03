# sticks_and_stones
A custom gamemode for Fluffy Server's minigames server on gmod.
NOTE: If you are using the github website to view this, read README.md instead
of this.

===============================================================================

Repo Details

===============================================================================

Date Created: 28/10/17
Date Last Modified 29/10/17
Author: AlbinoBlackHawk

===============================================================================

Gamemode Details

===============================================================================

Breakdown:
	- FFA
	- Aim of the game is to have the highest score at the end of a round**
	- 5 "points" are awarded for every meelee or Tomahawk kill**
	- 10 "points" are awarded for every ballistic knife and crossbow kill**
	- Getting killed by a tomahawk will result in one's score being reset**
	- 1 Frag is awarded for every kills**
	- Bonus frags can also be awarded:
		- if a player resets another players score, they get 1 frag per
		10 points the other player had.**
		- the winner of a round will get a yet to be determined amount of
		bonus frags**

Weapons
	- Crossbow
		- Pretty self explanatory
		- Starts with 2 clips of 3 rounds
		- Crossbow bolts stick and are explosive**
		- Left Click to Shoot
		- Aim down sights with right click
		- Manual reload
	- Ballistic Knives 
		- Orginally intended to be "shot" just like in COD, however, this
		proved to difficult, so they behave more like throwing knives
		- Starts with 4 clips of 1 round
		- Left click throws the knives at very high velocity, meaning little
		accuracy is lost due to gravity
		- Right click is a meelee attack
		- Auto reload
		- Knives can be picked up again, however, a player still can't have 
		more than 4 knives total at any one time
	- Tomahawk
		- This is a very customised weapon
		- The player does not carry this in their inventory, instead they 
		maintain a virtual count of how many "axes" they have
		- This weapon can be thrown whilst using another weapon
		- Thrown using IN_USE(by default 'e'), this may change
		- Can be picked up again
		- Start with 1, can carry up to 3

**Feature either not yet full implemented or not implemented at all

===============================================================================

Files

===============================================================================

Since there are a lot of files in this repo that I didn't create myself, 
particularly the weapons (which I downloaded from other sources, gutted, then 
modified to suit my needs), I'm including a breakdown of what code is mine 
and what code I have edited.

Created by me:
	- gamemode/* **
	- sticks_and_stone.txt

Severely Edited by me:
	- /entities/entities/sas_ent_tomahawk/init.lua
	- /entities/entities/sas_knife/init.lua**
	- /entities/weapons/weapon_sas_tomohawk/shared.lua**
	- /entities/weapons/weapon_sas_knife.lua**

Files I Plan on Editing:
	- /entities/entities/cw_lts_crossbowtip

**Yet to be tidied up, refactored and commented.

You can safely assume I haven't written or modified any other code files that
are not listed above.

===============================================================================

TODO List

===============================================================================

Everything in this section are things that need to be done to complete this
gamemode.

To do:
	- Redo explosions for crossbow bolts
	- Add a weapon tracking system so players can know what they were 
	killed by
	- Override DoPlayerDeath and implement the scoring/frag system
	- Add some kind of UI feature that displays the amount of axes on the 
	player
	- Add sound effects for picking up knives/axes
	- Refactor/Comment code
	- Tidy up directory, naming convention is currently inconsistent
	- Figure out how to force clients to download content and make sure
	thats implemented before the minigame goes live

Bugs:
	

===============================================================================