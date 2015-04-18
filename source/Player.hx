
package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{

	public var JumpKeys:Array<String>;
	public var LeftKeys:Array<String>;
	public var RightKeys:Array<String>;
	public var AttackKeys:Array<String>;
	public var BufferClearKeys:Array<String>;
	public var BufferSpamKeys:Array<String>;

	private var _jumpVelocity:Float;
	
	public function new(PlayerColor:Int,X:Float = 0, Y:Float = 0)
	{
		super(X,Y);
		makeGraphic(16,16, PlayerColor);
		maxVelocity.set(200,800);
		acceleration.y = 400; // GRAVITY
		drag.x = 1500;
		_jumpVelocity = 250;
	}

	override public function update():Void
	{
		ApplyMovement();
		super.update();
	} 
	
	private function ApplyMovement():Void
	{
		acceleration.x = 0;
		if(FlxG.keys.anyPressed(LeftKeys))
		{
			acceleration.x = -maxVelocity.x * 4;
		}
		if(FlxG.keys.anyPressed(RightKeys))
		{
			acceleration.x = maxVelocity.x * 4;
		}
		if(FlxG.keys.anyPressed(JumpKeys) && isTouching(FlxObject.FLOOR)) 
		{
			velocity.y = -_jumpVelocity;
		}

	}

}