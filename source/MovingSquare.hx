package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxRandom;

class MovingSquare extends FlxSprite {

    private var startX:Int;
    private var startY:Int;
    private var timer:Float;
    private var timeScaler:Float;

    public function new(x:Int, y:Int) {
        super();
        startX = x;
        startY = y;
        timer = 0.0;
        makeGraphic(3, 3, 0xFFFFFFFF);
		color = FlxColorUtil.getRandomColor(50, 255);
        this.x = startX;
        this.y = startY;
        timeScaler = FlxRandom.floatRanged(0, 1.5);
    }
    
    override public function update():Void {
        super.update();
        timer += FlxG.elapsed * timeScaler;
        this.x = startX + Math.cos(timer)*20;
        this.y = startY + Math.sin(timer)*20;
    }
}