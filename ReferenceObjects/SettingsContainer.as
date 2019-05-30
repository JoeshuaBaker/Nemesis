package ReferenceObjects {
	
	import flash.display.MovieClip;
	import ReferenceObjects.Buttons.ToggleBox;
	import ReferenceObjects.Buttons.NemesisSlider;
	import flash.events.Event;
	import ReferenceObjects.Pregame.DebugMenu;
	import flash.display.Shape;
	
	
	public class SettingsContainer extends MovieClip {
		
		public var nobg:ToggleBox;
		public var fps:ToggleBox;
		public var memory:ToggleBox;
		public var boxes:Vector.<ToggleBox>;
		private var sliders:SliderContainer;
		public var music:NemesisSlider;
		public var sfx:NemesisSlider;
		public var backgrounds:NemesisSlider;
		public var sunBeams:NemesisSlider;
		public var stars:NemesisSlider;
		public var planesPlayed:Vector.<Boolean> = new <Boolean>[false, false, false];
		public var nemesisesRevealed:Vector.<Boolean> = new <Boolean>[false, false, false];
		public var nemesisesKilled:Vector.<Boolean> = new <Boolean>[false, false, false];
		public var musicVol:uint = 0;
		public var sfxVol:uint = 0;
		public var high:ToggleBox;
		public var medium:ToggleBox;
		public var low:ToggleBox;
		public var debugMenu:DebugMenu;
		public var challengeModes:MovieClip;
		public var stamina:ToggleBox;
		public var onslaught:ToggleBox;
		//settings toggle boxes: -140, 0, 140
		
		public function SettingsContainer() {
			
			challengeModes = MovieClip(getChildByName("ChallengeModesStage"));
			nobg = new ToggleBox(-210, 50, false);
			fps = new ToggleBox(-16, 50, false);
			memory = new ToggleBox(178, 50, false);
			high = new ToggleBox(88, -205, false);
			medium = new ToggleBox(-16, -205, false);
			low = new ToggleBox(-120, -205, false);
			stamina = new ToggleBox(-135, 199.5, false);
			stamina.visible = false;
			onslaught = new ToggleBox(103, 199.5, false);
			onslaught.visible = false;
			
			sliders = new SliderContainer();
			addChild(sliders);
			
			music = sliders.addSlider(-270, -125, 100, 30);
			
			sfx = sliders.addSlider(22, -125, 100, 50);
			
			sunBeams = sliders.addSlider(-270, -45, 3, 2);
			
			stars = sliders.addSlider(22, -45, 100, 30);
			
			
			boxes = new <ToggleBox>[fps, memory, nobg, high, medium, low, stamina, onslaught];
			for(var i:int = 0; i < boxes.length; ++i)
			{
				addChild(boxes[i]);
			}
			visible = false;
			
			addEventListener(Event.ENTER_FRAME, upkeep, false, 0, true);
			
		}
		
		public function upkeep(e:Event)
		{
			if(low.pressed)
			{
				sunBeams.goto(0);
				stars.goto(0);
				low.changeState(false);
			}
			else if(medium.pressed)
			{
				sunBeams.goto(2);
				stars.goto(30);
				medium.changeState(false);
			}
			else if(high.pressed)
			{
				sunBeams.goto(3);
				stars.goto(75);
				high.changeState(false);
			}
			stamina.visible = challengeModes.visible;
			onslaught.visible = challengeModes.visible;
		}
		
		public function adoptSettings(old:SettingsContainer):void
		{
			nobg.changeState(old.nobg.pressed);
			debugMenu.collision.changeState(old.debugMenu.collision.pressed);
			debugMenu.hitboxes.changeState(old.debugMenu.hitboxes.pressed);
			fps.changeState(old.fps.pressed);
			debugMenu.children.changeState(old.debugMenu.children.pressed);
			memory.changeState(old.memory.pressed);
			stamina.changeState(old.stamina.pressed);
			onslaught.changeState(old.onslaught.pressed);
			
			music.goto(old.music.value);
			sfx.goto(old.sfx.value);
			sunBeams.goto(old.sunBeams.value);
			stars.goto(old.stars.value);
			planesPlayed[0] = old.planesPlayed[0];
			planesPlayed[1] = old.planesPlayed[1];
			planesPlayed[2] = old.planesPlayed[2];
			nemesisesRevealed[0] = old.nemesisesRevealed[0];
			nemesisesRevealed[1] = old.nemesisesRevealed[1];
			nemesisesRevealed[2] = old.nemesisesRevealed[2];
			nemesisesKilled[0] = old.nemesisesKilled[0];
			nemesisesKilled[1] = old.nemesisesKilled[1];
			nemesisesKilled[2] = old.nemesisesKilled[2];
			musicVol = old.musicVol;
			sfxVol = old.sfxVol;
		}
		
		public function updatePlayed(planeCode:uint):void
		{
			switch(planeCode)
			{
				case 1:
				planesPlayed[1] = true;
				break;
				
				case 2:
				planesPlayed[0] = true;
				break;
				
				case 3:
				case 4:
				planesPlayed[2] = true;
				break;
			}
		}
		
		public function updateNemesis(planeCode:uint):void
		{
			switch(planeCode)
			{
				case 1:
				nemesisesRevealed[1] = true;
				break;
				
				case 2:
				nemesisesRevealed[0] = true;
				break;
				
				case 3:
				case 4:
				nemesisesRevealed[2] = true;
				break;
			}
		}
		
		public function muteMusic()
		{
			if(music.value != 0)
			{
				musicVol = music.value;
				music.goto(0);
			}
			else
			{
				music.goto(musicVol);
				musicVol = 0;
			}
		}
		
		public function muteSfx()
		{
			if(sfx.value != 0)
			{
				sfxVol = sfx.value;
				sfx.goto(0);
			}
			else
			{
				sfx.goto(sfxVol);
				sfxVol = 0;
			}
		}

	}
	
}
