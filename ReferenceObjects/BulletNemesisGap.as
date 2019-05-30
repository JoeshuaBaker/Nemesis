package  ReferenceObjects{
	import flash.display.Shape;
	import Interfaces.Collidable;
	import flash.geom.Point;
	import ReferenceObjects.Vertex;
	import flash.display.MovieClip;
	import GameObjects.Enemies.BulletNemesis;
	
	public class BulletNemesisGap extends MovieClip implements Collidable {
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		public var hitBox:Shape;
		private var parentNemesis:BulletNemesis;

		public function BulletNemesisGap(_parentNemesis:BulletNemesis)
		{
			getHitPoly();
			parentNemesis = _parentNemesis;
		}

		public function collide(other:MovieClip):void
		{
			
		}
		public function isHitPoly():Boolean
		{
			return true;
		}
		public function getHitPoly():Vector.<Point>
		{
			if(!hasPoly)
			{
				hitPoly = new Vector.<Point>();
				hitPoly.push(new Point(-65, 20));
				hitPoly.push(new Point(65, 20));
				hitPoly.push(new Point(65, -20));
				hitPoly.push(new Point(-65, -20));
				hitPoly.sort(Vertex.clockwise);
				hasPoly = true;
				hitBox = new Shape();
				hitBox.graphics.lineStyle(1, 0x00FF00);
				hitBox.graphics.beginFill(0x00FF00, 0.5);
				hitBox.graphics.moveTo(hitPoly[0].x, hitPoly[0].y)
				for(var n:int = 1; n < hitPoly.length; ++n)
				{
					hitBox.graphics.lineTo(hitPoly[n].x, hitPoly[n].y);
				}
				hitBox.graphics.lineTo(hitPoly[0].x, hitPoly[0].y);
				hitBox.graphics.endFill();
				addChild(hitBox);
				hitBox.visible = false;

				return null;
			}
			else
			{
				var relativePoly:Vector.<Point> = new Vector.<Point>();
				var relativePoint:Point;
				
				var rotation360:Number;
				if(parentNemesis.rotation < 0)
					rotation360 = 180 + (180 - Math.abs(parentNemesis.rotation));
				else rotation360 = parentNemesis.rotation;
				rotation360 = (rotation360 * Math.PI/180)*-1;
				
				for(var j:int = 0; j < hitPoly.length; ++j)
				{
					relativePoint = new Point(parentNemesis.x + (hitPoly[j].y*Math.sin(rotation360) - hitPoly[j].x*Math.cos(rotation360)),
											  parentNemesis.y + (hitPoly[j].y*Math.cos(rotation360) + hitPoly[j].x*Math.sin(rotation360)));
					relativePoly.push(relativePoint);
				}
				return relativePoly;
			}
		}
		public function isHitCircle():Boolean
		{
			return false;
		}
		public function getHitCircle():Vector.<Number>
		{
			return null;
		}
		public function toggleHitbox():void
		{
			hitBox.visible = !hitBox.visible;
		}
		
		public function getHitbox():Shape
		{
			return hitBox;
		}

	}
	
}
