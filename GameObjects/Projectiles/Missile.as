package GameObjects.Projectiles {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;
	import GameObjects.Players.PlaneGeneric;

	
	public class Missile extends Projectile {
		
		public var targetPoint:Point;
		
		private var speed:Number = 1;
		private var speedY:Number = 0;
		private var speedX:Number = 0;
		private var lifetime:uint = 0;
		private var angleTracker:int = 0;
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;
		
		public function Missile(targetPointX:Number, targetPointY:Number) 
		{
			targetPoint = new Point(targetPointX, targetPointY);
			addEventListener(Event.ENTER_FRAME, AI, false, 0, true);
			getHitCircle();
		}
		
		public function stopMoving():void
		{
			stop();
			cullThis = true;
			removeEventListener(Event.ENTER_FRAME, AI);
		}
		
		private function AI(e:Event)
		{
			if(lifetime < 14)
			{
				y -= speed;
				speed += 0.5;
			}
			else
			{
				turnTowardsTarget();
				setSpeedFromRotation();
			
				x += speedX;
				y -= speedY;
			}
			lifetime++;
			if(lifetime > 600 || Math.abs(angleTracker) > 360)
				blowUp();
			else if(y > 350)
			{
				stopMoving();
				return;
			}
			
			var xAbs:Number = Math.abs(x);
			var tarxAbs:Number = Math.abs(targetPoint.x);
			var yAbs:Number = Math.abs(y);
			var taryAbs:Number = Math.abs(targetPoint.y);
			
			if(xAbs > tarxAbs)
			{
				if(yAbs > taryAbs)
				{
					if(xAbs - tarxAbs < 10 && yAbs - taryAbs < 10)
					{
						blowUp();
					}
				}
				else
				{
					if(xAbs - tarxAbs < 10 && taryAbs - yAbs < 10)
					{
						blowUp();
					}
				}
			}
			else
			{
				if(yAbs > taryAbs)
				{
					if(tarxAbs - xAbs < 10 && yAbs - taryAbs < 10)
					{
						blowUp();
					}
				}
				else
				{
					if(tarxAbs - xAbs < 10 && taryAbs - yAbs < 10)
					{
						blowUp();
					}
				}
			}
			
		}
		
		public function getFlyAngle( xPoint:Number, yPoint:Number ):Number
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
		
		public function turnTowardsTarget()
		{
			var angleToPlayer:Number = getFlyAngle (targetPoint.x, targetPoint.y);
			var rotation360:Number = rotation;
			if(rotation < 0)
				rotation360 = (360 - (rotation * -1) );
			
			var checkDistance:Number;
			
			if(rotation360 > angleToPlayer)
			{
				checkDistance = rotation360 - angleToPlayer;
			}
			else if( angleToPlayer >= rotation360 )
			{
				checkDistance = angleToPlayer - rotation360;
			}
			if (checkDistance < 180){
				if(angleToPlayer - 9 <  rotation360 && rotation360 < angleToPlayer + 9)
				{
					
				}
				else if(rotation360 > angleToPlayer)
				{
					rotation -= 9;
					angleTracker -=9;
				}
				else if(rotation360 < angleToPlayer)
				{
					rotation += 9;
					angleTracker += 9;
				}
			}
			else if (checkDistance > 180){
				if(angleToPlayer - 9 <  rotation360 && rotation360 < angleToPlayer + 9)
				{
					
				}
				else if(rotation360 < angleToPlayer)
				{
					rotation -= 9;
					angleTracker -=9;
				}
				else if(rotation360 > angleToPlayer)
				{
					rotation += 9;
					angleTracker +=9;
				}
			}
		}
		
		public function setSpeedFromRotation():void
		{
				speedY = speed * trigDistanceY();
				speedX = speed * trigDistanceX();
		}
		
		public function trigDistanceX():Number
		{
			var slopeX:Number;
		
			slopeX = Math.sin((rotation * Math.PI/180));
			return slopeX;
			
		}
		
		public function trigDistanceY():Number 
		{
			var slopeY:Number;
		
			slopeY = Math.cos((rotation * Math.PI/180));
			return slopeY;
		}
		
		public function blowUp()
		{
			removeEventListener(Event.ENTER_FRAME, AI);
			cullThis = true;
		}
		
		override public function collide(other:MovieClip):void
		{
			if(other is PlaneGeneric)
			{
				blowUp();
			}
		}
		override public function isHitPoly():Boolean
		{
			return false;
		}
		override public function getHitPoly():Vector.<Point>
		{
			return null;
		}
		override public function isHitCircle():Boolean
		{
			return true;
		}
		override public function getHitCircle():Vector.<Number>
		{
			if(!hasHitCircle)
			{
				hitCircle[0] = -3;
				hitCircle[1] = -8;
				hitCircle[2] = 3;
				hasHitCircle = true;
				hitCircleShape = new Shape();
				hitCircleShape.graphics.lineStyle(1, 0x4DFDFC);
				hitCircleShape.graphics.beginFill(0x4DFDFC, 0.5);
				hitCircleShape.graphics.drawCircle(trigDistanceX()*hitCircle[0], trigDistanceY()*hitCircle[1], hitCircle[2]);
				hitCircleShape.visible = false;
				addChild(hitCircleShape);
				return getHitCircle();
			}
			else
			{
				var relativeCircle:Vector.<Number> = new Vector.<Number>(3, true);
				relativeCircle[0] = x + trigDistanceX()*hitCircle[0];
				relativeCircle[1] = y + trigDistanceY()*hitCircle[1];
				relativeCircle[2] = hitCircle[2];
				return relativeCircle;
			}
		}
		
		override public function toggleHitbox():void
		{
			hitCircleShape.visible = !hitCircleShape.visible;
		}
		
		override public function getHitbox():Shape
		{
			return hitCircleShape;
		}

			
	}
	
}
