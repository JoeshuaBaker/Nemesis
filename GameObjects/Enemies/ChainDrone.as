package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import Interfaces.Collidable;
	import GameObjects.Enemies.ChainNemesis;
	import GameObjects.Players.SawPlane;
	import GameObjects.Players.MeleePlane;
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.events.Event;
	import ReferenceObjects.AnimationSymbols.DroneDeath;
	
	public class ChainDrone extends MovieClip implements Collidable{
		
		public var cullThis:Boolean = false;
		public var isBall:Boolean;
		
		private var parentNemesis:ChainNemesis;
		private var health:int = 3;
		
		private const hitCircle:Vector.<Number> = new Vector.<Number>(3, true);
		private var hitCircleShape:Shape;
		private var hasHitCircle:Boolean = false;

		
		public function ChainDrone(_parentNemesis:ChainNemesis, _isBall:Boolean) {
			parentNemesis = _parentNemesis;
			isBall = _isBall;
			if(isBall)
			{
				gotoAndPlay(61);
			}
		}
		
		public function getGlobalPos():Point
		{
			var rotation360:Number;
			if(parent.rotation < 0)
				rotation360 = 180 + (180 - Math.abs(parent.rotation));
			else rotation360 = parent.rotation;
			rotation360 = (rotation360 * Math.PI/180)*-1;
			
			return new Point(parentNemesis.x + (y*Math.sin(rotation360) - x*Math.cos(rotation360)), 
							 parentNemesis.y + (y*Math.cos(rotation360) + x*Math.sin(rotation360)));
		}
		
		public function collide(other:MovieClip):void
		{
			if((other is SawPlane || other is MeleePlane) && !isBall)
			{
				health--;
				if(health == 0)
				{
					var globalPos:Point = getGlobalPos();
					parentNemesis.soundHandler.playSfx(31, globalPos, 0.25);
					parentNemesis.parent.addChild(new DroneDeath(globalPos.x, globalPos.y));
					cullThis = true;
					visible = false;
				}
			}
		}
		public function isHitPoly():Boolean
		{
			return false;
		}
		public function getHitPoly():Vector.<Point>
		{
			return null;
		}
		public function isHitCircle():Boolean
		{
			return !cullThis;
		}
		public function getHitCircle():Vector.<Number>
		{
			if(!hasHitCircle)
			{
				hitCircle[0] = 0;
				hitCircle[1] = 0;
				if(isBall)
				{
					hitCircle[2] = 44;
				}
				else
				{
					hitCircle[2] = 8.5;
				}
				
				hasHitCircle = true;
				hitCircleShape = new Shape();
				hitCircleShape.graphics.lineStyle(1, 0x4DFDFC);
				hitCircleShape.graphics.beginFill(0x4DFDFC, 0.5);
				hitCircleShape.graphics.drawCircle(hitCircle[0], hitCircle[1], hitCircle[2]);
				hitCircleShape.visible = false;
				addChild(hitCircleShape);
				return getHitCircle();
			}
			else
			{
				var rotation360:Number;
				if(parent.rotation < 0)
					rotation360 = 180 + (180 - Math.abs(parent.rotation));
				else rotation360 = parent.rotation;
				rotation360 = (rotation360 * Math.PI/180)*-1;
				
				
				var relativeCircle:Vector.<Number> = new Vector.<Number>(3, true);
				relativeCircle[0] = parentNemesis.x + (y*Math.sin(rotation360) - x*Math.cos(rotation360));
				relativeCircle[1] = parentNemesis.y + (y*Math.cos(rotation360) + x*Math.sin(rotation360));
				relativeCircle[2] = hitCircle[2];
				return relativeCircle;
			}
		}
		public function toggleHitbox():void
		{
			hitCircleShape.visible = !hitCircleShape.visible;
		}
		
		public function getHitbox():Shape
		{
			return hitCircleShape;
		}
	}
	
}
