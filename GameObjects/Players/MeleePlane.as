package GameObjects.Players {
	
	import flash.display.MovieClip;
	import ReferenceObjects.AnimationSymbols.ChargeBoost;
	import ReferenceObjects.AnimationSymbols.ChargeBoostCharge;
	import ReferenceObjects.AnimationSymbols.Shield;
	import ReferenceObjects.AnimationSymbols.Spark;
	import GameObjects.Projectiles.WeaponHandler;
	import Interfaces.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class MeleePlane extends PlaneGeneric {
		
		private const DRAG:Number = 0.03;
		private const DASHBONUS:Number = 8;
		private const CHARGEMAX:uint = 60;
		private var dashCount:uint = 0;
		private var chargingAnimation:ChargeBoostCharge = new ChargeBoostCharge();
		private var shield:Shield = new Shield();
		public var shielding:Boolean = false;
		public var weaponHandlerPointer:WeaponHandler;
		private const BASEDAMAGE:uint = 4;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Vector.<Point>>;
		private var hitBox:Shape;
		
		public function MeleePlane() 
		{
			bulletCooldown = 0;
			damage = BASEDAMAGE;
			addChild(chargingAnimation);
			addChild(shield);
			getHitPoly();
			takesTouchDamage = false;
		}
		
		override public function accelerate():void
		{
			if(!dashing)
			{
				setSpeedFromRotation();
				setYPosition(y - speedY);
				setXPosition(x + speedX);
				if( y > MAX_HEIGHT )
					grav = 0;
			}
			else
				dash();
		}
		
		override public function momentum():void
		{
			if(!dashing)
			{
				speedX = speedX*.99;
				speedY = speedY*.99;
				setYPosition(y - speedY);
				setXPosition(x + speedX);
			}
			else
				dash();
		}
		
		private function dash()
		{
			dashing = (specialCooldown > 0);
			if(dashing)
			{
				if(fullCharge)
				{
					if(specialCooldown == 60)
					{
						chargingAnimation.shockwaveCharge();
					}
				}
				else
				{
					chargingAnimation.cancelAnimation();
				}
				speedY = (speedModifier + DASHBONUS * (specialCooldown/CHARGEMAX)) * rotateReference.trigDistanceY();
				speedX = (speedModifier + DASHBONUS * (specialCooldown/CHARGEMAX)) * rotateReference.trigDistanceX();
				damage = BASEDAMAGE + ((BASEDAMAGE * 2) * (specialCooldown/CHARGEMAX));
				setYPosition(y - speedY);
				setXPosition(x + speedX);
				spawnChargeBoost();
				specialCooldown--;
				dashCount++;
			}
			else
			{
				dashCount = 0;
				damage = BASEDAMAGE;
			}
				
			if( y > MAX_HEIGHT)
				grav = 0;
		}
		
		private function spawnChargeBoost()
		{
			var tempBoost = new ChargeBoost();
			tempBoost.rotation = rotateReference.rotation;
			tempBoost.x = x - 10 * rotateReference.trigDistanceX();
			tempBoost.y = y + 10 * rotateReference.trigDistanceY();
			parent.addChild(tempBoost);
		}
		
		override public function playSpecialAnimation()
		{
			if(specialCooldown == 0)
			{
				chargingAnimation.play();
			}
			if(specialCooldown < 60)
			{
				specialCooldown += 3;
			}
			else if(specialCooldown >= 60)
			{
				fullCharge = true;
			}
		}
		
		override public function specialMove()
		{
			if(!shielding)
			{
				shielding = true;
				shield.play();
				regenTimer = 0;
			}
		}
		
		override public function specialCancel()
		{
			if(shielding)
			{
				shield.endShield();
				shielding = false;
				regenTimer = 0;
			}
		}
		
		override public function getHit(damage:int):void
		{
			if(!shielding || damage == 1)
			{
				regenTimer = -30;
	
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
		}

		override public function regenerate(shooting:Boolean)
		{
			if(shielding)
			{
				if(regenTimer % 30 == 0)
				{
					getHit(1);
				}
				regenTimer++;
			}
			else
			{
				if (shooting && regenTimer > 0)
				{
					regenTimer = 0;
				}
				else
				{
					regenTimer++;
				}
					
				if (regenTimer > 90 && regenTimer % 5 == 0 && health < 30)
				{
					health++;
				}								
			}
		}
		
		override public function isHitPoly():Boolean
		{
			return true;
		}
		override public function getHitPoly():Vector.<Point>
		{
			if(!hasPoly)
			{
				hitPoly = new Vector.<Vector.<Point>>(40);
				
				for(var i:int = 0; i < hitPoly.length; ++i)
				{
					hitPoly[i] = new Vector.<Point>();
				}
				
				hitPoly[0].push(new Point(-7, 0), new Point(0, -8), new Point(7, 0), new Point(0, 8));
				hitPoly[1].push(new Point(-7, -1), new Point(1, -8), new Point(7, 2), new Point(-1, 8));
				hitPoly[2].push(new Point(-7, -2), new Point(4, -8), new Point(7, 4), new Point(-3, 7));
				hitPoly[3].push(new Point(-7, -3), new Point(5, -8), new Point(6, 4), new Point(-4, 7));
				hitPoly[4].push(new Point(-6, -3), new Point(6, -7), new Point(4, 6), new Point(-5, 7));
				hitPoly[5].push(new Point(-6, -3), new Point(7, -7), new Point(4, 5), new Point(-6, 6));
				hitPoly[6].push(new Point(-6, -3), new Point(7, -6), new Point(1, 6), new Point(-6, 5));
				hitPoly[7].push(new Point(-5, -5), new Point(8, -5), new Point(0, 5), new Point(-7, 3));
				hitPoly[8].push(new Point(-4, -5), new Point(8, -4), new Point(1, 5), new Point(-8, 2));
				hitPoly[9].push(new Point(-4, -4), new Point(8, -1), new Point(1, 4), new Point(-9, 1));
				hitPoly[10].push(new Point(-9, -1), new Point(0, -3), new Point(8, 0), new Point(-2, 3));
				hitPoly[11].push(new Point(-9, -1), new Point(-1, -4), new Point(8, 1), new Point(-4, 4));
				hitPoly[12].push(new Point(-9, -4), new Point(1, -5), new Point(8, 4), new Point(-4, 5));
				hitPoly[13].push(new Point(-7, -4), new Point(2, -4), new Point(8, 6), new Point(-5, 4));
				hitPoly[14].push(new Point(-6, 3), new Point(-6, -5), new Point(2, -5), new Point(7, 6));
				hitPoly[15].push(new Point(-6, -6), new Point(2, -7), new Point(7, 7), new Point(-7, 2));
				hitPoly[16].push(new Point(-5, -7), new Point(4, -6), new Point(6, 7), new Point(-6, 3));
				hitPoly[17].push(new Point(-7, 3), new Point(-4, -7), new Point(6, -4), new Point(5, 8));
				hitPoly[18].push(new Point(-7, 1), new Point(-3, -7), new Point(7, -5), new Point(4, 8));
				hitPoly[19].push(new Point(-7, 0), new Point(-1, -8), new Point(7, -4), new Point(1, 8));
				hitPoly[20].push(new Point(-7, 0), new Point(0, -8), new Point(7, 0), new Point(0, 8));
				hitPoly[21].push(new Point(-7, -2), new Point(1, -8), new Point(7, 1), new Point(-1, 8));
				hitPoly[22].push(new Point(-7, -4), new Point(3, -7), new Point(7, 2), new Point(-4, 8));
				hitPoly[23].push(new Point(-6, -4), new Point(4, -7), new Point(7, 3), new Point(-5, 8));
				hitPoly[24].push(new Point(-6, 7), new Point(-4, -6), new Point(5, -7), new Point(7, 1));
				hitPoly[25].push(new Point(-4, -5), new Point(6, -6), new Point(5, 4), new Point(-7, 7));
				hitPoly[26].push(new Point(-1, -6), new Point(6, -5), new Point(6, 3), new Point(-7, 6));
				hitPoly[27].push(new Point(-8, 6), new Point(-2, -4), new Point(7, -4), new Point(6, 3));
				hitPoly[28].push(new Point(-8, 4), new Point(-1, -5), new Point(9, -3), new Point(4, 5));
				hitPoly[29].push(new Point(-8, 1), new Point(-1, -4), new Point(9, -2), new Point(4, 4));
				hitPoly[30].push(new Point(-8, 0), new Point(0, -3), new Point(9, -1), new Point(3, 3));
				hitPoly[31].push(new Point(-8, -2), new Point(4, -4), new Point(8, 2), new Point(-1, 4));
				hitPoly[32].push(new Point(-8, -3), new Point(4, -5), new Point(8, 3), new Point(-1, 5));
				hitPoly[33].push(new Point(-8, -6), new Point(5, -5), new Point(6, 3), new Point(-2, 4));
				hitPoly[34].push(new Point(-7, -6), new Point(6, -3), new Point(6, 5), new Point(-2, 5));
				hitPoly[35].push(new Point(-7, -7), new Point(5, -4), new Point(6, 6), new Point(-4, 5));
				hitPoly[36].push(new Point(-6, -7), new Point(6, -3), new Point(5, 7), new Point(-4, 6));
				hitPoly[37].push(new Point(-5, -8), new Point(7, -3), new Point(3, 7), new Point(-6, 4));
				hitPoly[38].push(new Point(-4, -8), new Point(7, -2), new Point(3, 7), new Point(-7, 5));
				hitPoly[39].push(new Point(-7, 2), new Point(-1, -8), new Point(7, -1), new Point(1, 8));
				for each (var vector in hitPoly)
					vector.sort(Vertex.clockwise);
				
				hasPoly = true;
				hitBox = new Shape();
				addChild(hitBox);
				hitBox.visible = false;
				addEventListener(Event.ENTER_FRAME, hitboxManager, false, 0, true);
				return getHitPoly();
			}
			else
			{
				var relativePoly:Vector.<Point> = new Vector.<Point>();
				var relativePoint:Point;
				var index:uint = currentFrame - 1;
				for(var j:int = 0; j < hitPoly[index].length; ++j)
				{
					relativePoint = new Point(x + hitPoly[index][j].x, y + hitPoly[index][j].y);
					relativePoly.push(relativePoint);
				}
				return relativePoly;
			}
		}
		override public function isHitCircle():Boolean
		{
			return false;
		}
		override public function getHitCircle():Vector.<Number>
		{
			return null;
		}
		override public function toggleHitbox():void
		{
			hitBox.visible = !hitBox.visible;
		}
		
		private function hitboxManager(e:Event)
		{
			var index:uint = currentFrame - 1;
			hitBox.graphics.clear();
			hitBox.graphics.lineStyle(1, 0x990000);
			hitBox.graphics.beginFill(0x990000, 0.5);
			hitBox.graphics.moveTo(hitPoly[index][0].x, hitPoly[index][0].y);
			for(var i:int = 0; i < hitPoly[index].length; ++i)
			{
				hitBox.graphics.lineTo(hitPoly[index][i].x, hitPoly[index][i].y);
			}
			hitBox.graphics.lineTo(hitPoly[index][0].x, hitPoly[index][0].y);
		}
		
		override public function getHitbox():Shape
		{
			return hitBox;
		}


	}
}
