package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Interfaces.*;
	import flash.display.Shape;
	
	public class Nemesis extends MovieClip implements Damagable, DealsDamage, Collidable
	{

		public var health:int;
		public var damage:int = 0;

		public function Nemesis() {
			// constructor code
		}
		
		public function AI():void
		{
			
		}
		
		public function getDamage():int
		{
			return damage;
		}
		
		public function getHit(damage:int):void
		{
			trace("getHit on top-level nemesis does nothing.");
		}
		
		public function die()
		{
			this.parent.removeChild(this);
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
