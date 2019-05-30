package ReferenceObjects {
	
	import flash.display.MovieClip;
	import ReferenceObjects.Sun;
	import GameObjects.Players.PlaneGeneric;
	import ReferenceObjects.BackgroundLayer;
	
	
	public class Sunbeam extends MovieClip {
		
		
		public function Sunbeam(frameselect:uint, thisMask:BackgroundLayer) 
		{
			gotoAndStop(frameselect);
			cacheAsBitmap = true;
			mask = thisMask;
		}
		
		public function trackPlayer(sun:Sun, player:PlaneGeneric)
		{
			x = sun.x;
			if(player.y > 0)
			{
				y = 300 + (player.y / 4)
			}
			else if(player.y <= 0 && player.y > -400)
			{
				y = 300 - 700 * ((player.y) / -400)
			}
			else if(player.y <= -500)
			{
				y = player.y;
			}
		}
		
	}
	
}
