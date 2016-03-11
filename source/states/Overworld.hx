package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxMath;
import maps.DungeonGenerator;
import maps.GameMap;
import player.Party;

/**
 * ...
 * This is the overworld state. It's the junction into many menu sub-systems, as well as the roguelike dungeon crawling mode.
 * 
 * TODO: Going up/down stairs
 * TODO: Menus for inventory and party management
 * TODO: Basic combat transition
 * @author Zack
 */
class Overworld extends FlxState
{
	private var currentMap:GameMap;
	private var playerParty:Party;
	private var enemies:Array<Party>;
	
	private var playerPartyPawn:FlxSprite;
	
	private var turnCount:Int = 0; //This might be useful for things later on.
	private var turnId:Int = 0; //0 is idle. 1 is player movement, 2 is enemy movement.
	override public function create():Void 
	{
		super.create();
		//TODO: Get a little more persistence in this system so it's not always a random ass map.
		currentMap = DungeonGenerator.generate(80, 80, 45);
		currentMap.updateTilemap(AssetPaths.CaiTiles__png, false);
		playerParty = PartyInformation.getParty();
		
		enemies = [];
		
		add(currentMap);
		
		playerPartyPawn = playerParty.getOverworldSprite();
		add(playerPartyPawn);
		playerPartyPawn.x = currentMap.stairsDown.x;
		playerPartyPawn.y = currentMap.stairsDown.y;
		trace(playerParty.getDeity().getName());
		trace(playerParty.getOverworldSprite().pixels);
		
		FlxG.camera.follow(playerPartyPawn);
	}
	
	override public function update():Void 
	{
		super.update();
		var actionPerformed:Bool = false;
		//TODO: Make this much cleaner.
		if (turnId == 0) {
			if (FlxG.keys.anyJustPressed(["LEFT", "A"]) && currentMap.getMapTile(Math.floor(playerPartyPawn.x/64)-1, Math.floor(playerPartyPawn.y/64), true) == 0) {
				playerParty.targetDestination.set(playerPartyPawn.x - 64, playerPartyPawn.y);
				actionPerformed = true;
			}
			if (FlxG.keys.anyJustPressed(["RIGHT", "D"]) && currentMap.getMapTile(Math.floor(playerPartyPawn.x/64)+1, Math.floor(playerPartyPawn.y/64), true) == 0) {
				playerParty.targetDestination.set(playerPartyPawn.x + 64, playerPartyPawn.y);
				actionPerformed = true;
			}
			if (FlxG.keys.anyJustPressed(["UP", "W"]) && currentMap.getMapTile(Math.floor(playerPartyPawn.x/64), Math.floor(playerPartyPawn.y/64)-1, true) == 0) {
				playerParty.targetDestination.set(playerPartyPawn.x, playerPartyPawn.y - 64);
				actionPerformed = true;
			}
			if (FlxG.keys.anyJustPressed(["DOWN", "S"]) && currentMap.getMapTile(Math.floor(playerPartyPawn.x/64), Math.floor(playerPartyPawn.y/64)+1, true) == 0) {
				playerParty.targetDestination.set(playerPartyPawn.x, playerPartyPawn.y + 64);
				actionPerformed = true;
			}
		}
			
		if (actionPerformed) {
			executeTurn();
		}
		if (turnId == 1) {
			//Get chosen direction of the player
			if (slidePawnTo(playerPartyPawn, playerParty.targetDestination.x, playerParty.targetDestination.y)) {
				turnId = 2;
			}
		}
		if (turnId == 2) {
			var allEnemiesDone:Bool = true;
			for (enemy in enemies) {
				//TODO: Move enemies around.
			}
			if (allEnemiesDone) {
				turnId = 0;
				turnCount++;
			}
		}
	}
	
	//Takes in a pawn and lerps it over several frames to x, y
	//Returns true when the pawn made it.
	private function slidePawnTo(pawn:FlxSprite, x:Float, y:Float):Bool {
		trace("Slid Pawn");
		pawn.x = FlxMath.lerp(pawn.x, x, 0.80);
		pawn.y = FlxMath.lerp(pawn.y, y, 0.80);
		if (Math.abs((pawn.x - x) + (pawn.y - y)) < 1) {
			pawn.x = x;
			pawn.y = y;
			return true;
		}
		return false;
	}
	
	private function warpPawnTo(pawn:FlxSprite, x:Int, y:Int):Bool {
		trace("Warped Pawn");
		//TODO: Cool animations?
		pawn.x = x;
		pawn.y = y;
		return true;
	}
	
	private function executeTurn():Void {
		trace("Executed Turn");
		turnId = 1;
	}
	
	override public function destroy():Void 
	{
		trace("Destroyed");
		remove(playerPartyPawn);//Make sure it doesn't get caught in the normal destroy process. It needs to hang around in memory for later.
		super.destroy();
	}
	
}