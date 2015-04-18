package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
using flixel.addons.editors.ogmo.FlxOgmoLoader;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _player1:Player;
	private var _mapLoader:FlxOgmoLoader;
	private var _tileMap:FlxTilemap;


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

		_player1 = new Player();
		_player1.LeftKeys = ["A"];
		_player1.RightKeys = ["D"];
		_player1.JumpKeys = ["W"];
		_mapLoader.loadEntities(PlaceEntities, "entities");
		add(_player1);

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
		FlxG.collide();
		super.update();
		//FlxG.collide(_player1, _tileMap);
		
	}	
}