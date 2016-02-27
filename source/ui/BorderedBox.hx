package ui;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import ui.layout.Layout;

/**
 * ...
 * @author Zack
 */
class BorderedBox extends FlxGroup
{
	//Ideal API:
	//var uiElement:BorderedBox = new BorderedBox(borderType, Layout.VERTICAL, width?, height?);
	//uiElement.push(new FlxBasic());
	//
	private var background:FlxSprite;
	private var layout:Layout;
	private var width:Int;
	private var height:Int;
	private var padding:Int = 5;
	private var x:Int;
	private var y:Int;
	public function new(x:Int, y:Int, borderType:Int, layout:Layout, ?width:Int, ?height:Int) 
	{
		super();
		height = 0;
		this.x = x;
		this.y = y;
	}
	
	public function push(object:FlxObject):Void {
		object.x = x + padding;
		object.y = y + height + padding;
		height += Math.ceil(object.height + padding);
		add(object);
	}
	
	public function moveTo(x:Int, y:Int) {
		var dx = this.x - x;
		var dy = this.y - y;
		for (i in members) {
			try {
				cast (i, FlxObject).x -= dx;
				cast (i, FlxObject).y -= dy;
			}catch (s:String) {
				//Do nothing - it's not moveable.
			}
		}
	}
	
	public function getHeight():Int {
		return height + padding;
	}
	
}