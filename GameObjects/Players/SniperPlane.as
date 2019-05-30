package GameObjects.Players {
	
	import flash.display.MovieClip;
	import ReferenceObjects.RotateReference;
	import Interfaces.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;
	import flash.display.MovieClip;
	import flash.events.Event;
	import ReferenceObjects.LaserSight;
	
	public class SniperPlane extends PlaneGeneric {
		
		private var laserSight:LaserSight;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Vector.<Point>>;
		private var hitBox:Shape;
		
		public function SniperPlane() {
			bulletCooldown = 30;
			health = 30;
			damage = 24;
			laserSight = new LaserSight();
			removeChild(rotateReference);
			rotateReference = new RotateReference(true);
			addChild(rotateReference);
			rotateReference.addChild(laserSight);
			getHitPoly();
		}
		
		override public function specialMove()
		{
			laserSight.visible = true;
			specialCooldown = 1;
		}
		
		override public function specialCancel()
		{
			specialCooldown = 0;
			laserSight.visible = false;
		}
		
		public function updateReticle(bulletCounter:uint):void
		{
			if(bulletCounter == 0 && laserSight.currentFrame == 14) laserSight.gotoAndPlay(8);
			else if(laserSight.currentFrame == 7) laserSight.gotoAndPlay(1)
		}
		
		override public function isHitPoly():Boolean
		{
			return true;
		}
		override public function getHitPoly():Vector.<Point>
		{
			if(!hasPoly)
			{
				hitPoly = new Vector.<Vector.<Point>>(40);
				
				for(var i:int = 0; i < hitPoly.length; ++i)
				{
					hitPoly[i] = new Vector.<Point>();
				}
				
				hitPoly[0].push(new Point(-6, 4), new Point(0, -8), new Point(6, 4), new Point(0, 8));
				hitPoly[1].push(new Point(-7, 3), new Point(1, -8), new Point(6, 5), new Point(-1, 8));
				hitPoly[2].push(new Point(-7, 2), new Point(2, -8), new Point(5, 5), new Point(-3, 7));
				hitPoly[3].push(new Point(-7, 1), new Point(4, -8), new Point(4, 6), new Point(-4, 6));
				hitPoly[4].push(new Point(-7, 0), new Point(5, -7), new Point(2, 7), new Point(-5, 5));
				hitPoly[5].push(new Point(-7, 0), new Point(7, -7), new Point(0, 7), new Point(-6, 6));
				hitPoly[6].push(new Point(-7, 4), new Point(-7, -1), new Point(7, -6), new Point(-1, 6));
				hitPoly[7].push(new Point(-7, 4), new Point(-6, -2), new Point(8, -5), new Point(-2, 6));
				hitPoly[8].push(new Point(-7, -2), new Point(-5, -2), new Point(8, -3), new Point(-2, 5));
				hitPoly[9].push(new Point(-8, 1), new Point(-4, -2), new Point(8, -2), new Point(-1, 3));
				hitPoly[10].push(new Point(-8, -2), new Point(8, -1), new Point(8, 1), new Point(-6, 2));
				hitPoly[11].push(new Point(-8, -3), new Point(1, -3), new Point(8, 2), new Point(-4, 2));
				hitPoly[12].push(new Point(-7, -5), new Point(2, -3), new Point(8, 3), new Point(-5, 2));
				hitPoly[13].push(new Point(-7, -4), new Point(-2, -6), new Point(8, 5), new Point(-6, 2));
				hitPoly[14].push(new Point(-6, -5), new Point(-1, -6), new Point(7, 6), new Point(-7, 1));
				hitPoly[15].push(new Point(-7, 0), new Point(-6, -6), new Point(0, -7), new Point(7, 7));
				hitPoly[16].push(new Point(-7, 0), new Point(-5, -6), new Point(2, -7), new Point(6, 7));
				hitPoly[17].push(new Point(-7, -1), new Point(-4, -6), new Point(4, -7), new Point(5, 8));
				hitPoly[18].push(new Point(-7, -2), new Point(-3, -7), new Point(6, -6), new Point(2, 8));
				hitPoly[19].push(new Point(-7, -4), new Point(-1, -8), new Point(7, -5), new Point(1, 8));
				hitPoly[20].push(new Point(-7, -5), new Point(0, -8), new Point(7, -5), new Point(0, 8));
				hitPoly[21].push(new Point(-7, -6), new Point(1, -8), new Point(7, -4), new Point(-1, 8));
				hitPoly[22].push(new Point(-6, -6), new Point(3, -7), new Point(7, -2), new Point(-3, 8));
				hitPoly[23].push(new Point(-4, -7), new Point(4, -6), new Point(7, -1), new Point(-5, 8));
				hitPoly[24].push(new Point(-2, -7), new Point(5, -6), new Point(7, 0), new Point(-6, 7));
				hitPoly[25].push(new Point(0, -7), new Point(6, -6), new Point(7, 0), new Point(-7, 7));
				hitPoly[26].push(new Point(1, -6), new Point(6, -5), new Point(7, 1), new Point(-7, 6));
				hitPoly[27].push(new Point(2, -6), new Point(7, -4), new Point(6, 2), new Point(-8, 5));
				hitPoly[28].push(new Point(2, -5), new Point(7, -5), new Point(5, 2), new Point(-8, 3));
				hitPoly[29].push(new Point(-2, -3), new Point(8, -4), new Point(4, 2), new Point(-8, 2));
				hitPoly[30].push(new Point(-8, -1), new Point(8, -2), new Point(4, 2), new Point(-8, 1));
				hitPoly[31].push(new Point(-8, -1), new Point(4, -2), new Point(8, -1), new Point(3, 3));
				hitPoly[32].push(new Point(-8, -3), new Point(5, -2), new Point(8, 2), new Point(2, 5));
				hitPoly[33].push(new Point(-8, -5), new Point(6, -2), new Point(8, 4), new Point(2, 6));
				hitPoly[34].push(new Point(-7, -6), new Point(7, -1), new Point(6, 5), new Point(1, 6));
				hitPoly[35].push(new Point(-7, -7), new Point(7, 0), new Point(6, 6), new Point(0, 7));
				hitPoly[36].push(new Point(-6, -7), new Point(7, 0), new Point(5, 6), new Point(-2, 7));
				hitPoly[37].push(new Point(-5, -8), new Point(7, 1), new Point(3, 6), new Point(-4, 7));
				hitPoly[38].push(new Point(-2, -8), new Point(7, 2), new Point(2, 7), new Point(-6, 6));
				hitPoly[39].push(new Point(-1, -8), new Point(7, 3), new Point(1, 7), new Point(-7, 5));

				for each (var vector in hitPoly)
					vector.sort(Vertex.clockwise);
				
				hasPoly = true;
				hitBox = new Shape();
				addEventListener(Event.ENTER_FRAME, hitboxManager, false, 0, true);
				addChild(hitBox);
				hitBox.visible = false;
				return getHitPoly();
			}
			else
			{
				var relativePoly:Vector.<Point> = new Vector.<Point>();
				var relativePoint:Point;
				var index:uint = currentFrame - 1;
				for(var j:int = 0; j < hitPoly[index].length; ++j)
				{
					relativePoint = new Point(x + hitPoly[index][j].x, y + hitPoly[index][j].y);
					relativePoly.push(relativePoint);
				}
				return relativePoly;
			}
		}
		override public function isHitCircle():Boolean
		{
			return false;
		}
		override public function getHitCircle():Vector.<Number>
		{
			return null;
		}
		override public function toggleHitbox():void
		{
			hitBox.visible = !hitBox.visible;
		}
		
		private function hitboxManager(e:Event)
		{
			var index:uint = currentFrame - 1;
			hitBox.graphics.clear();
			hitBox.graphics.lineStyle(1, 0x990000);
			hitBox.graphics.beginFill(0x990000, 0.5);
			hitBox.graphics.moveTo(hitPoly[index][0].x, hitPoly[index][0].y);
			for(var i:int = 0; i < hitPoly[index].length; ++i)
			{
				hitBox.graphics.lineTo(hitPoly[index][i].x, hitPoly[index][i].y);
			}
			hitBox.graphics.lineTo(hitPoly[index][0].x, hitPoly[index][0].y);
		}
		
		override public function getHitbox():Shape
		{
			return hitBox;
		}


	}
	
}
