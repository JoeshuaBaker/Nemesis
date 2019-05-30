package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import collision.*;
	import ReferenceObjects.*;
	import ReferenceObjects.AnimationSymbols.*;
	import ReferenceObjects.Pregame.*;
	import GameObjects.Enemies.*;
	import GameObjects.Players.*;
	import GameObjects.Projectiles.*;
	import Sounds.*;
	import flash.geom.Point;
	
	public class GameEngine extends MovieClip {
		
		//game objects
		public var player:PlaneGeneric;
		
		//spawnloop & death objects
		var launchRocket:LaunchRocket;
		var launchPiece1:LaunchPiece;
		var launchPiece2:LaunchPiece;
		var launchPiece3:LaunchPiece;
		var deathExplosion:PlayerDeath;
		
		//timers
		var gameTimer									:uint = 0;
		var titleTimer									:Timer;
		var secondTimer									:uint = 1;
		var turningTimer								:uint = 0;
		var bulletCooldown								:uint = 0;
		
		//event flags
		public var rotatingRight						:Boolean = false;
		public var rotatingLeft							:Boolean = false;
		var boosting									:Boolean = false;
		var shooting									:Boolean = false;
		var special										:Boolean = false;
		var hasLoaded									:Boolean = false;
		var resetFlag									:Boolean = false;
		var hasLaunched									:Boolean = false;
		var dead										:Boolean = false;
		var scrollFinish								:Boolean = false;
		var deathSfx									:Boolean = false;
		
		//containers
		var weaponHandler:WeaponHandler;
		var collisionHandler:CollisionHandler;
		var enemyHandler:EnemyHandler;
		var titleScreen:TitleScreen;
		var backgroundHandler:BackgroundHandler;
		var soundHandler:SoundHandler;
		var settings:SettingsContainer;
		var uiOverlay:UIOverlay;
		var scoreScreen:ScoreScreen;
		
		public function GameEngine() 
		{
			//(#) means how many milliseconds do you want the timer to count.
			//gameTimer = new Timer ( 16.666666666666667 );
			//gameTimer.addEventListener( TimerEvent.TIMER, onTick);
			
			titleScreen = new TitleScreen();
			
			titleTimer = new Timer (1);
			titleTimer.addEventListener( TimerEvent.TIMER, titleLoop);
			titleTimer.start();
			
			addChildAt(titleScreen, 0);
		}
		
		public function titleLoop(e:TimerEvent)
		{
			if(!titleScreen.visible) 
			{
				titleTimer.removeEventListener(TimerEvent.TIMER, titleLoop);
				titleTimer.stop();
				//this is the event listener to start the game loop
				stage.addEventListener( Event.ENTER_FRAME, spawnLoop);
				removeChild(titleScreen);
				//titleScreen = null;
			}
			
			else if(titleScreen.hasLaunched && !hasLoaded)
			{
				loadGame();
			}
		}
		
		public function spawnLoop(event:Event):void
		{
			//trace("spawnLoop frame: " + gameTimer);
			backgroundHandler.upkeep();
			weaponHandler.waterline.followPlayerX(player);
			cameraFollowPlayer();
			
			if(gameTimer == 1) 
			{
				soundHandler.fadeMusic(1);
				soundHandler.playSfx(25);
			}
			else if(gameTimer < 112)
			{
				launchRocket.fly();
				player.x = launchRocket.x;
				player.y = launchRocket.y;
				if (launchRocket.y > 345 && launchRocket.y < 355)
				{
					var splash1:PlaneSplash = new PlaneSplash;
					splash1.y = 353;
					splash1.x = launchRocket.x;
					addChild(splash1);
				}
				else if (launchRocket.y > 265 && launchRocket.y < 275)
				{
					var splash2:PlaneSplash = new PlaneSplash;
					var splash3:PlaneSplash = new PlaneSplash;
					splash2.y = 370;
					splash2.x = launchRocket.x + 15;
					splash3.y = 370;
					splash3.x = launchRocket.x - 15;
					addChild(splash2);
					addChild(splash3);
				}
			}
			else
			{
				launchRocket.gotoAndPlay(58);
				addChild(launchPiece1);
				addChild(launchPiece2);
				addChild(launchPiece3);
				launchPiece1.x = launchRocket.x;
				launchPiece1.y = launchRocket.y;
				launchPiece2.x = launchRocket.x;
				launchPiece2.y = launchRocket.y;
				launchPiece3.x = launchRocket.x;
				launchPiece3.y = launchRocket.y;
				launchPiece1.beginFlying();
				launchPiece2.beginFlying();
				launchPiece3.beginFlying();
				player.visible = true;
				player.speedY = launchRocket.speed;
				
				stage.removeEventListener( Event.ENTER_FRAME, spawnLoop);
				stage.addEventListener( Event.ENTER_FRAME, onTick);
				trace("game started");
			}
			
			gameTimer++;
		}
		
		private function setupSpawnLoop()
		{
			player.visible = false;
			launchRocket = new LaunchRocket();
			launchPiece1 = new LaunchPiece(1);
			launchPiece2 = new LaunchPiece(2);
			launchPiece3 = new LaunchPiece(3);
			
			launchRocket.y = 800;
			addChildAt(launchRocket, 1);
			player.x = launchRocket.x;
			player.y = launchRocket.y;
			titleScreen.x = player.x;
			titleScreen.y = player.y;
			
			backgroundHandler.upkeep();
			weaponHandler.waterline.followPlayerX(player);
			cameraFollowPlayer();
			//trace("spawn loop set up");
		}
		
		private function onTick( event:Event ):void 
		{
			upkeep();
			
			onSecond();
		}
		
		private function keyPressInput(e:KeyboardEvent):void
		{
			switch (e.keyCode) {
				case Keyboard.UP:
				if(!boosting && gameTimer > 112 && player.health > 0) soundHandler.playSfx(1, null, 0.75);
				boosting = true;
				break;
				
				case Keyboard.RIGHT:
				rotatingRight = true;
				break;
				
				case Keyboard.LEFT:
				rotatingLeft = true;
				break;
				
				case Keyboard.X:
				shooting = true;
				break;
				
				case Keyboard.C:
				special = true;
				break;
				
				case Keyboard.Y:
				player.health = 0;
				break;
				
				default:
				break;
			}
		}
		
		private function keyReleaseInput(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.UP:
				if(boosting && gameTimer > 112 && player.health > 0) soundHandler.playSfx(2, null, 0.75);
				boosting = false;
				break
				
				case Keyboard.RIGHT:
				rotatingRight = false;
				break;
				
				case Keyboard.LEFT:
				rotatingLeft = false;
				break;
				
				case Keyboard.X:
				shooting = false;
				break;
				
				case Keyboard.C:
				special = false;
				break;
				
				default:
				break;
			}
		}
		
		private function cameraFollowPlayer():void
		{
 			root.scrollRect = new Rectangle(player.x - stage.stageWidth/2, player.y - stage.stageHeight/2, stage.stageWidth, stage.stageHeight);
		}
		
		private function playerUpkeep():void
		{
			player.deltaY = player.y;
			player.deltaX = player.x;
			
			if (player.health == 0)
			{
				if(player.y < 350)
				{
					if(!deathSfx)
					{
						soundHandler.playSfx(15);
						deathSfx = true;
					}
					player.rotateRight();
					player.momentum();
					player.gravity();
					if(secondTimer % 3 == 0)
					{
						player.spawnDamagedSmoke();
					}
					player.rotateReference.tail.newBoost.animationCancel();
				}
				else
				{
					if(!dead)
					{
						deathExplosion = new PlayerDeath();
						deathExplosion.x = player.getXPosition();
						deathExplosion.y = 352;
						addChild( deathExplosion );
						player.visible = false;
						dead = true;
						soundHandler.playSfx(16);
					}
					
					if(deathExplosion.done)
					{
						var playerCode:uint;
						if(player is BasicPlane) playerCode = 1;
						else if(player is SniperPlane) playerCode = 2;
						else playerCode = 3;
						
						enemyHandler.displayScore();
						scoreScreen = new ScoreScreen(enemyHandler.planeCounter, enemyHandler.boatCounter, 
													  enemyHandler.bshipCounter, enemyHandler.nemesisCounter, 
													  gameTimer, playerCode, enemyHandler.nemesisDiscovered);
						addChild(scoreScreen);
						scoreScreen.x = player.x;
						scoreScreen.y = player.y + 125;
						
						addEventListener(Event.ENTER_FRAME, postGame, false, 0, true);
						soundHandler.fadeMusic(5);
						stage.removeEventListener(Event.ENTER_FRAME, onTick);
						
					}
						//resetFlag = true;
				}
			}
			else
			{
				if(boosting)
				{
					player.accelerate();
					player.rotateReference.tail.newBoost.animationStart();
				}
				else
				{
					player.momentum();
					player.rotateReference.tail.newBoost.animationCancel();
				}
				if(player.y > 350)
					player.bouyancy();
				else
					player.gravity();
				
				if(rotatingRight || rotatingLeft)
				{
					turningTimer++;
				}
				else
				{
					turningTimer = 0;
				}
				
				if(rotatingRight)
				{
					if(turningTimer > 10)
					{
						if(!(player is BasicPlane))
							player.rotateRight(true);
						else if (player.specialCooldown < 5)
							player.rotateRight(true);
					}
					else
					{
						if(!(player is BasicPlane))
							player.rotateRight(false);
						else if (player.specialCooldown < 5)
							player.rotateRight(false);						
					}
				}
				else if(rotatingLeft)
				{
					if(turningTimer > 10)
					{
						if(!(player is BasicPlane))
							player.rotateLeft(true);
						else if (player.specialCooldown < 5)
							player.rotateLeft(true);						
					}
					else
					{
						if(!(player is BasicPlane))
							player.rotateLeft(false);
						else if (player.specialCooldown < 5)
							player.rotateLeft(false);
					}
				}
				
				if(special)
				{
					if(player is BasicPlane)
					{
						turningTimer = 0;
						if(player.specialCooldown == 0) soundHandler.playSfx(6);
					}
					else if(player is SniperPlane)
						(player as SniperPlane).updateReticle(bulletCooldown);
					else if(player is SawPlane)
					{
						if((player as SawPlane).shootSawblade(true))
							soundHandler.playSfx(17);
					}
						
						
					player.specialMove();
				}
				else
				{
					if(player is SniperPlane)
					{
						if(player.specialCooldown == 1 && bulletCooldown == 0)
						{
							weaponHandler.shoot(player, player.rotateReference);
							bulletCooldown = player.bulletCooldown;
							player.regenTimer = 0;
						}
						(player as SniperPlane).updateReticle(bulletCooldown);
					}
					player.specialCancel();
				}
				
				if(shooting && bulletCooldown == 0)
				{
					//adds bullet to weaponhandler, initializes it, then returns it, which is added to collisionHandler list
					if(player is BasicPlane)
					{
						weaponHandler.shoot(player, player.rotateReference);
						player.rotateReference.nose.muzzleFlare.resetAnimation();
					}
					else if(player is SniperPlane)
					{
						bulletCooldown = player.bulletCooldown;
						weaponHandler.shootShotgun(player);
						player.rotateReference.nose.muzzleFlare.resetSniperAnimation();
					}
					else if(player is MeleePlane)
					{
						if(!player.dashing)
							player.playSpecialAnimation();
					}
					else if(player is SawPlane)
					{
						if((player as SawPlane).shootSawblade(false))
							soundHandler.playSfx(17);
					}
					bulletCooldown = player.bulletCooldown;
				}
				else if(player is MeleePlane)
				{
					player.dashing = (player.specialCooldown > 0);
				}
				else if (bulletCooldown > 0)
				{
					bulletCooldown--;
				}
				if(player.fullCharge)
				{
					if(player.specialCooldown == 27)
					{
						weaponHandler.createExplosion(player.x, player.y, true);
						player.fullCharge = false;
					}
				}
					
				if(!settings.stamina.pressed) 
				{
					player.regenerate(shooting);
					if(player.regenTimer == 90 && player.health != player.maxHealth)
					{
						soundHandler.playSfx(3);
					}
				}
				
				if ((secondTimer % player.health == 0 && player.health != player.maxHealth) || (player.regenTimer < 0 && player.regenTimer % 4 == 0))
					player.spawnDamagedSmoke();
			}
					
			player.deltaX = player.x - player.deltaX;
			player.deltaY = player.y - player.deltaY;
			
		}
		
		private function postGame(e:Event)
		{
			if(scoreScreen.toTitle && scrollFinish)
			{
				removeEventListener(Event.ENTER_FRAME, postGame);
				if(scoreScreen.nemesisDiscovered) settings.updateNemesis(titleScreen.planeCode);
				resetGame();
				titleScreen.returnToTitle();
			}
			else if(scoreScreen.playAgain && scrollFinish)
			{
				removeEventListener(Event.ENTER_FRAME, postGame);
				if(scoreScreen.nemesisDiscovered) settings.updateNemesis(titleScreen.planeCode);
				resetGame(false);
				loadGame(false);
			}
			
			else if(scoreScreen.y <= 875)
			{
				if(scoreScreen.toTitle || scoreScreen.playAgain)
					scoreScreen.y += 3;
				else
					++scoreScreen.y;
					
				backgroundHandler.upkeep();
				root.scrollRect = new Rectangle(scoreScreen.x - stage.stageWidth/2, (scoreScreen.y - stage.stageHeight/2 - 125), stage.stageWidth, stage.stageHeight);
			}
			else
			{
				scrollFinish = true;
				scoreScreen.y = 875;
			}
		}
		
		private function onSecond():void
		{
			if(secondTimer == 60)
			{
				enemyHandler.waveAI();
				secondTimer = 0;
				
			}
			else
				secondTimer++;
		}
		
		private function upkeep():void
		{
			playerUpkeep();
			backgroundHandler.upkeep();
			soundHandler.wakeSound();
			
			collisionHandler.upkeep();
			
			enemyHandler.cullEnemies();

			//move enemy projectiles
			weaponHandler.cullProjectiles( collisionHandler, player.getXPosition(), player.getYPosition() );
			weaponHandler.moveBullets();
			weaponHandler.waterline.followPlayerX(player);
			
			enemyHandler.enemyPlaneAI(weaponHandler);
			enemyHandler.smallBoatsShoot(weaponHandler);
			enemyHandler.battleshipAI(weaponHandler);
			enemyHandler.nemesisAI(gameTimer);

			//Camera Following the player
			cameraFollowPlayer();
			uiOverlay.followPlayer();
			
			gameTimer++;
		}
		
		public function loadGame(fromTitle:Boolean = true):void
		{
				switch(titleScreen.planeCode)
				{
					case 1:
					player = new BasicPlane();
					break;
					
					case 2:
					player = new SniperPlane();
					break;
					
					case 3:
					player = new MeleePlane();
					break;
					
					case 4:
					player = new SawPlane();
					break;
					
					default:
					trace("Player plane code was not found, player could not be created.");
					break;
				}
				
				settings = titleScreen.settingsContainer;
				soundHandler = new SoundHandler(settings.sfx.value/100, settings.music.value/100, titleScreen.planeCode, player);
				collisionHandler = new CollisionHandler(player, settings, soundHandler);
				weaponHandler = new WeaponHandler(collisionHandler, player, settings, soundHandler);
				enemyHandler = new EnemyHandler(collisionHandler, weaponHandler, player, settings, soundHandler);
				backgroundHandler = new BackgroundHandler(player, settings);
				uiOverlay = new UIOverlay(player, weaponHandler, enemyHandler, collisionHandler, settings);
				if(settings.debugMenu.hitboxes.pressed) player.toggleHitbox();
				if(settings.stamina.pressed) 
				{
					player.maxHealth = 120;
					player.health = 120;
				}

				
				addChild( weaponHandler );
				addChild( enemyHandler );
				addChild( collisionHandler );
				addChild( soundHandler );
				addChild( player );
				addChild(uiOverlay);
				addChildAt( backgroundHandler, 0 );
	
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressInput);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyReleaseInput);
				
				hasLoaded = true;
				if(fromTitle) setChildIndex(titleScreen, numChildren - 1);
				bulletCooldown = 0;
				
				//Debug Stuff
				if(titleScreen.debugMenu.invincibility.pressed)
				{
					//WE INVINCIBLE NOW
					player.health = 4294967295;
				}
				
				enemyHandler.debugWave = new Wave();
				
				setupSpawnLoop();
				if(!fromTitle) stage.addEventListener( Event.ENTER_FRAME, spawnLoop);

		}
		
		private function resetGame(toTitle:Boolean = true):void
		{
			hasLoaded = false;
			hasLaunched = false;
			soundHandler.cleanUp();
			weaponHandler.clearMissiles();
			
			while( numChildren > 0)
			{
				var temp:Object = getChildAt(0);
				if(temp is MovieClip)
					temp.gotoAndStop(1);
				removeChildAt(0);
			}
			
			turningTimer = 0;
			bulletCooldown = 0;
			gameTimer = 0;
			rotatingRight = false;
			rotatingLeft = false;
			boosting = false;
			shooting = false;
			special = false;
			dead = false;
			scrollFinish = false;
			deathSfx = false;
			
			if(toTitle)
			{
				root.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
				var newTitle:TitleScreen = new TitleScreen();
				newTitle.settingsContainer.adoptSettings(settings);
				titleScreen = newTitle;
				addChildAt(titleScreen, 0);
				addChild(titleScreen);
				titleScreen.visible = true;
				titleTimer.addEventListener( TimerEvent.TIMER, titleLoop);
				titleTimer.start();				
			}
		}
	}	
}
