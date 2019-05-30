package ReferenceObjects {
	
	import flash.display.MovieClip;
	
	public class CityBackground extends MovieClip
	{

		public function CityBackground(type:int)
		{
			stop();
			if(type > 0 && type <= totalFrames)
			{
				gotoAndStop(type);
			}
			cacheAsBitmap = true;
		}
		
		public function copyBackground(copy:CityBackground)
		{
			stop();
			gotoAndStop(copy.currentFrame);
		}
		
	}
	
}
