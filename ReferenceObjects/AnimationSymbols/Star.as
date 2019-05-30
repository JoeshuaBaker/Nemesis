package  ReferenceObjects.AnimationSymbols
{
	
	import flash.display.MovieClip;
	
	public class Star extends MovieClip {
		
		public function Star() 
		{
			x = Math.random()*((Math.random() < 0.5) ? 640 : -640);
			y = Math.random()*((Math.random() < 0.5) ? 100 : -360);
			gotoAndPlay(Math.ceil(Math.random()*36));
		}
		
		public function jump()
		{
			var jumpTo:int = Math.ceil(Math.random()*100);
			
			if(jumpTo < 75)
			{
				gotoAndPlay(1);
			}
			else if(jumpTo < 95)
			{
				gotoAndPlay(13);
			}
			else
			{
				gotoAndPlay(25);
			}
		}
	}
	
}
