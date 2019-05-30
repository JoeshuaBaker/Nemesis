package ReferenceObjects.Pregame
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class TransitionScreen extends MovieClip {
		
		public var done:Boolean = false;
		public function TransitionScreen() 
		{
		}
		
		public function playReverse():void
		{
			addEventListener(Event.ENTER_FRAME, playReverseLoop, false, 0, true);
			gotoAndStop(totalFrames - 1);
		}
		
		private function playReverseLoop(e:Event):void
		{
			if(currentFrame == 1) 
			{
				stop();
				removeEventListener(Event.ENTER_FRAME, playReverseLoop);
			}
			else gotoAndStop(currentFrame - 1);
		}
	}
	
}
