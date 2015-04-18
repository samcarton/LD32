
package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class ProjectileL3 extends FlxSprite
{
	private var _speed:Float;
	public static var Damage:Float = 35;

	public function new()
	{
		super();
		if(FlxRandom.chanceRoll(50))
		{
			loadGraphic(AssetPaths.spacebar__png,false,24,8);
			width = 24;
			height = 8;			
		}
		else
		{
			loadGraphic(AssetPaths.return__png,false,16,16);
			width = 16;
			height = 16;
		}
		
		acceleration.y = 400;
		_speed = 400;
		
	}
	
	override public function update():Void
	{
		if(touching != 0)
		{
			kill();
		}
		super.update();
	}

	public function Shoot(location:FlxPoint, direction:FlxPoint, parentVelocity:FlxPoint):Void
	{		
		super.reset(location.x - width/2, location.y - height/2);
		velocity.x = direction.x * _speed + parentVelocity.x;
		velocity.y = direction.y * _speed + parentVelocity.y;
		solid = true;
		angularVelocity = FlxRandom.floatRanged(-300,300);
	}
	

}