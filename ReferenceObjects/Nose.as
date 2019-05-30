package ReferenceObjects {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import ReferenceObjects.AnimationSymbols.MuzzleFlare;
	
	public class Nose extends MovieClip{
		
		public var nosePoint:Point;
		public var muzzleFlare:MuzzleFlare;

		public function Nose() {
			nosePoint = new Point(x, y);
			muzzleFlare = new MuzzleFlare();
			addChild (muzzleFlare);
		}
		
		public function getX():Number {
			return x;
		}
		
		public function getY():Number {
			return y;
		}
		
		public function setX(i:Number):void{
			x = i;
		}
		
		public function setY(i:Number):void{
			y = i;
		}

	}
	
}
