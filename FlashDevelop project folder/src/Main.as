package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Six
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(800, 400, 60, true);
			FP.world = new MenuWorld();
			
			//FP.console.enable();
		}
	}	
}