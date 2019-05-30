package  ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import Sounds.*;
	import ReferenceObjects.Pregame.TitleScreen;
	
	public class LaunchButton extends GameButton {
		
		var buttonGameTimer:Timer;
		var countdown:TextField;
		var countdownTime:uint;
		private var titleScreenRef:TitleScreen;
		
		public function LaunchButton() 
		{
			titleScreenRef = TitleScreen(parent);
			code = 11;
		}
		
		
		override function mDown(event:MouseEvent) 
		{
			gotoAndStop(3);
			//uiClick.play();
			removeEventListener(MouseEvent.MOUSE_OUT, mOut);
			removeEventListener(MouseEvent.MOUSE_OVER, mOver);
			removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
			pressed = true;
			titleScreenRef.updatePlaneSelection(5);
			
		}
		
	}
}
