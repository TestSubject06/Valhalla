package ui.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;
import player.Actor;
import items.Item;
/**
 * ...
 * @author Zack
 */
enum InventorySubMenuAction {
	Cancel;
	Use;
	Give;
	Equip;
	Drop;
}
class Inventory extends FlxSubState
{
	private var inventory:Array<Item>;
	private var actor:Actor;
	private var container:FlxSpriteGroup;
	private var selector:FlxText;
	private var selected:Int = 0;
	private var action:InventorySubMenuAction = Cancel;
	private var openSubStateNextFrame:FlxSubState = null;
	public function new(BGColor:FlxColor=0, x:Int, y:Int, actor:Actor) 
	{
		super(BGColor);
		this.actor = actor;
		container = new FlxSpriteGroup(x, y);
	}
	
	override public function create():Void 
	{
		super.create();
		var backgroundSprite = new FlxSprite(0, 0);
		backgroundSprite.makeGraphic(250, 300, 0x0);
		FlxSpriteUtil.drawRoundRect(backgroundSprite, 0, 0, backgroundSprite.width-1, backgroundSprite.height-1, 5, 5, 0xff000080, { color:0xFFFFFFFF } );
		container.add(backgroundSprite);
		
		selector = new FlxText(3, 0, 20, ">", 8);
		container.add(selector);
		
		fillContainer();
		
		container.scrollFactor.set(0, 0);
		add(container);
	}
	
	public function fillContainer():Void {
		var tmp1 = container.members[0];
		var tmp2 = container.members[1];
		tmp2.x = 3;
		tmp2.y = 0;
		tmp1.x = 0;
		tmp1.y = 0;
		container.clear();
		container.add(tmp1);
		container.add(tmp2);
		inventory = actor.getInventory();
		
		container.add(new FlxText(0, 0, 200, actor.getName() + "'s Inventory", 16));
		container.add(new FlxText(190, 0, 60,inventory.length + "/" + Actor.MAX_INVENTORY, 16)); //TODO: Replace 30 with max inventory size constant somewhere.
		
		var index = 0;
		for (item in actor.getInventory()) {
			container.add(new FlxText(20, index * 10 + 25, 200, item.getName(), 8));
			index++;
		}
		container.add(new FlxText(20, index * 10 + 25, 200, "Cancel", 8));
		
		container.scrollFactor.set(0, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (openSubStateNextFrame != null) {
			openSubState(openSubStateNextFrame);
			openSubStateNextFrame = null;
		}
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed(["DOWN", "S"])) {
			selected = FlxMath.wrap(++selected, 0, inventory.length);
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"])) {
			selected = FlxMath.wrap(--selected, 0, inventory.length);
		}
		if (FlxG.keys.anyJustPressed(["ESCAPE", "X"])) {
			close();
		}
		if (FlxG.keys.anyJustPressed(["Z", "ENTER"])) {
			if (selected == inventory.length) {
				close();
			}else {
				action = Cancel;
				var subState = new SelectOneOf(Math.floor(selector.getScreenPosition().x + 50), Math.floor(selector.getScreenPosition().y), ["Use", "Give", "Equip", "Drop"], function(selectedItem:Int):Void {
					switch(selectedItem) {
						case 0:
							//TODO: Use item
							trace("Use the item");
							action = Use;
						case 1:
							//TODO: Give item
							trace("Give the item");
							action = Give;
						case 2:
							//TODO: Equip item
							trace("Equip the item");
							action = Equip;
						case 3:
							//TODO: Drop item
							trace("Drop the item");
							action = Drop;
					}
				});
				subState.closeCallback = function():Void {
					switch(action) {
						case Give:
							var options:Array<String> = [];
							var characterMap:Map<Int, Actor> = new Map();
							for (member in PartyInformation.getParty().getMembers().filter(function(a:Actor):Bool { return a != actor; } )) {
								characterMap.set(options.length, member);
								options.push(member.getName());
							}
							openSubStateNextFrame = new SelectOneOf(Math.floor(selector.getScreenPosition().x + 50), Math.floor(selector.getScreenPosition().y), options, function(selectedItem:Int):Void {
								//Get the item
								var item:Item = inventory[selected];
								//Put it in the friend's inventory
								actor.takeItem(item);
								characterMap[selectedItem].giveItem(item);
								//Remove it from current inventory
								trace("Redraw inventory");
								//Flag inventory for redraw
								fillContainer();
								options = null;
								characterMap = null;
							});
							
						default:
							return;
					}
				}
				openSubState(subState);
			}
		}
		selector.y = (selected * 10) + 60;
		
		
	}
	
	
	
}