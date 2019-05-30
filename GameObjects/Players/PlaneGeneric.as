package GameObjects.Players
{

	import flash.display.MovieClip;
	import ReferenceObjects.AnimationSymbols.DamagedSmoke;
	import ReferenceObjects.AnimationSymbols.Spark;
	import ReferenceObjects.RotateReference;
	import GameObjects.Projectiles.Bullet;
	import GameObjects.Enemies.SmallBoat;
	import GameObjects.Enemies.Battleship;
	import GameObjects.Enemies.EnemyPlane;
	import Interfaces.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import ReferenceObjects.Vertex;
	import flash.display.Shape;
	import GameObjects.Projectiles.Projectile;

	public class PlaneGeneric extends MovieClip implements DealsDamage, Damagable, Collidable
	{

		public var rotateReference:RotateReference = new RotateReference();
		protected var speedModifier:int = 5;
		protected const MAX_HEIGHT:int = -1000;
		public var speedY:Number = 0;
		public var speedX:Number = 0;
		public var deltaX:Number = 0;
		public var deltaY:Number = 0;
		var degreesToFrames:Number = 4.5;
		public var health:uint = 30;
		public var maxHealth:uint = 30;
		public var regenTimer:int = 0;
		public var grav:Number = 0;
		var bouy:Number = 0;
		var hasHalved:Boolean = false;
		public var dashing:Boolean = false;
		var waterTimer:uint = 0;
		public var bulletCooldown:uint = 6;
		public var specialCooldown:uint = 0;
		protected var damage:int = 20;
		public var fullCharge:Boolean = false;
		protected var takesTouchDamage:Boolean = true;
		
		public var turnRight:Boolean = false;
		public var turnLeft:Boolean = false;

		public function PlaneGeneric()
		{
			stop();
			addChild( rotateReference );
		}

		
		public function accelerate():void
		{
			setSpeedFromRotation();
			setYPosition(y - speedY);
			setXPosition(x + speedX);
			if( y > MAX_HEIGHT )
				grav = 0;
		}

		public function gravity():void
		{
			if(hasHalved)
			{
				hasHalved = false;
				grav = -bouy/2;
				bouy = 0;
				waterTimer = 0;
			}
			if(speedY > 0)
			{
				speedY -= 0.05;
			}
			if(grav < 5 || y < MAX_HEIGHT ) 
			{
				grav += 0.1;
			}
			setYPosition(y + grav);
		}

		public function bouyancy():void
		{
			if(waterTimer == 0)
			{
				if(Math.ceil(Math.random()*5) == 5)
				{
					getHit(1);
					regenTimer = -30;
				}
			}
			
			if(waterTimer >= 30 && waterTimer % 7 == 0)
			{
				getHit(1);
				regenTimer = -30;
			}
			
			++waterTimer;
			
			if(!hasHalved)
			{
				hasHalved = true;
			}
			if(grav > 0)
			{
				grav -= 0.2;
				setYPosition(y + grav);
			}
			else
			{
				bouy += 0.2;
				setYPosition(y - bouy);
			}
		}

		public function momentum():void
		{
			speedX = speedX*.99;
			speedY = speedY*.99;
			setYPosition(y - speedY);
			setXPosition(x + speedX);
		}

		public function setSpeedFromRotation():void
		{
				speedY = speedModifier * rotateReference.trigDistanceY();
				speedX = speedModifier * rotateReference.trigDistanceX();
		}

		public function rotateRight(doubleSpeed:Boolean = false):void
		{
			//change frames to 40 and rotation to 9 after new implementation
			if(doubleSpeed)
			{
				if (currentFrame == totalFrames)
				{
					gotoAndStop(1);
				}
				else
				{
					nextFrame();
				}
				rotateReference.rotateRight( degreesToFrames * 2 );
			}
			else
			{
				if(turnRight)
				{
					turnRight = false;
					turnLeft = false;
					if (currentFrame == totalFrames)
					{
						gotoAndStop(1);
					}
					else
					{
						nextFrame();
					}
				}
				else if(turnLeft)
				{
					turnLeft = false;
				}
				else
				{
					turnRight = true;
				}
				
				rotateReference.rotateRight( degreesToFrames );
			}
		}

		public function rotateLeft(doubleSpeed:Boolean = false):void
		{
			if(doubleSpeed)
			{
				if (currentFrame == 1)
				{
					gotoAndStop(totalFrames);
				}
				else
				{
					prevFrame();
				}
				rotateReference.rotateLeft( degreesToFrames * 2 );
			}
			else
			{
				if(turnLeft)
				{
					turnRight = false;
					turnLeft = false;
					if (currentFrame == 1)
					{
						gotoAndStop(totalFrames);
					}
					else
					{
						prevFrame();
					}
	
				}
				else if(turnRight)
				{
					turnRight = false;
				}
				else
				{
					turnLeft = true;
				}
				rotateReference.rotateLeft( degreesToFrames );
			}
		}

		public function getHit(damage:int):void
		{
			if(damage > 0) regenTimer = -30;

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

		public function regenerate(shooting:Boolean)
		{
			if (shooting && regenTimer > 0)
			{
				regenTimer = 0;
			}
			else
			{
				regenTimer++;
			}
				
			if (regenTimer > 90 && regenTimer % 5 == 0 && health < maxHealth)
			{
				health++;
			}
		}

		public function spawnDamagedSmoke()
		{
				var damagedSmoke = new DamagedSmoke();
				if(health > (maxHealth*0.6) || this is EnemyPlane)
				{
					damagedSmoke.smokeType = 0;
				}
				else if(health > (maxHealth*0.2))
				{
					damagedSmoke.smokeType = 1;
				}
				else
				{
					damagedSmoke.smokeType = 2;
				}
				
				var randomNum:Number = Math.random() * 5;
				if (Math.random() < 0.5)
				{
					damagedSmoke.x = x + randomNum;
				}
				else
				{
					damagedSmoke.x = x - randomNum;
				}
				randomNum = Math.random() * 5;
				if (Math.random() < 0.5)
				{
					damagedSmoke.y = y + randomNum;
				}
				else
				{
					damagedSmoke.y = y - randomNum;
				}
				parent.addChild(damagedSmoke);
		}
		
		public function makeSparks(hitBoat:Boolean)
		{
			var numSparks = (hitBoat)? 2 : 5;
			for(var i:int = 0; i < Math.floor(Math.random() * numSparks) + 1; ++i)
			{
				var spark:Spark = new Spark(this.x, this.y, this.speedX, this.speedY);
				parent.addChild(spark);
			}
		}
		
		public function specialMove()
		{
			//define in subclasses
		}
		
		public function playSpecialAnimation()
		{
			//define in subclasses
		}
		
		public function specialCancel()
		{
			//define in subclass
		}

		//getters and setters
		public function getDamage():int
		{
			if(health == 0) return 0;
			else return damage;
		}
		
		public function getXPosition():Number
		{
			return x;
		}

		public function setXPosition(n:Number):void
		{
			x = n;
		}

		public function getYPosition():Number
		{
			return y;
		}

		public function setYPosition(n:Number):void
		{
			y = n;
		}

		public function getRotation():Number
		{
			return rotateReference.rotation;
		}
		
		public function collide(other:MovieClip):void
		{
			//collision for player planes -- overloaded in enemyplane
			if(other is Projectile || takesTouchDamage)
			{
				getHit((other as DealsDamage).getDamage());
			}
			else if(!takesTouchDamage)
			{
				if(other is SmallBoat || other is Battleship)
				{
					makeSparks(true);
				}
				else
				{
					makeSparks(false);
				}
			}
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
			return false;
		}
		public function getHitCircle():Vector.<Number>
		{
			return null;
		}
		public function toggleHitbox():void
		{
			
		}
		public function getHitbox():Shape
		{
			return null;
		}
	}
}