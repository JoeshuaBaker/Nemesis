package ReferenceObjects {
	import flash.display.MovieClip;
	import ReferenceObjects.AnimationSymbols.NewBoost;
	
	public class Tail extends MovieClip{
		public var newBoost:NewBoost;

		public function Tail() {
			newBoost = new NewBoost();
			addChild(newBoost);
		}
		
		public function animationCancel():void
		{
			newBoost.visible = false;
			newBoost.gotoAndStop(1);
		}
		
		public function getX():Number {
			return x;
		}
		
		public function getY():Number {
			return y;
		}
		
		public function setX(i:Number):void{
			x = i;
		}
		
		public function setY(i:Number):void{
			y = i;
		}

	}
	
}
