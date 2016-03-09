package;

import player.*;

/**
 * ...
 * @author Zack
 */
class PartyInformation
{
	//A 'player' is a team of characters, usually three, sometimes four with an NPC, sometimes less if people are dead.
	//wishlist...
	//getParty()
	
	//A party has some header information such as a diety, party name
	//And an array of party members
	
	//A party member has header information such as base stats, and computed stats
	//Each party member has an inventory
	//Each party member has a skill chain
	//Each party member has a list of learned skills
	//Each party member has a list of learned spells
	//Each party member has a list of equipped items
	
	//Each item has stat modifiers - I'll figure out how this works later.
	
	
	//Targeting: Selector behavior based on targetnigType - then callback is called with each target selected.
	private static var party:Party;
	
	public static function getParty():Party {
		return PartyInformation.party;
	}
	
	public static function setParty(party:Party):Void {
		PartyInformation.party = party;
	}
}