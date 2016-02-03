package runes.keyboard;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxRandom;

/**
 * ...
 * Contains runic words that the user must type in rapid succession
 * @author Zack
 */
class KeyboardRune extends FlxSpriteGroup
{
	public static var runes:Array<String> = ["khak", "burk", "ched", "zlot", "pohk", "jhei", "ehnk", "kiij", "quaa", "bido"];
	
	private var targetRune:String;
	private var progress:Int;
	private var runeCompleteCallback:Void->Void;
	private var done:Bool = false;
	private var level:Int;
	
	private var letters:Array<FlxSprite>;

	public function new() 
	{
		super(0, 0, 0);
	}
	
	override public function update():Void 
	{
		super.update();
		//Check to see if the current key we needed was just pressed.
		if (FlxG.keys.checkStatus(FlxG.keys.getKeyCode(targetRune.charAt(progress).toUpperCase()), FlxKey.JUST_PRESSED) && !done) {
			trace("Rune Word Progressed. Just pressed:", targetRune.charAt(progress).toUpperCase());
			letters[progress].color = 0x999999;
			if (++progress >= targetRune.length) {
				//We finished typing the word!
				runeCompleteCallback();
				//Tear down the old rune.
				endRune();
				//Set up for the next rune.
				_startRune(++level);
			}
			letters[progress].color = 0xFFFF00;
		}
	}
	
	override public function draw():Void 
	{
		super.draw();
	}
	
	public function startRune(level:Int, runeCompleteCallback:Void->Void):Void {
		this.runeCompleteCallback = runeCompleteCallback;
		_startRune(level);
	}
	
	private function _startRune(level:Int):Void {
		targetRune = getRune(level);
		progress = 0;
		done = false;
		this.level = level;
		//Set up visuals for the rune
		letters = new Array<FlxSprite>();
		for (i in 0...targetRune.length) {
			var a = new FlxText(i * 20, 0, 0, targetRune.charAt(i), 16);
			a.x += FlxG.width / 2 - (20 * targetRune.length) / 2;
			a.y += FlxG.height / 2 - a.height / 2;
			a.color = i == 0 ? 0xFFFF00 : 0xFFFFFF;
			letters.push(a);
			add(a);
		}
	}
	
	//Get a random rune from the list of runes.
	private function getRune(level:Int):String {
		switch(level) {
			default:
				return getRandomFrom(0, 9);
		}
	}
	
	private function getRandomFrom(startIndex:Int, endIndex:Int):String {
		return runes[FlxRandom.intRanged(startIndex, endIndex)];
	}
	
	public function endRune():Void {
		for (sprite in letters) {
			remove(sprite);
			sprite = null;
		}
		letters = null;
	}
	
}