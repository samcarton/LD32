package;

import flash.filters.GlowFilter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxZoomCamera;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.util.FlxPoint;
import flixel.effects.FlxSpriteFilter;
using flixel.addons.editors.ogmo.FlxOgmoLoader;
using flixel.addons.display.FlxZoomCamera;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _player1:Player;
	private var _player2:Player;
	private var _dummyMidPoint:FlxSprite;
	private var _p1MidPoint:FlxPoint;
	private var _p2MidPoint:FlxPoint;

	// bars
	private var _p1HealthBar:FlxBar;
	private var _p2HealthBar:FlxBar;
	private var _p1ChargeBar:FlxBar;
	private var _p2ChargeBar:FlxBar;
	private var _chargeDebug:FlxText;

	// Projectiles
	private var _p1ProjectileL1s:FlxTypedGroup<ProjectileL1>;
	private var _p2ProjectileL1s:FlxTypedGroup<ProjectileL1>;
	private var _p1ProjectileL2s:FlxTypedGroup<ProjectileL2>;
	private var _p2ProjectileL2s:FlxTypedGroup<ProjectileL2>;
	private var _p1ProjectileL3s:FlxTypedGroup<ProjectileL3>;
	private var _p2ProjectileL3s:FlxTypedGroup<ProjectileL3>;

	// group for organising projectiles
	private var _p1Projectiles:FlxGroup;
	private var _p2Projectiles:FlxGroup;

	// keyboards
	private var _p1Keyboard:FlxTypedGroup<Keyboard>;
	private var _p2Keyboard:FlxTypedGroup<Keyboard>;

	// tilemap
	private var _mapLoader:FlxOgmoLoader;
	private var _tileMap:FlxTilemap;

	// camera
	private var _zoomCamera:FlxZoomCamera;	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//FlxG.mouse.visible = false;		

		FlxG.cameras.bgColor = 0xFF666666;

		_mapLoader = new FlxOgmoLoader(AssetPaths.level001__oel);
		_tileMap = _mapLoader.loadTilemap(AssetPaths.tiles__png,16,16,"stage");
		_tileMap.setTileProperties(1, FlxObject.ANY);
		_tileMap.setTileProperties(2, FlxObject.WALL);
		add(_tileMap);

		// Projectiles
		_p1ProjectileL1s = new FlxTypedGroup<ProjectileL1>();
		_p2ProjectileL1s = new FlxTypedGroup<ProjectileL1>();
		_p1ProjectileL2s = new FlxTypedGroup<ProjectileL2>();
		_p2ProjectileL2s = new FlxTypedGroup<ProjectileL2>();
		_p1ProjectileL3s = new FlxTypedGroup<ProjectileL3>();
		_p2ProjectileL3s = new FlxTypedGroup<ProjectileL3>();

		_p1ProjectileL1s.maxSize = 10;
		_p2ProjectileL1s.maxSize = 10;		
		_p1ProjectileL2s.maxSize = 5;
		_p2ProjectileL2s.maxSize = 5;
		_p1ProjectileL3s.maxSize = 10;
		_p2ProjectileL3s.maxSize = 10;

		// Keyboards
		_p1Keyboard = new FlxTypedGroup<Keyboard>();
		_p2Keyboard = new FlxTypedGroup<Keyboard>();
		_p1Keyboard.maxSize = 1; 
		_p2Keyboard.maxSize = 1; 

		_player1 = new Player(0xFFDA4200,_p1ProjectileL1s,_p1ProjectileL2s,_p1ProjectileL3s, _p1Keyboard);
		_player1.LeftKeys = ["A"];
		_player1.RightKeys = ["D"];
		_player1.JumpKeys = ["W"];		
		_player1.BufferSpamKeys = ["F"];
		_player1.ShootKeys = ["R"];
		_player1.AttackKeys = ["G"];

		_player2 = new Player(0xFFA3CE27,_p2ProjectileL1s,_p2ProjectileL2s,_p2ProjectileL3s, _p2Keyboard);
		_player2.LeftKeys = ["LEFT"];
		_player2.RightKeys = ["RIGHT"];
		_player2.JumpKeys = ["UP"];		
		_player2.BufferSpamKeys = ["L"];
		_player2.ShootKeys = ["O"];
		_player2.AttackKeys = ["K"];
		_player2.facing = FlxObject.LEFT;

		_mapLoader.loadEntities(PlaceEntities, "entities");
		add(_player1);
		add(_player2);

		// Add ProjectileL1s after so they are drawn on top
		add(_p1ProjectileL1s);
		add(_p2ProjectileL1s);
		add(_p1ProjectileL2s);
		add(_p2ProjectileL2s);
		add(_p1ProjectileL3s);
		add(_p2ProjectileL3s);

		add(_p1Keyboard);
		add(_p2Keyboard);

		// add projectiles to groups
		_p1Projectiles = new FlxGroup();
		_p1Projectiles.add(_p1ProjectileL1s);
		_p1Projectiles.add(_p1ProjectileL2s);
		_p1Projectiles.add(_p1ProjectileL3s);
		_p2Projectiles = new FlxGroup();
		_p2Projectiles.add(_p2ProjectileL1s);
		_p2Projectiles.add(_p2ProjectileL2s);
		_p2Projectiles.add(_p2ProjectileL3s);

		_dummyMidPoint = new FlxSprite();
		_dummyMidPoint.makeGraphic(0,0,0x000000); // Midpoint debug drawing
		_dummyMidPoint.solid = false;
		add(_dummyMidPoint);
		

		// BARS
		CreateHealthBar(_player1,_p1HealthBar);
		CreateHealthBar(_player2,_p2HealthBar);		
		CreateChargeBars(_player1,_p1ChargeBar);
		CreateChargeBars(_player2,_p2ChargeBar);

		_chargeDebug = new FlxText(_player1.x, _player1.y, 100, "", 10);
		add(_chargeDebug);
		
		_zoomCamera = new FlxZoomCamera(0,0,FlxG.width,FlxG.height,1);
		_zoomCamera.follow(_dummyMidPoint,5);
		FlxG.cameras.add(_zoomCamera);
		//FlxG.camera.follow(_dummyMidPoint, 5);
		//FlxG.camera.zoom = 5;

		//add(new FlxText("PLAYSTATE"));
		super.create();
	}

	private function CreateHealthBar(parent:Dynamic, outBar:Dynamic):Void
	{
		outBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 17, 3,parent, "Health", 0,100);
		outBar.createFilledBar(0xFFFF0000,0xFF00FF00,true, 0xFF262626);
		outBar.setParent(parent,"Health",true,0,-10);
		outBar.solid = false;
		add(outBar);
	}

	private function CreateChargeBars(parent:Dynamic, outBar:Dynamic):Void
	{
		outBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 17, 3,parent, "Charge", 0,100);
		//outBar.createFilledBar(0xFF0000FF,0xFF00FF00,true, 0xFF262626);
		outBar.createGradientBar(
			// empty gradient
			[0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFF31A2F2,
			0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFF31A2F2,
			0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFFCCCCCC,0xFF31A2F2],
			// full gradient
			[0xFFF7E26B,0xFFF7E26B,0xFFF7E26B,0xFFF7E26B,0xFFF7E26B,0xFFF7E26B,
			0xFFDA4200,0xFFDA4200,0xFFDA4200,0xFFDA4200,0xFFDA4200,0xFFDA4200,
			0xFF24A4FF,0xFF24A4FF,0xFF24A4FF,0xFF24A4FF,0xFF24A4FF,0xFF24A4FF
			],1,0,true,0xFF262626);		
		outBar.setParent(parent,"Charge",true,0,-8);
		outBar.solid = false;
		add(outBar);
	}
	
	private function PlaceEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if(entityName == "player1")
		{
			_player1.x = x;
			_player1.y = y;
			_p1MidPoint = _player1.getMidpoint();
		}
		else if(entityName == "player2")
		{
			_player2.x = x;
			_player2.y = y;
			_p2MidPoint = _player2.getMidpoint();
		}
	}

	private function UpdateMidPoint()
	{
		// midpoint = P1 + (P1->P2) *0.5;
		_p1MidPoint = _player1.getMidpoint(_p1MidPoint);
		_p2MidPoint = _player2.getMidpoint(_p2MidPoint);
		var xMid:Float = _p1MidPoint.x + (_p2MidPoint.x - _p1MidPoint.x) *0.5;
		var yMid:Float = _p1MidPoint.y + (_p2MidPoint.y - _p1MidPoint.y) *0.5;
		_dummyMidPoint.x = xMid;
		_dummyMidPoint.y = yMid;

		// size from 640-480 to 320-240
		// zoom from 1       to  2
		// based on x separation from ? to ?
		var xSeparation:Float = Math.abs(_p2MidPoint.x - _p1MidPoint.x);
		var maxSeparation:Float = 500;
		var minSeparation:Float = 50;
		var separationDifference:Float = maxSeparation - minSeparation;

		// resolution
		var maxWidth:Int = 640;
		var maxHeight:Int = 480;
		var minWidth:Int = 320;
		var minHeight:Int = 240;
		var widthDifference:Float = maxWidth - minWidth;
		var heightDifference:Float = maxHeight - minHeight;

		// zoom
		var maxZoom:Float = 1;
		var minZoom:Float = 3;
		var zoomDifference:Float = minZoom - maxZoom;

		if(xSeparation > maxSeparation)
		{
			_zoomCamera.targetZoom = maxZoom;
		}
		else if(xSeparation < minSeparation)
		{
			_zoomCamera.targetZoom = minZoom;
		}
		else
		{
			var currentSeparationDifference:Float = xSeparation - minSeparation;
			var currentSeparationRatio:Float = currentSeparationDifference/separationDifference;

			var currentZoom:Float = minZoom - (zoomDifference * currentSeparationRatio);
			_zoomCamera.targetZoom = currentZoom;
		}
		
	}

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		UpdateMidPoint();
		FlxG.collide(_player1, _tileMap);
		FlxG.collide(_player2, _tileMap);
		FlxG.collide(_player1, _player2);
		FlxG.collide(_p1Projectiles, _tileMap);
		FlxG.collide(_p2Projectiles, _tileMap);
		FlxG.collide(_p2Projectiles, _p1Projectiles);
		FlxG.overlap(_p1Projectiles, _player2, OnProjectileOverlap);
		FlxG.overlap(_p2Projectiles, _player1, OnProjectileOverlap);
		FlxG.overlap(_p1Keyboard, _player2, OnKeyboardOverlap);
		FlxG.overlap(_p2Keyboard, _player1, OnKeyboardOverlap);

		//DebugCharge();
		super.update();
		//FlxG.collide(_player1, _tileMap);
	}	

	private function OnProjectileOverlap(Sprite1:FlxObject, Sprite2:FlxObject):Void
	{
		if(Std.is(Sprite1, ProjectileL1) )
		{
			Sprite1.kill();
			if(Std.is(Sprite2, Player) )
			{
				Sprite2.hurt(ProjectileL1.Damage);
			}
		}
		else if(  Std.is(Sprite1, ProjectileL2))
		{
			Sprite1.kill();
			if(Std.is(Sprite2, Player) )
			{
				Sprite2.hurt(ProjectileL2.Damage);
			}
		}
		else if(  Std.is(Sprite1, ProjectileL3))
		{
			Sprite1.kill();
			if(Std.is(Sprite2, Player) )
			{
				Sprite2.hurt(ProjectileL3.Damage);
				_zoomCamera.shake(0.01);
			}
		}		
	}

	private function OnKeyboardOverlap(Sprite1:FlxObject, Sprite2:FlxObject):Void
	{
		if(Std.is(Sprite1, Keyboard) )
		{			
			if(Std.is(Sprite2, Player) )
			{
				Sprite2.hurt(Keyboard.Damage);
				_zoomCamera.shake(0.005,0.1);
				var kb:Keyboard = Std.instance(Sprite1, Keyboard);
				if(kb != null)
				{
					Sprite2.velocity.x = kb.HitDirection == FlxObject.RIGHT ? Keyboard.HitVelocityX : -Keyboard.HitVelocityX ;
				}
			}
		}		
	}


	private function DebugCharge():Void
	{
		_chargeDebug.text = Std.string(_player1.Charge);
		_chargeDebug.x = _player1.x;
		_chargeDebug.y = _player1.y + 20;
	}
}