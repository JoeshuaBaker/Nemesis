package ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class PowerButton extends GameButton {
		
		
		public function PowerButton() {
			play();
			code = 1;
		}
		
		override function mOut(e:MouseEvent)
		{
			play();
		}
		
		override function mOver(e:MouseEvent)
		{
			play();
		}
		
		override function mDown(e:MouseEvent)
		{
			gotoAndStop(121);
			pressed = true;
			disable();
		}
		
		override public function disable()
		{
			removeEventListener(MouseEvent.MOUSE_OUT, mOut);
			removeEventListener(MouseEvent.MOUSE_OVER, mOver);
			removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
		}
	}
	
}
