package ReferenceObjects.Pregame
{
	
	import flash.display.MovieClip;
	
	
	public class LaunchRocket extends MovieClip {
		
		public var speed:Number = 1;
		private var accel:Number = 0.1;
		
		public function LaunchRocket() {
			// constructor code
		}
		
		public function fly()
		{
			y -= speed;
			speed += accel;
		}
	}
	
}
