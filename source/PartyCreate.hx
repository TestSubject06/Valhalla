package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import items.Item;
import items.Potion1;
import items.Stick;
import openfl.display.BitmapData;
import player.Actor;
import player.Party;
import player.StatSheet;
import ui.BorderedBox;
import ui.layout.Layout;
import openfl.geom.Rectangle;
import openfl.geom.Point;

/**
 * ...
 * @author Zack
 */
class PartyCreate extends FlxState
{
	//Creates a party. Upon entering the screen it starts a new party object
	//Page 1:
	//Top of the screen: "Create a Party"
	//Top-Left: Character selector - Icon and name
	//Left: Character attribute rolls
	//Bottom: Dice remaining for the character
	//Top-Right: Icon selector
	//Right: Battle Sprite selector
	//Bottom-Right: Starting items (Can be skill books, spell books, weapons, armor, potions)
	//Very bottom right: Next
	
	//Page 2:
	//Select Diety
	//Bottom left: Prev
	
	private var party:Party;
	private var dice:Array<Int>;
	private var realScreen:BitmapData;
	private var realScreen2:BitmapData;
	private var time:Float = 0.0;
	public var xFreq:Float = 5.0;
	public var xSpeed:Float = 5.0;
	public var xAmplitude:Float = 10.0;
	public var yFreq:Float = 5.0;
	public var ySpeed:Float = 5.0;
	public var yAmplitude:Float = 10.0;
	
	override public function draw():Void 
	{
		super.draw();
		time += FlxG.elapsed;
		FlxG.log.add(time);
		realScreen.fillRect(new Rectangle(0, 0, realScreen.width, realScreen.height), FlxG.camera.bgColor);
		realScreen2.fillRect(new Rectangle(0, 0, realScreen.width, realScreen.height), FlxG.camera.bgColor);
		for (i in 0...FlxG.width) {
			realScreen.copyPixels(FlxG.camera.buffer, new Rectangle(i, 0, 1, FlxG.height), new Point(i, Math.sin( i * (yFreq / 100.0) - time * ySpeed ) * yAmplitude));
		}
		for (k in 0...FlxG.height) {
			realScreen2.copyPixels(realScreen, new Rectangle(0, k, FlxG.width, 1), new Point(1*Math.sin( k * (xFreq/100.0) - time * xSpeed ) * xAmplitude, k));
		}
		FlxG.camera.buffer.copyPixels(realScreen2, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(0, 0));
	}
	
	override public function create():Void 
	{
		super.create();
		party = new Party();
		dice = [5, 5, 5];
		
		realScreen = new BitmapData(FlxG.width, FlxG.width);
		realScreen2 = new BitmapData(FlxG.width, FlxG.width);
		
		var text = new FlxText(FlxG.width / 2 - 150, 2, 300, "Create a Party", 16);
		text.alignment = "center";
		add(text);
		
		//Character 1
		var character1:Actor = createCharacter();
		var character2:Actor = createCharacter();
		var character3:Actor = createCharacter();
		party.addActor(character1);
		party.addActor(character2);
		party.addActor(character3);
		
		var characterBox:BorderedBox = new BorderedBox(10, 35, 0, Layout.VERTICAL);
		add(characterBox);
		
		var box:BorderedBox = new BorderedBox(10, 35 + characterBox.getHeight(), 0, Layout.VERTICAL);
		add(box);
		populateStatsForBox(character1.getBaseStats(), box);
		
		var inventoryBox:BorderedBox = new BorderedBox(FlxG.width - 160, 35, 0, Layout.VERTICAL);
		add(inventoryBox);
		populateInvForBox(character1.getInventory(), inventoryBox);
		
		characterBox.push(new FlxButton(0, 0, character1.getName(), function():Void {
			populateStatsForBox(character1.getBaseStats(), box);
			populateInvForBox(character1.getInventory(), inventoryBox);
			trace("Switch view to Character 1");
		}));
		characterBox.push(new FlxButton(0, 0, character2 != null ? character2.getName() : "Create", function():Void {
			if (character2 == null) {
				character2 = new Actor("Character 2");
				party.addActor(character2);
			}
			populateStatsForBox(character2.getBaseStats(), box);
			populateInvForBox(character2.getInventory(), inventoryBox);
			trace("Switch view to Character 2");
		}));
		characterBox.push(new FlxButton(0, 0, character3 != null ? character3.getName() : "Create", function():Void {
			if (character3 == null) {
				character3 = new Actor("Character 3");
				party.addActor(character3);
			}
			populateStatsForBox(character3.getBaseStats(), box);
			populateInvForBox(character3.getInventory(), inventoryBox);
			trace("Switch view to Character 3");
		}));
		
		box.moveTo(10, 35 + characterBox.getHeight());
		
		var text = new FlxText(FlxG.width / 2 - 150, FlxG.height - 25, 300, "Re-rolls: " + dice[0], 8);
		text.alignment = "center";
		add(text);
		
		add(new FlxButton(FlxG.width - 90, FlxG.height - 30, "Next", function():Void {
			trace("Next step of party creation");
		}));
		
		var sprite:FlxSprite = new FlxSprite(FlxG.width / 2 - 70, 50, null);
		sprite.makeGraphic(140, 140, 0xFF666666);
		add(sprite);
		add(new FlxText(FlxG.width / 2 - 70, 70, 140, "Avatar"));
		
		sprite = new FlxSprite(FlxG.width / 2 - 100, FlxG.height - 270, null);
		sprite.makeGraphic(200, 200, 0xFF666666);
		add(sprite);
		add(new FlxText(FlxG.width / 2 - 70, FlxG.height - 180, 200, "Battle Sprite"));
		

	}
	
