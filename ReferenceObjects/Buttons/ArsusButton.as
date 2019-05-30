package ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import ReferenceObjects.Pregame.TitleScreen;
	
	public class ArsusButton extends GameButton 
	{
		
		private var titleScreenRef:TitleScreen;
		
		public function ArsusButton() 
		{
			titleScreenRef = TitleScreen(parent);
			code = 8;
		}
		
		override function mDown(event:MouseEvent)
		{
			gotoAndPlay(3);
			//uiClick.play();
			titleScreenRef.updatePlaneSelection(2);
			if(pressed)
				pressed = false;
			else
				pressed = true;
			
		}
	}
	
}
