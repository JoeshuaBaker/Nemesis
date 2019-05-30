package ReferenceObjects {
	
	import flash.display.MovieClip;
	
	
	public class Vertex extends MovieClip {
		
		
		public function Vertex() {
			visible = false;
		}
		
		public static function clockwise(a, b):int
		{
			if(a.x == b.x && a.y == b.y) return 0;
			if (a.x >= 0 && b.x < 0)
				return 1;
			if (a.x < 0 && b.x >= 0)
				return -1;
			if (a.x == 0 && b.x == 0) {
				if (a.y >= 0 || b.y >= 0)
					return (a.y > b.y) ? 1 : -1;
				return (b.y > a.y) ? 1 : -1;
			}
			
			var det:int = (a.x) * (b.y) - (b.x) * (a.y);
			if (det <= 0)
				return 1;
			else
				return -1;
		}
	}
	
}
