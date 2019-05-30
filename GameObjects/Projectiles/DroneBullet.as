package GameObjects.Projectiles {
	import GameObjects.Players.MeleePlane;
	import flash.events.Event;
	import GameObjects.Enemies.DroneNemesis;
	
	
	public class DroneBullet extends Projectile{
		
		private var player:MeleePlane;
		private var droneNemesis:DroneNemesis;
		private var isReflected:Boolean;
		private var speed:Number = 7;
		
		public function DroneBullet(_player:MeleePlane, shooter:DroneNemesis, _x:Number, _y:Number) {
			isEnemyBullet = true;
			x = _x;
			y = _y;
			damage = 8;
			player = _player;
			droneNemesis = shooter;
			isReflected = false;
			addEventListener(Event.ENTER_FRAME, AI, false, 0, true);
		}
		
		private function AI(e:Event)
		{
			if(!isReflected)
			{
				if(player == null) { die(); return };
				moveTowardsTarget(player.x, player.y);
				if(isCollide(player.x, player.y))
				{
					if(player.shielding)
					{
						isReflected = true;
					}
					else
					{
						player.getHit(damage);
						die();
					}
				}
				
			}
			else
			{
				if(droneNemesis == null) { die(); return };
				moveTowardsTarget(droneNemesis.x, droneNemesis.y);
				if(isCollide(droneNemesis.x, droneNemesis.y))
				{
					droneNemesis.killBarrier();
					die();
				}
			}
		}
		
		private function die()
		{
			removeEventListener(Event.ENTER_FRAME, AI);
			stop();
			this.parent.removeChild(this);
		}
		
		private function isCollide(_x:Number, _y:Number):Boolean
		{
			var radius:Number = (isReflected)? 18:9;
			return ( (((_x - x)*(_x - x)) + ((_y - y)*(_y - y)))  < (radius*radius));
		}
		
		private function getFlyAngle( xPoint:Number, yPoint:Number ):Number
		{
			var playerX:Number = xPoint;
			var playerY:Number = yPoint;
			var xDistance:Number = playerX - x;
			var yDistance:Number = playerY - y;
			var slope:Number = yDistance/xDistance;
			var angle:Number = 180/Math.PI * Math.atan(slope);
			
			if((slope < 0 && yDistance < 0) || 
			   (slope > 0 && yDistance > 0))
				angle += 90;
			else if((slope < 0 && yDistance > 0) ||
					(slope > 0 && yDistance < 0))
				angle += 270;
			
			return angle; //returns angle in degrees at which the enemy plane needs to be rotated to face the player directly
		}
		
		private function moveTowardsTarget(xTarget:Number, yTarget:Number)
		{
			var angle:Number = getFlyAngle(xTarget, yTarget);
			x += speed*Math.sin(angle*Math.PI/180);
			y -= speed*Math.cos(angle*Math.PI/180);
		}
	}
	
}
