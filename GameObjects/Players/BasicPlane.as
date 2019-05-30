package GameObjects.Players {
	
	import flash.events.Event;
	import Interfaces.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;
	import flash.display.MovieClip;

	
	public class BasicPlane extends PlaneGeneric
	{
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Vector.<Point>>;
		private var hitBox:Shape;
		
		public function BasicPlane() {
			health = 30;
			getHitPoly();
			damage = 24;
			bulletCooldown = 7;
		}
		
		override public function specialMove()
		{
			if(specialCooldown == 0)
			{
				addEventListener(Event.ENTER_FRAME, superTurn);
				specialCooldown = 8;
			}
		}
		
		public function superTurn(e:Event)
		{
			switch(specialCooldown)
			{
				case 1:
				removeEventListener(Event.ENTER_FRAME, superTurn);
				specialCooldown--;
				break;
				
				case 8:
				case 7:
				case 6:
				case 5:
				for(var i:int = 0; i < 5; i++)
					rotateRight(true);
				
				default:
				specialCooldown--;
				break;
			}
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
				
				hitPoly[0].push(new Point(-10, 0), new Point(0, -7), new Point(10, 0), new Point(0, 7));
				hitPoly[1].push(new Point(-10, 0), new Point(1, -7), new Point(10, 2), new Point(-1, 7));
				hitPoly[2].push(new Point(2, -7), new Point(9, 4), new Point(-3, 6), new Point(-9, -2));
				hitPoly[3].push(new Point(-8, -4), new Point(4, -7), new Point(7, 6), new Point(-4, 5));
				hitPoly[4].push(new Point(-7, -4), new Point(-4.5, 4.5), new Point(6, 6), new Point(5.5, -6.5));
				hitPoly[5].push(new Point(-6, -5), new Point(6, -6), new Point(5, 6), new Point(-4.5, 4.5));
				hitPoly[6].push(new Point(-5, -4.5), new Point(6.5, -5.5), new Point(3.5, 4.5), new Point(-5, 4));
				hitPoly[7].push(new Point(-4, -5), new Point(7, -5), new Point(3, 4), new Point(-6, 3));
				hitPoly[8].push(new Point(-3, -5), new Point(7, -4), new Point(2, 4), new Point(-6.5, 1.5));
				hitPoly[9].push(new Point(-7, 0), new Point(-1, -4), new Point(7, -1), new Point(-1, 3));
				hitPoly[10].push(new Point(-7, -3), new Point(7, -1), new Point(4, 2), new Point(-7, 1));
				hitPoly[11].push(new Point(-7, -2), new Point(1, -3), new Point(7, 1), new Point(-1, 4));
				hitPoly[12].push(new Point(-6.5, -3), new Point(2, -4), new Point(7, 4), new Point(-3, 5));
				hitPoly[13].push(new Point(-4, 5), new Point(-5.5, -3.5), new Point(3.5, -3.5), new Point(7, 5));
				hitPoly[14].push(new Point(-5, -4), new Point(3.5, -4.5), new Point(6.5, 5.5), new Point(-4.5, 4.5));
				hitPoly[15].push(new Point(-4.5, -4.5), new Point(5, -6), new Point(6, 6), new Point(-6, 5));
				hitPoly[16].push(new Point(-7, 4), new Point(-4.5, -4.5), new Point(6, -6), new Point(5.5, 6.5));
				hitPoly[17].push(new Point(-8, 3), new Point(-4, -5), new Point(7, -6), new Point(4, 7));
				hitPoly[18].push(new Point(-9, 0), new Point(-2, -6), new Point(9, -5), new Point(2, 7));
				hitPoly[19].push(new Point(1, 7), new Point(-10, -1), new Point(0.5, -7), new Point(10, -2));
				hitPoly[20].push(new Point(-10, 0), new Point(0, -7), new Point(10, 0), new Point(0, 7));
				hitPoly[21].push(new Point(-1, 7), new Point(-10, -3), new Point(1, -7), new Point(10, -2));
				hitPoly[22].push(new Point(-3, 7), new Point(-9, -5), new Point(2, -6), new Point(9, 1));
				hitPoly[23].push(new Point(-4, 7), new Point(-7, -6), new Point(3, -5), new Point(8, 3));
				hitPoly[24].push(new Point(-5, 6), new Point(-6, -6), new Point(4, -5), new Point(7, 3));
				hitPoly[25].push(new Point(-6, 6), new Point(-5, -6), new Point(4.5, -4.5), new Point(6, 4));
				hitPoly[26].push(new Point(-3, -5), new Point(5, -4), new Point(5, 4), new Point(-6.5, 5.5));
				hitPoly[27].push(new Point(-7, 5), new Point(-3, -4), new Point(5.5, -3.5), new Point(4, 5));
				hitPoly[28].push(new Point(-7, 3), new Point(-2, -4), new Point(6, -3), new Point(3, 5));
				hitPoly[29].push(new Point(-7, 1), new Point(-1, -3), new Point(7, -2), new Point(0, 4));
				hitPoly[30].push(new Point(-7, 0), new Point(-1, -2), new Point(7, 0), new Point(-1, 2));
				hitPoly[31].push(new Point(-7, -1), new Point(0, -4), new Point(7, 0), new Point(0, 3));
				hitPoly[32].push(new Point(-7, -4), new Point(2, -5), new Point(7, 1), new Point(-2, 4));
				hitPoly[33].push(new Point(-7, -5), new Point(4, -5), new Point(6, 3), new Point(-4, 3));
				hitPoly[34].push(new Point(-6.5, -5.5), new Point(4, -5), new Point(5, 4), new Point(-4, 4));
				hitPoly[35].push(new Point(-6, -6), new Point(6, -5), new Point(4.5, 4.5), new Point(-5, 6));
				hitPoly[36].push(new Point(-5.5, -6.5), new Point(7, -4), new Point(4.5, 4.5), new Point(-6, 6));
				hitPoly[37].push(new Point(-4, -7), new Point(8, -4), new Point(4, 5), new Point(-7, 6));
				hitPoly[38].push(new Point(-2, -7), new Point(9, -2), new Point(2, 6), new Point(-9, 5));
				hitPoly[39].push(new Point(-1, -7), new Point(10, 0), new Point(0, 7), new Point(-10, 2));
				for each (var vector in hitPoly)
					vector.sort(Vertex.clockwise);
				
				hasPoly = true;
				hitBox = new Shape();
				addEventListener(Event.ENTER_FRAME, hitboxManager, false, 0, true);
				hitBox.visible = false;
				addChild(hitBox);
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
