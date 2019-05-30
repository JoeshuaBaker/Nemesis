package GameObjects.Players {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.Shape;
	import ReferenceObjects.Vertex;
	import ReferenceObjects.AnimationSymbols.Spark;
	import GameObjects.Projectiles.Sawblade;
	import GameObjects.Projectiles.Projectile;
	import Interfaces.DealsDamage;
	import GameObjects.Enemies.SmallBoat;
	import GameObjects.Enemies.Battleship;
	import GameObjects.Enemies.ChainDrone;
	
	
	public class SawPlane extends PlaneGeneric {
		
		public var sawblade1:Sawblade;
		public var sawblade2:Sawblade;
		private var lockout:Boolean = false;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Vector.<Point>>;
		private var hitBox:Shape;
		
		public function SawPlane() {
			damage = 2;
			getHitPoly();
			bulletCooldown = 0;
			health = 30;
			sawblade1 = new Sawblade(this, true);
			sawblade2 = new Sawblade(this, false);
			addChild(sawblade1);
			addChild(sawblade2);
		}
		
		override public function collide(other:MovieClip):void
		{
			//collision for player planes -- overloaded in enemyplane
			
			if(other is ChainDrone)
			{
				var pos:Point = (other as ChainDrone).getGlobalPos();
				if((other as ChainDrone).isBall && Math.abs(pos.x - x) <= 50 && Math.abs(pos.y - y) <= 50)
				{
					getHit(30);
				}
				else if(!(other as ChainDrone).isBall &&  Math.abs(pos.x - x) <= 20 && Math.abs(pos.y - y) <= 20 )
				{
					getHit(1);
				}
			}
			else if(other is Battleship)
			{
				if(Math.abs(other.x - x) <= 91 && Math.abs(other.y - y) <= 25)
				{
					getHit(((other as DealsDamage).getDamage()/4));
				}
			}
			
			else if(Math.abs(other.x - x) <= 20 && Math.abs(other.y - y) <= 20)
			{
				getHit(((other as DealsDamage).getDamage()/4));
			}
		}
		
		private function sqr(x:Number):Number { return x * x }
		private function dist2(v:Point, w:Point):Number { return sqr(v.x - w.x) + sqr(v.y - w.y) }
		
		override public function specialMove()
		{
			//ha
		}
		
		public function shootSawblade(special:Boolean):Boolean
		{
			regenTimer = 0;
			var returnValue:Boolean;
			if(special)
			{
				returnValue = sawblade2.isHome;
				sawblade2.flyTo(2);
			}
			else
			{
				returnValue = sawblade1.isHome;
				sawblade1.flyTo(1);
			}
			return returnValue;
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
				
				hitPoly[0].push(new Point(-7, 0), new Point(0, -8), new Point(7, 0), new Point(0, 8));
				hitPoly[1].push(new Point(-7, -1), new Point(1, -8), new Point(7, 2), new Point(-1, 8));
				hitPoly[2].push(new Point(-7, -2), new Point(4, -8), new Point(7, 4), new Point(-3, 7));
				hitPoly[3].push(new Point(-7, -3), new Point(5, -8), new Point(6, 4), new Point(-4, 7));
				hitPoly[4].push(new Point(-6, -3), new Point(6, -7), new Point(4, 6), new Point(-5, 7));
				hitPoly[5].push(new Point(-6, -3), new Point(7, -7), new Point(4, 5), new Point(-6, 6));
				hitPoly[6].push(new Point(-6, -3), new Point(7, -6), new Point(1, 6), new Point(-6, 5));
				hitPoly[7].push(new Point(-5, -5), new Point(8, -5), new Point(0, 5), new Point(-7, 3));
				hitPoly[8].push(new Point(-4, -5), new Point(8, -4), new Point(1, 5), new Point(-8, 2));
				hitPoly[9].push(new Point(-4, -4), new Point(8, -1), new Point(1, 4), new Point(-9, 1));
				hitPoly[10].push(new Point(-9, -1), new Point(0, -3), new Point(8, 0), new Point(-2, 3));
				hitPoly[11].push(new Point(-9, -1), new Point(-1, -4), new Point(8, 1), new Point(-4, 4));
				hitPoly[12].push(new Point(-9, -4), new Point(1, -5), new Point(8, 4), new Point(-4, 5));
				hitPoly[13].push(new Point(-7, -4), new Point(2, -4), new Point(8, 6), new Point(-5, 4));
				hitPoly[14].push(new Point(-6, 3), new Point(-6, -5), new Point(2, -5), new Point(7, 6));
				hitPoly[15].push(new Point(-6, -6), new Point(2, -7), new Point(7, 7), new Point(-7, 2));
				hitPoly[16].push(new Point(-5, -7), new Point(4, -6), new Point(6, 7), new Point(-6, 3));
				hitPoly[17].push(new Point(-7, 3), new Point(-4, -7), new Point(6, -4), new Point(5, 8));
				hitPoly[18].push(new Point(-7, 1), new Point(-3, -7), new Point(7, -5), new Point(4, 8));
				hitPoly[19].push(new Point(-7, 0), new Point(-1, -8), new Point(7, -4), new Point(1, 8));
				hitPoly[20].push(new Point(-7, 0), new Point(0, -8), new Point(7, 0), new Point(0, 8));
				hitPoly[21].push(new Point(-7, -2), new Point(1, -8), new Point(7, 1), new Point(-1, 8));
				hitPoly[22].push(new Point(-7, -4), new Point(3, -7), new Point(7, 2), new Point(-4, 8));
				hitPoly[23].push(new Point(-6, -4), new Point(4, -7), new Point(7, 3), new Point(-5, 8));
				hitPoly[24].push(new Point(-6, 7), new Point(-4, -6), new Point(5, -7), new Point(7, 1));
				hitPoly[25].push(new Point(-4, -5), new Point(6, -6), new Point(5, 4), new Point(-7, 7));
				hitPoly[26].push(new Point(-1, -6), new Point(6, -5), new Point(6, 3), new Point(-7, 6));
				hitPoly[27].push(new Point(-8, 6), new Point(-2, -4), new Point(7, -4), new Point(6, 3));
				hitPoly[28].push(new Point(-8, 4), new Point(-1, -5), new Point(9, -3), new Point(4, 5));
				hitPoly[29].push(new Point(-8, 1), new Point(-1, -4), new Point(9, -2), new Point(4, 4));
				hitPoly[30].push(new Point(-8, 0), new Point(0, -3), new Point(9, -1), new Point(3, 3));
				hitPoly[31].push(new Point(-8, -2), new Point(4, -4), new Point(8, 2), new Point(-1, 4));
				hitPoly[32].push(new Point(-8, -3), new Point(4, -5), new Point(8, 3), new Point(-1, 5));
				hitPoly[33].push(new Point(-8, -6), new Point(5, -5), new Point(6, 3), new Point(-2, 4));
				hitPoly[34].push(new Point(-7, -6), new Point(6, -3), new Point(6, 5), new Point(-2, 5));
				hitPoly[35].push(new Point(-7, -7), new Point(5, -4), new Point(6, 6), new Point(-4, 5));
				hitPoly[36].push(new Point(-6, -7), new Point(6, -3), new Point(5, 7), new Point(-4, 6));
				hitPoly[37].push(new Point(-5, -8), new Point(7, -3), new Point(3, 7), new Point(-6, 4));
				hitPoly[38].push(new Point(-4, -8), new Point(7, -2), new Point(3, 7), new Point(-7, 5));
				hitPoly[39].push(new Point(-7, 2), new Point(-1, -8), new Point(7, -1), new Point(1, 8));
				for each (var vector in hitPoly)
					vector.sort(Vertex.clockwise);
				
				hasPoly = true;
				hitBox = new Shape();
				addChild(hitBox);
				hitBox.visible = false;
				addEventListener(Event.ENTER_FRAME, hitboxManager, false, 0, true);
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
			sawblade1.toggleHitbox();
			sawblade2.toggleHitbox();
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
