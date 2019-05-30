package  GameObjects.Enemies{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import GameObjects.Enemies.Nemesis;
	import ReferenceObjects.AnimationSymbols.DroneWindows;
	import flash.geom.Point;
	import GameObjects.Players.PlaneGeneric;
	import ReferenceObjects.LinkedList;
	import ReferenceObjects.LinkedListNode;
	import flash.events.Event;
	import flash.display.Sprite;
	import collision.CollisionHandler;
	import ReferenceObjects.AnimationSymbols.BallSplash;
	import flash.display.DisplayObject;
	import ReferenceObjects.Vertex;
	import Sounds.SoundHandler;

	
	public class ChainNemesis extends Nemesis {
		private var windows:DroneWindows;
		private var ball:ChainDrone;
		
		private var destination:Point = new Point(200, -200);
		private const DESTINATION_RANGE:uint = 200;
		private const IDLE_THRESH:uint = 300;
		private var idleTimer:uint = 0;
		private const FADE_RATE:Number = 0.015;
		private const DRONES_MAX:uint = 15;
		private var numDrones:uint;
		private const DRONE_OFFSET:uint = 50;
		private const DRONE_SPACING_MIN:Number = 20;
		private const DRONE_SPACING_MAX:Number = 40;
		private const PLAYER_OFFSET:int = 50;
		private const DRONE_SPACING:Number = (DRONE_SPACING_MIN + DRONE_SPACING_MAX)/2;
		private var minDist:Number;
		private var maxDist:Number;
		private const CHAIN_SPIN_SPEED:Number = 2;
		private const CHAIN_THRUST_SPEED:Number = 6;
		private var flickerFrames:uint = 5;
		private var ballGravity:Number = 0;

		private var player:PlaneGeneric;
		private var droneContainer:MovieClip;
		private var drones:LinkedList;
		private var collisionHandler:CollisionHandler;
		public var soundHandler:SoundHandler;
		private var redLine:Sprite;
		
		private var fadingOut:Boolean;
		private var fadingIn:Boolean;
		private var spinningChain:Boolean;
		private var extending:Boolean;
		private var thrustingChain:Boolean;
		private var deathFlag:Boolean = false;
		private var hasDied:Boolean = false;
		
		private var hasPoly:Boolean = false;
		private var hitPoly:Vector.<Point>;
		private var hitBox:Shape;


		public function ChainNemesis(_player:PlaneGeneric, _collisionHandler:CollisionHandler, _soundHandler:SoundHandler) {
			player = _player;
			health = 60;
			damage = 30;
			collisionHandler = _collisionHandler;
			soundHandler = _soundHandler;
			redLine = new Sprite();
			
			spinningChain = true;
			thrustingChain = false;
			soundHandler.playSfx(21, new Point(x, y));
			
			windows = new DroneWindows();
			addChild(windows);
			droneContainer = new MovieClip();
			addChild(droneContainer);
			droneContainer.addChild(redLine);
			ball = new ChainDrone(this, true);
			droneContainer.addChild(ball);
			
			drones = new LinkedList();
			
			var newDrone:ChainDrone;
			for(var i:int = 0; i < DRONES_MAX; ++i)
			{
				newDrone = new ChainDrone(this, false);
				newDrone.y = DRONE_OFFSET + (DRONE_SPACING*i);
				drones.push(newDrone);
				collisionHandler.addList(newDrone, 1);
				droneContainer.addChild(newDrone);
			}
			
			numDrones = DRONES_MAX;
			setMinMax();
			ball.y = DRONE_OFFSET + (DRONE_SPACING*DRONES_MAX) + 44;
			collisionHandler.addList(ball, 1);
			
			redLine.graphics.lineStyle(5, 0xFF0000);
		}
		
		override public function AI():void
		{
			++idleTimer;
			if(deathFlag)
			{
				deathLoop();
				return;
			}
			
			//handle fading out and fading in
			if(fadingOut && alpha > 0)
				alpha -= FADE_RATE;
			else if(alpha <= 0)
				fadingOut = false;
				
			if(fadingIn && alpha < 1)
				alpha += FADE_RATE;
			else if(alpha >= 1)
				fadingIn = false;
			
			//handling if it should teleport or start fading
			if(idleTimer == IDLE_THRESH)
			{
				fadingOut = true;
			}
			else if(idleTimer > IDLE_THRESH && fadingOut == false)
			{
				fadingIn = true;
				idleTimer = 0;
				cullDrones();
				if(numDrones < DRONES_MAX) respawnDrone(1);
				setMinMax();
				teleport();
				setupThrustAttack();
			}
			
			//attack and shit

			if(spinningChain) spinChain();
			else if(thrustingChain) thrustChain();
			
			droneAI();
			drawRedLine();
			
		}
		
		public function setMinMax():void
		{
			minDist = 44 + numDrones*DRONE_SPACING_MIN;
			maxDist = 44 + numDrones*DRONE_SPACING_MAX;
		}
		
		public function getFlyAngle( xPoint:Number, yPoint:Number ):Number
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
		
		private function teleport():void
		{
			var circlePos:Number = 2*Math.random();
			var dronesOffset:Number = 15*(DRONES_MAX - numDrones); 
			var teleRadius:Number = (PLAYER_OFFSET + dronesOffset + maxDist);
			x = player.x + (teleRadius*Math.sin(circlePos));
			y = player.y + (teleRadius*Math.cos(circlePos));
			if (y > 200)
			{
				y = 200;
				x = player.x + (teleRadius*((Math.random() < 0.5)? 1:-1));
			}
			else if(y < -800)
			{
				y = -800;
				x = player.x + (teleRadius*((Math.random() < 0.5)? 1:-1));
			}
		}
		
		private function spinChain():void
		{
			droneContainer.rotation += CHAIN_SPIN_SPEED;
			if(ball.y + CHAIN_SPIN_SPEED < (maxDist + minDist)/2) ball.y += CHAIN_SPIN_SPEED;
			if(numDrones == 3 && droneContainer.rotation >= 180 - CHAIN_SPIN_SPEED && droneContainer.rotation <= 180 + CHAIN_SPIN_SPEED)
			{
				deathFlag = true;
			}
		}
		
		private function setupThrustAttack():void
		{
			ball.y = minDist;
			droneContainer.rotation = 180 + getFlyAngle(player.x, player.y);
			extending = true;
			spinningChain = false;
			thrustingChain = true;
		}
		
		private function thrustChain():void
		{
			if(extending)
			{
				ball.y += CHAIN_THRUST_SPEED*alpha;
				if(ball.y + CHAIN_THRUST_SPEED > maxDist) extending = false;
			}
			else
			{
				ball.y -= CHAIN_THRUST_SPEED;
				if(ball.y - CHAIN_THRUST_SPEED < minDist)
				{
					spinningChain = true;
					thrustingChain = false;
					soundHandler.playSfx(21, new Point(x, y));
				}
			}
			
		}
		
		private function drawRedLine():void
		{
			redLine.graphics.clear();
			if((idleTimer % numDrones == 0) && flickerFrames == 0 && numDrones != DRONES_MAX)
			{
				if(numDrones < 4) flickerFrames = 1;
				else flickerFrames = 2;
			}
			else if (flickerFrames > 0)
			{
				--flickerFrames;
			}
			else {
				var distScale:Number = (maxDist - ball.y)/(maxDist - minDist);
				redLine.graphics.lineStyle(10*distScale, getBetweenColorByPercent(distScale, 0xFF0000, 0x300000));
				redLine.graphics.moveTo(0, drones.head.data.y);
				redLine.graphics.lineTo(0, ball.y - 44);
			}
		}
		
		private function getBetweenColorByPercent(value:Number = 0.5 /* 0-1 */, highColor:uint = 0xFFFFFF, lowColor:uint = 0x000000):uint 
		{
			var r:uint = highColor >> 16;
			var g:uint = highColor >> 8 & 0xFF;
			var b:uint = highColor & 0xFF;
		
			r += ((lowColor >> 16) - r) * value;
			g += ((lowColor >> 8 & 0xFF) - g) * value;
			b += ((lowColor & 0xFF) - b) * value;
		
			return (r << 16 | g << 8 | b);
		}
		
		private function droneAI():void
		{
			
			
			//space the drones and check if they are dead, if so remove them properly
			var spacing:Number;
			var thisDrone:LinkedListNode = drones.head;

			
			spacing = (ball.y - 44 - DRONE_OFFSET)/numDrones;
			var iterator:uint = 0;
			while(thisDrone != null)
			{
				thisDrone.data.y = DRONE_OFFSET + spacing*iterator++;
				thisDrone = thisDrone.next;
			}
		}
		
		private function cullDrones(clearAll:Boolean = false):void
		{
			var thisDrone:LinkedListNode = drones.head;
			var nextNode:LinkedListNode;
			var removeFlag:Boolean = false;
			while(thisDrone != null)
			{
				if(thisDrone.data.cullThis || clearAll)
				{
					removeFlag = true;
					collisionHandler.removeList(thisDrone.data, 1);
					thisDrone.data.stop();
					nextNode = thisDrone.next;
					droneContainer.removeChild(thisDrone.data);
					drones.remove(thisDrone);
					--numDrones;
				}
				if(removeFlag) thisDrone = nextNode;
				else thisDrone = thisDrone.next;
				nextNode = null;
				removeFlag = false;
			}
			setMinMax();
		}
		
		private function respawnDrone(numRespawn:uint = 1):void
		{
			var newDrone:ChainDrone;
			if(numDrones < 3) numRespawn = 3-numDrones;
			for(var i = 0; i < numRespawn; ++i)
			{
				newDrone = new ChainDrone(this, false);
				drones.push(newDrone);
				collisionHandler.addList(newDrone, 1);
				droneContainer.addChild(newDrone);
				++numDrones;
			}
		}
		
		private function deathLoop()
		{
			if( currentFrame != 115)
			{
				if(!hasDied)
				{
					droneContainer.rotation = 180;
					alpha = 1;
					redLine.graphics.clear();
					hasDied = true;
					ballGravity = 1;
					idleTimer = 0;
					cullDrones(true);
					collisionHandler.removeList(ball, 1);
				}
	
				ballGravity *= 1.03;
				ball.y -= ballGravity;
				if(ball.y - 44 < 0)
				{
					if(currentFrame < 72) 
					{
						gotoAndPlay(72);
						soundHandler.playSfx(30, new Point(x, y));
					}
					++idleTimer;
				}
				if(idleTimer == 1 || idleTimer == 2) windows.gotoAndPlay(currentFrame + 15);
				else if(idleTimer == 3)
				{
					windows.stop();
					removeChild(windows);
				}

			}
			else
			{
				ballGravity *= 1.03;
				ball.y -= ballGravity;
				if(y + Math.abs(ball.y) > 333)
				{
					var splash:BallSplash = new BallSplash(x, 333);
					parent.addChild(splash);
					health = 0;
				}
			}
		}
		
		override public function getDamage():int
		{
			return damage;
		}
		
		override public function getHit(damage:int):void
		{
			trace("getHit on top-level nemesis does nothing.");
		}
		
		override public function die()
		{
			stop();
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
				hitBox.graphics.moveTo(hitPoly[0].x, hitPoly[0].y);
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
