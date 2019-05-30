package GameObjects.Enemies {
	
	import flash.display.MovieClip;
	import ReferenceObjects.AnimationSymbols.DroneWindows;
	import ReferenceObjects.AnimationSymbols.DroneReload;
	import ReferenceObjects.AnimationSymbols.DroneContainer;
	import GameObjects.Enemies.Drone;
	import GameObjects.Enemies.EnemyHandler;
	import GameObjects.Players.PlaneGeneric;
	import GameObjects.Players.MeleePlane;
	import flash.display.Graphics;
	import flash.events.Event;
	import GameObjects.Projectiles.WeaponHandler;
	import flash.display.Shape;
	import GameObjects.Projectiles.DroneBullet;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import ReferenceObjects.Vertex;
	
	
	public class DroneNemesis extends Nemesis {
		
		private var windows:DroneWindows;
		private var reload:DroneReload;
		private var player:PlaneGeneric;
		private var enemyHandler:EnemyHandler;
		private var weaponHandler:WeaponHandler;
		private var drones:Array;
		private var barriers:Array;
		private var numBarriers:uint = 0;
		private var numDrones:uint = 0;
		private var aliveCounter:uint = 0;
		private var spawnDir:Boolean = false;
		private var nonCol:DroneContainer;
		private var xSpeed:Number;
		private var ySpeed:Number;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;

		
		public function DroneNemesis(_player:PlaneGeneric, _enemyHandler:EnemyHandler, container:DroneContainer, _weaponHandler:WeaponHandler) {
			windows = new DroneWindows();
			reload = new DroneReload();
			drones = new Array(6);
			barriers = new Array(6);
			for(var i:int = 0; i < barriers.length; ++i)
			{
				barriers[i] = new Shape();
				barriers[i].graphics.lineStyle(3, 0x4DFDFC);
				addChild(barriers[i]);
			}
			
			graphics.lineStyle(3, 0x4DFDFC);
			nonCol = container;
			xSpeed = ySpeed = 2;
			
			addChild(windows);
			addChild(reload);
			player = _player;
			enemyHandler = _enemyHandler;
			weaponHandler = _weaponHandler;
			health = 100;
			getHitPoly();
		}
		
		override public function AI ():void
		{
			++aliveCounter;
			
			for(var i:int = 0; i < 6; ++i)
			{
				if(drones[i] == null) continue;
				
				drones[i].AI();
				if(drones[i].angleCounter < 360)
				{
					if(drones[i].orbiting) 
					{
						if(!drones[i].begunDraw)
						{
							nonCol.drawLayers[i].graphics.moveTo(drones[i].x, drones[i].y);
							drones[i].begunDraw = true;
						}
						nonCol.drawLayers[i].graphics.lineTo(drones[i].x, drones[i].y);
					}
					
				}
				else
				{
					if(!drones[i].fullCircle)
					{
						nonCol.drawLayers[i].graphics.clear();
						drones[i].fullCircle = true;
						barriers[i].graphics.drawCircle(0, 0, drones[i].radius);
						++numBarriers;
					}
				}
				
				if(drones[i].shoot)
				{
					weaponHandler.addChild(new DroneBullet(MeleePlane(player), this, (x + drones[i].x), (y + drones[i].y)));
					drones[i].shoot = false;
				}
			}
			
			if(aliveCounter == 300 || aliveCounter == 600)
			{
				deployDrones();
			}
			
			moveTowardsTarget(player.x, player.y);
			
			nonCol.x = x;
			nonCol.y = y;
		}
		
		public function deployDrones()
		{
			reload.gotoAndPlay(2);
			addEventListener(Event.ENTER_FRAME, droneWatch, false, 0, true);
		}
		
		public function killBarrier()
		{
			var foundDrone:Boolean = false;
			for(var i:int = 5; i >= 0; --i)
			{
				if(drones[i] != null && !foundDrone)
				{
					drones[i].die();
					drones[i] = null;
					nonCol.drones[i] = null;
					nonCol.drawLayers[i].graphics.clear();
					barriers[i].graphics.clear();
					--numBarriers;
					--numDrones;
					foundDrone = true;
				}
			}
		}
		
		public function droneWatch(e:Event)
		{
			if(reload.spawnDrone)
			{
				spawnDir = !spawnDir;
				drones[numDrones] = new Drone(numDrones + 1, reload.y + reload.spawnLoc, spawnDir);
				nonCol.drones[numDrones] = drones[numDrones];
				nonCol.addChild(drones[numDrones]);
				reload.clearSpawn();
				++numDrones;
			}
			
			if(reload.currentFrame == 1)
			{
				removeEventListener(Event.ENTER_FRAME, droneWatch);
			}
		}
		
		private function getFlyAngle( xPoint:Number, yPoint:Number ):Number
		{
			var playerX:Number = xPoint;
			var playerY:Number = yPoint;
			var xDistance:Number = playerX - x;
			var yDistance:Number = playerY - y;
			var slope:Number = yDistance/xDistance;
			var angle:Number = 180/Math.PI * Math.atan(slope);
			
			if((slope < 0 && yDistance < 0) || 
			   (slope > 0 && yDistance > 0))
				angle += 90;
			else if((slope < 0 && yDistance > 0) ||
					(slope > 0 && yDistance < 0))
				angle += 270;
			
			return angle; //returns angle in degrees at which the enemy plane needs to be rotated to face the player directly
		}
		
		public function moveTowardsTarget(xTarget:Number, yTarget:Number)
		{
			var angle:Number = getFlyAngle(xTarget, yTarget);
			x += xSpeed*Math.sin(angle*Math.PI/180);
			y -= ySpeed*Math.cos(angle*Math.PI/180);
		}
		
		override public function getHit(damage:int):void
		{
			
			switch (health)
			{
				case 0 :
					break;

				default :
					if (health > damage)
					{
						health -=  damage;
					}
					else
					{
						health = 0;
					}
					break;
			}
			
		}
		
		override public function die()
		{
			while( nonCol.numChildren > 0)
			{
				var temp:Object = nonCol.getChildAt(0);
				if(temp is MovieClip)
					temp.gotoAndStop(1);
				nonCol.removeChildAt(0);
			}
			parent.removeChild(nonCol);
			this.parent.removeChild(this);
			
		}
		
		override public function collide(other:MovieClip):void
		{
			
		}
		override public function isHitPoly():Boolean
		{
			return true;
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
				hitBox.graphics.lineStyle(1, 0x990000);
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
				for(var j:int = 0; j < hitPoly.length; ++j)
				{
					relativePoint = new Point(x + hitPoly[j].x, y + hitPoly[j].y);
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
