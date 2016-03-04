package;

import deities.Deity;
import deities.Loki;
import deities.Thor;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxRandom;
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
	private var page:Int = 0;
	private var page1:FlxGroup;
	private var page2:FlxGroup;
	private var selectorSprite:FlxSprite;
	private var selectedDeity:Int = 0;
	
	override public function create():Void 
	{
		super.create();
		party = new Party();
		dice = [5, 5, 5];
		
		page1 = new FlxGroup();
		page2 = new FlxGroup();
		
		var text = new FlxText(FlxG.width / 2 - 150, 2, 300, "Create a Party", 16);
		text.alignment = "center";
		page1.add(text);
		
		//Character 1
		var character1:Actor = createCharacter();
		var character2:Actor = createCharacter();
		var character3:Actor = createCharacter();
		party.addActor(character1);
		party.addActor(character2);
		party.addActor(character3);
		
		var characterBox:BorderedBox = new BorderedBox(10, 35, 0, Layout.VERTICAL);
		page1.add(characterBox);
		
		var box:BorderedBox = new BorderedBox(10, 35 + characterBox.getHeight(), 0, Layout.VERTICAL);
		page1.add(box);
		populateStatsForBox(character1.getBaseStats(), box);
		
		var inventoryBox:BorderedBox = new BorderedBox(FlxG.width - 160, 35, 0, Layout.VERTICAL);
		page1.add(inventoryBox);
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
		page1.add(text);
		
		page1.add(new FlxButton(FlxG.width - 90, FlxG.height - 30, "Next", function():Void {
			flipToPage(1);
		}));
		
		var sprite:FlxSprite = new FlxSprite(FlxG.width / 2 - 70, 50, null);
		sprite.makeGraphic(140, 140, 0xFF666666);
		sprite.stamp(character1.getIcon(), 15, 15);
		page1.add(sprite);
		page1.add(new FlxText(FlxG.width / 2 - 70, 70, 140, "Avatar"));
		
		sprite = new FlxSprite(FlxG.width / 2 - 100, FlxG.height - 270, null);
		sprite.makeGraphic(200, 200, 0xFF666666);
		sprite.stamp(character1.getBattleSprite(), 15, 15);
		page1.add(sprite);
		page1.add(new FlxText(FlxG.width / 2 - 70, FlxG.height - 180, 200, "Battle Sprite"));
		
		//Page 2:
		text = new FlxText(FlxG.width / 2 - 150, 2, 300, "Select a Deity", 16);
		text.alignment = "center";
		page2.add(text);
		
		page2.add(new FlxButton(10, FlxG.height - 30, "Prev", function():Void {
			flipToPage(0);
		}));
		
		page2.add(new FlxButton(FlxG.width - 90, FlxG.height - 30, "Done", function():Void {
			trace("Move on...");
			party.setDeity(getDeityFromId(selectedDeity));
			trace(party.getDeity().getName());
			PartyInformation.setParty(party);
			FlxG.switchState(new MenuState());//TODO: Replace with a real next-state
		}));
		
		selectorSprite = new FlxSprite(0, 35, null);
		selectorSprite.makeGraphic(260, 260);
		page2.add(selectorSprite);
		
		var thorBox:BorderedBox = new BorderedBox(20, 35, 0, Layout.VERTICAL);
		var thorIcon:FlxSprite = new FlxSprite(0, 0, AssetPaths.ThorHammerIcon__jpg);
		thorIcon.scale.set(0.5, 0.5);
		thorIcon.updateHitbox();
		thorBox.push(thorIcon);
		thorBox.push(new FlxText(0, 0, 250, "Thor", 16));
		thorBox.push(new FlxText(0, 0, 250, "", 8));
		thorBox.push(new FlxText(0, 0, 250, "Demigod of thunder", 12));
		thorBox.push(new FlxText(0, 0, 250, "", 8));
		thorBox.push(new FlxText(0, 0, 250, "", 8));
		thorBox.push(new FlxText(0, 0, 250, "Increases all characters' attack by 10%", 8));
		thorBox.push(new FlxText(0, 0, 250, "Increases all front row characters' defense by 5%", 8));
		thorBox.push(new FlxText(0, 0, 250, "BLAH BLAH BUFFS", 8));
		thorBox.push(new FlxText(0, 0, 250, "", 8));
		thorBox.push(new FlxText(0, 0, 250, "Temperment: Good", 8));
		page2.add(thorBox);
		
		var lokiBox:BorderedBox = new BorderedBox(20 + 260, 35, 0, Layout.VERTICAL);
		var lokiIcon:FlxSprite = new FlxSprite(0, 0, AssetPaths.LokiHelmetIcon__jpg);
		lokiIcon.scale.set(0.5, 0.5);
		lokiIcon.updateHitbox();
		lokiBox.push(lokiIcon);
		lokiBox.push(new FlxText(0, 0, 250, "Loki", 16));
		lokiBox.push(new FlxText(0, 0, 250, "", 8));
		lokiBox.push(new FlxText(0, 0, 250, "Demigod of trickery", 12));
		lokiBox.push(new FlxText(0, 0, 250, "", 8));
		lokiBox.push(new FlxText(0, 0, 250, "", 8));
		lokiBox.push(new FlxText(0, 0, 250, "Increases all characters' speed by 10%", 8));
		lokiBox.push(new FlxText(0, 0, 250, "Increases all characters' critical damage by 5%", 8));
		lokiBox.push(new FlxText(0, 0, 250, "BLAH BLAH BUFFS", 8));
		lokiBox.push(new FlxText(0, 0, 250, "", 8));
		lokiBox.push(new FlxText(0, 0, 250, "Temperment: Angsty", 8));
		page2.add(lokiBox);
		
		add(page1);
		page2.exists = false;
		add(page2);
	}
	
	override public function update():Void 
	{
		super.update();
		if (page2.exists) {
			if (FlxG.keys.justPressed.LEFT) {
				selectedDeity--;
				if (selectedDeity < 0) {
					selectedDeity = 1;//TODO:Make sure this becomes max
				}
			}
			if (FlxG.keys.justPressed.RIGHT) {
				selectedDeity++;
				if (selectedDeity > 1) { //TODO:Make sure this becomes max
					selectedDeity = 0;
				}
			}
			selectorSprite.x = 20 + selectedDeity * 260;
			selectorSprite.color = FlxRandom.intRanged();
		}
	}
	
	private function getDeityFromId(id:Int):Deity {
		switch(id) {
			case 0:
				return new Thor();
			case 1:
				return new Loki();
			default:
				return new Thor();
		}
	}
	
	private function flipToPage(pageNumber:Int):Void {
		if (pageNumber == 0) {
			page1.exists = true;
			page2.exists = false;
		}
		if (pageNumber == 1) {
			page1.exists = false;
			page2.exists = true;
		}
	}
	
	//TODO: Find a good way to rename the character
	private var names:Array<String> = ["Joe", "Susan", "Bob", "Alex", "James", "Zack", "Connor", "Griffin", "Doug", "Alice", "Kelsey"];
	private function getRandomName():String {
		return names[Math.floor(Math.random() * names.length)];
	}
	
	private function createCharacter():Actor {
		var character:Actor = new Actor(getRandomName());
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
		
		character.setIcon(new FlxSprite(0, 0, AssetPaths.CharacterPortrait__png));
		character.setBattleSprite(new FlxSprite(0, 0, AssetPaths.CharacterBattleSprite__png));
		character.setOverworldSprite(new FlxSprite(0, 0, AssetPaths.overworld__png));
		
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