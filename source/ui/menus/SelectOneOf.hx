package ui.menus;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Zack
 */
class SelectOneOf extends FlxSubState
{
	public var selectCallback:Int->Void;
	private var container:FlxSpriteGroup;
	private var items:Array<String>;
	private var title:String;
	private var selector:FlxText;
	private var selected:Int = 0;
	public function new(x:Int, y:Int, items:Array<String>, callback:Int->Void, title:String="")
	{
		super(FlxColor.TRANSPARENT);
		container = new FlxSpriteGroup(x, y);
		this.items = items;
		this.title = title;
		selectCallback = callback;
	}
	
	override public function create():Void 
	{
		super.create();
		var backgroundSprite = new FlxSprite(0, 0);
		container.add(backgroundSprite);

		var pos = 0;
		if (title != "") {
			container.add(new FlxText(0, 0, 100, title, 16));
			pos ++;
		}
		for (item in items) {
			container.add(new FlxText(15, pos * 20, 100, item, 16));
			pos++;
		}
		container.add(new FlxText(15, pos * 20, 100, "Cancel", 16));
		
		selector = new FlxText(3, 0, 20, ">", 16);
		container.add(selector);
		
		backgroundSprite.makeGraphic(Math.floor(container.width), Math.floor(container.height), 0x0);
		FlxSpriteUtil.drawRoundRect(backgroundSprite, 0, 0, backgroundSprite.width-1, backgroundSprite.height-1, 5, 5, 0xff000080, { color:0xFFFFFFFF } );
		
		container.scrollFactor.set(0, 0);
		add(container);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed(["DOWN", "S"])) {
			selected = FlxMath.wrap(++selected, 0, items.length);
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"])) {
			selected = FlxMath.wrap(--selected, 0, items.length);
		}
		if (FlxG.keys.anyJustPressed(["ESCAPE", "X"])) {
			close();
		}
		if (FlxG.keys.anyJustPressed(["Z", "ENTER"])) {
			if (selected == items.length) {
				close();
			}else {
				selectCallback(selected);
				close();
			}
		}
		selector.y = container.y + (selected * 20);
	}
	
}