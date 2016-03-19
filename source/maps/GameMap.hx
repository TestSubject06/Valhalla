package maps;

import flixel.FlxSprite;
import flixel.tile.FlxTilemap;

/**
 * Once initialized, it cannot be re-sized.
 * ...
 * @author Zack
 */
class GameMap extends FlxTilemap
{
	public var mapData:Array<Int>;
	//TODO: Possibly convert this to an array of entrances and exits, for branching paths?
	public var stairsDown:FlxSprite;
	public var stairsUp:FlxSprite;
	public function new(width:Int, height:Int) 
	{
		super();
		var i = 0;
		mapData = [];
		while (i < width * height) {
			mapData.push(1);
			i++;
		}
		this.heightInTiles = height;
		this.widthInTiles = width;
	}
	
	public function getMapTile(x:Int, y:Int, solidOob:Bool):Int {
		if (x < 0 || x > widthInTiles - 1 || y < 0 || y > heightInTiles - 1) {
			//Return solid wall outside of the bounds of the map.
			return solidOob ? 1 : 0;
		}
		return mapData[x + (widthInTiles * y)];
	}
	
	public function setMapTile(x:Int, y:Int, tile:Int):Int {
		return mapData[x + (widthInTiles*y)] = tile;
	}
	
	public function setMapRect(x:Int, y:Int, width:Int, height:Int, tile:Int):Void {
		for (i in x...x + width) {
			for (k in y...y + height) {
				setMapTile(i, k, tile);
			}
		}
	}
	
	public function checkRect(x:Int, y:Int, width:Int, height:Int, solidOob:Bool):Bool {
		if(x-1 > 0 && x + width+1 < widthInTiles && y-1 > 0 && y + height + 1 < heightInTiles){
			for(i in x-1...x+width+1){
				for (k in y - 1...y + height + 1){
					if(getMapTile(i, k, solidOob) != 1){
						return false;
					}
				}
			}
		}else{
			return false;
		}
		return true;
	}
	
	public function updateTilemap(tiles:Dynamic = AssetPaths.autotiles__png, autotile:Bool = true):Void {
		trace(tiles);
		trace(autotile);
		loadMapFromArray(mapData, widthInTiles, heightInTiles, tiles, 0, 0, autotile?AUTO:OFF, 0, 0, 1);
		//loadMapFromArray(mapData, 0, 0, tiles, 64, 64, autotile?AUTO:OFF);
	}
	
	//Takes in a tileX and a tileY and adds the stairs up there.
	public function setStairsUp(x:Int, y:Int):Void {
		stairsUp = new FlxSprite(x * 64, y * 64, AssetPaths.StairsUp__png);
	}
	
	//Takes in a tileX and a tileY and adds the stairs up there.
	public function setStairsDown(x:Int, y:Int, visible:Bool):Void {
		stairsDown = new FlxSprite(x * 64, y * 64, AssetPaths.StairsDown__png);
		stairsDown.visible = false;
	}
	
	override public function draw():Void 
	{
		super.draw();
		if (stairsDown != null) {
			stairsDown.draw();
		}
		if (stairsUp != null) {
			stairsUp.draw();
		}
	}
	
}