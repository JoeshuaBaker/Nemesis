package ReferenceObjects {
	
	import flash.display.MovieClip;
	
	
	public class Sun extends MovieClip {
		
		private var distance:Number = 200;
		
		public function Sun() {
			cacheAsBitmap = true;
			stop();
		}
		
		public function trackPlayer(playerX:Number, playerY:Number)
		{
			x = playerX;
			y = playerY + distance;
		}
	}
	
}
