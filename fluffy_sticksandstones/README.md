# sticks_and_stones
A custom gamemode for Fluffy Server's minigames server on gmod.<br />
NOTE: If you are reading this on your computer locally (i.e. not on the github website), read readme.txt.

===============================================================================

<p align="center"><b>Repo Details</b></p>
===============================================================================

<ul>
	<li>Date Created: 28/10/17</li>
	<li>Date Last Modified: 29/10/17</li>
	<li>Author: AlbinoBlackHawk</li>
</ul>

===============================================================================

<p align="center"><b>Gamemode Details</b></p>
===============================================================================

<b>Breakdown:</b>
<ul>
	<li>FFA</li>
	<li>Aim of the game is to have the highest score at the end of a round**</li>
	<li>5 "points" are awarded for every meelee or Tomahawk kill**</li>
	<li>10 "points" are awarded for every ballistic knife and crossbow kill**</li>
	<li>Getting killed by a tomahawk will result in one's score being reset**</li>
	<li>1 Frag is awarded for every kills**</li>
	<li>Bonus frags can also be awarded:
	<ul>
		<li>if a player resets another players score, they get 1 frag per
		10 points the other player had.**</li>
		<li>the winner of a round will get a yet to be determined amount of
		bonus frags**</li>
	</ul></li>
</ul>

<b>Weapons:</b>
<ul>
	<li>Crossbow
	<ul>
		<li>Pretty self explanatory</li>
		<li>Starts with 2 clips of 3 rounds</li>
		<li>Crossbow bolts stick and are explosive**</li>
		<li>Left Click to Shoot</li>
		<li>Aim down sights with right click</li>
		<li>Manual reload</li>
	</ul></li>
	<li>Ballistic Knives 
	<ul>
		<li>Orginally intended to be "shot" just like in COD, however, this
		proved to difficult, so they behave more like throwing knives</li>
		<li>Starts with 4 clips of 1 round</li>
		<li>Left click throws the knives at very high velocity, meaning little
		accuracy is lost due to gravity</li>
		<li>Right click is a meelee attack</li>
		<li>Auto reload</li>
		<li>Knives can be picked up again, however, a player still can't have 
		more than 4 knives total at any one time</li>
	</ul></li>
	<li>Tomahawk
	<ul>
		<li>This is a very customised weapon</li>
		<li>The player does not carry this in their inventory, instead they 
		maintain a virtual count of how many "axes" they have</li>
		<li>This weapon can be thrown whilst using another weapon</li>
		<li>Thrown using IN_USE(by default 'e'), this may change</li>
		<li>Can be picked up again</li>
		<li>Start with 1, can carry up to 3</li>
	</ul></li>
</ul>

**Feature either not yet full implemented or not implemented at all

===============================================================================

<p align="center"><b>Files</b></p>
===============================================================================

Since there are a lot of files in this repo that I didn't create myself, 
particularly the weapons (which I downloaded from other sources, gutted, then 
modified to suit my needs), I'm including a breakdown of what code is mine 
and what code I have edited.

<b>Created by me:</b>
<ul>
	<li>gamemode/* **</li>
	<li>sticks_and_stone.txt</li>
</ul>
<b>Severely Edited by me:</b>
<ul>
	<li>/entities/entities/sas_ent_tomahawk/init.lua</li>
	<li>/entities/entities/sas_knife/init.lua**</li>
	<li>/entities/weapons/weapon_sas_tomohawk/shared.lua**</li>
	<li>/entities/weapons/weapon_sas_knife.lua**</li>
</ul>
<b>Files I Plan on Editing:</b>
<ul>
	<li>/entities/entities/cw_lts_crossbowtip</li>
</ul>

**Yet to be tidied up, refactored and commented.

You can safely assume I haven't written or modified any other code files that
are not listed above.

===============================================================================

<p align="center"><b>TODO List</b></p>
===============================================================================

Everything in this section are things that need to be done to complete this
gamemode.

<b>To do:</b>
<ul>
	<li>Redo explosions for crossbow bolts</li>
	<li>Add a weapon tracking system so players can know what they were 
	killed by</li>
	<li>Override DoPlayerDeath and implement the scoring/frag system</li>
	<li>Add some kind of UI feature that displays the amount of axes on the 
	player</li>
	<li>Add sound effects for picking up knives/axes</li>
	<li>Refactor/Comment code</li>
	<li>Tidy up directory, naming convention is currently inconsistent</li>
	<li>Figure out how to force clients to download content and make sure
	thats implemented before the minigame goes live</li>
</ul>
<b>Bugs:</b>
<ul>
	
</ul>

===============================================================================
