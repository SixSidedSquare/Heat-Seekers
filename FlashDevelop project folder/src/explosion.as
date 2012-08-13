package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Six
	 */
	public class explosion extends Entity
	{
		[Embed(source = "/boom.png")] private const BOOM_IMAGE:Class;
		
		private var explosionGraphic:Image;
		private var fullTime:Number = 0.2; //seconds till fade out
		private var fadeTime:Number = 1; //seconds for fade out
		private var alphaFadePerSec:Number = 1 / 1; // 1 / fadeTime
		
		public function explosion(xLocation:Number, yLocation:Number) 
		{
			x = xLocation; y = yLocation;
			
			explosionGraphic = new Image(BOOM_IMAGE);
			explosionGraphic.centerOrigin();
			graphic = explosionGraphic;
			
			super(x, y);
		}
		
		override public function update():void 
		{
			if (fullTime > 0)
			{
				fullTime -= FP.elapsed;
			}
			else if (fadeTime > 0)
			{
				fadeTime -= FP.elapsed
				//adjust alpha
				explosionGraphic.alpha -= alphaFadePerSec * FP.elapsed;
			}
			else
			{
				//remove from world
				FP.world.remove(this);
			}
			
			super.update();
		}
		
	}

}