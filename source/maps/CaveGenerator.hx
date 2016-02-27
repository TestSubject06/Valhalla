package maps;
import lime.ui.Gamepad;

/**
 * ...
 * @author Zack
 */
class CaveGenerator
{
	private static var result:GameMap;
	private static var shadowMap:Array<Int>;
	public static function generate(width:Int, height:Int, initPercent:Int):GameMap {
		var map:GameMap = null;
		while (map == null) {
			map = genMap(width, height, initPercent);
		}
		return map;
	}
	
	private static function genMap(width:Int, height:Int, initPercent:Int):GameMap {
		result = new GameMap(width, height);
		shadowMap = [];
		for (x in 0...width) {
			for (y in 0...height) {
				result.setMapTile(x, y, Math.random() * 100 < initPercent ? 1 : 0);
				shadowMap.push(0);
			}
		}
		
		for (i in 0...4) {
			genStep(5, 2);
		}
		
		for (i in 0...3) {
			genStep(5, -1);
		}
		if (floodFill()) {
			return result;
		}
		return null;
	}
	
	private static function genStep(R1:Int, R2:Int):Void {
		for (x in 0...result.widthInTiles) {
			for (y in 0...result.heightInTiles) {
				var count = countCellAndNStepNeighbors(x, y, 1);
				var count2 = countCellAndNStepNeighbors(x, y, 2);
				if (count >= R1 || count2 <= R2) {
					shadowMap[x + result.widthInTiles * y] = 1;
				}else {
					shadowMap[x + result.widthInTiles * y] = 0;
				}
			}
		}
		result.mapData = shadowMap.slice(0);
	}
	
	private static function floodFill():Bool {
		var width = result.widthInTiles;
		var height = result.heightInTiles;
		var x = Math.floor(Math.random() * width);
		var y = Math.floor(Math.random() * height);
		while (result.getMapTile(x, y, true) != 0) {
			x = Math.floor(Math.random() * width);
			y = Math.floor(Math.random() * height);
		}
		var Q:Array<Dynamic> = [ { x:x, y:y } ];
		var P:Array<Bool> = [];
		for (i in 0...width * height) {
			P.push(false);
		}
		var numBlue = 0;
		while (Q.length > 0) {
			var node = Q.shift();
			if (result.getMapTile(node.x, node.y, true) == 0) {
				result.setMapTile(node.x, node.y, 2);
				numBlue++;
				P[node.x + node.y * width] = true;
				
				if(!P[node.x+1 + node.y * width])
					Q.push({x:node.x+1, y:node.y});
				if(!P[Math.floor((node.x-1) + node.y * width)])
					Q.push({x:node.x-1, y:node.y});
				if(!P[node.x + ((node.y+1) * width)])
					Q.push({x:node.x, y:node.y+1});
				if(!P[node.x + ((node.y-1) * width)])
					Q.push({x:node.x, y:node.y-1});
			}
		}
		if (numBlue < width * height * 0.45) {
			return false;
		}
		
		for (i in 0...width) {
			for (k in 0...height) {
				if (result.getMapTile(i, k, true) != 2) {
					result.setMapTile(i, k, 1);
				}else {
					result.setMapTile(i, k, 0);	
				}
			}
		}
		return true;
	}
	
	private static function countCellAndNStepNeighbors(x:Int, y:Int, steps:Int):Int {
		var count = 0;
		var iters = 0;
		for (i in x - steps...x + steps+1) {
			for (k in y - steps...y + steps + 1) {
				iters++;
				if (result.getMapTile(i, k, true) == 1) {
					count++;
				}
			}
		}
		return count;
	}
}