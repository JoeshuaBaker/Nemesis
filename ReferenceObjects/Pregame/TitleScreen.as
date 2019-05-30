package  ReferenceObjects.Pregame
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import ReferenceObjects.Buttons.*;
	import flash.display.Shape;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import ReferenceObjects.Pregame.*
	import Sounds.TitleLoop;
	import ReferenceObjects.AnimationSymbols.SmallScreenFlicker;
	import ReferenceObjects.AnimationSymbols.Light;
	import ReferenceObjects.AnimationSymbols.ButtonGlow;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import ReferenceObjects.SettingsContainer;
	import Sounds.Sfx.ButtonClick;
	import Sounds.Sfx.PowerClick;
	import Sounds.Sfx.StartupBeep;
	import Sounds.Sfx.MenuFan;
	
	public class TitleScreen extends MovieClip {
		
		private var keener:KeenerButton;
		private var arsus:ArsusButton;
		private var vandal:VandalButton;
		private var launch:LaunchButton;
		private var debugButton:GameButton;
		private var power:PowerButton;
		private var enemy:EnemyButton;
		private var credits:CreditsButton;
		private var keenerInfo:InfoButton;
		private var arsusInfo:InfoButton;
		private var vandalInfo:InfoButton;
		private var music:MusicButton;
		private var settings:SettingsButton;
		private var sfx:SfxButton;
		private var buttonGlow:ButtonGlow;
		
		private var smallScreen:SmallScreen;
		private var bigScreen:BigScreen;
		private var transitionScreen:TransitionScreen;
		private var titleLoop:TitleLoop;
		private var titleChannel:SoundChannel;
		private var sfxChannel:SoundChannel;
		private var trans:SoundTransform;
		private var sfxTransform:SoundTransform;
		private var buttonClick:ButtonClick = new ButtonClick();
		private var powerClick:PowerClick = new PowerClick();
		private var startupBeep:StartupBeep = new StartupBeep();
		private var menuFan:MenuFan = new MenuFan();
		private var smallScreenFlicker:SmallScreenFlicker;
		private var startupCounter:uint = 0;
		private var startingUp:Boolean = true;
		private var fadingIn:Boolean = false;
		private var fadingOut:Boolean = false;
		private var keyPrompt:Boolean = false;
		
		private var xDown:Boolean = false;
		private var cDown:Boolean = false;
		private var upDown:Boolean = false;
		private var leftDown:Boolean = false;
		private var rightDown:Boolean = false;
		
		var buttonArray:Array;
		var lightArray:Array;
		public var playerTypeCode:uint = 0;
		public var debugMenu:DebugMenu;
		public var buttonCode:uint = 0;
		public var planeCode:uint = 0;
		public var hasLaunched:Boolean = false;
		public var settingsContainer:SettingsContainer;

		public function TitleScreen() 
		{
			x = 640;
			y = 360;
			
			keener = KeenerButton(getChildByName("KeenerButtonStage"));
			arsus = ArsusButton(getChildByName("ArsusButtonStage"));
			vandal = VandalButton(getChildByName("VandalButtonStage"));
			debugButton = DebugButton(getChildByName("debugButtonStage"));
			launch = LaunchButton(getChildByName("LaunchButtonStage"));
			power = PowerButton(getChildByName("PowerButtonStage"));
			enemy = EnemyButton(getChildByName("EnemyInfoButtonStage"));
			credits = CreditsButton(getChildByName("CreditsButtonStage"));
			keenerInfo = InfoButton(getChildByName("KeenerInfoButtonStage"));
			keenerInfo.subcode = 1;
			arsusInfo = InfoButton(getChildByName("ArsusInfoButtonStage"));
			arsusInfo.subcode = 2;
			vandalInfo = InfoButton(getChildByName("VandalInfoButtonStage"));
			vandalInfo.subcode = 3;
			music = MusicButton(getChildByName("MusicButtonStage"));
			settings = SettingsButton(getChildByName("SettingsButtonStage"));
			sfx = SfxButton(getChildByName("SfxButtonStage"));
			buttonGlow = new ButtonGlow();
			
			smallScreen = SmallScreen(getChildByName("SmallScreenStage"));
			bigScreen = BigScreen(getChildByName("BigScreenStage"));
			transitionScreen = new TransitionScreen();
			settingsContainer = bigScreen.settings;
			
			smallScreenFlicker = new SmallScreenFlicker();
			smallScreenFlicker.x = -339;
			smallScreenFlicker.y = -229;
			smallScreenFlicker.stop();
			addChild(smallScreenFlicker);
			
			lightArray = new Array(12);
			for (var n:int = 0; n < lightArray.length; ++n)
			{
				lightArray[n] = new Light();
				lightArray[n].y = -93 + 80*(Math.floor(n/3));
				lightArray[n].x = -470 + 60*(n % 3);
				addChild(lightArray[n]);
			}
			
			buttonArray = new Array(keener, arsus, vandal, debugButton, launch, enemy, credits, keenerInfo, arsusInfo, vandalInfo, music, settings, sfx, power);
			for(var i:int = 0; i < buttonArray.length; ++i)
			{
				addChild(buttonArray[i]);
				buttonArray[i].disable();
			}
			
			
			power.enable();
			debugButton.enable();
			titleLoop = new TitleLoop();
			trans = new SoundTransform(0.02, 0);
			sfxChannel = new SoundChannel();
			sfxTransform = new SoundTransform(0, 0);
			
			debugMenu = new DebugMenu();
			debugMenu.visible = false;
			addChild(debugMenu);
			settingsContainer.debugMenu = debugMenu;
			
			addChild(transitionScreen);
			transitionScreen.stop();
			
			addChildAt(buttonGlow, 4);
			buttonGlow.moveThis(arsus.x, arsus.y);
			addEventListener(Event.ENTER_FRAME, onTick);
			
		}
		
		public function returnToTitle():void
		{
			for each(var button in buttonArray)
			{
				button.enable();
			}
			
			transitionScreen.playReverse();
			
			launch.disable();
			power.disable();
			updateButtons();
			power.gotoAndStop(121);
			bigScreen.gotoAndPlay(16);
			smallScreenFlicker.play();
			smallScreen.play();
			buttonGlow.stop();
			removeChild(buttonGlow);
			titleChannel = titleLoop.play(0, 10000, trans);
			addEventListener(Event.ENTER_FRAME, soundFadeIn, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressInput, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleaseInput, false, 0, true);
			fadingIn = true;
			transitionScreen.playReverse();
			startingUp = false;
			
		}

		public function onTick(e:Event)
		{
			for(var i:int = 0; i < buttonArray.length; ++i)
			{
				if(buttonArray[i].pressed)
				{
					buttonHandler(buttonArray[i]);
				}
			}
			
			if(transitionScreen.done)
			{
				visible = false;
				trace("title screen is gone yo");
				removeEventListener(Event.ENTER_FRAME, onTick);
			}
			
			if(keyPrompt) handleKeys();
			
			if(!startingUp) updateLights();
			
		}
		
		private function handleKeys():void
		{
			var keyCheck:Boolean = false;
			if(leftDown)
			{
				keyCheck = bigScreen.updateKeys(1);
			}
			if(upDown)
			{
				keyCheck = bigScreen.updateKeys(2);
			}
			if(rightDown)
			{
				keyCheck = bigScreen.updateKeys(3);
			}
			if(xDown)
			{
				keyCheck = bigScreen.updateKeys(4);
			}
			if(cDown)
			{
				keyCheck = bigScreen.updateKeys(5);
			}
			
			if(keyCheck)
			{
				addEventListener(Event.ENTER_FRAME, startUp, false, 0, true);
				startingUp = true;
				keyPrompt = false;
			}
		}
		
		private function updateButtons():void
		{
			arsus.enable();
			arsusInfo.enable();
			if(settingsContainer.planesPlayed[0])
			{
				keener.enable();
				keenerInfo.enable();
			}
			else
			{
				keener.disable();
				keenerInfo.disable();
			}
			if(settingsContainer.planesPlayed[1])
			{
				vandal.enable();
				vandalInfo.enable();
			}
			else
			{
				vandal.disable();
				vandalInfo.disable();
			}
			
			if(settingsContainer.planesPlayed[0] &&
			   settingsContainer.planesPlayed[1] &&
			   settingsContainer.planesPlayed[2])
			   {
				   credits.enable();
			   }
			   else
			   {
				   credits.disable();
			   }
		}
		
		private function unlockButtons():void
		{
			settingsContainer.updatePlayed(1);
			settingsContainer.nemesisesRevealed[0] = true;
			settingsContainer.nemesisesKilled[0] = true;
			settingsContainer.updatePlayed(2);
			settingsContainer.nemesisesRevealed[1] = true;
			settingsContainer.nemesisesKilled[1] = true;
			settingsContainer.updatePlayed(3);
			settingsContainer.nemesisesRevealed[2] = true;
			settingsContainer.nemesisesKilled[2] = true;
			bigScreen.intel.updatePanes();
			enemy.enable();
			updateButtons();
			updateLights();
		}
		
		private function transition()
		{
			addEventListener(Event.ENTER_FRAME, fadeOut ,false, 0, true);
		}
		
		private function fadeMusicOut(e:Event)
		{
			if(!fadingIn)
			{
				trans.volume -= 0.005;
				titleChannel.soundTransform = trans;
			}
			if(trans.volume < 0)
			{
				trans.volume = 0;
				titleChannel.soundTransform = trans;
				titleChannel.stop();
				removeEventListener(Event.ENTER_FRAME, fadeMusicOut);
				fadingOut = false;
			}
		}
		
		private function fadeOut(e:Event):Boolean
		{
			bigScreen.alpha -= .34;
			if(bigScreen.alpha <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, fadeOut);
				addEventListener(Event.ENTER_FRAME, fadeIn ,false, 0, true);
				return true;
			}
			return false;
		}
		
		private function fadeIn(e:Event)
		{
			bigScreen.alpha += .34;
			if(bigScreen.alpha >= 1)
				removeEventListener(Event.ENTER_FRAME, fadeIn);
		}
		
		private function updateLights():void
		{
			var i:int = 0;
			for(i = 0; i < 3; ++i)
			{
				if(!lightArray[i].stay)
				{
					lightArray[i].light(true);
				}
			}
			var musicVol:uint = settingsContainer.music.value;
			if(!fadingIn && !fadingOut)
			{
				trans.volume = Number(musicVol)/100.0;
				titleChannel.soundTransform = trans;
			}
			if(musicVol == 0)
			{
				lightArray[3].off();
				lightArray[4].off();
				lightArray[5].off();
			}
			else if(musicVol < 15)
			{
				lightArray[3].toggleOn();
				lightArray[4].off();
				lightArray[5].off();
			}
			else if(musicVol < 29)
			{
				lightArray[3].toggleOn();
				lightArray[4].toggleOn();
				lightArray[5].off();
			}
			else if(musicVol <= 45)
			{
				lightArray[3].toggleOn();
				lightArray[4].toggleOn();
				lightArray[5].toggleOn();
			}
			else if(musicVol < 60)
			{
				lightArray[3].toggleOn(false);
				lightArray[4].toggleOn();
				lightArray[5].toggleOn();				
			}
			else if(musicVol < 75)
			{
				lightArray[3].toggleOn(false);
				lightArray[4].toggleOn(false);
				lightArray[5].toggleOn();

			}
			else
			{
				lightArray[3].toggleOn(false);
				lightArray[4].toggleOn(false);
				lightArray[5].toggleOn(false);
			}
			
			var sfxVol:uint = settingsContainer.sfx.value;
			if(sfxVol == 0)
			{
				lightArray[6].off();
				lightArray[7].off();
				lightArray[8].off();
			}
			else if(sfxVol < 17)
			{
				lightArray[6].toggleOn();
				lightArray[7].off();
				lightArray[8].off();
			}
			else if(sfxVol < 34)
			{
				lightArray[6].toggleOn();
				lightArray[7].toggleOn();
				lightArray[8].off();
			}
			else if(sfxVol <= 50)
			{
				lightArray[6].toggleOn();
				lightArray[7].toggleOn();
				lightArray[8].toggleOn();
			}
			else if(sfxVol < 67)
			{
				lightArray[6].toggleOn(false);
				lightArray[7].toggleOn();
				lightArray[8].toggleOn();
			}
			else if(sfxVol < 84)
			{
				lightArray[6].toggleOn(false);
				lightArray[7].toggleOn(false);
				lightArray[8].toggleOn();
			}
			else
			{
				lightArray[6].toggleOn(false);
				lightArray[7].toggleOn(false);
				lightArray[8].toggleOn(false);				
			}
			
			if(settingsContainer.nemesisesRevealed[0]) lightArray[9].toggleOn(false);
			else if(settingsContainer.planesPlayed[0]) lightArray[9].toggleOn();
			if(settingsContainer.nemesisesRevealed[1]) lightArray[10].toggleOn(false);
			else if(settingsContainer.planesPlayed[1]) lightArray[10].toggleOn();
			if(settingsContainer.nemesisesRevealed[2]) lightArray[11].toggleOn(false);
			else if(settingsContainer.planesPlayed[2]) lightArray[11].toggleOn();
			bigScreen.intel.updatePanes();
		}
		
		public function buttonHandler(button:GameButton)
		{
			//Button codes:
			//1:Power	2:Music	3:SFX	4:Credits
			//5:Setting	6:Info	7:Basic	8:Sniper
			//9:Melee	10: Enemy Info	11:Launch
			sfxTransform.volume = Number(settingsContainer.sfx.value/100.0);
			sfxChannel.soundTransform = sfxTransform;
			if(button.code == 1)
			{
				sfxChannel = powerClick.play(0, 0, sfxTransform);
			}
			else
			{
				sfxChannel = buttonClick.play(0, 0, sfxTransform);
			}
			button.depress();
			bigScreen.clearMenus();
			var tempFunc:Function = function();
			switch(button.code)
			{
				//power button
				case 1:
				keyPrompt = true;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressInput, false, 0, true);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyReleaseInput, false, 0, true);
				bigScreen.addKeys();
				lightArray[0].toggleOn(false);
				bigScreen.play();
				/*
				keener.enable();
				arsus.enable();
				vandal.enable();
				launch.disable();
				music.enable();
				bigScreen.play();
				smallScreen.play();
				transitionScreen.gotoAndStop(1);
				*/
				break;
				
				//music button
				case 2:
				settingsContainer.muteMusic();
				if(bigScreen.currentFrame >= bigScreen.settingsFrame &&
				   bigScreen.currentFrame <= (bigScreen.settingsFrame + 5)) settingsContainer.visible = true;
				else if(bigScreen.currentFrame >= bigScreen.enemyInfoFrame &&
						bigScreen.currentFrame <= (bigScreen.enemyInfoFrame + 5))
						{
							bigScreen.intel.visible = true;
						}
				break;
				
				//sfx button
				case 3:
				settingsContainer.muteSfx();
				if(bigScreen.currentFrame >= bigScreen.settingsFrame &&
				   bigScreen.currentFrame <= (bigScreen.settingsFrame + 5)) settingsContainer.visible = true;
				else if(bigScreen.currentFrame >= bigScreen.enemyInfoFrame &&
						bigScreen.currentFrame <= (bigScreen.enemyInfoFrame + 5))
						{
							bigScreen.intel.visible = true;
						}   
				
				break;
				
				//credits button
				case 4:
				transition();
				tempFunc = function() {bigScreen.gotoAndPlay(bigScreen.creditsFrame)};
				break;
				
				//settings button
				case 5:
				transition();
				tempFunc = function() 
				{
					bigScreen.gotoAndPlay(bigScreen.settingsFrame); 
					bigScreen.settings.visible = true;
					if(settingsContainer.planesPlayed[0] && settingsContainer.planesPlayed[1] && settingsContainer.planesPlayed[2])
						settingsContainer.challengeModes.visible = true;
					else
						settingsContainer.challengeModes.visible = false;
					
				};
				break;
				
				//info button(s)
				case 6:
				switch( InfoButton(button).subcode)
				{
					case 1:
					transition();
					tempFunc = function() {bigScreen.gotoAndPlay(bigScreen.bulletInfoFrame)};
					break;
					
					case 2:
					transition();
					tempFunc = function() {bigScreen.gotoAndPlay(bigScreen.sniperInfoFrame)};
					break;
					
					case 3:
					transition();
					tempFunc = function() {bigScreen.gotoAndPlay(bigScreen.meleeInfoFrame)};
					break;
				}
				
				break;
				
				//basic plane
				case 7:
				transition();
				tempFunc = function()
				{		
					keener.lightUp();
					if(!arsus.disabled) arsus.resetColor();
					if(!vandal.disabled) vandal.resetColor();
					launch.enable();
					bigScreen.gotoAndPlay(bigScreen.bulletPlaneFrame);
					planeCode = 1;
				}
				break;
				
				//sniper plane
				case 8:
				transition();
				tempFunc = function()
				{						
					if(!keener.disabled) keener.resetColor();
					arsus.lightUp();
					if(!vandal.disabled) vandal.resetColor();
					launch.enable();
					bigScreen.gotoAndPlay(bigScreen.sniperPlaneFrame);
					buttonGlow.moveThis(launch.x, launch.y);
					planeCode = 2;
				}
				break;
				
				//melee plane
				case 9:
				transition();
				tempFunc = function()
				{		
					if(!keener.disabled) keener.resetColor();
					if(!arsus.disabled) arsus.resetColor();
					vandal.lightUp();
					launch.enable();
					if(debugMenu.meleePlane.pressed)
					{
						bigScreen.gotoAndPlay(792);
					}
					else if(Math.random() < 0.01)
					{
						bigScreen.gotoAndPlay(bigScreen.meleePlaneFrame + 6);
					}
					else
					{
						bigScreen.gotoAndPlay(bigScreen.meleePlaneFrame);
					}
					if(debugMenu.meleePlane.pressed) planeCode = 3;
					else planeCode = 4;
				}
				break;
				
				//enemy info
				case 10:
				transition();
				tempFunc = function() {bigScreen.gotoAndPlay(bigScreen.enemyInfoFrame); bigScreen.intel.visible = true;};
				break;
				
				//launch
				case 11:
				keener.disable();
				arsus.disable();
				vandal.disable();
				launch.disable();
				hasLaunched = true;
				transitionScreen.play();
				buttonGlow.visible = false;
				removeEventListener(Event.ENTER_FRAME, soundFadeIn);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressInput);
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleaseInput);
				fadingIn = false;
				addEventListener(Event.ENTER_FRAME, fadeMusicOut, false, 0, true);
				fadingOut = true;
				settingsContainer.updatePlayed(planeCode);
				break;
				
				case 0:
				(debugMenu.visible) ? debugMenu.visible = false : debugMenu.visible = true;
				unlockButtons();
				break;
				
				default:
				trace("u fucked up in buttonhandler @ titlescreen");
				break;
			}
			
			delayedFunctionCall(50, function(e:Event) {e.currentTarget.removeEventListener(e.type, arguments.callee); tempFunc();});
		}
		
		function startUp(e:Event)
		{
			++startupCounter;
			if(startupCounter == 1)
			{
				titleChannel = titleLoop.play(0, 10000, trans);
				addEventListener(Event.ENTER_FRAME, soundFadeIn, false, 0, true);
				fadingIn = true;
				for each(var light in lightArray)
				{
					light.short(false);
				}
			}
			else if (startupCounter == 15)
			{
				sfxTransform.volume = Number(settingsContainer.sfx.value/100.0)*0.25;
				sfxChannel.soundTransform = sfxTransform;
				sfxChannel = startupBeep.play(0, 0, sfxTransform);
				for each(var light2 in lightArray)
				{
					light2.long(true);
				}
			}
			else if (startupCounter == 40)
			{
				sfxTransform.volume = Number(settingsContainer.sfx.value/100.0)*0.85;
				sfxChannel.soundTransform = sfxTransform;
				sfxChannel = menuFan.play(0, 0, sfxTransform);
			}
			else if (startupCounter >= 50 && startupCounter < 80)
			{
				var index:int = startupCounter - 50;
				if(index < 24 && index % 2 == 0)
				{
					if( (index/2) < 9)
					{
						lightArray[(index/2)].light(true);
					}
					else
					{
						lightArray[(index/2)].short(true);
					}
				}
			}
			
			
			else if (startupCounter >= 80)
			{
				for each(var button in buttonArray)
				{
					button.enable();
				}
				
				launch.disable();
				power.disable();
				smallScreenFlicker.play();
				smallScreen.play();
				buttonGlow.visible = true;
				updateButtons();
				enemy.disable();
				transitionScreen.gotoAndStop(1);
				startingUp = false;
				bigScreen.gotoAndPlay(8);
				bigScreen.clearKeys();
				removeEventListener(Event.ENTER_FRAME, startUp);
			}
		}
		
		function soundFadeIn(e:Event)
		{
			trans.volume += .002;
			titleChannel.soundTransform = trans;
			var sliderVolume:Number = Number(settingsContainer.music.value)/100.0;
			if(titleChannel.soundTransform.volume >= sliderVolume)
			{
				trans.volume = sliderVolume;
				titleChannel.soundTransform = trans;
				removeEventListener(Event.ENTER_FRAME, soundFadeIn);
				fadingIn = false;
			}
		}
		
		function delayedFunctionCall(delay:int, func:Function) {
			//trace('going to execute the function you passed me in', delay, 'milliseconds');
			var timer:Timer = new Timer(delay, 1);
			timer.addEventListener(TimerEvent.TIMER, func);
			timer.start();
		}
		
		
		public function updatePlaneSelection(_buttonCode:uint)
		{
			buttonCode = _buttonCode;
		}
		
		private function keyPressInput(e:KeyboardEvent):void
		{
			switch (e.keyCode) {
				case Keyboard.UP:
				upDown = true;
				break;
				
				case Keyboard.RIGHT:
				rightDown = true;
				break;
				
				case Keyboard.LEFT:
				leftDown = true;
				break;
				
				case Keyboard.X:
				xDown = true;
				break;
				
				case Keyboard.C:
				cDown = true;
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
				upDown = false;
				break
				
				case Keyboard.RIGHT:
				rightDown = false;
				break;
				
				case Keyboard.LEFT:
				leftDown = false;
				break;
				
				case Keyboard.X:
				xDown = false;
				break;
				
				case Keyboard.C:
				cDown = false;
				break;
				
				default:
				break;
			}
		}

	}
	
}
