package GameObjects.Projectiles {
	import flash.display.MovieClip;
	import collision.*;
	import ReferenceObjects.AnimationSymbols.BulletHit;
	import ReferenceObjects.AnimationSymbols.Plink;
	import GameObjects.Players.PlaneGeneric;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import ReferenceObjects.Vertex;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import GameObjects.Enemies.BulletNemesis;
	import GameObjects.Enemies.Battleship;
	import GameObjects.Enemies.SmallBoat;
	import GameObjects.Enemies.BlobNemesis;
	import Interfaces.Collidable;
	import Sounds.SoundHandler;

	
	public class Bullet extends Projectile{
		
		public var speedX:Number;
		public var speedY:Number;
		var enemyBulletSpeed:uint = 7;
		var playerBulletSpeed:uint = 10;
		var shotgunBulletSpeed:uint = 15;
		public var isShotgunBullet:Boolean = false;
		public var isBattleshipBullet:Boolean = false;
		public var isBasicBullet:Boolean = false;
		private var collisionHandler:CollisionHandler;
		public var soundHandler:SoundHandler;
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;
		
		public function Bullet(xInput:Number, yInput:Number, bulletCode:uint = 0, _collisionHandler:CollisionHandler = null, _soundHandler:SoundHandler = null) {
			speedX = xInput;
			speedY = yInput;
			cullThis = false;
			isEnemyBullet = false;
			damage = 12;
			collisionHandler = _collisionHandler;
			soundHandler = _soundHandler;
			
			switch(bulletCode)
			{
				case 0:
				isBasicBullet = true;
				damage = 12;
				break;
				
				case 1:
				isBattleshipBullet = true;
				damage = 12;
				break;
				
				case 2:
				isShotgunBullet = true;
				damage = 8;
				break;
			}
			getHitCircle();
		}
		
		public function moveThis():void
		{
			if(isEnemyBullet)
			{
				x += speedX * enemyBulletSpeed;
				y -= speedY * enemyBulletSpeed;
			}
			else if(isShotgunBullet)
			{
				x += speedX * shotgunBulletSpeed;
				y -= speedY * shotgunBulletSpeed;
			}
			else
			{
				x += speedX * playerBulletSpeed;
				y -= speedY * playerBulletSpeed;
			}
		}
		
		public function removeThis(numOfCollisions:int = -1, angle:Number = 0):void
		{
			cullThis = true;
			if(numOfCollisions == -1)
			{
				var plink:Plink = new Plink();
				plink.rotation = angle;
				plink.x = x;
				plink.y = y;
				parent.addChild(plink);
				soundHandler.playSfx(19, new Point(x, y), 0.20);
			}
			else
			{
				var bulletHitAnimation = new BulletHit(numOfCollisions);
				bulletHitAnimation.x = x;
				bulletHitAnimation.y = y;
				parent.addChild(bulletHitAnimation);	
				
			}
		}
		override public function collide(other:MovieClip):void
		{
			if(other is PlaneGeneric || other is Battleship || other is SmallBoat || other is BlobNemesis)
			{
				removeThis( Math.floor(Math.random()*2));
			}
			if(other is BulletNemesis)
			{
				if((other as BulletNemesis).isHitPoly())
				{
					if(collisionHandler.checkCollisionSAT((this as Collidable), ((other as BulletNemesis).freeSpace as Collidable)))
					{
						trace("bullet collision with freespace returned true");
						if(Math.abs(other.x - x) < 13 && Math.abs(other.y - y) < 13)
						{
							removeThis(Math.floor(Math.random()*2));
						}
					}
					else
					{
						removeThis(-1, 90 + Math.atan2(other.y - y, other.x - x)*(180/Math.PI));
					}
				}
				else
				{
					removeThis(-1, 90 + Math.atan2(other.y - y, other.x - x)*(180/Math.PI));
				}
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
				if(isBasicBullet)
				{
					hitCircle[0] = 0;
					hitCircle[1] = 0;
					hitCircle[2] = 5;
				}
				else if(isBattleshipBullet)
				{
					hitCircle[0] = -5;
					hitCircle[1] = -8;
					hitCircle[2] = 5;
				}
				else if(isShotgunBullet)
				{
					hitCircle[0] = -3;
					hitCircle[1] = -18;
					hitCircle[2] = 2;
				}
				
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
				relativeCircle[0] = x + Math.sin((rotation * Math.PI/180))*hitCircle[0];
				relativeCircle[1] = y + Math.cos((rotation * Math.PI/180))*hitCircle[1];
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
