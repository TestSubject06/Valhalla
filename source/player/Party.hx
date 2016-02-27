package player;

/**
 * ...
 * @author Zack
 */
class Party
{
	//Examine party to see members in-game?
	
	//A party has some header information such as a diety, party name
	//And an array of party members
	private var diety:Diety;
	private var partyName:String;
	private var members:Array<Actor>;
	public function new() 
	{
		members = [];
	}
	
	public function addActor(actor:Actor) {
		members.push(actor);
	}
	
}