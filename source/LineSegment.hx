package;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Zack
 */
class LineSegment
{
	public var p1:FlxPoint;
	public var p2:FlxPoint;
	public function new(p1:FlxPoint, p2:FlxPoint) 
	{
		this.p1 = p1;
		this.p2 = p2;
	}
}