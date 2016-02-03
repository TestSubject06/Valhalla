package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public var text:FlxText;
	public var group:FlxTypedGroup<MovingSquare>;
	public var runes:RuneDrawingMinigame;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		text = new FlxText(50, 50, 200, "Valhalla debug menu", 16);
		add(text);
		
		runes = new RuneDrawingMinigame();
		add(runes);
		
		add(new FlxButton(50, 300, "Dungeon", function():Void {
			trace("Go to dungeon");
		}));
		
		add(new FlxButton(50, 320, "Battle", function():Void {
			trace("Go to battle");
		}));
		
		add(new FlxButton(50, 340, "Score Screen", function():Void {
			trace("Go to score screen");
		}));
		
		add(new FlxButton(50, 360, "Rune Drawing", function():Void {
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
		
		add(new FlxButton(50, 380, "Message", function():Void {
			trace("Show a message");
		}));
		
		FlxG.log.redirectTraces = true;
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