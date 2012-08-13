package  
{
	import flash.sampler.NewObjectSample;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Six
	 */
	public class playerBox extends Entity
	{
		private var baseSpeed:Number = 100;
		private var maxSpeed:Number = 320;
		private var movespeed:Number;
		private var shipGraphic:Image;
		
		public function playerBox(xStart:Number, yStart:Number) 
		{
			type = "player";
			
			x = xStart; y = yStart;
			width = 14; height = 14;
			centerOrigin();
			
			shipGraphic = new Image(new BitmapData(20, 20, false, 0xCCC4FF));
			shipGraphic.centerOrigin();
			
			graphic = shipGraphic;
			super(x, y);
		}
		
		
		override public function update():void 
		{
			super.update();
			movespeed = FP.clamp(baseSpeed + FP.distance(x, y, Input.mouseFlashX, Input.mouseFlashY) * 4, 0, maxSpeed);
			this.moveTowards(Input.mouseFlashX, Input.mouseFlashY, movespeed * FP.elapsed);
		}
		
	}

}