package ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import ReferenceObjects.Pregame.TitleScreen;
	
	public class VandalButton extends GameButton 
	{
		
		private var titleScreenRef:TitleScreen;
		
		public function VandalButton() 
		{
			titleScreenRef = TitleScreen(parent);
			code = 9;
		}
		
		override function mDown(event:MouseEvent)
		{
			gotoAndPlay(3);
			//uiClick.play();
			titleScreenRef.updatePlaneSelection(3);
			if(pressed)
				pressed = false;
			else
				pressed = true;
			
		}
	}
	
}
