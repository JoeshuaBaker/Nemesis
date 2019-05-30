package ReferenceObjects.AnimationSymbols {
	import flash.display.MovieClip;
	
	public class MuzzleFlare extends MovieClip{

		public function MuzzleFlare() 
		{
			gotoAndStop(7);
		}
		
		public function resetAnimation() 
		{
			if(currentFrame == 7)
				gotoAndPlay(1);
		}
		
		public function resetSniperAnimation()
		{
			if(currentFrame == 7 || currentFrame == totalFrames)
				gotoAndPlay(8);
		}

	}
	
}
