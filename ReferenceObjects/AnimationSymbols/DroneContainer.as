package ReferenceObjects.AnimationSymbols {
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	public class DroneContainer extends MovieClip{
		
		public var drawLayers:Array = new Array(6);
		public var drones:Array = new Array(6);
		
		public function DroneContainer() {
			for(var i:int = 0; i < drawLayers.length; ++i)
			{
				drawLayers[i] = new Shape();
				drawLayers[i].graphics.lineStyle(2, 0x4DFDFC, 0.5);
				addChild(drawLayers[i]);
			}
		}

	}
	
}
