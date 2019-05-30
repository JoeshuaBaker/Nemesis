package GameObjects.Projectiles 
{
	import flash.display.MovieClip;
	import Interfaces.*;
	import flash.geom.Point;
	import flash.display.Shape;
	
	public class Projectile extends MovieClip implements DealsDamage, Collidable
	{
		public var cullThis:Boolean = false;
		public var isEnemyBullet:Boolean = false;
		protected var damage:int = 0;

		public function Projectile()
		{
			// constructor code
		}
		
		public function getDamage():int
		{
			return damage;
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
