package maps;
import flixel.FlxG;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Zack
 */
typedef Dimension = {
	width:Int,
	height:Int
}
class DungeonGenerator
{
	private static var result:GameMap;
	private static var rooms:Array<Room>;
	
	public static function generate(width:Int, height:Int, roomCount:Int):GameMap {
		rooms = [];
		result = new GameMap(width, height);
		var numRooms = 0;
		
		var startingRoom:Room = generateRandomStartingRoom(Math.floor(width/2), Math.floor(height/2));
		if (checkAndSetRoomInMap(startingRoom, result)) {
			rooms.push(startingRoom);
		}
		
		while (rooms.length < roomCount) {
			generateRoom();
		}
		
		//Set the tile above any filled tile to '1', anything else to '2'
		var resultTile:Int = 0;
		for (x in 0...width) {
			for (y in 0...height) {
				//if this is an open tile, and the tile above it is a wall
				if (result.getMapTile(x, y, true) == 0 && result.getMapTile(x, y-1, true) == 1) {
					result.setMapTile(x, y - 1, 2);
				}
				
			}
		}
		
		//Choose a room, and place the stairs up somewhere in that room.
		var endRoom = rooms[Math.floor(Math.random() * rooms.length)];
		result.setStairsUp(endRoom.x + Math.floor(Math.random()*endRoom.width), endRoom.y + Math.floor(Math.random()*endRoom.height));
		//Choose a different room, and place the stairs down in that room.
		var startRoom = rooms[Math.floor(Math.random() * rooms.length)];
		while (startRoom == endRoom) {
			startRoom = rooms[Math.floor(Math.random() * rooms.length)];
		}
		result.setStairsDown(startRoom.x + Math.floor(Math.random()*startRoom.width), startRoom.y + Math.floor(Math.random()*startRoom.height), true);
		
		return result;
	}
	
	//It will try to center the room on thexe coords.
	private static function generateRandomStartingRoom(x:Int, y:Int):Room {
		var room = getRandomRoomSize();
		if (result.checkRect(Math.floor(x - room.width / 2), Math.floor(y - room.height / 2), room.width, room.height, false)) {
			return new Room(Math.floor(x - room.width / 2), Math.floor(y - room.height / 2), room.width, room.height);
		}else{
			return generateRandomStartingRoom(x, y);
		}
	}
	
	private static function getRandomRoomSize():Dimension {
		var random = Math.random();
		if(random < 0.15){
			return {width: Math.ceil(Math.random() * 7 + 3), height:1};
		}else if(random < 0.3){
			return {width: 1, height:Math.ceil(Math.random() * 7 + 3)};
		}else{
			return {width: Math.ceil(Math.random() * 6 + 2), 
						height:  Math.ceil(Math.random() * 6 + 2)};
		}
	}
	
	private static function getRandomEdgeOfRoom(room:Room, direction:Int):Dynamic {
		switch(direction) {
			case 0:
				return {
					x: Math.floor(Math.random() * room.width) + room.x,
					y: room.y-1
				}
			case 1:
				return {
					y: Math.floor(Math.random() * room.height) + room.y,
					x: room.x+room.width
				}
			case 2:
				return {
					y: room.y + room.height,
					x: Math.floor(Math.random() * room.width) + room.x
				}
			case 3:
				return {
					y: Math.floor(Math.random() * room.height) + room.y,
					x: room.x -1
				}
		}
		return { x:0, y:0 };
	}
	
	private static function generateRoom():Room {
		var room:Room = rooms[Math.floor(Math.random() * rooms.length)];
		
		//Pick a direction
		var direction = Math.floor(Math.random() * 4);
		
		//Get a wall bordering the room
		var wallPos = getRandomEdgeOfRoom(room, direction);
		
		//Generate a room size
		var newRoomSize = getRandomRoomSize();

		//Offset based on direction
		var x = wallPos.x + 0;
		var y = wallPos.y + 0;
		switch(direction){
			case 0:
				y -= newRoomSize.height;
				x -= Math.floor(Math.random()*newRoomSize.width);
			
			case 1:
				x += 1;
				y -= Math.floor(Math.random()*newRoomSize.height);
			
			case 2:
				y += 1;
				x -= Math.floor(Math.random()*newRoomSize.width);
			
			case 3:
				x -= newRoomSize.width;
				y -= Math.floor(Math.random()*newRoomSize.height);
		}
		
		var newRoom = new Room(x, y, newRoomSize.width, newRoomSize.height);
		if (checkAndSetRoomInMap(newRoom, result)) {
			result.setMapTile(wallPos.x, wallPos.y, 0);
			rooms.push(newRoom);
			return newRoom;
		}
		
		return null;
	}
	
	private static function checkAndSetRoomInMap(room:Room, map:GameMap):Bool {
		if (map.checkRect(room.x, room.y, room.width, room.height, false)) {
			trace(room.x, room.y, room.width, room.height);
			map.setMapRect(room.x, room.y, room.width, room.height, 0);
			return true;
		}
		return false;
	}
}