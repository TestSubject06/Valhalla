package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import haxe.Constraints.Function;
import player.Actor;
import ui.menus.Inventory;

/**
 * ...
 * @author Zack
 */
class CharacterPlate extends FlxSpriteGroup
{
	
	//Constructs a character plate for the selected unit.
	private var icon:FlxSprite;
	private var actor:Actor;
	private var text:FlxText;
	private var bottomPart:FlxSpriteGroup;
	private var topPart:FlxSpriteGroup;
	private var selector:FlxText;
	private var selected:Int = 0;
	private var menuHeight:Int = 130;
	private var transitioning:Bool = false;
	private var startPoint:FlxPoint;
	private var targetPoint:FlxPoint;
	public function new(x:Float, y:Float, unit:Actor) 
	{
		super(x, y);
		topPart = new FlxSpriteGroup(0, 0);
		topPart.add(new FlxSprite(0, 0, AssetPaths.CharacterPlate__png));
		
		icon = new FlxSprite(4-48, 30-48, unit.getIcon().pixels);
		icon.scale.set(0.258, 0.258);
		
		actor = unit;
		
		topPart.add(icon);
		
		text = new FlxText(40, 30, 100, "");
		topPart.add(text);
		text.text = actor.health +  " / " + actor.getBaseStats().maxhealth;
		text.color = 0xFF0000;
		
		text = new FlxText(40, 30, 100, actor.getName());
		text.x = 150 - text.width;
		text.alignment = FlxTextAlign.RIGHT;
		text.color = 0xFFFFFF;
		topPart.add(text);
		
		
		bottomPart = new FlxSpriteGroup(0, 0);
		var backplate = new FlxSprite(0, 64, null);
		backplate.makeGraphic(150, 150, 0xFF2E4D7A);
		bottomPart.add(backplate);
		
		var offset = 50;
		selector = new FlxText(5, offset+20, 20, ">", 16);
		bottomPart.add(new FlxText(20, (offset = offset + 20), 120, "Status", 16));
		bottomPart.add(new FlxText(20, (offset = offset + 20), 120, "Inventory", 16));
		bottomPart.add(new FlxText(20, (offset = offset + 20), 120, "Equipment", 16));
		bottomPart.add(new FlxText(20, (offset = offset + 20), 120, "Skills", 16));
		bottomPart.add(new FlxText(20, (offset = offset + 20), 120, "Spells", 16));
		bottomPart.add(selector);
		
		add(topPart);
		add(bottomPart);
		
		bottomPart.exists = false;
		
		scrollFactor.set(0, 0);
		startPoint = new FlxPoint(x, y);
		targetPoint = new FlxPoint(x,y);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (bottomPart.exists) {
			selector.y = (cast (bottomPart.members[0], FlxSprite).y) + (20 * selected) + 5;
			trace(bottomPart.toString());
		}
		if (transitioning) {
			y = FlxMath.lerp(y, targetPoint.y, 0.74);
			if (Math.abs(y - targetPoint.y) < 1) {
				y = targetPoint.y;
				transitioning = false;
			}
			if (y == startPoint.y) {
				bottomPart.exists = false;
			}else {
				bottomPart.exists = true;
			}
		}
	}
	
	public function downPressed():Void {
		selected++;
		if (selected > 4) {
			selected = 0;
		}
	}
	
	public function upPressed():Void {
		selected--;
		if (selected < 0) {
			selected = 4;
		}
	}
	
	public function expand():Void {
		//Move everything up
		selected = 0;
		bottomPart.exists = true;
		transitioning = true;
		targetPoint.set(startPoint.x, startPoint.y - menuHeight);
		trace(members[1].toString());
	}
	
	public function collapse():Void {
		//Move everything back down
		transitioning = true;
		targetPoint.set(startPoint.x, startPoint.y);
	}
	
	public function select():Void {
		switch(selected) {
			case 1:
				var newSubState:Inventory = new Inventory(0, Math.floor(topPart.x + 30), Math.floor(startPoint.y - menuHeight - 250), actor);
				FlxG.state.openSubState(newSubState);
		}
	}
	
}