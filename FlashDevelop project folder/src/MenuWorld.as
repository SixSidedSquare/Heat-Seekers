package  
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import GameSettings;
	
	/**
	 * ...
	 * @author Six
	 */
	public class MenuWorld extends World
	{
		// World variables defined here
		
		public function MenuWorld() 
		{
			trace("MenuWorld created");
			addGraphic(new Text("Click to start", 10, 10));
		}
		
		override public function update():void
		{
			if (Input.mousePressed)
			{
				FP.world = new GameWorld();
			}
			super.update();
		}
		
	}

}