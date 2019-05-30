package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class Shield extends MovieClip {
		
		private var idleFrame:uint = 40;
		private var endFrame:uint = 75;
		
		public function Shield() 
		{
			stop();
		}
		
		public function endShield()
		{
			gotoAndPlay(endFrame);
		}
	}
	
}
