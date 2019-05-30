package  ReferenceObjects {

	import flash.display.MovieClip;
	import GameObjects.Players.PlaneGeneric;

	public class Wave 
	{
		
		private var xOff:Number; //should be greater than |640|
		private var yOff:Number; //should be greater than |360|
		public var spawn:uint; //how many times should the wave spawn before it gets removed
		public var waveBuffer:uint;
		public var numPlanes:uint;
		public var numSmallBoats:uint;
		public var numBattleships:uint;
		public var randomVariation:uint;
		public var numNemesises:uint;

		public function Wave( spawnMode:Number = 0, numberOfPlanes:uint = 0, numberOfSmallBoats:uint = 0, numberOfBattleships:uint = 0,
							  numberOfNemesises:uint = 0, _waveBuffer:uint = 0, xOffset:Number = 700 ,yOffset:Number = 0, randomVar:uint = 50) 
		{
			xOff = xOffset;
			yOff = yOffset;
			spawn = spawnMode;
			numPlanes = numberOfPlanes;
			numSmallBoats = numberOfSmallBoats;
			numBattleships = numberOfBattleships;
			numNemesises = numberOfNemesises;
			waveBuffer = _waveBuffer;
			randomVariation = randomVar;
			
		}
		
		//getters and setters
		public function getxOff():Number
		{
			return xOff;
		}
		public function setxOff(newxOff:Number):void
		{
			xOff = newxOff;
		}
		public function getyOff():Number
		{
			return yOff;
		}
		public function setyOff(newyOff:Number):void
		{
			yOff = newyOff;
		}
		
		public function nullValues():void
		{
			xOff = NaN;
			yOff = NaN;
			spawn = NaN;
			numPlanes = NaN;
			numSmallBoats = NaN;
			numBattleships = NaN;
			numNemesises = NaN;
			randomVariation = NaN;
		}
		
	}
	
}
