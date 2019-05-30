package GameObjects.Enemies 
{
	import flash.display.MovieClip;
	import GameObjects.Players.PlaneGeneric;
	import collision.CollisionHandler;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.events.Event;
	import ReferenceObjects.AnimationSymbols.Spurt;
	import flash.display.Shape;
	import Interfaces.DealsDamage;
	import GameObjects.Projectiles.Bullet;
	import GameObjects.Projectiles.SniperBullet;
	
	public class BlobNemesis extends Nemesis 
	{
		public var xSpeed:Number;
		public var ySpeed:Number;
		private var speedLimit:Number = 5;
		private var serfSpeedLimit:Number = 7;
		private var momentum:Number = 0.99;
		private var baseSpeed:uint = 1;
		private var rotateSpeed:int;
		private var baseRotateSpeed:int = 10;
		private var rotateAccel:uint = 2;
		private var player:PlaneGeneric;
		private var collisionHandler:CollisionHandler;
		private var freeCounter:uint = 0;
		private var kingCounter:Number = 0;
		private var deathPoint:Point;
		
		private var points:Array = new Array();
		private var dumbness:uint = 10;
		
		public var buddyRadius:int = 50;
		public var isSerf:Boolean = false;
		public var isKing:Boolean = false;
		public var isFree:Boolean = false;
		private var isDead:Boolean = false;
		public var king:BlobNemesis;
		public var serfCount:uint;
		public var serfs:Array;
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;

		public function BlobNemesis(playerRef:PlaneGeneric, _collisionHandler:CollisionHandler) 
		{
			damage = 1;
			health = 100;
			player = playerRef;
			collisionHandler = _collisionHandler;
			baseRotateSpeed = (Math.random() < 0.5)? baseRotateSpeed*Math.random():baseRotateSpeed*Math.random()*-1;
			rotateSpeed = baseRotateSpeed;
			collisionHandler.addList(this, 0);
			collisionHandler.addList(this, 1);
			serfs  = new Array();
			becomeKing();
			getHitCircle();
			gotoAndPlay(Math.ceil(Math.random()*60));
		}
		
		override public function AI():void
		{
			if(isKing)
			{
				xSpeed = baseSpeed + Math.ceil(serfCount/2) + kingCounter/600;
				if (xSpeed > speedLimit)
				{
					xSpeed = speedLimit;
				}
				ySpeed = xSpeed;
				
				//if the array is not full
				if(points.length < dumbness)
				{
					points.push(new Point(player.x, player.y));
					moveTowardsTarget(points[0].x, points[0].y);
				}
				else
				{
					var temp:Point = points.shift();
					moveTowardsTarget(temp.x, temp.y);
					points.push(new Point(player.x, player.y));
				}
				
				++kingCounter;
			}
			else if (isSerf)
			{
				accelToKing();
				move();
			}
			else if (isFree)
			{
				move();
				freeCounter--;
				if(freeCounter == 0)
				{
					becomeKing();
				}
			}
			
			if(rotateSpeed != baseRotateSpeed)
			{
				rotateSpeed += (rotateSpeed < baseRotateSpeed)? rotateAccel : rotateAccel*-1;
			}
			rotate();
		}
		
		private function accelToKing()
		{
			var angle:Number = getFlyAngle(king.x, king.y);
			xSpeed += Math.sin(angle*Math.PI/180)/2;
			ySpeed += Math.cos(angle*Math.PI/180)/2;
			
			if(xSpeed < -serfSpeedLimit)
			{
				xSpeed = -serfSpeedLimit;
			}
			else if(xSpeed > serfSpeedLimit)
			{
				xSpeed = serfSpeedLimit;
			}
			
			if(ySpeed < -serfSpeedLimit)
			{
				ySpeed = -serfSpeedLimit;
			}
			else if(ySpeed > serfSpeedLimit)
			{
				ySpeed = serfSpeedLimit;
			}
			
		}
		
		private function move()
		{
			x += xSpeed;
			y -= ySpeed;
			if(y > 350) y = 350;
		}
		
		private function rotate()
		{
			rotation += rotateSpeed;
		}
		
		public function becomeKing(_serfCount:uint = 0)
		{
			if(isSerf)
			{
				collisionHandler.addList(this, 0);
			}
			
			isKing = true;
			isSerf = false;
			isFree = false;
			king = null;
			serfCount += _serfCount;
			addOutline();
		}
		
		public function becomeSerf(_king:BlobNemesis)
		{
			if(isKing || isFree)
			{
				collisionHandler.removeList(this, 0);
			}
			
			isKing = false;
			isSerf = true;
			isFree = false;
			king = _king;
			
			for(var i:int = 0; i < serfs.length; ++i)
			{
				serfs[i].king = king;
				king.serfs.push(serfs[i]);
			}
			
			for(var j:int = 0; j < points.length; ++j)
			{
				points[j] = null;
				points = new Array();
			}
			king.serfs.push(this);
			serfs = new Array();
			serfCount = 0;
			kingCounter = 0;
			removeOutline();
		}
		
		public function becomeFree()
		{
			if(isSerf)
			{
				collisionHandler.addList(this, 0);
			}
			
			if(!isFree)
			{
				isKing = false;
				isSerf = false;
				isFree = true;
				serfCount = 0;
				serfs = new Array();
				freeCounter = 60 + Math.ceil(120*Math.random());
				
				var angle:Number = getFlyAngle(king.x, king.y);
				xSpeed = -1*(Math.sin(angle*Math.PI/180))*speedLimit*Math.random()*4;
				ySpeed = -1*(Math.cos(angle*Math.PI/180))*speedLimit*Math.random()*4;
				
				king = null;
				kingCounter = 0;
			}
			
		}
		
		public function isBuddy(other:BlobNemesis):Boolean
		{
			return (Math.pow(other.x - x, 2) + Math.pow(other.y - y, 2) <= Math.pow(buddyRadius, 2));
		}
		
		public function moveTowardsTarget(xTarget:Number, yTarget:Number)
		{
			var angle:Number = getFlyAngle(xTarget, yTarget);
			x += xSpeed*Math.sin(angle*Math.PI/180);
			y -= ySpeed*Math.cos(angle*Math.PI/180);
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
		
		
		private function addOutline():void {
			var outline:GlowFilter = new GlowFilter();
			outline.blurX = outline.blurY = 2;
			outline.color = 0xC50205;
			outline.quality = BitmapFilterQuality.HIGH;
			outline.strength = 100;
			var filterArray:Array = new Array();
			filterArray.push(outline);
			this.filters = filterArray;
		}
		
		private function removeOutline()
		{
			filters = new Array();
		}
		
		override public function die()
		{
			if(!isDead)
			{
				trace(ySpeed);
				freeCounter = 0;
				isKing = isSerf = isFree = false;
				addEventListener(Event.ENTER_FRAME, deathLoop, false, 0, true);				
				isDead = true;
				deathPoint = new Point(player.x, player.y);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, deathLoop);
				this.parent.removeChild(this);
			}
		}
		
		private function deathLoop(e:Event)
		{
			if(freeCounter % 6 == 0)
			{
				var spurt:Spurt = new Spurt();
				addChild(spurt);
			}
			rotate();
			moveTowardsTarget(deathPoint.x + ( (deathPoint.x < 0) ? freeCounter*xSpeed*-1 : freeCounter*xSpeed), deathPoint.y + (freeCounter*ySpeed));
			if(ySpeed > 1) ySpeed *= momentum;
			if(xSpeed > 1) xSpeed *= momentum;
			if(freeCounter > 60 && currentFrame == 30)
			{
				gotoAndPlay(61);
			}
			++freeCounter;
		}

		
		override public function getHit(damage:int):void
		{
			if(isKing)
			{
				if(damage == 25)
				{
					for(var i:int = 0; i < serfs.length; ++i)
					{
						serfs[i].becomeFree();
					}
					serfs = new Array();
					serfCount = 0;
					damage = 0;
					kingCounter = 0;
				}
				if (serfCount > damage)
					damage = 0;
			}
			
			if(!(freeCounter > 60))
			{
				switch (health)
				{
					case 0 :
						break;
	
					default :
						if (health > damage)
						{
							health -=  damage;
						}
						else
						{
							health = 0;
						}
						break;
				}								
			}
			
			if(health == 0)
			{
				for(var j:int = 0; j < serfs.length; ++j)
					{
						serfs[j].becomeFree();
					}
					serfs = new Array();
					serfCount = 0;
			}
		}
		
		override public function collide(other:MovieClip):void
		{
			if(other is Bullet || other is SniperBullet)
			{
				getHit((other as DealsDamage).getDamage());
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
				hitCircle[0] = 0;
				hitCircle[1] = 0;
				hitCircle[2] = 18;
				
				hasHitCircle = true;
				hitCircleShape = new Shape();
				hitCircleShape.graphics.lineStyle(1, 0x4DFDFC);
				hitCircleShape.graphics.beginFill(0x4DFDFC, 0.5);
				hitCircleShape.graphics.drawCircle(hitCircle[0], hitCircle[1], hitCircle[2]);
				hitCircleShape.visible = false;
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
			hitCircleShape.visible = !hitCircleShape.visible;
		}
		
		override public function getHitbox():Shape
		{
			return hitCircleShape;
		}

	}
	
}
