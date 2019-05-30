package ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import ReferenceObjects.Pregame.TitleScreen;

	public class KeenerButton extends GameButton 
	{
		
		private var titleScreenRef:TitleScreen;
		
		public function KeenerButton() 
		{
			titleScreenRef = TitleScreen(parent);
			code = 7;
		}
		
		override function mDown(event:MouseEvent)
		{
			gotoAndPlay(3);
			//uiClick.play();
			titleScreenRef.updatePlaneSelection(1);
			if(pressed)
				pressed = false;
			else
				pressed = true;
			
		}
	}
	
}
