package  ReferenceObjects.AnimationSymbols
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Spark extends MovieClip {
		
		private const MAXSPEED:Number = 5.0;
		private var xSpeed:Number;
		private var ySpeed:Number;
		
		public function Spark(xpos:Number, ypos:Number, xPlaneSpeed:Number, yPlaneSpeed:Number) 
		{
			x = xpos;
			y = ypos;
			rotation = 360 * Math.random();
			
			ySpeed = (MAXSPEED/2) * Math.random() * -1 - (yPlaneSpeed*0.75);
			if(Math.random() > 0.5)
			{
				xSpeed = MAXSPEED * Math.random() + (xPlaneSpeed*0.75);
			}
			else
			{
				xSpeed = MAXSPEED * Math.random() * -1 + (xPlaneSpeed*0.75);
			}
			
			//addEventListener(Event.ENTER_FRAME, fly);
		}
		
		private function fly()
		{
			x += xSpeed;
			y += ySpeed;
			ySpeed += 0.1;
			/*if(y > 350)
				gotoAndPlay(25);*/
		}
		
		
	}
	
}
