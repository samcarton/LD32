
package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;

class Player extends FlxSprite
{

	public var JumpKeys:Array<String>;
	public var LeftKeys:Array<String>;
	public var RightKeys:Array<String>;
	public var AttackKeys:Array<String>;
	public var BufferClearKeys:Array<String>;
	public var BufferSpamKeys:Array<String>;
	public var ShootKeys:Array<String>;

	private var _jumpVelocity:Float;

	public var Charge:Float;
	public var Health:Float;

	private var _chargeIncrement:Float;

	private var _projectilesL1:FlxTypedGroup<ProjectileL1>;
	private var _projectilesL2:FlxTypedGroup<ProjectileL2>;

	private var _chargeEmptyValue:Float;
	private static var _chargeLevel1:Float = 36;
	private static var _chargeLevel2:Float = 65;
	private static var _chargeLevel3:Float = 95;
	

	public function new(PlayerColor:Int,X:Float = 0, Y:Float = 0, ProjectilesL1:FlxTypedGroup<ProjectileL1>, ProjectilesL2:FlxTypedGroup<ProjectileL2>)
	{
		super(X,Y);
		
		//makeGraphic(16,16, PlayerColor);
		loadGraphic(AssetPaths.pc1__png,true,16,16);
		setFacingFlip(FlxObject.LEFT,true,false );
		setFacingFlip(FlxObject.RIGHT,false,false );
		animation.add("walk",[1,0],8,false);

		color = PlayerColor;

		setSize(15,15);
		offset.set(0,1);

		maxVelocity.set(200,800);
		acceleration.y = 400; // GRAVITY
		drag.x = 1500;
		_jumpVelocity = 250;

		Health = 100;
		Charge = _chargeEmptyValue = 6;
		_chargeIncrement = 6;		

		_projectilesL1 = ProjectilesL1;
		_projectilesL2 = ProjectilesL2;

	}

	override public function update():Void
	{
		ApplyMovement();
		ApplyCharge();
		Shoot();
		super.update();
	} 
	
	private function ApplyMovement():Void
	{
		acceleration.x = 0;
		if(FlxG.keys.anyPressed(LeftKeys))
		{
			facing = FlxObject.LEFT;
			acceleration.x = -maxVelocity.x * 4;
		}
		if(FlxG.keys.anyPressed(RightKeys))
		{
			facing = FlxObject.RIGHT;
			acceleration.x = maxVelocity.x * 4;
		}
		if(FlxG.keys.anyJustPressed(JumpKeys) && isTouching(FlxObject.FLOOR)) 
		{
			velocity.y = -_jumpVelocity;
		}
		if(isTouching(FlxObject.FLOOR) && velocity.x != 0)
		{
			animation.play("walk");
		}
	}

	private function ApplyCharge():Void
	{
		if(FlxG.keys.anyJustPressed(BufferSpamKeys))
		{
			Charge += _chargeIncrement;
		}
		if(Charge>= _chargeLevel3)
		{
			Charge	= _chargeLevel3;
		}
	}

	private function Shoot():Void
	{
		if(FlxG.keys.anyJustPressed(ShootKeys))
		{
			var midPoint:FlxPoint = getMidpoint();
			_projectilesL2.recycle(ProjectileL2).Shoot(midPoint, new FlxPoint(facing == FlxObject.RIGHT ? 1 : -1,-0.25),velocity);
		}
	}

	override public function hurt(Damage:Float):Void
	{
		Health -= Damage;
	}	

}