package ReferenceObjects {
	import flash.display.MovieClip;
	import ReferenceObjects.Buttons.NemesisSlider;
	import flash.events.MouseEvent;
	
	public class SliderContainer extends MovieClip
	{
		var sliders:Array;

		public function SliderContainer() {
			sliders = new Array();
			addEventListener(MouseEvent.MOUSE_UP, mUp, false, 0, true);

		}
		
		public function addSlider(xPos:Number, yPos:Number, degrees:uint, value:uint):NemesisSlider
		{
			var tempSlider:NemesisSlider = new NemesisSlider(degrees, value);
			tempSlider.x = xPos;
			tempSlider.y = yPos;
			sliders.push(tempSlider);
			addChild(tempSlider);
			return tempSlider;
		}
		
		public function mUp(e:MouseEvent)
		{
			for(var i:int = 0; i < sliders.length; ++i)
			{
				sliders[i].cancel();
			}
		}

	}
	
}
