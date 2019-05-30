package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import ReferenceObjects.BattleshipCannon;
	import ReferenceObjects.AnimationSymbols.CannonFire;
	import ReferenceObjects.AnimationSymbols.BulletSplash;
	import flash.events.Event;
	import GameObjects.Projectiles.Bullet;
	import GameObjects.Projectiles.Projectile;
	import GameObjects.Players.PlaneGeneric;
	import GameObjects.Players.SawPlane;
	import GameObjects.Players.MeleePlane;
	import Interfaces.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;
	import Sounds.SoundHandler;
	
	public class Battleship extends MovieClip implements Damagable, DealsDamage, Collidable
	{
		public var health:uint;
		private var cannonSpeed:Number = 0.5;
		private var tolerance:int = 0;
		private const STEADY_TIMER:uint = 120;
		private const VOLLEY_COOLDOWN:uint = 300;
		private const DEATH_FRAME:uint = 217;
		private const MAX_TOLERANCE:uint = 15;
		public var bulletCooldown:uint = VOLLEY_COOLDOWN;
		public var firing:Boolean = false;
		protected var damage:int = 500;
		private var splishTimer:uint = 0;
		private var splishFrequency:uint = 10;
		private var splish:BulletSplash;
		private var bigSplish:BulletSplash;
		public var playerOffset:Number = NaN;
		
		public var leftCannon:BattleshipCannon;
		public var leftFire:CannonFire;
		public var rightCannon:BattleshipCannon;
		public var rightFire:CannonFire;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;
		
		private var soundHandler:SoundHandler;
		
		public function Battleship( _soundHandler:SoundHandler, xPos:Number = NaN, playerX:Number = NaN) {
			if(arguments.length > 0)
			{
				playerOffset = xPos;
				x = xPos + playerX;		
			}
			y = 327;
			soundHandler = _soundHandler;
			
			health = 300;
			leftCannon = new BattleshipCannon();
			leftCannon.x = -63;
			leftCannon.y = 4;
			leftCannon.tail.visible = false;
			leftCannon.rotation = -80;
			leftFire = new CannonFire();
			leftFire.x = -63;
			leftFire.y = 15;
			
			rightCannon = new BattleshipCannon();
			rightCannon.x = 10;
			rightCannon.y = 4;
			rightCannon.rotation = -80;
			rightCannon.tail.visible = false;
			rightFire = new CannonFire();
			rightFire.x = 10;
			rightFire.y = 15;
			
			addChildAt(leftCannon, 0);
			addChildAt(rightCannon, 0);
			addChild(leftFire);
			addChild(rightFire);
			getHitPoly();
			
		}
		
		public function getHit(damage:int):void
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
		
		public function die():void
		{
			removeChild(leftCannon);
			removeChild(rightCannon);
			gotoAndPlay(DEATH_FRAME);
		}
		
		public function getDamage():int
		{
			return damage;
		}
		
		public function AI(player:PlaneGeneric):void
		{
			var leftTrack:int = trackPlayer(player, leftCannon);
			var rightTrack:int = trackPlayer(player, rightCannon);
			if(bulletCooldown > 0)
				--bulletCooldown;
			
			if( leftTrack == -1 && rightTrack == -1)
			{
				--tolerance;
			}
			else if (leftTrack == 1 && rightTrack == 1)
			{
				++tolerance;
			}
			
			if((Math.abs(tolerance) > MAX_TOLERANCE) && !firing)
			{
				if(bulletCooldown < STEADY_TIMER)
				{
					bulletCooldown = STEADY_TIMER;
				}
				tolerance = 0;
			}
			
			if(bulletCooldown == 0 && !firing)
			{
				firing = true;
				tolerance = 0;
				bulletCooldown = 300;
			}
			else if(bulletCooldown == 0 && firing)
			{
				firing = false;
				bulletCooldown = VOLLEY_COOLDOWN;
			}
		}
		
		public function splishes(e:Event)
		{
			
			//left side: -79, 28 right side: 79, 28
			splishTimer++;
			if(splishTimer >= splishFrequency)
			{
				splishTimer = 0;
				if (splishFrequency != 1) splishFrequency--;
				splish = new BulletSplash(true);
				splish.x = (79*Math.random());
				if (Math.random() < 0.5) splish.x *= -1;
				splish.y = 28;
				addChild(splish);
				
				if(splishFrequency < 5)
				{
					if(Math.random() < 0.5)
					{
						splish = new BulletSplash();
						splish.x = (79*Math.random());
						if (Math.random() < 0.5) splish.x *= -1;
						splish.y = 28;
						addChild(splish);
						
					}
				}
			}
			
		}
		
		public function trackPlayer(player:PlaneGeneric, cannon:BattleshipCannon):int
		{
			var hasTurned:int = 0;
			var playerX:Number = player.x;
			var playerY:Number = player.y;
			var xDistance:Number = playerX - (cannon.x + x);
			var yDistance:Number = playerY - (cannon.y + y);
			var slope:Number = yDistance/xDistance;
			var angle:Number = 180/Math.PI * Math.atan(slope);
			
			if((slope < 0 && yDistance < 0) || 
			   (slope > 0 && yDistance > 0))
				angle += 90;
			else if((slope < 0 && yDistance > 0) ||
					(slope > 0 && yDistance < 0))
				angle += 270;
				
			if(angle > 80 && angle <= 180)
				angle = 80;
				
			else if(angle > 180 && angle < 280)
				angle = 280;
			
			var rotation360:Number = cannon.rotation;
			if(cannon.rotation < 0)
				rotation360 = (360 - (cannon.rotation * -1) );
			
			var checkDistance:Number;
			
			if(rotation360 > angle)
			{
				checkDistance = rotation360 - angle;
			}
			else if( angle >= rotation360 )
			{
				checkDistance = angle - rotation360;
			}
			if (checkDistance < 180){
				if(angle - cannonSpeed <  rotation360 && rotation360 < angle + cannonSpeed)
				{
					
				}
				else if(rotation360 > angle)
				{
					cannon.rotation -= cannonSpeed;
					if(!firing)
					{
						hasTurned = -1;
					}
				}
				else if(rotation360 < angle)
				{
					cannon.rotation += cannonSpeed;
					if(!firing)
					{
						hasTurned = 1;
					}
				}
			}
			else if (checkDistance > 180){
				if(angle - cannonSpeed <  rotation360 && rotation360 < angle + cannonSpeed)
				{
					
				}
				else if(rotation360 < angle)
				{
					cannon.rotation -= cannonSpeed;
					if(!firing)
					{
						hasTurned = -1;
					}
				}
				else if(rotation360 > angle)
				{
					cannon.rotation += cannonSpeed;
					if(!firing)
					{
						hasTurned = 1;
					}
				}
			}
			
			if(angle == 80 || angle == 280)
				hasTurned = 0;
				
			return hasTurned;
		}
		
		public function collide(other:MovieClip):void
		{
			if(other is Projectile || other is PlaneGeneric)
			{
				getHit((other as DealsDamage).getDamage());
			}
			else
			{
				trace("something besides a projectile or a plane hit the battleship...");
			}
		}
		public function isHitPoly():Boolean
		{
			return true;
		}
		public function getHitPoly():Vector.<Point>
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
				hitBox.graphics.moveTo(hitPoly[0].x, hitPoly[0].y);
				for(var n:int = 1; n < hitPoly.length; ++n)
				{
					hitBox.graphics.lineTo(hitPoly[n].x, hitPoly[n].y);
				}
				hitBox.graphics.lineTo(hitPoly[0].x, hitPoly[0].y);
				hitBox.graphics.endFill();
				hitBox.visible = false;
				addChild(hitBox);

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
		public function isHitCircle():Boolean
		{
			return false;
		}
		public function getHitCircle():Vector.<Number>
		{
			return null;
		}
		
		public function toggleHitbox():void
		{
			hitBox.visible = !hitBox.visible;
		}
		
		public function getHitbox():Shape
		{
			return hitBox;
		}

	}
}