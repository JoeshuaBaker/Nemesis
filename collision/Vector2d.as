package  collision{
	import flash.geom.Point;
	
	public class Vector2d {
		private var _x:Number;
		private var _y:Number;

		public function Vector2d(x:Number, y:Number) {
			_x = x;
			_y = y;
		}
		
		public function get x():Number { return _x;}
		public function get y():Number { return _y;}
		public function set x(x:Number):void { _x = x; }
		public function set y(y:Number):void { _y = y; }
		
		public function getLeftNorm():Vector2d
		{
			var mag:Number = mag();
			return new Vector2d((_y*-1/mag), (_x/mag));
		}
		
		public function getRightNorm():Vector2d
		{
			var mag:Number = mag();
			return new Vector2d((_y/mag), (_x*-1/mag));
		}
		
		public function dotProduct(vec:Vector2d):Number
		{
			return (_x * vec.x) + (_y * vec.y);
		}
		
		public function mag():Number { return Math.sqrt(_x * _x + _y * _y); }
		public function magSqr():Number { return _x * _x + _y * _y; }
		
		public function toPoint():Point { return new Point(_x, _y); }

	}
	
}
