package ReferenceObjects.AnimationSymbols {
	
	import flash.display.MovieClip;
	
	
	public class DroneReload extends MovieClip {
		
		public var spawnDrone:Boolean = false;
		public var spawnLoc:Number;
		
		public function DroneReload() {
			y = 27;
		}
		
		public function clearSpawn()
		{
			spawnDrone = false;
			spawnLoc = 0.0;
		}
	}
	
}
