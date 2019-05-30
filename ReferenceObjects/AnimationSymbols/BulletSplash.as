package  ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class BulletSplash extends MovieClip {
		
		//this object commits suicide at frame 18
		
		public function BulletSplash(isSmall:Boolean = false)
		{
			if(isSmall)
			{
				gotoAndPlay(19);
			}
		}
	}
	
}
