package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TestNemesis extends MovieClip {
		
		
		public function TestNemesis() {
			addEventListener(Event.ENTER_FRAME, spin);
		}
		
		public function spin(e:Event) {
			rotation += 1;
		}
	}
	
}
