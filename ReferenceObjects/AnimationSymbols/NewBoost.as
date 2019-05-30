package ReferenceObjects.AnimationSymbols {
	import flash.display.MovieClip;
	
	public class NewBoost extends MovieClip{

		public function NewBoost() 
		{
			
		}

		public function animationCancel():void
		{
			visible = false;
			gotoAndStop(1);
		}
		
		public function animationStart():void
		{
			visible = true;
			play();
		}
	}
	
}
