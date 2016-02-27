package;

/**
 * ...
 * @author Zack
 */
class TargetingType
{
	public static inline var SELF:Int = 0x1;
	public static inline var ALLY:Int = 0x2;
	public static inline var ENEMY:Int = 0x4;
	public static inline var ALL_SIDE:Int = 0x8;
	public static inline var ALL:Int = 0x16;
	public static inline var KO:Int = 0x32;
	public static inline var AFFLICTED:Int = 0x64;
	public static inline var ROW:Int = 0x128;
	public static inline var COLUMN:Int = 0x256;
	public static inline var ADJACENT:Int = 0x512;
	
	public function new() 
	{
		
	}
	
}