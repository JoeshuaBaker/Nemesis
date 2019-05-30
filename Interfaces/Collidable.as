package Interfaces {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import ReferenceObjects.Vertex;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	
	public interface Collidable {

		// Interface methods:
		function collide(other:MovieClip):void;
		function isHitPoly():Boolean;
		function getHitPoly():Vector.<Point>;
		function isHitCircle():Boolean;
		function getHitCircle():Vector.<Number>;
		function toggleHitbox():void
		function getHitbox():Shape
		
	}
	
}

/*		interface prototype:

		public function collide(other:MovieClip):void
		{
			
		}
		public function isHitPoly():Boolean
		{
			return null;
		}
		public function getHitPoly():Vector.<Point>
		{
			return null;
		}
		public function isHitCircle():Boolean
		{
			return null;
		}
		public function getHitCircle():Vector.<Number>
		{
			return null;
		}
		public function toggleHitbox():void
		{
			
		}
		
		Hitcircle local variables:
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var drawnCircle:Boolean = false;
		private var hasHitCircle:Boolean = false;
		
		Hitpoly local variables:
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;
		private var drawnHitbox:Boolean = false;
		

*/
