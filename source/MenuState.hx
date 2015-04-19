package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;
using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _playButton:FlxButton;
	private var _titleText:FlxText;
	private var _titleSplash:FlxSprite;
	private var _background:FlxSprite;
	private var _creditText:FlxText;
	private var _buttonSound:FlxSound;

	private var _buttonHit:Bool;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.mouse.visible = true;
		FlxG.cameras.bgColor = 0xFF000000;

		_buttonHit = false;

		_background = FlxGradient.createGradientFlxSprite(800,250,[0xFF000000,0xFFFFFFFF,0xFF000000],10,90);
		_background.y += 70;
		add(_background);

		_titleSplash = new FlxSprite();
		_titleSplash.loadGraphic(AssetPaths.titlesplashlrgwithInstructions2__png,false,640,480);
		add(_titleSplash);

		_playButton = new FlxButton(0,0, "B:\\$H",OnClickPlay);
		_playButton.screenCenter();		
		_playButton.color = 0xFFFFFFFF;
		_playButton.label.color = 0xFF303030;		
		_playButton.y += 40;
		add(_playButton);

		_titleText = new FlxText(0,0,0,"Buffer Over~B:\\$H");
		_titleText.size = 32;		
		_titleText.screenCenter();
		_titleText.y -= 200;
		_titleText.x -= _titleText.fieldWidth/3;
		add(_titleText);

		_creditText = new FlxText(0,0,0,"Ludum Dare 32 - by Sam Carton - April 2015");
		_creditText.screenCenter();
		_creditText.y = FlxG.height - 20;
		add(_creditText);

		// sound
		_buttonSound = FlxG.sound.load(AssetPaths.menuSelect__wav);

		super.create();
	}
	
	private function OnClickPlay():Void
	{
		if(_buttonHit == false)
		{
			_buttonSound.play(true);
			FlxG.camera.fade(0xFF000000,1,false,OnFinishFade);
			_buttonHit = true;
		}		
	}

	public function OnFinishFade():Void
	{
		FlxG.switchState(new PlayState());
	}

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		if(_playButton != null)
		{
			_playButton.destroy();
			_playButton = null;
		}
		if(_titleText != null)
		{
			_titleText.destroy();
			_titleText = null;
		}
		if(_titleSplash != null)
		{
			_titleSplash.destroy();
			_titleSplash = null;
		}
		if(_creditText != null)
		{
			_creditText.destroy();
			_creditText = null;
		}
		if(_buttonSound != null)
		{
			_buttonSound.destroy();
			_buttonSound = null;
		}
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}