package GameObjects.Projectiles {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import GameObjects.Players.PlaneGeneric;
	import flash.geom.Point;
	import ReferenceObjects.AnimationSymbols.Spark;
	import Interfaces.Collidable;
	import flash.display.Shape;
	import GameObjects.Enemies.*;
	
	
	public class Sawblade extends MovieClip implements Collidable {
		
		private const rotationMax:uint = 20;
		private const rotationMin:uint = 15;
		private const speed:Number = 10;
		private const distance:Number = 600;
		private const recallBuffer:uint = 20;
		private const flyMax:uint = 40;
		private var speedX:Number;
		private var speedY:Number;
		private var rotationCur:int;
		private var player:PlaneGeneric;
		private var targetPoint:Point;
		private var goHome:Boolean;
		public var isHome:Boolean;
		private var flyTime:uint = 0;
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;
		
		public function Sawblade(_player:PlaneGeneric, switchMode:Boolean) {
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			rotationCur = rotationMin + Math.ceil((rotationMax - rotationMin)*Math.random());
			stop();
			if(switchMode)
			{
				rotationCur *= -1;
				gotoAndStop(2);
			}
			player = _player;
			targetPoint = new Point(0, 0);
			isHome = true;
			goHome = false;
			visible = false;
			getHitCircle();
		}
		
		public function flyTo(modeCode:uint):void
		{
			switch(modeCode)
			{
				//fly to player
				case 0:
					if(isHome) return;
					goHome = true;
					targetPoint.x = 0;
					targetPoint.y = 0;
					setSpeedFromAngle();
					trace(flyTime);
				break;
				
				//stop sawblade
				case 1:
				if(isHome)
				{
					speedX = 0;
					speedY = 0;
					isHome = false;
					goHome = false;
					visible = true;
					flyTime = 0;
				}
				break;
				
				//fly forward
				case 2:
				if(isHome)
				{
					var playerRotation:Number = player.rotateReference.rotation;
					targetPoint.x = distance*trigDistanceX(playerRotation);
					targetPoint.y = distance*trigDistanceY(playerRotation)*-1;
					setSpeedFromAngle();
					isHome = false;
					goHome = false;
					visible = true;
					flyTime = 0;
				}
				else if( flyTime > 10)
				{
					speedX = 0;
					speedY = 0;
				}
				break;
			}
		}
		
		public function makeSparks(hitBoat:Boolean)
		{
			var numSparks = (hitBoat)? 1 : 2;
			for(var i:int = 0; i < Math.floor(Math.random() * numSparks) + 1; ++i)
			{
				var spark:Spark = new Spark(player.x + this.x, player.y + this.y, this.speedX, this.speedY);
				player.parent.addChild(spark);
			}
		}
		
		private function update(e:Event)
		{
			rotation += rotationCur;
			++flyTime;
			
			if(isHome)
			{
				x = 0;
				y = 0;
				flyTime = 0
				return;
			}
			
			if(goHome)
			{
				flyTo(0);
				if(Math.abs(x) < 20 && Math.abs(y) < 20)
				{
					isHome = true;
					goHome = false;
					visible = false;
					flyTime = 0;
				}
			}
			else if(flyTime > flyMax)
				flyTo(0);
			else if(!isHome && !goHome && parent.y + y > 351)
			{
				speedX = 0;
				speedY = 0;
			}
			
			x += speedX;
			y -= speedY;
			x -= player.deltaX;
			y -= player.deltaY;
		}
		
		public function setSpeedFromAngle():void
		{
			var angle:Number = getFlyAngle(targetPoint.x, targetPoint.y);
			speedY = speed * trigDistanceY(angle);
			speedX = speed * trigDistanceX(angle);
		}

		public function trigDistanceX(angle:Number):Number
		{
			var slopeX:Number;
		
			slopeX = Math.sin((angle * Math.PI/180));
			return slopeX;
			
		}
		
		public function trigDistanceY(angle:Number):Number 
		{
			var slopeY:Number;
		
			slopeY = Math.cos((angle * Math.PI/180));
			return slopeY;
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

		public function collide(other:MovieClip):void
		{
			
		}
		public function isHitPoly():Boolean
		{
			return false;
		}
		public function getHitPoly():Vector.<Point>
		{
			return null;
		}
		public function isHitCircle():Boolean
		{
			return true;
		}
		public function getHitCircle():Vector.<Number>
		{
			if(!hasHitCircle)
			{
				hitCircle[0] = 0;
				hitCircle[1] = 0;
				hitCircle[2] = 16;
				
				hasHitCircle = true;
				hitCircleShape = new Shape();
				hitCircleShape.graphics.lineStyle(1, 0x4DFDFC);
				hitCircleShape.graphics.beginFill(0x4DFDFC, 0.5);
				hitCircleShape.graphics.drawCircle(Math.sin((rotation * Math.PI/180))*hitCircle[0], Math.cos((rotation * Math.PI/180))*hitCircle[1], hitCircle[2]);
				hitCircleShape.visible = false;
				addChild(hitCircleShape);
				return getHitCircle();
			}
			else
			{
				var relativeCircle:Vector.<Number> = new Vector.<Number>(3, true);
				relativeCircle[0] = player.x + x;
				relativeCircle[1] = player.y + y;
				relativeCircle[2] = hitCircle[2];
				return relativeCircle;
			}
		}
		public function toggleHitbox():void
		{
			hitCircleShape.visible = !hitCircleShape.visible;
		}
		
		public function getHitbox():Shape
		{
			return hitCircleShape;
		}
		
		
	}
	
}
