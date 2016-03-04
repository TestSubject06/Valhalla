package player;

import deities.Deity;

/**
 * ...
 * @author Zack
 */
class Party
{
	//Examine party to see members in-game?
	
	//A party has some header information such as a diety, party name
	//And an array of party members
	private var deity:Deity;
	private var partyName:String;
	private var members:Array<Actor>;
	public function new() 
	{
		members = [];
	}
	
	public function addActor(actor:Actor):Void {
		members.push(actor);
	}
	
	public function setDeity(deity:Deity):Void {
		this.deity = deity;
	}
	
	public function getDeity():Deity {
		return deity;
	}
	
}