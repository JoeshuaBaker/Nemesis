package ReferenceObjects
{
	import flash.display.MovieClip;
	import GameObjects.Players.PlaneGeneric;
	import flash.display.Shape;

	public class BackgroundLayer extends MovieClip
	{
		private var bg:CityBackground;
		private var dist:Number;
		private var num:int;
		private var player:PlaneGeneric;
		private var isFirst:Boolean;
		private var bgwidth:Number = 300;
		private var cloud:Boolean = false;
		private var initialY:Number = 0;
		public var backgrounds:Array;
		public var starMask:Shape;

		public function BackgroundLayer(newbg:CityBackground, newnum:int, newdist:Number, playerRef:PlaneGeneric, isFirstBackground:Boolean = false)
		{
			bg = newbg;
			num = newnum;
			dist = newdist;
			player = playerRef;
			isFirst = isFirstBackground;
			cloud = (bg.currentFrame < 9) ? false : true;
			if (!cloud)
			{
				initialY = 350;
			}
			else
			{
				switch(bg.currentFrame)
				{
					case 9:
					initialY = -1000;
					starMask = new Shape();
					starMask.y = -1751;
					starMask.graphics.beginFill(0x051414, 1);
					starMask.graphics.moveTo(-640, 0);
					starMask.graphics.lineTo(-640, 1751);
					starMask.graphics.lineTo(640, 1751);
					starMask.graphics.lineTo(640, 0);
					starMask.graphics.lineTo(-640, 0);
					starMask.graphics.endFill();
					addChild(starMask);
					break;
					
					case 10:
					initialY = -760;
					break;
					
					case 11:
					initialY = -600;
					break;
					
					case 12:
					initialY = -450;
					break;
				}
			}
			y = initialY;
			backgrounds = new Array();
			var position:Number = 0;
			if (num % 2 == 0)
			{
				position = -1*(bg.width/2);
			}
			position -= bg.width*(Math.floor(num/2));

			
			for (var i:int = 0; i < num; i++)
			{
				var temp:CityBackground = new CityBackground(1);
				temp.copyBackground(bg);
				temp.x = position;
				position +=  bg.width;
				backgrounds.push(temp);
				addChild(temp);
			}
		}

		public function tileBackgrounds()
		{
			for (var i:int = 0; i < num; i++)
			{
				if (backgrounds[i].x + x > player.x + stage.width / 2 + bg.width / 2 )
				{
					//if this is farther than 700 pixels to the right of the plane
					backgrounds[i].x -=  bg.width * num;

				}
				else if (backgrounds[i].x + x < player.x - stage.width/2 - bg.width/2 )
				{
					//if this is farther than 700 pixels to the left of the plane
					backgrounds[i].x +=  bg.width * num;

				}
			}
		}

		public function parallax(tempX:Number)
		{
			if(!cloud)
			{
				if(!isFirst)
				{
					if(player.y < 0)
					{
						y = (player.y + initialY) + 0.00001*Math.abs(player.y)*dist;
					}
					else
					{
						y = initialY + 5000*player.y/dist;
					}					
				}
			}
			else
			{
				if(!isFirst)
				{
					y = initialY + 17000*player.y/dist;
				}
			}
			
			//var tempX:Number = player.deltaX;
			if(!cloud)
			{
				x +=  int(tempX - (tempX * (dist / 100000)));
			}
			else
			{
				x +=  int(tempX - (tempX * (dist / 100000)));
			}

		}

	}

}