
package ;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class ProjectileL2 extends FlxSprite
{
	private var _speed:Float;
	public static var Damage:Float = 25;

	public function new()
	{
		super();

		loadGraphic(AssetPaths.keysL2__png,true,16,8);
		animation.add("keys",[0,1,2,3,4,5],0,false);
		acceleration.y = 400;
		_speed = 400;
		width = 16;
		height = 8;
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
		animation.randomFrame();
		super.reset(location.x - width/2, location.y - height/2);
		velocity.x = direction.x * _speed + parentVelocity.x;
		velocity.y = direction.y * _speed + parentVelocity.y;
		solid = true;
		angularVelocity = FlxRandom.floatRanged(-500,500);
	}
	

}