package  ReferenceObjects
{
	import flash.display.MovieClip;
	import ReferenceObjects.CityBackground;
	import GameObjects.Players.PlaneGeneric;
	import ReferenceObjects.AnimationSymbols.Wake;
	import ReferenceObjects.BackgroundLayer;
	import ReferenceObjects.Sun;
	import ReferenceObjects.Sunbeam;
	import ReferenceObjects.AnimationSymbols.Star;
	
	public class BackgroundHandler extends MovieClip
	{
		public var backgroundLayers:Array;
		public var backgroundTrim:Array;
		private var stars:Array = new Array();
		private var starfield:MovieClip = new MovieClip();
		private var cloudLayer:Array;
		private var sunbeams:Array;
		private var sun:Sun = new Sun();
		public var wakes:Array = new Array();
		private var player:PlaneGeneric;
		private var counter:int;
		private const STARVARIANCE:uint = 10;
		private var starCounter:int;
		private var nobg:Boolean;
		//private var waterline:Waterline;
		//waterline moved to weaponhandler because mitchell is autistic
		
		public function BackgroundHandler(playerRef:PlaneGeneric, settings:SettingsContainer) 
		{
			player = playerRef;
			addChild(sun);
			
			nobg = settings.nobg.pressed;
			
			backgroundLayers = new Array(new BackgroundLayer(new CityBackground(4), 4, 30000, player),
										 new BackgroundLayer(new CityBackground(3), 4, 45000, player),
										 new BackgroundLayer(new CityBackground(2), 4, 70000, player),
										 new BackgroundLayer(new CityBackground(1), 4, 100000, player, true));
			backgroundTrim = new Array(new BackgroundLayer(new CityBackground(8), 4, 30000, player),
									   new BackgroundLayer(new CityBackground(7), 4, 45000, player),
									   new BackgroundLayer(new CityBackground(6), 4, 70000, player));
			sunbeams = new Array(new Sunbeam(1, backgroundTrim[0]), new Sunbeam(2, backgroundTrim[1]), new Sunbeam(2, backgroundTrim[2]));
			var sunCounter:uint = settings.sunBeams.value;
			
			cloudLayer = new Array(new BackgroundLayer(new CityBackground(12), 4, 32500, player),
								   new BackgroundLayer(new CityBackground(11), 4, 45000, player),
								   new BackgroundLayer(new CityBackground(10), 4, 70000, player),
								   new BackgroundLayer(new CityBackground(9), 4, 100000, player, true));
			
			if(!nobg)
			{
				addChild(backgroundLayers[0]);
				addChild(cloudLayer[0]);
			
				for(var i:int = 1; i < backgroundLayers.length; ++i)
				{
					addChild(backgroundTrim[i - 1]);
					if(i - 1 < sunCounter && i <= sunCounter) addChild(sunbeams[i - 1]);
					addChild(backgroundLayers[i]);
					addChild(cloudLayer[i]);
				}
			}
			else
			{
				addChild(backgroundLayers[3]);
				addChild(cloudLayer[3]);
			}

			starCounter = settings.stars.value - Math.floor(STARVARIANCE*Math.random());
			if(starCounter < 0) starCounter = 0;
			var tempStar:Star;
			addChild(starfield);
			starfield.mask = cloudLayer[3].starMask;
			

			for(i = starCounter - 1; i >= 0; --i)
			{
				tempStar = new Star();
				stars.push(tempStar);
				starfield.addChild(tempStar);
			}
			trace("made " + starCounter + " stars");
			

		}
		
		public function upkeep()
		{
			sun.trackPlayer(player.x, player.y);
			counter++;
			
			if(!nobg)
			{
				if(player.y > -225 || player.y < -700)
				{
					sunbeams[1].visible = false;
					sunbeams[2].visible = false;
				}
				else
				{
					sunbeams[1].visible = true;
					sunbeams[2].visible = true;
				}
				
				sunbeams[0].trackPlayer(sun, player);
				sunbeams[1].y = -610 - sunbeams[0].y;
				sunbeams[2].y = -525 - sunbeams[0].y;
				var pDeltaX:Number = player.deltaX;
				for(var i:int = backgroundLayers.length - 1; i >= 0; --i)
				{
					backgroundLayers[i].parallax(pDeltaX);
					backgroundLayers[i].tileBackgrounds();
					cloudLayer[i].parallax(pDeltaX);
					cloudLayer[i].tileBackgrounds();
					if(i == 3) cloudLayer[i].starMask.x = player.x;
					if(i < 3)
					{
						backgroundTrim[i].x = backgroundLayers[i].x;
						backgroundTrim[i].y = backgroundLayers[i].y;
						backgroundTrim[i].tileBackgrounds();
						sunbeams[i].x = player.x;
					}
				}
			}
			else
			{
				backgroundLayers[3].parallax(player.deltaX);
				backgroundLayers[3].tileBackgrounds();
				cloudLayer[3].parallax(player.deltaX);
				cloudLayer[3].tileBackgrounds();
				cloudLayer[3].starMask.x = player.x;
			}
			
			starfield.x = player.x;
			starfield.y = player.y;
			wake();
		}
		
		private function wake()
		{
			if (player.y > 200 && player.y < 370 && Math.abs(player.speedX) > 0.3 && player.health > 0)
			{
				var temp:Wake = new Wake(420 - ((player.y - 200)/3) - 3*Math.abs(player.speedX), 
										 (player.speedX > 0) ? (player.x - 5) : (player.x + 5));
				if(player.speedX < 0)
				{
					temp.scaleX = -1;
				}
				temp.gotoAndPlay(Math.ceil(Math.random()*10));
				wakes.push(temp);
				addChild(temp);
			}
			for(var i:int = wakes.length - 1; i >= 0; --i)
			{
				wakes[i].y++;
				if(wakes[i].y > 380)
				{
					removeChild(wakes[i]);
					wakes.splice(i, 1);
				}
			}
		}

	}
	
}
