package GameObjects.Enemies 
{
	import flash.display.MovieClip;
	import collision.CollisionHandler;
	import GameObjects.Players.*;
	import GameObjects.Projectiles.WeaponHandler;
	import ReferenceObjects.Wave;
	import ReferenceObjects.AnimationSymbols.DroneContainer;
	import ReferenceObjects.SettingsContainer;
	import ReferenceObjects.LinkedList;
	import ReferenceObjects.LinkedListNode;
	import Sounds.SoundHandler;
	import flash.geom.Point;
	
	public class EnemyHandler extends MovieClip
	{
		
		var enemyPlanes:LinkedList = new LinkedList();
		var smallBoats:LinkedList = new LinkedList();
		var battleships:LinkedList = new LinkedList();
		var nemesises:LinkedList = new LinkedList();
		var allEnemies:Array = new Array(enemyPlanes, smallBoats, battleships, nemesises);
		public var debugWave:Wave = null;
		public var waves:Array = new Array();
		private var waveBuffer:uint = 0;
		var collisionHandler:CollisionHandler;
		private var weaponHandler:WeaponHandler;
		private var soundHandler:SoundHandler;
		var player:PlaneGeneric;
		
		private const BOAT_DISTANCE:Number = 2000;
		private const SPAWN_OFFSET:Number = 800;
		
		private var settings:SettingsContainer;
		
		public var planeCounter:uint = 0;
		public var boatCounter:uint = 0;
		public var bshipCounter:uint = 0;
		public var nemesisCounter:uint = 0;
		public var nemesisDiscovered:Boolean = false;
		private var postgame:Boolean = false;
		private var reinforcements:Wave;
		private var numNemesises:uint;

		public function EnemyHandler(colHandler:CollisionHandler, wepHandler:WeaponHandler, playerReference:PlaneGeneric, _settings:SettingsContainer, _soundHandler:SoundHandler) 
		{
			collisionHandler = colHandler;
			player = playerReference;
			weaponHandler = wepHandler;
			settings = _settings;
			soundHandler = _soundHandler
			
			numNemesises = (player is SniperPlane)? 10 : 1;
			
			//seconds used: 102
			//					   1, 2, 3, 4, 5
			// 1 -- planes
			// 2 -- small boats
			// 3 -- battleship
			// 4 -- nemesis
			// 5 -- seconds til next wave
			if(!settings.onslaught.pressed)
			{
				waves.push(new Wave(0, 0, 0, 0, 0, 5, genXOffset()));
				waves.push(new Wave(0, 2, 0, 0, 0, 3, genXOffset()));
				waves.push(new Wave(0, 5, 1, 0, 0, 7, genXOffset()));
				waves.push(new Wave(0, 3, 0, 0, 0, 8, genXOffset()));
				waves.push(new Wave(0, 3, 1, 0, 0, 8, genXOffset()));
				waves.push(new Wave(0, 1, 0, 1, 0, 9, genXOffset()));
				waves.push(new Wave(0, 7, 0, 0, 0, 8, genXOffset()));
				waves.push(new Wave(0, 8, 1, 1, 0, 6, genXOffset()));
				waves.push(new Wave(0, 4, 0, 0, 0, 6, genXOffset()));
				waves.push(new Wave(0, 14, 1, 0, 0, 12, genXOffset()));
				waves.push(new Wave(0, 4, 1, 2, 0, 10, genXOffset()));
				waves.push(new Wave(0, 7, 1, 0, 0, 20, genXOffset()));
				waves.push(new Wave(0, 0, 0, 0, numNemesises, 20, genXOffset()));				
			}
			else
			{
				postgame = true;
				nemesisDiscovered = true;
				nemesisCounter = 0;
			}
			
			reinforcements = new Wave(0, 10, 1, 0, 0, 15);
		}
		
		public function genXOffset():Number
		{
			return (SPAWN_OFFSET*((Math.random() < 0.5) ? -1 : 1));
		}
		
		public function spawnEnemyPlane( xPos:Number = NaN, yPos:Number = NaN):EnemyPlane
		{
			var enemy:EnemyPlane;
			var playerX:Number = player.x;
			var playerY:Number = player.y;
			
			if(arguments.length > 0) //default arguments not used
			{
				enemy = new EnemyPlane(xPos, yPos);
				addChild( enemy );
				enemyPlanes.push(enemy);
				collisionHandler.addList( enemy, 0 );
				collisionHandler.addList( enemy, 1 );
				if(settings.debugMenu.hitboxes.pressed) enemy.toggleHitbox();
				return enemy;
			}
			
			enemy = new EnemyPlane();
			
			//adding enemy plane to the appropriate zones
			addChild( enemy );
			enemyPlanes.push(enemy);
			collisionHandler.addList( enemy, 0 );
			collisionHandler.addList( enemy, 1 );
			
			var randSpawn:uint = Math.ceil(Math.random() * 3); //returns either 1, 2, 3 randomly
			var spawnVariation:Number = Math.ceil(Math.random() * 2);
			switch (spawnVariation) {
				case 2:
				spawnVariation = Math.random() * -1;
				break;
				
				default:
				spawnVariation = Math.random();
				break;
			}
			
			switch (randSpawn) {
				case 1:
				enemy.x = playerX + ((stage.stageWidth/2) + 100);
				if(playerY < 600) enemy.y = playerY - Math.abs(((stage.stageHeight/2) * spawnVariation));
				else enemy.y = playerY + ((stage.stageHeight/2) * spawnVariation); 
				//spawns plane to the right of the stage
				break;
				
				case 2:
				enemy.y = playerY - ((stage.stageHeight/2) + 100);
				enemy.x = playerX + ((stage.stageWidth/2) * spawnVariation);
				//spawns plane on top of stage
				break;
				
				case 3:
				enemy.x = playerX - ((stage.stageWidth/2) + 100);
				if(playerY < 600) enemy.y = playerY - Math.abs(((stage.stageHeight/2) * spawnVariation));
				else enemy.y = playerY + ((stage.stageHeight/2) * spawnVariation);
				//spawns plane to left of the stage
				break;
				
				default:
				break;
			}
			if(settings.debugMenu.hitboxes.pressed) enemy.toggleHitbox();
			return enemy;
		}
		
		//do not add any more non-default arguments to this function without changing arguments.length
		public function spawnSmallBoat( xPos:Number = NaN ):SmallBoat
		{
			var boat:SmallBoat;
			var playerX:Number = player.x;
			
			if(arguments.length > 0) //default arguments not used
			{
				boat = new SmallBoat(soundHandler, xPos, playerX);
				addChild ( boat );
				smallBoats.push(boat);
				collisionHandler.addList( boat, 0 );
				collisionHandler.addList( boat, 1 );
				if(settings.debugMenu.hitboxes.pressed) boat.toggleHitbox();

				
				if (xPos < playerX + stage.stageWidth/2 && xPos > playerX - stage.stageWidth/2)
					trace("You probably spawned a boat within the screen. idiot.");
				return boat;
			}
			
			boat = new SmallBoat(soundHandler);
			addChild ( boat );
			smallBoats.push(boat);
			collisionHandler.addList( boat, 0 );
			collisionHandler.addList( boat, 1 );
			
			var spawnVariation:Number = Math.ceil(Math.random() * 2);
			switch (spawnVariation) 
			{
				case 2:
				spawnVariation =  playerX +(Math.random() * -3000) - 100 - stage.stageWidth/2;
				break;
				
				default:
				spawnVariation = playerX + (Math.random() * 3000) + 100 + stage.stageWidth/2;
				break;
			}
			
			boat.x = spawnVariation;
			boat.y = 328;
			if(settings.debugMenu.hitboxes.pressed) boat.toggleHitbox();

			return boat;
		}
		
		public function nemesisAI(gameTimer:uint)
		{
			var current:LinkedListNode = nemesises.head;
			var currentData:*;
			var sfxFlag:Boolean = true;
			while(current != null)
			{
				currentData = current.data;
				
				currentData.AI();
				if(currentData is BulletNemesis && currentData.shooting)
				{
					weaponHandler.drawLasers(currentData);
				}
				else if(currentData is BlobNemesis && currentData.isKing && gameTimer % 10 == 0)
				{
					var blob:LinkedListNode = nemesises.head;
					while(blob != null && nemesises.length > 1)
					{
						var blobData:BlobNemesis = (blob.data as BlobNemesis);
						if(blobData.isSerf || currentData.isFree || currentData == blobData)
						{
							
						}
						else if(currentData.isBuddy(blobData))
						{
							if(nemesises.indexOf(currentData) < nemesises.indexOf(blobData))
							{
								setChildIndex(currentData, numChildren - 1);
								currentData.becomeKing(1 + blobData.serfCount);
								blobData.becomeSerf(currentData);
							}
							else
							{
								setChildIndex(blobData, numChildren - 1);
								blobData.becomeKing(1 + currentData.serfCount);
								currentData.becomeSerf(blobData);
							}
							if(sfxFlag) {
								soundHandler.playSfx(24, new Point(currentData.x, currentData.y));
								sfxFlag = false;
							}
						}
						blob = blob.next;
					}
				}
				current = current.next;
			}
		}
		
		public function spawnBattleship( xPos:Number = NaN ):Battleship
		{
			var boat:Battleship;
			var playerX:Number = player.x;
			
			if(arguments.length > 0) //default arguments not used
			{
				boat = new Battleship(soundHandler, xPos, playerX);
				addChild (boat);
				if(settings.debugMenu.hitboxes.pressed) boat.toggleHitbox();
				battleships.push(boat); //adds boat to the array
				collisionHandler.addList( boat, 0 );
				collisionHandler.addList( boat, 1 );
				
				return boat;
			}
			
			boat = new Battleship(soundHandler);
			addChild (boat);
			battleships.push(boat); //adds boat to the array
			collisionHandler.addList( boat, 0 );
			collisionHandler.addList( boat, 1 );
			
			var spawnVariation:Number = Math.ceil(Math.random() * 2);
			switch (spawnVariation) 
			{
				case 2:
				spawnVariation =  playerX +(Math.random() * -3000) - 100 - stage.stageWidth/2;
				break;
				
				default:
				spawnVariation = playerX + (Math.random() * 3000) + 100 + stage.stageWidth/2;
				break;
			}
			
			boat.x = spawnVariation;
			if(settings.debugMenu.hitboxes.pressed) boat.toggleHitbox();
			return boat;
		}
		
		public function spawnNemesis(xOffset:Number)
		{
			var nemesis:Nemesis;
			
			if(player is BasicPlane)
			{
				nemesis = new BulletNemesis(player, soundHandler);
				collisionHandler.addList(nemesis, 0);
				collisionHandler.addList(nemesis, 1);				
			}
			else if(player is SniperPlane)
			{
				nemesis = new BlobNemesis(player, collisionHandler);
				collisionHandler.addList(nemesis, 1);
			}
			else if(player is SawPlane || player is MeleePlane)
			{
				nemesis = new ChainNemesis(player, collisionHandler, soundHandler);
				collisionHandler.addList(nemesis, 1);
			}
			
			nemesises.push(nemesis);
			nemesis.x = player.x + xOffset;
			var nemesisRange:Number = 500;
			if( Math.random() < 0.5) nemesisRange *= -1;
			nemesis.y = player.y + nemesisRange*Math.random();
			if(nemesis.y > 350) nemesis.y = 350;
			else if (nemesis.y < -1100) nemesis.y = -1100;
			addChild(nemesis);
			nemesisDiscovered = true;
			if(player is SniperPlane) settings.nemesisesRevealed[0] = true;
			else if(player is BasicPlane) settings.nemesisesRevealed[1] = true;
			else if(player is SawPlane || player is MeleePlane) settings.nemesisesRevealed[2] = true;
			
			
			
			if(settings.debugMenu.hitboxes.pressed) nemesis.toggleHitbox();
			
		}
		
		public function enemyPlaneAI(weaponHandler:WeaponHandler)
		{
			var current:LinkedListNode = enemyPlanes.head;
			var currentData:EnemyPlane;
			while (current != null)
			{
				currentData = (current.data as EnemyPlane);
				currentData.AI(player);
				
				if(currentData.checkAngleTo( player ) <= 9 && currentData.bulletCooldown == 0)
				{
					weaponHandler.shoot(currentData, currentData.rotateReference);
					currentData.rotateReference.nose.muzzleFlare.resetAnimation();
					currentData.bulletCooldown = 300;
				}
				else if (currentData.bulletCooldown > 0)
				{
					currentData.bulletCooldown -= 1;
				}
				current = current.next;
			}
		}
		
		public function battleshipAI(weaponHandler:WeaponHandler)
		{
			var current:LinkedListNode = battleships.head;
			var currentData:Battleship;
			while (current != null)
			{
				currentData = (current.data as Battleship);
				currentData.AI(player);
				if(currentData.firing)
				{
					if(currentData.bulletCooldown % 25 == 0)
					{
						weaponHandler.shoot(currentData, currentData.leftCannon);
						currentData.leftFire.gotoAndPlay(2);
						currentData.leftCannon.gotoAndPlay(2);
					}
					else if ((currentData.bulletCooldown + 5) % 25 == 0)
					{
						weaponHandler.shoot(currentData, currentData.rightCannon);			
						currentData.rightFire.gotoAndPlay(2);
						currentData.rightCannon.gotoAndPlay(2);
					}
				}
				
				if( Math.abs(currentData.x - player.x) > BOAT_DISTANCE )
				{
					if(player.speedX < 0)
					{
						currentData.x = player.x - Math.abs(currentData.playerOffset);
					}
					else
					{
						currentData.x = player.x + Math.abs(currentData.playerOffset);
					}
				}
				current = current.next;
			}
		}
		
		public function cullEnemies():void
		{
			var current:LinkedListNode;
			var currentData:*;
			var nextNode:LinkedListNode = null;
			for(var i:int=allEnemies.length - 1; i >= 0; i--)
			{
				current = allEnemies[i].head;
				while(current != null)
				{
					currentData = current.data;
					if(currentData.health == 0)
					{
							if(currentData is Nemesis) 
							{
								if(player is BasicPlane)
								{
									settings.nemesisesKilled[1] = true;
									postgame = true;
									soundHandler.playSfx(20, new Point(currentData.x, currentData.y));
								}
								else if(player is SniperPlane)
								{
									settings.nemesisesKilled[0] = true;
									if(nemesisCounter > 8) postgame = true;
									soundHandler.playSfx(23, new Point(currentData.x, currentData.y));
								}
								else if(player is SawPlane || player is MeleePlane)
								{
									settings.nemesisesKilled[2] = true;
									postgame = true;
								}
							}
							currentData.die();
							selectSfx(currentData);
							collisionHandler.removeList( currentData, 0 ); //collision list cleanup
							collisionHandler.removeList( currentData, 1 );
							scoreCounter(currentData);
							nextNode = current.next;
							allEnemies[i].remove(current); //enemy array cleanup
					}
					if(nextNode != null) current = nextNode;
					else current = current.next;
					nextNode = null;
				}
			}
		}
		
		private function selectSfx(object:MovieClip):void
		{
			if(object is EnemyPlane)
				soundHandler.playSfx(12, new Point(object.x, object.y));
		}
		
		private function scoreCounter(enemy:Object)
		{
			if(enemy is EnemyPlane)
			{
				++planeCounter;
			}
			else if(enemy is SmallBoat)
			{
				++boatCounter;
			}
			else if(enemy is Battleship)
			{
				++bshipCounter;
			}
			else if(enemy is Nemesis)
			{
				++nemesisCounter;
			}
		}
		
		public function displayScore()
		{
			trace("Number of enemies killed--Planes: " + planeCounter + " Small Boats: " + boatCounter + " Battleships: " + bshipCounter + " Nemesises: " + nemesisCounter);
		}
		
		public function smallBoatsShoot(weaponHandler:WeaponHandler)
		{
			var current:LinkedListNode = smallBoats.head;
			var currentData:SmallBoat;
			while(current != null)
			{
				currentData = (current.data as SmallBoat);
				if(currentData.bulletCooldown == 0 && (Math.abs(currentData.x - player.x) < 2000))
				{
					var missileX:Number = currentData.x;
					var missileY:Number = currentData.y;
					var shootMissile:Boolean = false;
					
						switch(currentData.missileCounter)
						{
							case 1:
							case 4:
							missileX += 22;
							missileY += -1;
							currentData.bulletCooldown = 8;
							currentData.missileCounter++;
							shootMissile = true;
							soundHandler.playSfx(14, new Point(currentData.x, currentData.y));
							break;
							
							case 2:
							case 5:
							missileX += 27;
							missileY += -1;
							currentData.bulletCooldown = 8;
							currentData.missileCounter++;
							shootMissile = true;
							break;
							
							case 3:
							missileX += 32;
							missileY += -1;
							currentData.bulletCooldown = 8;
							currentData.missileCounter++;
							shootMissile = true;
							break;
							
							case 6:
							missileX += 32;
							missileY += -1;
							currentData.bulletCooldown = 300;
							currentData.missileCounter = 0;
							shootMissile = true;
							break;
							
							case 0:
							currentData.bulletCooldown = 10;
							currentData.startAttackAnimation();
							currentData.missileCounter = 1;
							break;
							
							default:
							trace("a missile tried to shoot but shouldn't have");
							break;
						}
						
					if(shootMissile)
					{
						collisionHandler.addList(weaponHandler.shootMissile(missileX, missileY, player.x, player.y), 1);
					}
						
				}
				else
				{
					if(currentData.bulletCooldown == 17)
					{
						currentData.startFireIndicator();
						soundHandler.playSfx(13, new Point(currentData.x, currentData.y));
					}
					
					if(currentData.bulletCooldown != 0)
					currentData.bulletCooldown--;
				}
				currentData.attackAnimation.nextFrame();
				
				if( Math.abs(currentData.x - player.x) > BOAT_DISTANCE )
				{
					currentData.x = player.x + currentData.playerOffset;
				}

				current = current.next;
			}
			
		}
		
		public function waveAI():void
		{
			if(waveBuffer == 0)
			{
				if(waves.length != 0)
				{
					waveBuffer = waves[0].waveBuffer;
					spawnWave(waves[0]);
					waves[0].nullValues();
					waves[0] = null;
					waves.shift();
				}
				else
				{
					if(postgame)
						postgameWaves();
					else
					{
						waveBuffer = reinforcements.waveBuffer;
						spawnWave(reinforcements);
						trace("spawned reinforcements");
					}
				}
			}
			else
			{
				waveBuffer--;
			}
		}
		
		private function postgameWaves():void
		{
			trace("added more postgame waves");
			waves.push(new Wave(0, 15, 2, 1, 0, 8, genXOffset()));
			waves.push(new Wave(0, 8, 1, 0, 0, 4, genXOffset()));
			waves.push(new Wave(0, 8, 0, 1, 0, 4, genXOffset()));
			waves.push(new Wave(0, 10, 2, 1, 0, 4, genXOffset()));
			waves.push(new Wave(0, 5, 0, 0, numNemesises, 10));
			numNemesises += (player is SniperPlane)? 5 : 1;
		}
		
		public function spawnWave(wave:Wave):void
			{
				var i:int = 0;
				var position:int = -83;
				for(i = 0; i < wave.numPlanes; i++)
				{
					var testX:Number = player.x + wave.getxOff() + (Math.random() * wave.randomVariation);
					var testY:Number = player.y + wave.getyOff() + (Math.random() * wave.randomVariation);
					if (testY > 333)
					{
						testY = 250 + (Math.random() * wave.randomVariation);
					}
					spawnEnemyPlane(testX, testY);
				}
				for(i = 0; i < wave.numSmallBoats; i++)
				{
					position += 83;
					if( wave.getxOff() >= 0)
					{
						spawnSmallBoat( wave.getxOff() + position  + (Math.random() * wave.randomVariation) );
					}
					else if( wave.getxOff() < 0)
					{
						spawnSmallBoat( wave.getxOff() - position  - (Math.random() * wave.randomVariation) );
					}
				}
				for(i = 0; i < wave.numBattleships; i++)
				{
					position += 187;
					if( wave.getxOff() >= 0)
					{
						spawnBattleship( wave.getxOff() + position  + (Math.random() * wave.randomVariation) );
					}
					else if( wave.getxOff() < 0)
					{
						spawnBattleship( wave.getxOff() - position - (Math.random() * wave.randomVariation) );
					}
				}
				for(i = 0; i < wave.numNemesises; ++i)
				{
					spawnNemesis(genXOffset());
				}
			}
		
	}
}
