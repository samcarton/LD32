package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
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

	private var _mapLoader:FlxOgmoLoader;
	private var _tileMap:FlxTilemap;

	private var _zoomCamera:FlxZoomCamera;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//FlxG.mouse.visible = false;

		FlxG.cameras.bgColor = 0xFF262626;

		_mapLoader = new FlxOgmoLoader(AssetPaths.level001__oel);
		_tileMap = _mapLoader.loadTilemap(AssetPaths.tiles__png,16,16,"stage");
		_tileMap.setTileProperties(1, FlxObject.ANY);
		_tileMap.setTileProperties(2, FlxObject.WALL);
		add(_tileMap);

		_player1 = new Player(0xFFDA4200);
		_player1.LeftKeys = ["A"];
		_player1.RightKeys = ["D"];
		_player1.JumpKeys = ["W"];		

		_player2 = new Player(0xFFA3CE27);
		_player2.LeftKeys = ["LEFT"];
		_player2.RightKeys = ["RIGHT"];
		_player2.JumpKeys = ["UP"];		
		_player2.facing = FlxObject.LEFT;

		_mapLoader.loadEntities(PlaceEntities, "entities");
		add(_player1);
		add(_player2);

		_dummyMidPoint = new FlxSprite();
		_dummyMidPoint.makeGraphic(0,0,0x000000); // Midpoint debug drawing
		_dummyMidPoint.solid = false;
		add(_dummyMidPoint);

		_zoomCamera = new FlxZoomCamera(0,0,FlxG.width,FlxG.height,1);
		_zoomCamera.follow(_dummyMidPoint,5);
		FlxG.cameras.add(_zoomCamera);
		//FlxG.camera.follow(_dummyMidPoint, 5);
		//FlxG.camera.zoom = 5;

		add(new FlxText("PLAYSTATE"));
		super.create();
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
		var minZoom:Float = 2;
		var zoomDifference:Float = minZoom - maxZoom;

		if(xSeparation > maxSeparation)
		{
			_zoomCamera.targetZoom = maxZoom;
			//FlxG.camera.setSize(maxWidth,maxHeight);
			//FlxG.camera.zoom = maxZoom;
		}
		else if(xSeparation < minSeparation)
		{
			_zoomCamera.targetZoom = minZoom;
			//FlxG.camera.setSize(minWidth,minHeight);
			//FlxG.camera.zoom = minZoom;
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
		FlxG.collide();
		super.update();
		//FlxG.collide(_player1, _tileMap);
		
	}	
}