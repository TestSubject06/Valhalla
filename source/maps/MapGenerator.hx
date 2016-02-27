package maps;

/**
 * ...
 * @author Zack
 */
enum MapType {
	Dungeon;
	Cavern;
}

class MapGenerator
{
	private var result:GameMap;
	private var mapType:MapType;
	
	public function new(type:MapType) 
	{
		this.mapType = type;
	}
	
	public function setMapType(type:MapType) {
		this.mapType = type;
	}
	
	public static function generateMap(type:MapType, width:Int, height:Int, modifier:Int):GameMap {
		switch(type) {
			case Dungeon:
				return DungeonGenerator.generate(width, height, modifier);
				
			case Cavern:
				return CaveGenerator.generate(width, height, modifier);
			
			default:
				return null;
		}
	}
	
}