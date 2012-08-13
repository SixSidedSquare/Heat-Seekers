package  
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	import GameSettings;
	
	/**
	 * ...
	 * @author Six
	 */
	public class GameWorld extends World
	{
		// World variables defined here
		private var playerEntity:playerBox;
		private var hitText:Text;
		private var collideText:Text;

		public function GameWorld() 
		{
			trace("GameWorld created");
			addGraphic(new Text("Space to launch\nR to clear", 50, FP.screen.height - 50));
			hitText = new Text("0", FP.screen.width - 50, 15, {color:"0xFF7777"});
			collideText = new Text("0", FP.screen.width - 50, 30, {color:"0x77FF77"});
			
			addGraphic(hitText);
			addGraphic(collideText);
			
			GameSettings.smokeScreen = new smokeTrails();
			
			playerEntity = new playerBox(Input.mouseFlashX, Input.mouseFlashY);
			
			add( new seekerLauncher(FP.screen.width - 100, FP.screen.height / 2 - 37, playerEntity));		
			
			add(playerEntity);
			add(GameSettings.smokeScreen);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.R))
			{
				GameSettings.hitCount = 0;
				GameSettings.collidedCount = 0;
				GameSettings.smokeScreen.clearSmoke();
			}
			
			hitText.text = "" + GameSettings.hitCount;
			collideText.text = "" + GameSettings.collidedCount;
		}
		
	}

}