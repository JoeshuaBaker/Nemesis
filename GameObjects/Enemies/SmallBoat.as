package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import ReferenceObjects.AnimationSymbols.SmallBoatFire;
	import GameObjects.Projectiles.Bullet;
	import GameObjects.Projectiles.SniperBullet;
	import GameObjects.Projectiles.Projectile;
	import GameObjects.Players.PlaneGeneric;
	import Interfaces.*;
	import ReferenceObjects.AnimationSymbols.ChargeBoostCharge;
	import GameObjects.Players.SawPlane;
	import GameObjects.Players.MeleePlane;
	import flash.geom.Point;
	import ReferenceObjects.Vertex;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import Sounds.SoundHandler;
	
	public class SmallBoat extends MovieClip implements Damagable, DealsDamage, Collidable
	{
		
		var health:uint;
		var deathFrame:uint = 385;
		var bulletCooldown:uint = 60;
		var missileCounter:uint = 0;
		var attackAnimation:SmallBoatFire = new SmallBoatFire();
		protected var damage:int = 15;
		private var fireIndicator:ChargeBoostCharge = new ChargeBoostCharge();
		public var playerOffset:Number = NaN;
		private var soundHandler:SoundHandler;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;
		
		public function SmallBoat(_soundHandler:SoundHandler, xPos:Number = NaN, playerX:Number = NaN) {
			
			if(arguments.length > 0)
			{
				playerOffset = xPos;
				x = xPos + playerX;		
			}
			soundHandler = _soundHandler;
			y = 333;
			health = 120;
			attackAnimation.visible = false;
			attackAnimation.x = 26.5;
			attackAnimation.y = 13;
			fireIndicator.x = 27;
			fireIndicator.y = -3;
			addChild(attackAnimation);
			addChild(fireIndicator);
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
			gotoAndPlay(deathFrame);
			parent.setChildIndex(this, 0);
			attackAnimation.visible = false;
			soundHandler.playSfx(16, new Point(x, y));
		}
		
		public function startAttackAnimation()
		{
			attackAnimation.visible = true;
			attackAnimation.gotoAndStop(1);
		}
		
		public function startFireIndicator()
		{
			fireIndicator.gotoAndPlay(29);
		}
		
		public function getDamage():int
		{
			return damage;
		}
		
		public function collide(other:MovieClip):void
		{
			if(other is Projectile || other is PlaneGeneric)
			{
				getHit((other as DealsDamage).getDamage());
			}
			else
			{
				trace("something besides a projectile or a plane hit the small boat...");
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
				hitBox.graphics.moveTo(hitPoly[0].x, hitPoly[0].y)
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
