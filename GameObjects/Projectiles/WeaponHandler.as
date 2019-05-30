package GameObjects.Projectiles {
	
	import flash.display.MovieClip;
	import ReferenceObjects.RotateReference;
	import ReferenceObjects.Waterline;
	import collision.CollisionHandler;
	import ReferenceObjects.AnimationSymbols.BulletSplash;
	import ReferenceObjects.BattleshipCannon;
	import GameObjects.Players.*;
	import GameObjects.Enemies.*;
	import collision.CollisionList;
	import ReferenceObjects.SettingsContainer;
	import ReferenceObjects.LinkedList;
	import ReferenceObjects.LinkedListNode;
	import ReferenceObjects.AnimationSymbols.LaserSplash;
	import Sounds.SoundHandler;
	import flash.geom.Point;
	
	public class WeaponHandler extends MovieClip {
		
		var bulletArray:LinkedList = new LinkedList();
		var sniperBulletArray:LinkedList = new LinkedList();
		var missileArray:LinkedList = new LinkedList();
		var explosionArray:LinkedList = new LinkedList();
		var beamArray:LinkedList = new LinkedList();
		var allProjectiles:Array = new Array(bulletArray, sniperBulletArray, missileArray, explosionArray, beamArray);
		var bullet:Bullet;
		var sniperBullet:SniperBullet;
		var missile:Missile;
		var missileVarRadius:uint = 50; //in pixels
		
		var shotgunBullets:int = 8;
		var shotgunArc:uint = 16;
		var spreadLimit:int = 2;
		
		public var waterline:Waterline;
		
		private var soundHandler:SoundHandler;
		var collisionHandler:CollisionHandler;
		var player:PlaneGeneric;
		var settings:SettingsContainer;
		
		//animation symbols
		var bulletSplash:BulletSplash;

		public function WeaponHandler(colHandler:CollisionHandler, playerRef:PlaneGeneric, _settings:SettingsContainer, _soundHandler:SoundHandler)
		{
			collisionHandler = colHandler;
			soundHandler = _soundHandler;
			player = playerRef;
			waterline = new Waterline();
			settings = _settings;
			addChild(waterline);
		}
		
		public function shoot( shooter:MovieClip, rotateReference:RotateReference ):void
		{
			if (shooter is BasicPlane)
			{
				var playerBullet:Bullet = shootBasicBullet(shooter.x, shooter.y, rotateReference, 0);
				collisionHandler.addList(playerBullet, 0);
				playerBullet.soundHandler = soundHandler;
				soundHandler.playSfx(5);
			}
			else if(shooter is EnemyPlane)
			{
				var temp:Bullet = shootBasicBullet(shooter.x, shooter.y, rotateReference, 0);
				temp.isEnemyBullet = true;
				collisionHandler.addList( temp, 1 );
				soundHandler.playSfx(11, new Point(shooter.x, shooter.y));
			}
			else if (shooter is SniperPlane)
			{
				collisionHandler.addList(shootSniperBullet(shooter.x, shooter.y, rotateReference), 0);
				soundHandler.playSfx(7);
			}
			else if (shooter is Battleship)
			{
				var temp2:Bullet = shootBasicBullet(shooter.x, shooter.y, rotateReference, 1);
				temp2.isEnemyBullet = true;
				collisionHandler.addList(temp2, 1);
				soundHandler.playSfx(18, new Point(shooter.x, shooter.y), 0.75);
			}
			else
			{
				trace("WeaponHandler failed to shoot.");
			}
		}
		
		private function shootBasicBullet( shooterX:Number, shooterY:Number, rotateReference:RotateReference, bulletCode:uint = 0 ):Bullet
		{
			bullet = new Bullet(rotateReference.trigDistanceX(), rotateReference.trigDistanceY(), bulletCode, collisionHandler);
			if(rotateReference is BattleshipCannon)
			{
				bullet.x = shooterX + rotateReference.x + 30*rotateReference.trigDistanceX();
				bullet.y = shooterY + rotateReference.y - 30*rotateReference.trigDistanceY();
				bullet.gotoAndPlay(13);
				bullet.rotation = rotateReference.rotation;
			}
			else
			{
				bullet.x = rotateReference.nose.x + shooterX;
				bullet.y = rotateReference.nose.y + shooterY + 9;
			}
			bulletArray.push(bullet);
			addChildAt (bullet, 0);
			if(settings.debugMenu.hitboxes.pressed) bullet.toggleHitbox();
			return bullet;
		}
		
		public function shootShotgun( shooter:PlaneGeneric ):void
		{
			var temp:Bullet;
			var spread:Array = new Array(shotgunBullets);
			var startingRotation:int = shotgunArc*-1;
			var spreadChecker:Boolean = true;
			

			for(var i:int = shotgunBullets - 1; i >= 0; --i)
			{
				temp = shootBasicBullet(shooter.x, shooter.y, shooter.rotateReference, 2);
				temp.rotation = shooter.rotateReference.rotation;
				collisionHandler.addList(temp, 0);
				temp.gotoAndPlay(25);
				temp.isShotgunBullet = true;
				if(settings.debugMenu.hitboxes.pressed) temp.toggleHitbox();
				temp.rotation += startingRotation;
				startingRotation += ((shotgunArc*2)/shotgunBullets);

				/*
				while(spreadChecker)
				{
					spreadChecker = false;
					temp.rotation = startingRotation;
					temp.rotation += (Math.random() < 0.5)? shotgunArc*Math.random() : shotgunArc*Math.random()*-1;
					for(var j:int = spread.length - 1; j>=0; --j)
					{
						if(temp.rotation > spread[j] - spreadLimit && temp.rotation < spread[j] + spreadLimit)
						{
							spreadChecker = true;
						}
					}
				}
				spread.push(temp.rotation);
				*/
				temp.speedX = Math.sin((temp.rotation * Math.PI/180));
				temp.speedY = Math.cos((temp.rotation * Math.PI/180));
			}
			soundHandler.playSfx(8);
		}
		
		private function shootSniperBullet( planeX:Number, planeY:Number, rotateReference:RotateReference ):SniperBullet
		{
			sniperBullet = new SniperBullet(rotateReference.rotation, rotateReference.nose.x + planeX, rotateReference.nose.y + planeY + 9);
			sniperBulletArray.push(sniperBullet);
			addChildAt( sniperBullet, 0 );
			if(settings.debugMenu.hitboxes.pressed) sniperBullet.toggleHitbox();

			return sniperBullet;
		}
		
		public function shootMissile( missileX:Number, missileY:Number, targetX:Number, targetY:Number):Missile
		{
			if( Math.random() > 0.5)
			{
				targetX += Math.random()*missileVarRadius;
			}
			else
			{
				targetX -= Math.random()*missileVarRadius;
			}
			if( Math.random() > 0.5)
			{
				targetY += Math.random()*missileVarRadius;
			}
			else
			{
				targetY -= Math.random()*missileVarRadius;
			}
			missile = new Missile(targetX, targetY);
			missile.x = missileX;
			missile.y = missileY;
			missileArray.push(missile);
			addChild(missile);
			if(settings.debugMenu.hitboxes.pressed) missile.toggleHitbox();

			return missile;
		}
		
		public function createExplosion(xpos:Number, ypos:Number, isShockwave:Boolean = false)
		{
			var explosion:SlugExplosion = new SlugExplosion(collisionHandler, isShockwave);
			explosion.x = xpos;
			explosion.y = ypos;
			addChild(explosion);
			if(isShockwave)
			{
				collisionHandler.addList(explosion, 0);
			}
			else
			{
				collisionHandler.addList( explosion, 1 );
			}
			explosionArray.push(explosion);
			if(settings.debugMenu.hitboxes.pressed) explosion.toggleHitbox();

		}
		
		public function drawLasers( shooter:BulletNemesis )
		{
			//var slope:Number = shooter.trigDistanceY()/shooter.trigDistanceX();
			if(shooter.currentFrame == 171)
			{
				var shooterX:Number = shooter.x;
				var shooterY:Number = shooter.y;
				var shooterTrigX:Number = shooter.trigDistanceX();
				var shooterTrigY:Number = shooter.trigDistanceY();
				var shooterRotation:Number = shooter.rotation;
				var hasDrawnSplash:Boolean = false;
				for(var i:int = shooter.lasers.length - 1; i >= 0; --i)
				{
					var thisBeam:NemesisBeam = shooter.lasers[i];
					if(settings.debugMenu.hitboxes.pressed) thisBeam.toggleHitbox();
					if(i % 2 == 0)
					{
						thisBeam.rotation = shooterRotation + 90;
						thisBeam.x = shooterX + 449*(i/2)*shooterTrigX;
						thisBeam.y = shooterY - 449*(i/2)*shooterTrigY;
						thisBeam.gotoAndPlay(1);
						beamArray.push(thisBeam);
						addChildAt(thisBeam, 0);
						collisionHandler.addList(thisBeam, 1);
					}
					else
					{
						thisBeam.rotation = shooterRotation - 90;
						thisBeam.x = shooterX - 449*Math.floor(i/2)*shooterTrigX;
						thisBeam.y = shooterY + 449*Math.floor(i/2)*shooterTrigY;
						thisBeam.gotoAndPlay(1);
						beamArray.push(thisBeam);
						addChildAt(thisBeam, 0);
						collisionHandler.addList(thisBeam, 1);

					}
					
					if(thisBeam.y > 350 && !hasDrawnSplash)
					{
						hasDrawnSplash = true;
						
						var rotation360:Number;
						if(shooter.rotation > 0 && shooter.rotation <= 180)
						{
							rotation360 = shooter.rotation + 90;
						}
						else
						{
							rotation360 = 360 - Math.abs(shooter.rotation) - 90;
						}
						rotation360 *= (Math.PI/180);
						var yDist:Number = 350 - shooter.y;
						var xOffset:Number = yDist*Math.tan(rotation360);
						var laserSplash:LaserSplash = new LaserSplash();
						laserSplash.y = 350;
						laserSplash.x = shooter.x - xOffset;
						addChild(laserSplash);
						
					}
				}
			}
			
		}
		
		public function cullProjectiles ( collisionHandler:CollisionHandler, planeX:Number, planeY:Number ):void
		{
			var currentNode:LinkedListNode;
			var currentData:*;
			var nextNode:LinkedListNode;
			if(sniperBullet != null && sniperBullet.currentFrame == 2)
			{
				collisionHandler.removeList(sniperBullet, 0);
			}
			for(var i:int = allProjectiles.length - 1; i >= 0; i--)
			{
				currentNode = allProjectiles[i].head;
				while(currentNode != null)
				{
					currentData = currentNode.data;
					if(currentData.cullThis ||
					   Math.abs(currentData.x - planeX) > 2000 ||
					   Math.abs(currentData.y - planeY) > 2000 ||
					   (currentData.y > 351 && !(currentData is SlugExplosion)))
					{
						
						if(currentData is Missile && !(currentData.y > 351))
						{
							createExplosion(currentData.x, currentData.y);
							soundHandler.playSfx(22, new Point(currentData.x, currentData.y));
						}
						else if(currentData is SlugExplosion)
						{
							currentData.inactive();
						}
						
						if(currentData.y > 351 && !(currentData is SniperBullet) && !(currentData is SlugExplosion))
						{
							bulletSplash = new BulletSplash()
							bulletSplash.x = currentData.x;
							bulletSplash.y = currentData.y;
							addChild( bulletSplash );								
						}
						
						collisionHandler.removeList(currentData, 0);
						collisionHandler.removeList(currentData, 1);
						currentData.stop();
						removeChild( currentData );
						nextNode = currentNode.next;
						allProjectiles[i].remove( currentNode );
					}
					if(nextNode != null) currentNode = nextNode;
					else currentNode = currentNode.next;
					nextNode = null;
				}
			}
		}
		
		public function moveBullets ()
		{
			var currentNode:LinkedListNode = bulletArray.head;
			while(currentNode != null)
			{
				currentNode.data.moveThis();
				currentNode = currentNode.next;
			}
		}
		
		public function clearMissiles():void
		{
			var currentNode:LinkedListNode = missileArray.head;
			while(currentNode != null)
			{
				(currentNode.data as Missile).stopMoving();
				currentNode = currentNode.next;
			}
		}

	}
	
}
