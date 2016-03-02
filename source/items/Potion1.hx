package items;

/**
 * ...
 * @author Zack
 */
class Potion1 extends Item
{

	public function new() 
	{
		super();
		name = "Light Healing Potion";
		targetingType = TargetingType.SELF;
		usable = true;
		equipment = false;
	}
	
}