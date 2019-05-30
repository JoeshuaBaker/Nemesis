package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class ButtonGlow extends MovieClip {
		
		
		public function ButtonGlow() {
			visible = false;
		}
		
		public function moveThis(_x:Number, _y:Number):void
		{
			x = _x;
			y = _y;
		}
	}
	
}
