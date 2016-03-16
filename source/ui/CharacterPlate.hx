package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import haxe.Constraints.Function;
import player.Actor;

/**
 * ...
 * @author Zack
 */
class CharacterPlate extends FlxGroup
{
	
	//Constructs a character plate for the selected unit.
	private var icon:FlxSprite;
	private var actor:Actor;
	private var text:FlxText;
	private var bottomPart:FlxGroup;
	private var topPart:FlxGroup;
	private var selector:FlxText;
	private var selected:Int = 0;
	public function new(x:Float, y:Float, unit:Actor) 
	{
		super();
		topPart = new FlxGroup();
		topPart.add(new FlxSprite(x, y, AssetPaths.CharacterPlate__png));
		
		icon = new FlxSprite(x+4-48, y+30-48, unit.getIcon().pixels);
		icon.scale.set(0.258, 0.258);
		
		actor = unit;
		
		topPart.add(icon);
		
		text = new FlxText(x + 40, y + 30, 100, "");
		topPart.add(text);
		text.text = actor.health +  " / " + actor.getBaseStats().maxhealth;
		text.color = 0xFF0000;
		
		//TODO: Make the bottom part of the menu
		bottomPart = new FlxGroup();
		var backplate = new FlxSprite(x, y + 64, null);
		backplate.makeGraphic(150, 150, 0xFF2E4D7A);
		bottomPart.add(backplate);
		bottomPart.exists = false;
		
		var offset = 50;
		selector = new FlxText(x+5, y + offset+20, 20, ">", 16);
		bottomPart.add(selector);
		bottomPart.add(new FlxText(x + 20, y + (offset = offset + 20), 120, "Status", 16));
		bottomPart.add(new FlxText(x + 20, y + (offset = offset + 20), 120, "Inventory", 16));
		bottomPart.add(new FlxText(x + 20, y + (offset = offset + 20), 120, "Equipment", 16));
		bottomPart.add(new FlxText(x + 20, y + (offset = offset + 20), 120, "Skills", 16));
		bottomPart.add(new FlxText(x + 20, y + (offset = offset + 20), 120, "Spells", 16));
		
		
		add(topPart);
		add(bottomPart);
		
		for (s in bottomPart.members) {
			cast(s, FlxSprite).scrollFactor.set(0, 0);
		}
		for (s in topPart.members) {
			cast(s, FlxSprite).scrollFactor.set(0, 0);
		}
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function downPressed():Void {
		//TODO: Fix menu logic here.
		selector.y += 20;
		selected++;
	}
	
	public function upPressed():Void {
		selector.y -= 20;
		selected--;
	}
	
	public function expand():Void {
		//Move everything up
		selected = 0;
		for (s in bottomPart.members) {
			cast(s, FlxSprite).y -= 150;
		}
		for (s in topPart.members) {
			cast(s, FlxSprite).y -= 150;
		}
		bottomPart.exists = true;
		
	}
	
	public function collapse():Void {
		//Move everything back down
		for (s in bottomPart.members) {
			cast(s, FlxSprite).y += 150;
		}
		for (s in topPart.members) {
			cast(s, FlxSprite).y += 150;
		}
		bottomPart.exists = false;
	}
	
}