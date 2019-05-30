package ReferenceObjects {
	
	import ReferenceObjects.RotateReference;
	import ReferenceObjects.Nose;
	
	
	public class BattleshipCannon extends RotateReference {
		
		
		public function BattleshipCannon() {
			nose = new Nose();
			addChild(nose);
			nose.setY(-22.5);
			nose.setX(x);
			stop();
		}
	}
	
}
