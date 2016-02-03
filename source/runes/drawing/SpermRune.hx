package runes.drawing;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import runes.drawing.Rune;

/**
 * ...
 * @author Zack
 */
class SpermRune extends runes.drawing.Rune
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		var path:Array<FlxPoint> = new Array<FlxPoint>();
		path.push(new FlxPoint(96, 107));
		path.push(new FlxPoint(104, 101));
		path.push(new FlxPoint(109, 95));
		path.push(new FlxPoint(111, 82));
		path.push(new FlxPoint(112, 76));
		path.push(new FlxPoint(109, 63));
		path.push(new FlxPoint(100, 52));
		path.push(new FlxPoint(88, 45)); 
		path.push(new FlxPoint(75, 41));
		path.push(new FlxPoint(63, 42));
		path.push(new FlxPoint(55, 44));
		path.push(new FlxPoint(42, 48));
		path.push(new FlxPoint(34, 54));
		path.push(new FlxPoint(27, 64));
		path.push(new FlxPoint(25, 78));
		
		var endpoints:Array<FlxPoint> = new Array<FlxPoint>();
		endpoints.push(new FlxPoint(96, 107));
		endpoints.push(new FlxPoint(212, 270));
		
		runeSegments.push(new RuneSegment(endpoints, path));
		add(new FlxSprite(X, Y, AssetPaths.SpermRune__png));
		for (point in path) {
			var d = new FlxSprite(point.x, point.y);
			d.makeGraphic(2, 2);
			add(d);
		}
		for (point in endpoints) {
			var d = new FlxSprite(point.x, point.y);
			d.makeGraphic(5, 5, 0xFF00FF00);
			add(d);
		}
		
	}
	
}