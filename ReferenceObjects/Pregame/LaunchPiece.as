package ReferenceObjects.Pregame
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import ReferenceObjects.AnimationSymbols.PlaneSplash;
	
	
	public class LaunchPiece extends MovieClip 
	{
		
		var xSpeed:Number;
		var ySpeed:Number;
		var spinSpeed:Number;
		const XMAX:Number = 5;
		const XMIN:Number = 2;
		const YMAX:Number = 6;
		const YMIN:Number = 3;
		const SPINMAX:Number = 12;
		const SPINMIN:Number = 8;
		
		public function LaunchPiece(pieceCode:uint)
		{
			switch(pieceCode)
			{
				case 1:
				gotoAndPlay(19);
				xSpeed = -1*(Math.random()*(XMAX - XMIN) + XMIN);
				ySpeed = (Math.random()*(YMAX - YMIN) + YMIN)*-1;
				spinSpeed = -1*Math.random()*(SPINMAX - SPINMIN) + SPINMIN;
				break;
				
				case 2:
				gotoAndPlay(39);
				xSpeed = Math.random()*(XMAX - XMIN) + XMIN;
				ySpeed = (Math.random()*(YMAX - YMIN) + YMIN)*-1;
				spinSpeed = Math.random()*(SPINMAX - SPINMIN) + SPINMIN;				
				break;
				
				case 3:
				gotoAndPlay(45);
				xSpeed = (Math.random()*(XMAX - XMIN) + XMIN)*((Math.random() < 0.5)? -1:1);
				ySpeed = Math.random()*(YMAX - YMIN) + YMIN;
				spinSpeed = (Math.random()*(SPINMAX - SPINMIN) + SPINMIN)*((Math.random() < 0.5)? -1:1);				
				break;
				
				default:
				gotoAndPlay(1);
				break;
			}
			
		}
	
		public function beginFlying()
		{
			addEventListener(Event.ENTER_FRAME, fly, false, 0, true);
		}
		
		private function fly(event:Event)
		{
			x += xSpeed;
			y += ySpeed;
			rotation += spinSpeed;
			ySpeed += 0.1;
			
			if(y > 350)
			{
				stop();
				var planeSplash = new PlaneSplash();
				planeSplash.y = 353;
				planeSplash.x = this.x;
				this.parent.addChild(planeSplash);
				this.parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, fly);
			}
		}
	
	}
	
}
