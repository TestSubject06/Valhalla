package runes.drawing;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * A rune is an image, and a collection of rune segments
 * 
 * Rune segments are a definition of a path with two endpoints.
 * @author Zack
 */
class Rune extends FlxSpriteGroup
{
	
	private var runeSegments:Array<RuneSegment>;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		runeSegments = new Array<RuneSegment>();
	}
	
}