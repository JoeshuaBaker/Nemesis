package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import GameObjects.Players.PlaneGeneric;
	import flash.geom.Point;
	import GameObjects.Projectiles.NemesisBeam;
	import ReferenceObjects.AnimationSymbols.NemesisBeamCore;
	import ReferenceObjects.AnimationSymbols.ExtraDamage;
	import ReferenceObjects.BulletNemesisGap;
	import flash.display.Shape;
	import flash.events.Event;
	import ReferenceObjects.Vertex;
	import flash.display.DisplayObject;
	import Interfaces.DealsDamage;
	import GameObjects.Projectiles.Bullet;
	import Sounds.SoundHandler;
	
	public class BulletNemesis extends Nemesis
	{
		private var player:PlaneGeneric;
		public var moving:Boolean = false;
		public var idling:Boolean = false;
		public var shooting:Boolean = false;
		public var switchTimer:uint = 0;
		private const SPEED:uint = 25;
		private const MOVERADIUS:uint = 500;
		private var loopsToFire:uint = 3;
		private var currentLoops:uint = 0;
		private var movePoint:Point = new Point(200, -200);
		private var idleTimer:uint = 150;
		private var trackTimer:uint = 0;
		private var extraDamage:Boolean = true;
		public var lasers:Array = new Array();
		public var freeSpace:BulletNemesisGap;
		private var deathFlag:Boolean = false;
		//private var stayStill:Boolean = false;
		private var soundHandler:SoundHandler;

		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;


		public function BulletNemesis(playerRef:PlaneGeneric, _soundHandler:SoundHandler) 
		{
			damage = 50;
			health = 200;
			player = playerRef;
			soundHandler = _soundHandler;
			switchMode(1);
			for(var i:int = 0; i < 18; ++i)
			{
				lasers.push(new NemesisBeam());
			}
			freeSpace = new BulletNemesisGap(this);
			addChild(freeSpace);
			getHitCircle();
			getHitPoly();
		}
		
		override public function getDamage():int
		{
			return damage;
		}
		
		override public function getHit(damage:int):void
		{
			switch (health)
			{
				case 0 :
					break;

				default :
					if(extraDamage)
					{
						damage *= 5;
						extraDamage = false;
						var crit:ExtraDamage = new ExtraDamage();
						crit.x = x;
						crit.y = y;
						parent.addChild(crit);
					}
					
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
		
		private function getFlyAngle(xPoint:Number, yPoint:Number):Number
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
		
		private function trackPlayer()
		{
			rotation = 90 + getFlyAngle(player.x, player.y);
		}
		
		override public function AI():void
		{
			//trace(lasers);
			if(moving)
			{
				trackPlayer();
				if(switchTimer == 1)
				{
					findNewMovepoint();
				}
				if(moveToPoint())
				{
					if(currentLoops < loopsToFire)
					{
						switchMode(2);
					}
					else
					{
						switchMode(3);
						currentLoops = 0;
						findNewMovepoint();
						extraDamage = true;
					}
				}
			}
			else if(idling)
			{
				trackPlayer();
				idle();
				if(switchTimer > idleTimer)
				{
					switchMode(1);
					++currentLoops;
				}
			}
			else if(shooting)
			{
				shoot();
			}
			
			switchTimer++;
		}
		
		private function shoot()
		{
			if(switchTimer < trackTimer)
			{
				trackPlayer();
			}
			if(switchTimer == 1)
			{
				gotoAndPlay(23);
			}
			if(currentFrame == 238)
			{
				
				var core:NemesisBeamCore = new NemesisBeamCore();
				core.rotation = this.rotation + 90;
				core.x = x;
				core.y = y;
				parent.addChild(core);
				
				if(idleTimer < 90)
				{
					if(loopsToFire > 0)
					{
						loopsToFire--;
						idleTimer = 150;
					}
					else
					{
						if(idleTimer > 0)
						{
							idleTimer -= 30;
						}
					}
				}
				else
				{
					idleTimer -= 30;
				}
				
				if(trackTimer < 150)
				{
					trackTimer +=15;
				}
			}
		}
		
		public function trigDistanceX():Number
		{
			return Math.sin(((rotation + 90) * Math.PI/180));
		}
		
		private function trueTrigX():Number
		{
			return Math.sin(rotation * Math.PI/180);
		}
		
		public function trigDistanceY():Number 
		{
			return Math.cos(((rotation + 90) * Math.PI/180));
		}
		
		private function trueTrigY():Number
		{
			return Math.cos(rotation * Math.PI/180);
		}
		
		private function idle()
		{
			if(switchTimer % 30 == 0)
			{
				findNewMovepoint();
			}
			moveToPoint();
			
		}
		
		private function moveToPoint():Boolean
		{
			var nearPoint:Boolean = false;
			
			if(Math.abs(movePoint.x - x) < getSpeed())
			{
				nearPoint = true;
			}
			else
			{
				x += (x > movePoint.x)? getSpeed()*-1 : getSpeed();
			}
			
			if(Math.abs(movePoint.y - y) < getSpeed())
			{
				if(nearPoint)
				{
					return true;
				}
			}
			else
			{
				y += (y > movePoint.y)? getSpeed()*-1 : getSpeed();
			}
			return false;
		}
		
		private function findNewMovepoint()
		{
			/*if(stayStill)
			{
				
			}*/
			
			if(moving)
			{
				if(x > player.x)
				{
					movePoint.x = player.x + 100 + MOVERADIUS * Math.random();
				}
				else
				{
					movePoint.x = player.x - 100 - MOVERADIUS * Math.random();
				}
				
				if(y > player.y)
				{
					movePoint.y = player.y + 100 + MOVERADIUS * Math.random();
					if(movePoint.y > 300)
						movePoint.y = 300 - (MOVERADIUS / 2) * Math.random();
				}
				else
				{
					movePoint.y = player.y - 100 - MOVERADIUS * Math.random();
				}
			}
			else
			{
				movePoint.x = x + ((Math.random() < 0.5)? -50 : 50)*Math.random();
				movePoint.y = y + ((Math.random() < 0.5)? -50 : 50)*Math.random();
			}
		}
		
		private function switchMode(modeCode:uint)
		{
			switch(modeCode)
			{
				case 1:
				moving = true;
				idling = false;
				shooting = false;
				break;
				
				case 2:
				moving = false;
				idling = true;
				shooting = false;
				break;
				
				case 3:
				moving = false;
				idling = false;
				shooting = true;
				break;
				
				default:
				trace("u suck @ programming, from bulletNemesis switchMode");
				break;
			}
			
			switchTimer = 0;
			
		}
		
		private function isOnScreen():Boolean
		{   
				   
			if( x + width/2 < player.x - 640 || 
			     x - width/2 > player.x + 640 ||
				y + height/2 < player.y - 360 ||
				 y - height/2 > player.y + 360 )
				 return false;
				 
				 
			else return true;
		}
		
		private function getSpeed():uint
		{
			if(moving)
				return SPEED;
			else
				return SPEED/5;
		}
		
		override public function die()
		{
			//23
			//428
			if(currentFrame > 95 && currentFrame < 429) gotoAndPlay(453);
			deathFlag = true;
		}
		
		override public function collide(other:MovieClip):void
		{
			if(isHitPoly() && other is Bullet && Math.abs(other.x - x) < 13 && Math.abs(other.y - y) < 13)
			{
				getHit((other as DealsDamage).getDamage());
			}
		}
		override public function isHitPoly():Boolean
		{
			return (currentFrame >= 60 && currentFrame <= 413);
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
				//hitPoly.sort(Vertex.clockwise);
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
				hitCircleShape.visible = hitBox.visible = false;

				return getHitPoly();
			}
			else
			{
				var relativePoly:Vector.<Point> = new Vector.<Point>();
				var relativePoint:Point;
				
				var rotation360:Number;
				if(rotation < 0)
					rotation360 = 180 + (180 - Math.abs(rotation));
				else rotation360 = rotation;
				rotation360 = (rotation360 * Math.PI/180)*-1;
				
				for(var j:int = 0; j < hitPoly.length; ++j)
				{
					relativePoint = new Point(x + (hitPoly[j].y*Math.sin(rotation360) - hitPoly[j].x*Math.cos(rotation360)),
											  y + (hitPoly[j].y*Math.cos(rotation360) + hitPoly[j].x*Math.sin(rotation360)));
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
				hitCircle[2] = 43;
				
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
				freeSpace.hitBox.visible = true;
				hitCircleShape.visible = false;
			}
			else if(isHitCircle() && !hitCircleShape.visible)
			{
				hitBox.visible = false;
				freeSpace.hitBox.visible = false;
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
			{
				return hitCircleShape;
			}
		}

	}
	
}
