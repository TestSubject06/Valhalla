package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import player.Actor;
import player.Party;
import player.StatSheet;
import ui.BorderedBox;
import ui.layout.Layout;

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
	override public function create():Void 
	{
		super.create();
		party = new Party();
		dice = [5, 5, 5];
		
		
		var text = new FlxText(FlxG.width / 2 - 150, 2, 300, "Create a Party", 16);
		text.alignment = "center";
		add(text);
		
		
		
		//Character 1
		var character1:Actor = new Actor("Character 1");
		var character2:Actor = null;
		var character3:Actor = null;
		party.addActor(character1);
		
		var stats:StatSheet = new StatSheet();
		rollRandomStats(stats);
		character1.setBaseStats(stats);
		
		var characterBox:BorderedBox = new BorderedBox(10, 35, 0, Layout.VERTICAL);
		add(characterBox);
		characterBox.push(new FlxButton(0, 0, character1.getName(), function():Void {
			trace("Switch view to Character 1");
		}));
		characterBox.push(new FlxButton(0, 0, character2 != null ? character2.getName() : "Create", function():Void {
			trace("Switch view to Character 2");
		}));
		characterBox.push(new FlxButton(0, 0, character3 != null ? character3.getName() : "Create", function():Void {
			trace("Switch view to Character 3");
		}));
		
		trace(characterBox.getHeight());
		var box:BorderedBox = new BorderedBox(10, 35 + characterBox.getHeight(), 0, Layout.VERTICAL);
		add(box);
		box.push(new FlxText(0, 0, 250, "Strength: " + character1.getBaseStats().strength));
		box.push(new FlxText(0, 0, 250, "Constitution: " + character1.getBaseStats().constitution));
		box.push(new FlxText(0, 0, 250, "Intelligence: " + character1.getBaseStats().intelligence));
		box.push(new FlxText(0, 0, 250, "Wisdom: " + character1.getBaseStats().wisdom));
		box.push(new FlxText(0, 0, 250, "Dexterity: " + character1.getBaseStats().dexterity));
		box.push(new FlxText(0, 0, 250, "Agility: " + character1.getBaseStats().agility));
		box.push(new FlxText(0, 0, 250, "Luck: " + character1.getBaseStats().luck));
		box.push(new FlxText(0, 0, 250, ""));
		box.push(new FlxText(0, 0, 250, "Max Health: " + character1.getBaseStats().maxhealth));
		box.push(new FlxText(0, 0, 250, "Max Mana: " + character1.getBaseStats().maxmana));
		box.push(new FlxText(0, 0, 250, "Attack: " + character1.getBaseStats().attack));
		box.push(new FlxText(0, 0, 250, "Defense: " + character1.getBaseStats().defense));
		box.push(new FlxText(0, 0, 250, "Magic Attack: " + character1.getBaseStats().magicAttack));
		box.push(new FlxText(0, 0, 250, "Magic Defense: " + character1.getBaseStats().magicDefense));
		box.push(new FlxText(0, 0, 250, "Speed: " + character1.getBaseStats().speed));
		
		var text = new FlxText(FlxG.width / 2 - 150, FlxG.height - 25, 300, "Re-rolls: " + dice[0], 8);
		text.alignment = "center";
		add(text);
		
		add(new FlxButton(FlxG.width - 90, FlxG.height - 30, "Next", function():Void {
			trace("Next step of party creation");
		}));
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