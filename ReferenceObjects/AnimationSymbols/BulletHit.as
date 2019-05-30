package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class BulletHit extends MovieClip {
		
		
		//THIS OBJECT HAS CODE ATTACHED TO FRAMES OF ANIMATION.
		//FOR DETAILS, CHECK THE TIMELINE OF THIS SYMBOL
		//Summary:
		//This object instructs its parent to remove it once it reaches frame 11, 22, or 34.
		
		public function BulletHit(animationDecider:uint) {
			if(animationDecider % 2 == 0)
			{
				gotoAndPlay(1);
			}
			else
			{
				gotoAndPlay(12);
			}
		}
	}
	
}
