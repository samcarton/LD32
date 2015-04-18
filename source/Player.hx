
package ;

import flixel.FlxG;
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
	
	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X,Y);
		makeGraphic(16,16, FlxColor.RED);
		maxVelocity.set(200,200);
		//acceleration.y = 200; // GRAVITY
		drag.x = maxVelocity.x * 4;
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
		if(FlxG.keys.anyPressed(JumpKeys)) // add check for if touching floor
		{
		
		}

	}

}