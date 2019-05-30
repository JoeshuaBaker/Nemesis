package GameObjects.Projectiles {
	
	import flash.display.MovieClip;
	import collision.*;
	import flash.geom.Point;
	import ReferenceObjects.Vertex;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import GameObjects.Players.PlaneGeneric;
	import GameObjects.Enemies.EnemyPlane;
	
	public class SlugExplosion extends Projectile
	{
		
		//THIS OBJECT HAS CODE ATTACHED TO FRAMES OF ANIMATION.
		//FOR DETAILS, CHECK THE TIMELINE OF THIS SYMBOL
		//Summary:
		//This object goes inactive on frame 5 and sets cullthis to true on frame 25 (last)
		
		public var isActive:Boolean;
		public var collisionHandler:CollisionHandler;
		public var isShockwave:Boolean;
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;

		
		public function SlugExplosion(_collisionHandler:CollisionHandler, _isShockwave:Boolean) 
		{
			damage = 14;
			isActive = true;
			collisionHandler = _collisionHandler;
			isShockwave = _isShockwave;
			if(isShockwave)
			{
				gotoAndPlay(40);
			}
			
			getHitCircle();
		}
		
		public function inactive():void
		{
			if(isActive)
			{
				isActive = false;
				if(isShockwave)
				{
					collisionHandler.removeList(this, 0);
				}
				else
				{
					collisionHandler.removeList(this, 1);
				}
			}
		}

		override public function collide(other:MovieClip):void
		{
			if(other is PlaneGeneric && !(other is EnemyPlane))
			{
				inactive();
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
				if(!isShockwave)
				{
					hitCircle[0] = 0;
					hitCircle[1] = 0;
					hitCircle[2] = 12;
				}
				else
				{
					hitCircle[0] = 0;
					hitCircle[1] = 0;
					hitCircle[2] = 27;
				}
				
				hitCircleShape = new Shape();
				hitCircleShape.graphics.lineStyle(1, 0x4DFDFC);
				hitCircleShape.graphics.beginFill(0x4DFDFC, 0.5);
				hitCircleShape.graphics.drawCircle(hitCircle[0], hitCircle[1], hitCircle[2]);
				hitCircleShape.visible = false;
				addChild(hitCircleShape);
				hasHitCircle = true;
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
