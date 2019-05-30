package GameObjects.Projectiles 
{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;

	
	public class NemesisBeam extends Projectile {
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;

		public function NemesisBeam() {
			stop();
			damage = 30;
			cullThis = false;
			getHitPoly();
		}
		
		override public function getDamage():int
		{
			if(currentFrame >= 70 && currentFrame <= 81)
			{
				return damage;
			}
			else
			{
				return 0;
			}
		}
		
		override public function collide(other:MovieClip):void
		{
			
		}
		override public function isHitPoly():Boolean
		{
			return (currentFrame >= 70 && currentFrame <= 81);
		}
		override public function getHitPoly():Vector.<Point>
		{
			if(!hasPoly)
			{
				hitPoly = new Vector.<Point>();
				var hitPoint:Point;
				var thisObject:DisplayObject;
				for(var i:int = 0; i < numChildren; ++i)
				{
					thisObject = getChildAt(i);
					if(thisObject is Vertex)
					{
						hitPoint = new Point(thisObject.x, thisObject.y);
						hitPoly.push(hitPoint);
					}
				}
				hitPoly.sort(Vertex.clockwise);
				hasPoly = true;
				hitBox = new Shape();
				hitBox.graphics.lineStyle(1, 0x990000, 0.98);
				hitBox.graphics.beginFill(0x990000, 0.5);
				hitBox.graphics.moveTo(hitPoly[0].x, hitPoly[0].y)
				for(var n:int = 1; n < hitPoly.length; ++n)
				{
					hitBox.graphics.lineTo(hitPoly[n].x, hitPoly[n].y);
				}
				hitBox.graphics.lineTo(hitPoly[0].x, hitPoly[0].y);
				hitBox.graphics.endFill();
				hitBox.visible = false;
				addChild(hitBox);
				return getHitPoly();
			}
			else
			{
				var relativePoly:Vector.<Point> = new Vector.<Point>();
				var relativePoint:Point;
				var rotation360:Number;
				
				if(rotation < 0)
					rotation360 = 180 + (180 - Math.abs(rotation));
				else rotation360 = rotation;
				rotation360 = (rotation360 * Math.PI/180)*-1;
				
				for(var j:int = 0; j < hitPoly.length; ++j)
				{
					relativePoint = new Point(x + (hitPoly[j].y*Math.sin(rotation360) - hitPoly[j].x*Math.cos(rotation360)),
											  y + (hitPoly[j].y*Math.cos(rotation360) + hitPoly[j].x*Math.sin(rotation360)));
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
		
		override public function getHitbox():Shape
		{
			return hitBox;
		}

	}
	
}
