package player;

/**
 * ...
 * @author Zack
 */
class StatSheet
{
	//No hard maximums
	//Very minor diminishing returns to prevent stale characters
	public var intelligence:Int; //Magic Attack
	public var strength:Int; //Attack
	public var luck:Int; //roll influence
	public var agility:Int; //Speed
	public var wisdom:Int;	//Max mana, magic defense
	public var constitution:Int; //Health, defense
	public var dexterity:Int; //Extends perfect strike window, extends spell minigame window
	
	public var defense:Int;
	public var magicDefense:Int;
	public var attack:Int;
	public var magicAttack:Int;
	public var maxhealth:Int;
	public var maxmana:Int;
	public var speed:Int;
	public function new() 
	{
		intelligence = 0;
		strength = 0;
		luck = 0;
		agility = 0;
		constitution = 0;
		wisdom = 0;
		dexterity = 0;
	}
	
	public function calculateDerrivedStats():Void {
		maxhealth = 30 + constitution * 4;
		maxmana = 20 + wisdom * 3;
		defense = 8 + constitution * 3;
		magicDefense = 8 + wisdom * 3;
		speed = 6 + Math.floor(agility * 1.5);
		attack = 10 + strength * 2;
		magicAttack = 8 + intelligence * 3;
	}
}