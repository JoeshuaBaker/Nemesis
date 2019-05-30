package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.events.Event;
	
	public class Drone extends MovieClip {
		
		public var layer:int;
		private var radiusGap:int = 30;
		private var radiusOffset:int = 100;
		public var radius;
		
		private var xSpeed:Number = 0.5;
		private var ySpeed:Number = 0;
		private var angularSpeed:Number = 1;
		private var angle:Number;
		private var spawnDir:Boolean;
		private var tiltThreshold:Number = 3;
		private var bulletCooldown:uint = 0;
		private var bulletMax:uint = 1;
		
		public var angleCounter:Number = 0;
		public var fullCircle:Boolean = false;
		public var orbiting:Boolean = false;
		public var begunDraw:Boolean = false;
		public var shoot:Boolean = false;
		
		public function Drone(_layer:int, yPos:Number, initialDir:Boolean) {
			y = yPos;
			layer = _layer;
			spawnDir = initialDir;
			gotoAndPlay(36);
			radius = radiusOffset + radiusGap*layer;
			graphics.lineStyle(3, 0x4DFDFC);
			bulletCooldown = Math.ceil(Math.random()*bulletMax);

		}
		
		
		public function AI()
		{
			if(!orbiting)
			{
				if( dist() >= radius)
				{
					orbiting = true;
					var slope:Number = y/x;
					angle = Math.atan(slope) - 90;
					
					if((slope < 0 && y < 0) || 
					   (slope > 0 && y > 0))
						angle += 90;
					else if((slope < 0 && y > 0) ||
							(slope > 0 && y < 0))
						angle += 270;
					
					updatePos(radius*Math.cos(angle * (Math.PI/180)), radius*Math.sin(angle * (Math.PI/180)));
				}
				else
				{
					if(spawnDir)
					{
						updatePos(x - xSpeed, y + ySpeed);
					}
					else
					{
						updatePos(x + xSpeed, y + ySpeed);
					}
					xSpeed *= 1.1;
					ySpeed -= 0.04;
				}
				
			}
			else
			{
				
				updatePos(radius*Math.cos(angle * (Math.PI/180)), radius*Math.sin(angle * (Math.PI/180)));
				angle += (angularSpeed + (angularSpeed/3 * 6/layer));
				if(!fullCircle) angleCounter += (angularSpeed + (angularSpeed/3 * 6/layer));
				if(angle >= 360) angle = 0;
				bulletCooldown--;
				if(bulletCooldown == 0)
				{
					bulletCooldown = bulletMax;
					shoot = true;
				}
			}
		}
		
		public function die()
		{
			addEventListener(Event.ENTER_FRAME, deathLoop, false, 0, true);
			gotoAndPlay(106);
		}
		
		public function deathLoop(e:Event)
		{
			if(y > 320)
			{
				stop();
				removeEventListener(Event.ENTER_FRAME, deathLoop);
				this.parent.removeChild(this);
			}
			else
			{
				y += 3;
			}
		}
		
		private function dist():Number
		{
			return Math.sqrt( (x*x) + (y*y) );
		}
		
		private function updatePos(_x:Number, _y:Number)
		{

			
			if( _x - x > tiltThreshold && currentFrame < 71)
			{
				gotoAndPlay(currentFrame + 35);
			}
			else if (_x - x < tiltThreshold*-1 && currentFrame > 35)
			{
				gotoAndPlay(currentFrame - 35);
			}
			else
			{
				if(currentFrame > 71)
				{
					gotoAndPlay(currentFrame - 35);
				}
				else if(currentFrame < 36)
				{
					gotoAndPlay(currentFrame + 35);
				}
			}
			
			x = _x;
			y = _y;
			
		}
		
	}
	
}
