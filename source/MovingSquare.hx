package;

import flixel.FlxG;
import flixel.FlxSprite;

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
		
		this.color = FlxG.random.color();
        this.x = startX; 
        this.y = startY;
        timeScaler = FlxG.random.float(0, 1.5);
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        timer += elapsed * timeScaler;
        this.x = startX + Math.cos(timer)*20;
        this.y = startY + Math.sin(timer)*20;
    }
}