	private function createCharacter():Actor {
		var character:Actor = new Actor("New Character");
		var stats:StatSheet = new StatSheet();
		rollRandomStats(stats);
		character.setBaseStats(stats);
		
		for (i in 0...Math.floor(Math.random() * 5)) {
			if (Math.random() > 0.5) {
				character.giveItem(new Stick());
			}else {
				character.giveItem(new Potion1());
			}
		}
		
		return character;
	}
	
	private function populateInvForBox(inventory:Array<Item>, box:BorderedBox) {
		box.forEach(function(object:FlxBasic):Void { 
			object.destroy();
		});
		box.clear();
		
		box.push(new FlxText(0, 0, 150, "-- -- Inventory -- --"));
		for (item in inventory) {
			box.push(new FlxText(0, 0, 150, item.getName()));
		}
	}
	
	private function populateStatsForBox(statSheet:StatSheet, box:BorderedBox):Void {
		box.forEach(function(object:FlxBasic):Void { 
			object.destroy();
		});
		box.clear();
		
		box.push(new FlxText(0, 0, 100, "-- -- Stats -- --"));
		box.push(new FlxText(0, 0, 100, "Strength: " + statSheet.strength));
		box.push(new FlxText(0, 0, 100, "Constitution: " + statSheet.constitution));
		box.push(new FlxText(0, 0, 100, "Intelligence: " + statSheet.intelligence));
		box.push(new FlxText(0, 0, 100, "Wisdom: " + statSheet.wisdom));
		box.push(new FlxText(0, 0, 100, "Dexterity: " + statSheet.dexterity));
		box.push(new FlxText(0, 0, 100, "Agility: " + statSheet.agility));
		box.push(new FlxText(0, 0, 100, "Luck: " + statSheet.luck));
		box.push(new FlxText(0, 0, 100, ""));
		box.push(new FlxText(0, 0, 100, "Max Health: " + statSheet.maxhealth));
		box.push(new FlxText(0, 0, 100, "Max Mana: " + statSheet.maxmana));
		box.push(new FlxText(0, 0, 100, "Attack: " + statSheet.attack));
		box.push(new FlxText(0, 0, 100, "Defense: " + statSheet.defense));
		box.push(new FlxText(0, 0, 100, "Magic Attack: " + statSheet.magicAttack));
		box.push(new FlxText(0, 0, 100, "Magic Defense: " + statSheet.magicDefense));
		box.push(new FlxText(0, 0, 100, "Speed: " + statSheet.speed));
	}
	
	private function rollRandomStats(statSheet:StatSheet):StatSheet {
		var numStats = 24 + Math.floor(Math.random() * 5);
		trace(numStats);
		while (numStats > 0) {
			var stat = Math.floor(Math.random() * 7);
			trace(stat);
			switch(stat) {
				case 0:
					statSheet.intelligence++;
				case 1:
					statSheet.strength++;
				case 2:
					statSheet.luck++;
				case 3:
					statSheet.agility++;
				case 4:
					statSheet.constitution++;
				case 5:
					statSheet.wisdom++;
				case 6:
					statSheet.dexterity++;
			}
			numStats--;
		}
		statSheet.calculateDerrivedStats();
		return statSheet;
	}
	
}