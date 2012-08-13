package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Six
	 */
	public class seekerLauncher extends Entity
	{
		[Embed(source = "/launcher.png")] private const LAUNCH_IMAGE:Class;
		
		private var targetEntity:Entity;
		
		public function seekerLauncher(xLocation:Number, yLocation:Number, target:Entity) 
		{
			x = xLocation; y = yLocation;
			
			height = 100;
			width = 50;
			
			graphic = new Image(LAUNCH_IMAGE);
			graphic.x -= 5;
			
			targetEntity = target;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.SPACE))
			{
				launch();
				trace("FIRE!");
			}
		}
		
		
		public function launch():void
		{
			
			for (var j:Number = 0; j < 2; j++)
			{
				for (var i:Number = 0; i < 5; i++)
				{
					FP.world.add(new HeatSeaker(x + -5 + j * 40, y + 15 + (85/5) * i, i * (100/5) + FP.rand(10) + 135, targetEntity));
				}
			}
		}
		
	}

}