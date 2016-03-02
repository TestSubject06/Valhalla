package items;

/**
 * ...
 * @author Zack
 */
class Stick extends Item
{

	public function new() 
	{
		super();
		name = "Stick";
		usable = false;
		equipment = true;
		targetingType = 0;
	}
	
}