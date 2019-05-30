package  ReferenceObjects.Buttons{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ToggleBox extends MovieClip {
		
		public var pressed:Boolean = false;
		protected var empty:uint = 1;
		protected var half:uint = 2;
		protected var full:uint = 3;
		
		public function ToggleBox(_x:Number, _y:Number, _pressed:Boolean, isBig:Boolean = false) {
			x = _x;
			y = _y;
			pressed = _pressed;
			
			if(isBig)
			{
				empty = 4;
				half = 5;
				full = 6;
			}
			
			gotoAndStop( (pressed) ? full : empty);
			addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
		}
		
		public function mOver(event:MouseEvent) 
		{
			gotoAndStop(half);
		}
		
		public function mOut(event:MouseEvent) 
		{
			if(pressed)
				gotoAndStop(full);
			else
				gotoAndStop(empty);
		}
		
		public function mDown(event:MouseEvent) 
		{
			pressed = !pressed;
			if(pressed)
				gotoAndStop(full);
			else
				gotoAndStop(empty);
		
		}
		
		public function changeState(newState:Boolean):void
		{
			pressed = newState;
			if(pressed)
			{
				gotoAndStop(full);
			}
			else
			{
				gotoAndStop(empty);
			}
		}
		
	}
	
}
