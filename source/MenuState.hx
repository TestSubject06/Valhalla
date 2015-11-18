package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public var text:FlxText;
	public var group:FlxTypedGroup<MovingSquare>;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		text = new FlxText(50, 50, 200, "Hello World", 16);
		add(text);

		group = new FlxTypedGroup<MovingSquare>(1800);

		for(i in 0...1800){
			group.add(new MovingSquare(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height)));
		}
		add(group);
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