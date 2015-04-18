
package ;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class ProjectileL1 extends FlxSprite
{
	private var _speed:Float;

	public function new()
	{
		super();

		loadGraphic(AssetPaths.keysL1__png,true,8,8);
		animation.add("keys",[0,1,2,3,4,5,6,7,8,9,10,11],0,false);
		acceleration.y = 400;
		_speed = 150;
		width = 8;
		height = 8;
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