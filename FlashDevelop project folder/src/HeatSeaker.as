package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import GameSettings;
	/**
	 * ...
	 * @author Six
	 */
	public class HeatSeaker extends Entity
	{
		private var travelSpeed:Number = 270; //speed the seeker moves in pixels per second
		private var randomSpeedMod:Number = 120;
		
		private var turnSpeed:Number = 210; //speed the seeker turns in degrees per second
		private var randomTurnMod:Number = 100;
		private var turnDirection:Number = 0; //is either 1 or -1 to turn in the different directions
		
		private var turningRadius:Number; // calculated to make things easier
		
		private var seekTarget:Point = new Point(); //target the seeker is heading to
		private var seekEntity:Entity = null;
		
		private var reseekTimer:Number; // gets set to the initial seek delay
		private var initialSeekDelayMax:Number = 0.5;
		private var initialSeekDelayMin:Number = 0.3;
		
		private var reseekMax:Number = 0.2;
		private var reseekMin:Number = 0.1;
		
		private var velocity:Vector3D = new Vector3D(); // X = x speed, Y = y speed, Z = angle 
		
		private var seekerGraphic:Image;
		
		private var collidedSeeker:HeatSeaker;
		private var collidedPlayer:playerBox;
		
		private var previousXY:Point = new Point;
		
		public function HeatSeaker(xStart:Number, yStart:Number, angleStart:Number, target:Entity = null ) 
		{
			type = "seeker";
			
			layer = 5;
			
			x = xStart;
			y = yStart;
			
			travelSpeed = travelSpeed - randomSpeedMod / 2 + FP.rand(randomSpeedMod);
			turnSpeed = turnSpeed - randomTurnMod / 2 + FP.rand(randomTurnMod);
			
			velocity.z = angleStart;
			
			seekEntity = target;
			
			reseekTimer = FP.random * (initialSeekDelayMax - initialSeekDelayMin) + initialSeekDelayMin;
			
			//set hitbox
			width = 3;
			height = 3;
			centerOrigin();
			
			// create a rectangle for the graphic
			var seekerImage:BitmapData = new BitmapData(20, 6, false, 0xFF2211);
			
			seekerGraphic = new Image(seekerImage);
			seekerGraphic.centerOrigin();
			//seekerGraphic.x += 10;
			graphic = seekerGraphic;
			super(x, y);
			
			// calculate turning radius from speed and turnspeed
			turningRadius = travelSpeed * turnSpeed / (180 * Math.PI);
			
			//trace("Seeker created at " + x + ", " + y);
		}
		
		
		override public function update():void 
		{
			super.update();
			previousXY.x = x; previousXY.y = y;
			
			//update the reseek timer
			reseekTimer -= FP.elapsed;
			
			// if the timer has gone off, then recalculate the new rotation
			if (reseekTimer < 0)
			{
				reseek();				
			}
			
			// check for missiles on either side and turn away if detected
			/*if (collide("seeker", x - velocity.y * 5 / travelSpeed, y - velocity.x * 5 / travelSpeed) || 
				collide("seeker", x - (velocity.y + velocity.x) * 5 / travelSpeed, y - (velocity.x + velocity.y) * 5 / travelSpeed) || 
				collide("seeker", x + velocity.x * 5 / travelSpeed, y + velocity.y * 5 / travelSpeed))
			{
				turnDirection = -1; 
				trace("Dodge!");
			}
			else if (collide("seeker", x + velocity.y * 5 / travelSpeed, y + velocity.x * 5 / travelSpeed) || 
					 collide("seeker", x + (velocity.y + velocity.x) * 5 / travelSpeed, y + (velocity.x + velocity.y) * 5 / travelSpeed))
			{
				turnDirection = 1;
				trace("Dodge!");
			}*/
			
			
			// calculate the new angle, and from that update velocities
			velocity.z += turnSpeed * turnDirection * FP.elapsed;
			seekerGraphic.angle = velocity.z;
			
			
			//velocity.x = Math.cos(FP.RAD * velocity.z) * travelSpeed;
			//velocity.y = Math.sin(FP.RAD * velocity.z) * travelSpeed;
			FP.angleXY(velocity, velocity.z, travelSpeed);
			
			x += velocity.x * FP.elapsed;
			y += velocity.y * FP.elapsed;
			
			
			
			collidedPlayer = null;
			collidedPlayer = playerBox(collide("player", x, y));
			collidedSeeker = null;
			collidedSeeker = HeatSeaker(collide("seeker", x, y));
			if (collidedSeeker != null)
			{
				collidedSeeker.explode();
				this.explode();
				GameSettings.collidedCount += 2;
			}
			else if ( collidedPlayer != null)
			{
				this.explode(); 
				GameSettings.hitCount++;
			}
			
			
			// draw smoke trail
			GameSettings.smokeScreen.addSmokePuff(x - velocity.x * 10 / travelSpeed, y - velocity.y * 10 / travelSpeed);
			//GameSettings.smokeScreen.addSmokeLine(previousXY.x, previousXY.y, x, y);
			
		}
		
		private function reseek():void
		{
			// calculate the angle to the target
			if (seekEntity != null)
			{
				seekTarget.x = seekEntity.x;
				seekTarget.y = seekEntity.y;
			}
			
			//takes the difference in current angle and the angle to target
			//turnDirection = FP.sign(FP.angleDiff(velocity.z, FP.angle(this.x, this.y, seekTarget.x, seekTarget.y)));
			
			// how much the angle is off by, given in the range of -180 to 180
			var angleToTurnToTarget:Number = FP.angleDiff(velocity.z, FP.angle(this.x, this.y, seekTarget.x, seekTarget.y));
			
			//turnDirection = probableTurn(angleToTurnToTarget / 180);
			turnDirection = FP.sign(angleToTurnToTarget);
			
			// check to avoid orbiting by seeing if the player is behind the seeker, and inside the turn circle
			if ((angleToTurnToTarget > 90 || angleToTurnToTarget < -90) && FP.rand(100) > 10)
			{
				var distanceToTarget:Number = FP.distance(x, y, seekTarget.x, seekTarget.y);
				
				var absAngle:Number = angleToTurnToTarget > 0 ? angleToTurnToTarget : -angleToTurnToTarget;
				
				var chordLength:Number = 2 * turningRadius * Math.sin((180 - 2 * (absAngle-90)) / 2)
				
				if (chordLength > distanceToTarget)
					turnDirection = 0;
					
				reseekTimer = reseekMin;
				return;
			}
			
			// go straight if the angle to the player is less than a 10 degree cone, except don't 10% of checks
			if (angleToTurnToTarget < 10 && angleToTurnToTarget > -10 && FP.rand(100) > 10)
				turnDirection = 0;
			
			//randomly change 5% of the time
			if (FP.rand(100) < 5)
			{
				turnDirection = -turnDirection;
				
				reseekTimer = reseekMin;// + (reseekMax - reseekMin) / 2;
				return;
			}
			
			reseekTimer = FP.random * (reseekMax - reseekMin) + reseekMin;
		}
		
		public function explode():void
		{
			GameSettings.smokeScreen.addExplosionPuff(x, y);
			FP.world.add(new explosion(x, y));
			FP.world.remove(this);
		}
		
		public function probableTurn(x:Number):Number
		{
			if (x == 0) return 0; 
			else if (x < 0) return FP.random > -x / 10 ? -1 : 1; 
			else return FP.random > x / 10 ? 1 : -1;
		}
		
	}

}