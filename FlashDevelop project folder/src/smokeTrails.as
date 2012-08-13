package  
{
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Six
	 */
	public class smokeTrails extends Entity
	{
		private var smokeGraphic:BitmapData;
		private var smokeImage:Image;
		
		private var puffGraphic:BitmapData;
		
		private var drawingRect:Rectangle = new Rectangle();
		private var drawingPoint:Point = new Point();
		
		private var blurFilter:BlurFilter = new BlurFilter(1.4, 1.2);
		private var blurTimer:Number;
		private var blurDelay:Number = 60; //blur is applied after this many frames
		
		
		public function smokeTrails() 
		{
			layer = 0;
			
			blurTimer = blurDelay;
			
			smokeGraphic = new BitmapData(FP.screen.width, FP.screen.height, true, 0x00000000);
			
			puffGraphic = new BitmapData(5, 5, true, 0x33FFFFFF);
			puffGraphic.setPixel32(0, 0, 0x00000000);
			puffGraphic.setPixel32(0, 4, 0x00000000);
			puffGraphic.setPixel32(4, 0, 0x00000000);
			puffGraphic.setPixel32(4, 4, 0x00000000);
			
			graphic = smokeImage = new Image(smokeGraphic);
			
		}
		
		override public function render():void 
		{
			blurTimer--;
			if (blurTimer < 0)
			{
				drawingPoint.x = drawingPoint.y = 0;
				smokeGraphic.applyFilter(smokeGraphic, smokeGraphic.rect, drawingPoint, blurFilter);
				blurTimer = blurDelay
			}
			smokeImage.updateBuffer();
			super.render();
		}
		
		
		public function addSmokePuff(xLocation:Number, yLocation:Number, puffSize:Number = 5):void
		{
			drawingRect.x = 0;
			drawingRect.y = 0;
			drawingRect.width = puffSize;
			drawingRect.height = puffSize;
			
			drawingPoint.x = xLocation - puffSize / 2;
			drawingPoint.y = yLocation - puffSize / 2;
			
			//smokeGraphic.fillRect(drawingRect, 0x88FFFFFF);
			smokeGraphic.copyPixels(puffGraphic, drawingRect, drawingPoint, null, null, true);
		}
		public function addExplosionPuff(xLocation:Number, yLocation:Number, puffSize:Number = 12):void
		{
			Draw.setTarget(smokeGraphic);
			Draw.circlePlus(xLocation, yLocation, puffSize, 0xFFFFFF, 0.15);
			Draw.resetTarget();	
		}
		
		public function addSmokeLine(x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			slowLine(x1, y1, x2, y2, 0xFFFFFF, smokeGraphic);
		}
		
		public function clearSmoke():void
		{
			drawingRect.x = drawingRect.y = 0;
			drawingRect.width = FP.screen.width;
			drawingRect.height = FP.height;
			smokeGraphic.fillRect(drawingRect, 0x00000000);
			smokeImage.updateBuffer();
		}
		
		private function slowLine(x1:int, y1:int, x2:int, y2:int, color:uint, bitmap:BitmapData):void
		{
			Draw.setTarget(bitmap);
			
			Draw.linePlus(x1, y1, x2, y2, color, 0.2, 4);
			
			Draw.resetTarget();	
		}
		
		private function efla(x1:int, y1:int, x2:int, y2:int, color:uint, bitmap:BitmapData):void
		{
		  var shortLen:int = y2-y1;
		  var longLen:int = x2-x1;
		  if((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31))
		  {
		  shortLen ^= longLen;
		  longLen ^= shortLen;
		  shortLen ^= longLen;

		  var yLonger:Boolean = true;
		  }
		  else
		 {
		  yLonger = false;
		 }

		  var inc:int = longLen < 0 ? -1 : 1;

		  var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;

		  if (yLonger) 
		  {
			for (var i:int = 0; i != longLen; i += inc) 
			{
			  bitmap.setPixel(x1 + i*multDiff, y1+i, color);
			}
		  } 
		  else 
		  {
			for (i = 0; i != longLen; i += inc) 
			{
			  bitmap.setPixel(x1+i, y1+i*multDiff, color);
			}
		  }
		}
	}

}