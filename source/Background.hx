
package ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxRandom;

class Background extends FlxGroup
{
	public var _backGround:FlxSprite;
	public var _text:FlxText;
	
	private var _lastKey:String;
	private var _currentLength:Int;

	private static var _colors:Array<Int> = [0xFFF8F8F2, 0xFFA6E22E, 0xFFE6DB74, 0xFFF92672, 0xFFCCCCCC, 0xFFAE81FF, 0xFF75715E, 0xFFE6DB74, 0xFFAE81FF, 0xFFF92672, 0xFFFFFFFF, 0xFFF92672, 0xFF66D9EF, 0xFFA6E22E,
	0xFF66D9EF, 0xFFFD971F, 0xFFF92672, 0xFFF92672, 0xFFA3CE27];

	private static var _hitStrings:Array<String> = 
	[";]3%", "\\ #`~", "<.'__[","!+[/.-", " ^&::z","Line 27:#% ", "#$Unexpected~>", "0x#4;", ":\"(", "^.^", "#0,=+."];

	private static var _deathStrings:Array<String> = 
	["[FATAL EXCEPTION]", "BUFFER OVERFLOW", "UNHANDLED EXCEPTION", "Application Error"];

	public function new()
	{
		super();
		_backGround = new FlxSprite(4000,0);		
		_backGround.makeGraphic(FlxG.width,FlxG.height, 0x00000000);
		add(_backGround);		

		_text = new FlxText(4005,130,600,"B:\\$H:",18);		
		_currentLength = _text.text.length;
		var format:FlxTextFormat = new FlxTextFormat(0xFFA3CE27,false,false,null,0,_currentLength);
		_text.addFormat(format);
		_text.alpha = 0.7;
		add(_text);		
		// bounds are x from 4005 to 4605, y from 130 to 560

	}

	override public function update():Void
	{
		super.update();
		_lastKey = FlxG.keys.firstJustPressed();
		
		if(_lastKey != "")
		{
			addToString(_lastKey);
		}
	}

	private function addToString(stringToAdd:String):Void
	{
		var stringToAddLength:Int = stringToAdd.length;
		var format:FlxTextFormat = new FlxTextFormat(randomColor(),false,false,null,_currentLength,_currentLength + stringToAddLength);
		_text.text = _text.text + stringToAdd;
		_text.addFormat(format);
		_currentLength = _text.text.length;
	}

	public function addHitString():Void
	{
		addToString(FlxRandom.getObject(_hitStrings));
	}

	public function addDeathString():Void
	{
		addToString(FlxRandom.getObject(_deathStrings));
	}

	private function randomColor():Int
	{
		return FlxRandom.getObject(_colors);
	}

}