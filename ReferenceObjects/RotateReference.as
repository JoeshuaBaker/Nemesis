package ReferenceObjects{
	
	import flash.display.MovieClip;
	import GameObjects.Players.SniperPlane;
	
	public class RotateReference extends MovieClip{
		
		public var nose:Nose;
		public var tail:Tail;
		
		public function RotateReference(sLine:Boolean = false) {
			
			nose = new Nose();
			addChild( nose );
			nose.setY(-9);
			
			tail = new Tail();
			addChild( tail );
			tail.setY(9);
			
		}
		
		public function trigDistanceX():Number
		{
			var slopeX:Number;
		
			slopeX = Math.sin((rotation * Math.PI/180));
			return slopeX;
			
		}
		
		public function trigDistanceY():Number 
		{
			var slopeY:Number;
		
			slopeY = Math.cos((rotation * Math.PI/180));
			return slopeY;
			
		}
		
		//getters and setters
		public function setRotation(n:Number):void
		{
			rotation = n;
		}
		
		public function getRotation():Number
		{
			return rotation;
		}
		
		public function rotateRight(n:Number):void
		{
			rotation += n;
		}
		
		public function rotateLeft(n:Number):void
		{
			rotation -= n;
		}

	}
	
}
