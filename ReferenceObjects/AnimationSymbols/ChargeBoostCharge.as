package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class ChargeBoostCharge extends MovieClip {
		
		
		public function ChargeBoostCharge() {
			stop();
		}
		
		public function cancelAnimation()
		{
			gotoAndStop(1);
		}
		
		public function shockwaveCharge()
		{
			gotoAndPlay(29);
		}
	}
	
}
