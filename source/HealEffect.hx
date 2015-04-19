
package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class HealEffect extends FlxSprite
{

	public function new()
	{
		super();

		loadGraphic(AssetPaths.healeffect__png,true,16,16);
		animation.add("heal",[0,1,2,3,4,5,6,7],10,false);				
		width = 16;
		height = 16;
		solid = false;
		visible = false;
		alpha = 0.8;
	}

	public function PlayHeal():Void	
	{
		visible = true;
		animation.play("heal",true);
	}


	override public function update():Void
	{
		if(animation.finished)
		{
			visible = false;
		}
		super.update();
	}

}