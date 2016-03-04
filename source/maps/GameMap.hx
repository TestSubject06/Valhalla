package maps;

import flixel.tile.FlxTilemap;

/**
 * Once initialized, it cannot be re-sized.
 * ...
 * @author Zack
 */
class GameMap extends FlxTilemap
{
	public var mapData:Array<Int>;
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
		
		loadMap(mapData, tiles, 0, 0, autotile ? FlxTilemap.AUTO : FlxTilemap.OFF, 0, 0, 1);
	}
	
}