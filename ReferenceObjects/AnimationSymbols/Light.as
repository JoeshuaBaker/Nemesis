package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class Light extends MovieClip {
		
		var linger:uint = 0;
		public var stay:Boolean = false;
		var blueFrame:int = 2;
		var redFrame:int = 6;
		public var isOn:Boolean = false;
		public var isRed:Boolean = false;
		public var isBlue:Boolean = false;
		
		public function Light() {
			stop();
		}
		
		public function short(blue:Boolean)
		{
			linger = 10;
			stay = false;
			isOn = true;
			gotoAndPlay(((blue)? blueFrame : redFrame));
		}
		
		public function long(blue:Boolean)
		{
			linger = 30;
			stay = false;
			isOn = true;
			gotoAndPlay(((blue)? blueFrame : redFrame));
		}
		
		public function light(blue:Boolean)
		{
			gotoAndPlay(((blue)? blueFrame : redFrame));
			stay = true;
			isOn = true;
			isRed = !blue;
			isBlue = blue;
		}
		
		public function toggleOn(blue:Boolean = true)
		{
			if(blue)
			{
				if(!isOn || isRed)
				{
					light(true);
				}
			}
			else
			{
				if(!isOn || isBlue)
				{
					light(false);
				}
			}
		}
		
		public function off()
		{
			stay = false;
			isRed = false;
			isBlue = false;
			if(currentFrame == 5)
			{
				gotoAndPlay(10);
			}
			else if(currentFrame == 9)
			{
				gotoAndPlay(13);
			}
			else if(!isOn)
			{
				gotoAndStop(1);
			}
		}
	}
	
}
