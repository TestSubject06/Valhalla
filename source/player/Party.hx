package player;

import deities.Deity;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

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
	public var targetDestination:FlxPoint;
	public function new() 
	{
		members = [];
		targetDestination = new FlxPoint(0, 0);
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
	
	public function getOverworldSprite():FlxSprite {
		//TODO: Implement intelligent logic that grabs the most powerful representative's overworld sprite.
		return members[0].getOverworldSprite();
	}
	
	public function getMembers():Array<Actor> {
		return members;
	}
	
}