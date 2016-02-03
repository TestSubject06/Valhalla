package runes.drawing;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import haxe.ds.Vector;

/**
 * ...
 * @author Zack
 */
class RuneSegment
{
	private static inline var pointSize:Int = 5;
	private var endpoints:Array<FlxPoint>;
	private var path:Array<FlxPoint>;
	
	public function new(endpoints:Array<FlxPoint>, path:Array<FlxPoint>) 
	{
		this.path = path;
		this.endpoints = endpoints;
	}
	
	/**
	 * Checks if this line segment passed through 
	 * @param	lineSegment the line segment to pass this through
	 */
	public function testLineSegmentAgainstPath(lineSegment:LineSegment) {
		for(point in path){
			var d:FlxPoint = new FlxPoint(lineSegment.p2.x - lineSegment.p1.x, lineSegment.p2.y - lineSegment.p1.y);
			var f:FlxPoint = new FlxPoint(lineSegment.p1.x - point.x, lineSegment.p1.y - point.y);
			
			var a:Float = FlxMath.dotProduct(d.x, d.y, d.x, d.y);
			var b:Float = 2 * FlxMath.dotProduct(f.x, f.y, d.x, d.y);
			var c:Float = FlxMath.dotProduct(f.x, f.y, f.x, f.y) - pointSize * pointSize;
			
			var discriminant:Float = b * b - 4 * a * c;
			
			if( discriminant < 0 ){
				continue;
			} else {
				discriminant = Math.sqrt(discriminant);
				
				var t1:Float = ( -b - discriminant) / (2 * a);
				var t2:Float = ( -b + discriminant) / (2 * a);
				
				if((t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1)){
					path.remove(point);
					continue;
				}
			}
		}
	}
	
}