package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import ReferenceObjects.AnimationSymbols.BulletSplash;	
	
	public class DroneDeath extends MovieClip {
		
		
		public function DroneDeath(_x:Number, _y:Number) {
			// constructor code
			x = _x;
			y = _y;
			addEventListener(Event.ENTER_FRAME, fall, false, 0, true);
		}
		
		private function fall(e:Event):void
		{
			y += 5;
			if(y > 350)
			{
				var splash:BulletSplash = new BulletSplash();
				splash.y = y;
				splash.x = x;
				parent.addChild(splash);
				stop();
				removeEventListener(Event.ENTER_FRAME, fall);
				this.parent.removeChild(this);
			}
		}
	}
	
}
