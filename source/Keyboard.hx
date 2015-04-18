
package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

class Keyboard extends FlxSprite
{
	public static var Damage:Float = 10;
	public static var HitVelocityX:Float = 200;
	public var HitDirection:Int;
	public function new()
	{
		super();
		loadGraphic(AssetPaths.keyboard__png,false,16,10);
		width = 16;
		height = 10;
		HitDirection = 0;
	}	

}