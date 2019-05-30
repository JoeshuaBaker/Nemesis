package ReferenceObjects {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class InfoPane extends MovieClip {
		
		public var revealed:Boolean = false;
		public var pressed:Boolean = false;
		public var pressable:Boolean = true;
		private var listeners:Boolean = false;
		
		public function InfoPane(type:uint = 1) {
			switch(type)
			{
				case 1:
				gotoAndStop(1);
				pressable = false;
				break;
				
				case 2:
				gotoAndStop(2);
				addListeners();
				break;
				
				case 3:
				gotoAndStop(4);
				addListeners();
				break;
				
				case 4:
				gotoAndStop(6);
				addListeners();
				break;
			}
		}
		
		public function declassify(type:uint):void
		{
			if(!revealed)
			{
				switch(type)
				{
					case 1:
					gotoAndStop(8);
					break;
					
					case 2:
					gotoAndStop(10);
					break;
					
					case 3:
					gotoAndStop(12);
					break;
					
					default:
					return;
					break;
				}
				revealed = true;
				pressable = true;
				addListeners();
			}
		}
		
		public function disable():void
		{
			visible = false;
			removeListeners();
		}
		
		public function enable():void
		{
			visible = true;
			addListeners();
		}
		
		private function addListeners():void
		{
			if(pressable && !listeners)
			{
				addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, mOut, false, 0, true);
				addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
				listeners = true;
			}
		}
		
		private function removeListeners():void
		{
			if(listeners)
			{
				removeEventListener(MouseEvent.MOUSE_OVER, mOver);
				removeEventListener(MouseEvent.MOUSE_OUT, mOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
				listeners = false;
			}
		}
		
		private function mOver(e:MouseEvent):void
		{
			if(currentFrame % 2 == 0)
			{
				gotoAndStop(currentFrame + 1);				
			}
		}
		
		private function mOut(e:MouseEvent):void
		{
			if(currentFrame % 2 != 0 && currentFrame != 1)
			{
				gotoAndStop(currentFrame - 1);
			}
		}
		
		private function mDown(e:MouseEvent):void
		{
			pressed = true;
			if(currentFrame % 2 != 0 && currentFrame != 1)
			{
				gotoAndStop(currentFrame - 1);
			}
		}
		
	}
	
}
