
package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;
import flixel.util.FlxSpriteUtil;

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
	private var _projectilesL3:FlxTypedGroup<ProjectileL3>;

	private var _keyboardGroup:FlxTypedGroup<Keyboard>;
	private var _keyboard:Keyboard;
	private var _keyboardOffset:Float;
	private var _keyboardPoint:FlxPoint;
	private var _angle:Float;
	private var _angleDiff:Float;	
	private var _angleFinish:Float;
	private var _swinging:Bool;	
	private var _swingFacing:Int;

	private static var _angleStartRight:Float = -80;
	private static var _angleStartLeft:Float = 260;
	private static var _angleFinishRight:Float = 50;
	private static var _angleFinishLeft:Float = 130;
	private static var _angleDiffRight:Float = 7;
	private static var _angleDiffLeft:Float = -7;

	public var _flickering:Bool = false;

	private var _chargeEmptyValue:Float;
	private static var _chargeLevel1:Float = 36;
	private static var _chargeLevel2:Float = 65;
	private static var _chargeLevel3:Float = 95;
	

	public function new(PlayerColor:Int,X:Float = 0, Y:Float = 0, 
		ProjectilesL1:FlxTypedGroup<ProjectileL1>, 
		ProjectilesL2:FlxTypedGroup<ProjectileL2>, 
		ProjectilesL3:FlxTypedGroup<ProjectileL3>, 
		keyboardGroup:FlxTypedGroup<Keyboard>)
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

		_keyboardOffset = 15;
		_angle = 0;
		_angleDiff = 7;		
		_angleFinish = 50;
		_keyboardPoint = new FlxPoint();
		_keyboardGroup = keyboardGroup;
		_swinging = false;
		_swingFacing = FlxObject.RIGHT;


		_projectilesL1 = ProjectilesL1;
		_projectilesL2 = ProjectilesL2;
		_projectilesL3 = ProjectilesL3;
	}

	override public function update():Void
	{
		ApplyMovement();
		ApplyCharge();
		Shoot();
		KeyboardAttack();
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

	private function KeyboardAttack():Void
	{	
		
		if(FlxG.keys.anyJustPressed(AttackKeys) && _swinging == false)
		{
			_keyboard = _keyboardGroup.recycle(Keyboard);
			_angle = facing == FlxObject.RIGHT ? _angleStartRight : _angleStartLeft;
			_angleFinish = facing == FlxObject.RIGHT ? _angleFinishRight : _angleFinishLeft;
			_angleDiff = facing == FlxObject.RIGHT ? _angleDiffRight : _angleDiffLeft;
			_swinging = true;
			_swingFacing = facing;
			_keyboard.HitDirection = facing;
		}
		
		if(_swinging)
		{
			FlxAngle.rotatePoint(x + _keyboardOffset, y, x, y,_angle,_keyboardPoint);			
			_keyboard.x = _keyboardPoint.x;
			_keyboard.y = _keyboardPoint.y;
			_keyboard.angle = _angle;
			_angle += _angleDiff;


			if((_swingFacing == FlxObject.RIGHT && _angle >= _angleFinish) 
				|| (_swingFacing == FlxObject.LEFT && _angle <= _angleFinish))
			{
				_swinging = false;
				_keyboard.kill();
			}
		}
	}


	private function Shoot():Void
	{		
		if(FlxG.keys.anyJustPressed(ShootKeys) && Charge > _chargeLevel1)
		{
			ShootBasedOnCharge();	
		}
	}	

	private function ShootBasedOnCharge():Void
	{
		if(Charge >= _chargeLevel3)
		{
			var midPoint:FlxPoint = getMidpoint();
			_projectilesL3.recycle(ProjectileL3).Shoot(midPoint, new FlxPoint(facing == FlxObject.RIGHT ? 1 : -1,-0.25),velocity);
		}
		else if
		(Charge >= _chargeLevel2)
		{
			var midPoint:FlxPoint = getMidpoint();
			_projectilesL2.recycle(ProjectileL2).Shoot(midPoint, new FlxPoint(facing == FlxObject.RIGHT ? 1 : -1,-0.15),velocity);
		}
		else if
		(Charge >= _chargeLevel1)
		{
			var midPoint:FlxPoint = getMidpoint();
			_projectilesL1.recycle(ProjectileL1).Shoot(midPoint, new FlxPoint(facing == FlxObject.RIGHT ? 1 : -1,-0.10),velocity);
		}

		Charge = _chargeEmptyValue;
	}

	override public function hurt(Damage:Float):Void
	{
		if(_flickering)
		{
			return;
		}

		Flicker(1.2);

		Health -= Damage;		

	}	

	private function Flicker(duration:Float):Void
	{
		FlxSpriteUtil.flicker(this, duration, 0.02, true, true, function(_){_flickering = false;});
		_flickering = true;
	}

}