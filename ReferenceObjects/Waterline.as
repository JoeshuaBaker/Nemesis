package ReferenceObjects {	
	import flash.display.MovieClip;
	import GameObjects.Players.PlaneGeneric;
	
	public class Waterline extends MovieClip
	{

		public function Waterline() {
			x = 300;
			y = 350;
			cacheAsBitmap = true;
			stop();
		}
		
		public function followPlayerX( plane:PlaneGeneric ) {
			x = plane.x;
		}

	}
	
}
