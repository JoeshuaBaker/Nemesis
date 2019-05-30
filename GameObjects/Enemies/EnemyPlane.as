package GameObjects.Enemies {
	
	import flash.events.Event;
	import ReferenceObjects.AnimationSymbols.PlaneSplash;
	import ReferenceObjects.AnimationSymbols.EngineFire;
	import GameObjects.Players.PlaneGeneric;
	import GameObjects.Projectiles.Bullet;
	import GameObjects.Projectiles.SniperBullet;
	import GameObjects.Projectiles.Projectile;
	import Interfaces.DealsDamage;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import ReferenceObjects.Vertex;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	
	public class EnemyPlane extends PlaneGeneric {
		
		var deathFrame:uint = 41;
		var enemyTurn:Boolean = true;
		var AIMode:uint = 0;
		var deathSplash:PlaneSplash;
		var flyToAngle:Number = 0;
		var updatePositionTimer:uint = 0;
		var angleToPlayer:Number = 0;
		var engineFire:EngineFire;
		//CURRENT AI MODES:
		//0 - Track Player
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var drawnCircle:Boolean = false;
		private var hasHitCircle:Boolean = false;
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;
		private var drawnHitbox:Boolean = false;
		private var playerPos:Point;
		
		public function EnemyPlane(xPos:Number = NaN, yPos:Number = NaN) 
		{
			if(arguments.length > 0)
			{
				x = xPos;
				y = yPos;
			}
			playerPos = new Point();
			speedModifier = 4;
			rotateReference.tail.visible = false;
			health = 24;
			bulletCooldown = 300;
			damage = 12;
			getHitCircle();
			getHitPoly();
		}
		
		public function AI(player:PlaneGeneric):void
		{
			switch(AIMode)
			{
				case 0:
				if(player.health > 0)
				{
						if(y > 320)
					{
						if(rotateReference.rotation > 0 && rotateReference.rotation < 180)
							rotateLeft();
						else
							rotateRight();
					}
					else if(enemyTurn)
					{
						playerPos.x = player.x;
						playerPos.y = player.y;
						turnTowardsPoint( playerPos );
						enemyTurn = false;
					}
					else
					{
						enemyTurn = true;
					}
					accelerate();
					gravity();
					break;
				}
				else
				{
					playerPos.x = x;
					playerPos.y = -1000;
					turnTowardsPoint(playerPos);
					accelerate();
					gravity();
					break;
				}
				
				default:
				trace("the AI of a plane is fuckin wrong, fix it loser");
				break;
				
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
		
		public function turnTowardsPoint( player:Point ):void
		{
			if(updatePositionTimer == 0)
			{
				angleToPlayer = getFlyAngle( player.x, player.y );
				updatePositionTimer = Math.ceil(Math.random() * 15);
			}
			else
			{
				updatePositionTimer--;
			}
			
			var rotation360:Number = rotateReference.rotation;
			if(rotateReference.rotation < 0)
				rotation360 = (360 - (rotateReference.rotation * -1) );
			
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
					rotateReference.rotation -= 9;
					if(currentFrame == 1)
						gotoAndStop (totalFrames);
					else
						prevFrame();
				}
				else if(rotation360 < angleToPlayer)
				{
					rotateReference.rotation += 9;
					if(currentFrame == totalFrames)
						gotoAndStop(1);
					else
						nextFrame();
				}
			}
			else if (checkDistance > 180){
				if(angleToPlayer - 9 <  rotation360 && rotation360 < angleToPlayer + 9)
				{
					
				}
				else if(rotation360 < angleToPlayer)
				{
					rotateReference.rotation -= 9;
					if(currentFrame == 1)
						gotoAndStop (totalFrames);
					else
						prevFrame();
				}
				else if(rotation360 > angleToPlayer)
				{
					rotateReference.rotation += 9;
					if(currentFrame == totalFrames)
						gotoAndStop(1);
					else
						nextFrame();
				}
			}
		}
		
		public function checkAngleTo( player:PlaneGeneric):Number
		{
			var angleToPlayer:Number = getFlyAngle( player.x, player.y );
			var rotation360:Number = rotateReference.rotation; //current rotation of enemy plane
			if(rotateReference.rotation < 0) //convert -180 - 180 scale to 0 - 360 scale 
				rotation360 = (360 - (rotateReference.rotation * -1) );
				
			var checkDistance:Number;
			if(rotation360 > angleToPlayer)
			{
				checkDistance = rotation360 - angleToPlayer;
			}
			else if( angleToPlayer >= rotation360 )
			{
				checkDistance = angleToPlayer - rotation360;
			}
			return checkDistance;
		}
		
		public function die():void
		{
			engineFire = new EngineFire();
			addEventListener(Event.ENTER_FRAME, deathLoop);
			addChild(engineFire);
			play();
		}
		
		private function deathLoop(e:Event):void
		{
			deltaX = x;
			deltaY = y;
			gravity();
			momentum();
			engineFire.rotation = 180 + getFlyAngle(deltaX, deltaY);
			if(Math.ceil(Math.random() * 20) == 1)
			{
				spawnDamagedSmoke();
			}
			if(y > 354)
			{
				removeEventListener(Event.ENTER_FRAME, deathLoop);
				deathSplash = new PlaneSplash();
				deathSplash.x = x;
				deathSplash.y = y;
				this.parent.addChild( deathSplash );
				stop();
				this.parent.removeChild( this );
			}
		}
		
		public function setAIMode(newMode:uint)
		{
			if(0 <= newMode && newMode <= 1)
			{
				trace("AI of a plane was just set to " + newMode);
				AIMode = newMode;
			}
		}
		
		override public function set y( n:Number ):void
		{
			super.y = n;
			if(y > 354)
			{
				health = 0;
			}
		}
		
		override public function collide(other:MovieClip):void
		{

			if(other is Projectile || other is PlaneGeneric)
			{
				getHit((other as DealsDamage).getDamage());
			}
		}
		
		override public function getDamage():int
		{
			return damage;
		}

		override public function isHitPoly():Boolean
		{
			return ((currentFrame >= 9 && currentFrame <= 13) || (currentFrame >= 29 && currentFrame <= 33));
		}
		override public function getHitPoly():Vector.<Point>
		{
			if(!hasPoly)
			{
				hitPoly = new Vector.<Point>();
				var hitPoint:Point;
				var thisObject:DisplayObject;
				for(var i:int = 0; i < numChildren; ++i)
				{
					thisObject = getChildAt(i);
					if(thisObject is Vertex)
					{
						hitPoint = new Point(thisObject.x, thisObject.y);
						hitPoly.push(hitPoint);
					}
				}
				hitPoly.sort(Vertex.clockwise);
				hasPoly = true;
				hitBox = new Shape();
				hitBox.graphics.lineStyle(1, 0x990000);
				hitBox.graphics.beginFill(0x990000, 0.5);
				hitBox.graphics.moveTo(hitPoly[0].x, hitPoly[0].y)
				for(var n:int = 1; n < hitPoly.length; ++n)
				{
					hitBox.graphics.lineTo(hitPoly[n].x, hitPoly[n].y);
				}
				hitBox.graphics.lineTo(hitPoly[0].x, hitPoly[0].y);
				hitBox.graphics.endFill();
				addChild(hitBox);
				drawnCircle = drawnHitbox = true;
				hitCircleShape.visible = hitBox.visible = false;
				return getHitPoly();
			}
			else
			{
				var relativePoly:Vector.<Point> = new Vector.<Point>();
				var relativePoint:Point;
				for(var j:int = 0; j < hitPoly.length; ++j)
				{
					relativePoint = new Point(x + hitPoly[j].x, y + hitPoly[j].y);
					relativePoly.push(relativePoint);
				}
				return relativePoly;
			}
		}
		override public function isHitCircle():Boolean
		{
			return !isHitPoly();
		}
		override public function getHitCircle():Vector.<Number>
		{
			if(!hasHitCircle)
			{
				hitCircle[0] = 0;
				hitCircle[1] = 0;
				hitCircle[2] = 9;
				
				hasHitCircle = true;
				hitCircleShape = new Shape();
				hitCircleShape.graphics.lineStyle(1, 0x4DFDFC);
				hitCircleShape.graphics.beginFill(0x4DFDFC, 0.5);
				hitCircleShape.graphics.drawCircle(hitCircle[0], hitCircle[1], hitCircle[2]);
				addChild(hitCircleShape);
				return getHitCircle();
			}
			else
			{
				var relativeCircle:Vector.<Number> = new Vector.<Number>(3, true);
				relativeCircle[0] = x + hitCircle[0];
				relativeCircle[1] = y + hitCircle[1];
				relativeCircle[2] = hitCircle[2];
				return relativeCircle;
			}
		}
		override public function toggleHitbox():void
		{
			if(hitBox.visible || hitCircleShape.visible)
			{
				hitBox.visible = hitCircleShape.visible = false;
				removeEventListener(Event.ENTER_FRAME, hitboxSwap);
			}
			else
			{
				addEventListener(Event.ENTER_FRAME, hitboxSwap);
			}
		}
		
		private function hitboxSwap(e:Event)
		{
			if(isHitPoly() && !hitBox.visible)
			{
				hitBox.visible = true;
				hitCircleShape.visible = false;
			}
			else if(isHitCircle() && !hitCircleShape.visible)
			{
				hitBox.visible = false;
				hitCircleShape.visible = true;
			}
		}
		
		override public function getHitbox():Shape
		{
			if(isHitPoly())
			{
				return hitBox;
			}
			else
				return hitCircleShape;
		}

	}
	
}
