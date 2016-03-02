package player;

import flixel.FlxSprite;
import items.Item;
import skills.Skill;

/**
 * ...
 * @author Zack
 */
class Actor
{
	private var name:String;
	private var inventory:Array<Item>;
	private var skillChain:Array<Skill>;
	private var baseStats:StatSheet;
	private var computedStats:StatSheet;
	private var icon:FlxSprite;
	private var overworldSprite:FlxSprite;
	private var battleSprite:FlxSprite;
	private var level:Int;
	private var health:Int;
	private var mana:Int;
	public function new(name:String) 
	{
		this.name = name;
		this.computedStats = new StatSheet();
		this.baseStats = new StatSheet();
	}
	
	public function setBaseStats(baseStats:StatSheet):Void {
		this.baseStats = baseStats;
		inventory = [];
		skillChain = [];
	}
	
	public function getBaseStats():StatSheet {
		return baseStats;
	}
	
	public function getComputedStats():StatSheet {
		return computedStats;
	}
	
	public function recomputeStats():Void {
		//Run through and recompute the stats.
		
	}
	
	public function getName():String {
		return name;
	}
	
	public function getInventory():Array<Item> {
		return inventory;
	}
	
	public function giveItem(item:Item):Void {
		inventory.push(item);
	}
	
}