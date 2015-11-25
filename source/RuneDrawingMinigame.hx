package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;

/**
 * ...
 * @author Zack
 */
class RuneDrawingMinigame extends FlxSpriteGroup
{
	private var timerBar:FlxBar;
	private var timer:Float;
	private var totalTime:Float;
	private var minigameRunning:Bool;
	
	private var runeCompleteCallback:Void->Void;
	private var spellCompleteCallback:Spell->Int->Void;
	private var spell:Spell;
	
	private var spellBackdrop:FlxSprite;
	private var spellBackdropPulse:FlxSprite;
	
	private var spellBackdropFire1:FlxSprite;
	private var spellBackdropFire2:FlxSprite;
	private var spellBackdropFire3:FlxSprite;
	private var spellBackdropFire4:FlxSprite;
	
	public function new() 
	{
		super(0, 0, 16);
		totalTime = 5.0;
		timerBar = new FlxBar(FlxG.width / 2 - 100, FlxG.height - 20, FlxBar.FILL_LEFT_TO_RIGHT, 200, 10, this, "timer", 0.0, totalTime, true);
		add(timerBar);
		minigameRunning = false;
		
		spellBackdrop = new FlxSprite(0, 0, AssetPaths.RunicBackdrop__png);
		spellBackdrop.antialiasing = true;
		spellBackdrop.scale.set(0.7, 0.7);
		spellBackdrop.x = FlxG.width / 2 - spellBackdrop.width / 2;
		spellBackdrop.y = FlxG.height / 2 - spellBackdrop.height / 2;
		spellBackdrop.visible = false;
		add(spellBackdrop);
		
		spellBackdropPulse = new FlxSprite(0, 0, AssetPaths.RunicBackdrop__png);
		spellBackdropPulse.antialiasing = true;
		spellBackdropPulse.scale.set(0.8, 0.8);
		spellBackdropPulse.x = FlxG.width / 2 - spellBackdrop.width / 2;
		spellBackdropPulse.y = FlxG.height / 2 - spellBackdrop.height / 2;
		spellBackdropPulse.visible = false;
		add(spellBackdropPulse);
		
		spellBackdropFire1 = new FlxSprite(0, 0, AssetPaths.FireRune1__png);
		spellBackdropFire1.antialiasing = true;
		spellBackdropFire1.scale.set(0.20, 0.20);
		spellBackdropFire1.x = FlxG.width / 2 - spellBackdropFire1.width / 2;
		spellBackdropFire1.y = FlxG.height / 2 - spellBackdropFire1.height / 2;
		add(spellBackdropFire1);
		
		spellBackdropFire2 = new FlxSprite(0, 0, AssetPaths.FireRune2__png);
		spellBackdropFire2.antialiasing = true;
		spellBackdropFire2.scale.set(0.20, 0.20);
		spellBackdropFire2.x = FlxG.width / 2 - spellBackdropFire2.width / 2;
		spellBackdropFire2.y = FlxG.height / 2 - spellBackdropFire2.height / 2;
		add(spellBackdropFire2);
		
		spellBackdropFire3 = new FlxSprite(0, 0, AssetPaths.FireRune3__png);
		spellBackdropFire3.antialiasing = true;
		spellBackdropFire3.scale.set(0.20, 0.20);
		spellBackdropFire3.x = FlxG.width / 2 - spellBackdropFire3.width / 2;
		spellBackdropFire3.y = FlxG.height / 2 - spellBackdropFire3.height / 2;
		add(spellBackdropFire3);
		
		spellBackdropFire4 = new FlxSprite(0, 0, AssetPaths.FireRune4__png);
		spellBackdropFire4.antialiasing = true;
		spellBackdropFire4.scale.set(0.20, 0.20);
		spellBackdropFire4.x = FlxG.width / 2 - spellBackdropFire4.width / 2;
		spellBackdropFire4.y = FlxG.height / 2 - spellBackdropFire4.height / 2;
		add(spellBackdropFire4);
		
		add(new SpermRune(100, 100));
	}
	
	override public function update():Void 
	{
		if (minigameRunning) {
			//spellBackdrop.angle += FlxG.elapsed * 30;
			//spellBackdropPulse.angle += FlxG.elapsed * 30;
			spellBackdropFire1.angle += FlxG.elapsed * 30;
			spellBackdropFire2.angle -= FlxG.elapsed * 30;
			spellBackdropFire4.angle += FlxG.elapsed * 30;
			//spellBackdropPulse.scale.set(Math.sin(timer*20)*0.02+0.69, Math.sin(timer*20)*0.02+0.69);
			super.update();	
			timer -= FlxG.elapsed;
			if (timer <= 0) {
				minigameRunning = false;
				spellCompleteCallback(spell, 0);
			}
		}else {
			visible = false;
		}
	}
	
	public function startMinigame(spell:Spell, runeCompleteCallback:Void->Void, spellCompleteCallback:Spell->Int->Void):Void {
		if(!minigameRunning){
			minigameRunning = true;
			this.runeCompleteCallback = runeCompleteCallback;
			this.spellCompleteCallback = spellCompleteCallback;
			this.spell = spell;
			
			timer = totalTime;
			visible = true;
		}
	}
	
}