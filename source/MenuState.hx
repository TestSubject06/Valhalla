package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxRandom;
import maps.MapGenerator;
import maps.GameMap;

/**
 * A FlxState which can be used for the game's menu.
 * 
 * 
 * TODO: Next up: Transition into the dungeon mode - and get dungeon movement working
 */
class MenuState extends FlxState
{
	public var text:FlxText;
	public var group:FlxTypedGroup<MovingSquare>;
	public var runes:RuneDrawingMinigame;
	public var map:GameMap;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var mainLayer:FlxGroup;
	private var effectLayer:FlxGroup;
	override public function create():Void
	{
		super.create();
		mainLayer = new FlxGroup();
		effectLayer = new FlxGroup();

		add(mainLayer);
		add(effectLayer);

		text = new FlxText(50, 50, 200, "Valhalla debug menu", 16);
		mainLayer.add(text);


		runes = new RuneDrawingMinigame();
		effectLayer.add(runes);

		map = new GameMap(54, 54);
		map.x = 200;
		map.y = 25;
		map.updateTilemap();
		mainLayer.add(map);
		add(new FlxButton(50, 300, "Dungeon", function():Void {
			//Generate a map
			mainLayer.remove(map, true);
			map = MapGenerator.generateMap(Dungeon, 54, 54, 45);
			map.updateTilemap(AssetPaths.CaiTiles__png, false);
			//Display the map
			map.x = 200;
			map.y = 25;
			map.visible = true;
			mainLayer.add(map);
			trace("Go to dungeon");
		}));
		
		add(new FlxButton(50, 320, "Cavern", function():Void {
			//Generate a map
			mainLayer.remove(map, true);
			map = MapGenerator.generateMap(Cavern, 54, 54, 45);
			map.updateTilemap();
			//Display the map
			map.x = 200;
			map.y = 25;
			map.visible = true;
			mainLayer.add(map);
			trace("Go to cavern");
		}));
		
		add(new FlxButton(50, 340, "Battle", function():Void {
			trace("Go to battle");
		}));
		
		add(new FlxButton(50, 360, "Score Screen", function():Void {
			trace("Go to score screen");
		}));
		
		add(new FlxButton(50, 380, "Rune Drawing", function():Void {
			trace("Summon rune drawing minigame");
			runes.startMinigame(
				new Spell(), 
				function():Void { 
					trace("Rune completed!"); 
					
				}, 
				function(spell:Spell, numRunesDrawn:Int):Void { 
					trace("Rune drawing finished! Completed " + numRunesDrawn + " runes."); 
				} 
			);
		}));
		
		add(new FlxButton(50, 400, "Message", function():Void {
			trace("Show a message");
		}));
		
		add(new FlxButton(50, 420, "Create Party", function():Void {
			trace("Create a party");
			FlxG.switchState(new PartyCreate());
		}));
		
		//FlxG.log.redirectTraces = true;
		FlxG.camera.bgColor = 0xFF111111;
		FlxG.scaleMode = new PixelPerfectScaleMode();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}