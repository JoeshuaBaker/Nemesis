package ReferenceObjects {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import ReferenceObjects.Buttons.ToggleBox;
	
	
	public class ScoreScreen extends MovieClip {
		
		public var playAgain:Boolean = false;
		public var toTitle:Boolean = false;
		
		[Embed(source="/../ASSETS/Nemesis.ttf",
        fontName = "Nemesis",
        mimeType = "application/x-font",
        advancedAntiAliasing="true",
        embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		private var nemesisFormat:TextFormat;
		
		private var planesKilled:uint;
		private var boatsKilled:uint;
		private var bshipsKilled:uint;
		private var nemesisesKilled:uint;
		private var playerCode:uint
		public var nemesisDiscovered:Boolean;
		
		private var planeCounter:TextField;
		private var boatCounter:TextField;
		private var bshipCounter:TextField;
		private var nemesisCounter:TextField;
		private var counterArray:Array;
		
		private var countingText:TextField;
		private var countingNum:uint = 0;
		private var countingMax:uint = 0;
		private var countingDone:Boolean = true;
		private var fieldsCounted:uint = 0;
		
		private var superweapon:Superweapon;
		private var blackOut:ColorTransform;
		
		private var counter:uint = 0;
		
		private var toTitleBox:ToggleBox;
		private var playAgainBox:ToggleBox;
		
		//text fields and buttons to reset game/load back to title
		//mouse listener that pops all numbers into fields when it hears click
		//same mouse listener can probably handle button functionality
		public function ScoreScreen(_planesKilled:uint, _boatsKilled:uint, _battleshipsKilled:uint, _nemesisesKilled:uint, _timeAlive:uint, _playerCode:uint, _nemesisDiscovered:Boolean) {
			addEventListener(Event.ENTER_FRAME, tally, false, 0, true);
			addEventListener(Event.ENTER_FRAME, buttonHandler, false, 0, true);
			planesKilled = _planesKilled;
			boatsKilled = _boatsKilled;
			bshipsKilled = _battleshipsKilled;
			nemesisesKilled = _nemesisesKilled;
			playerCode = _playerCode;
			nemesisDiscovered = _nemesisDiscovered;
			
			superweapon = new Superweapon();
			superweapon.x = -75;
			superweapon.y = 90;
			superweapon.gotoAndStop(_playerCode);
			blackOut = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
			superweapon.transform.colorTransform = blackOut;
			
			planeCounter = new TextField();
			boatCounter = new TextField();
			bshipCounter = new TextField();
			
			nemesisFormat = new TextFormat("Nemesis", 24, 0x4DFDFC);
			counterArray = new Array(planeCounter, boatCounter, bshipCounter);
			for(var i:int = 0; i < counterArray.length; ++i)
			{
				addChild(counterArray[i]);
				counterArray[i].defaultTextFormat = nemesisFormat;
				counterArray[i].text = "";
				counterArray[i].x = 80;
				counterArray[i].y = -158 + 70*i;
				counterArray[i].selectable = false;
			}
			
			nemesisCounter = new TextField();
			nemesisCounter.x = 80;
			nemesisCounter.y = 73;
			nemesisCounter.defaultTextFormat = nemesisFormat;
			nemesisCounter.selectable = false;
			addChild(nemesisCounter);
			
			toTitleBox = new ToggleBox(82, 168, false, true);
			playAgainBox = new ToggleBox(-83, 168, false, true);
		}
		
		private function tally(e:Event)
		{
			++counter;
			if(currentFrame == 51) 
			{
				addChild(toTitleBox);
				addChild(playAgainBox);
				addChild(superweapon);
			}
			if(counter > 60)
			{
				if(fieldsCounted == 0 && countingDone)
				{
					count(planeCounter, planesKilled);
				}
				else if(fieldsCounted == 1 && countingDone)
				{
					count(boatCounter, boatsKilled);
				}
				else if(fieldsCounted == 2 && countingDone)
				{
					count(bshipCounter, bshipsKilled);
				}
				else if(fieldsCounted == 3 && countingDone)
				{
					if(nemesisDiscovered)
					{
						blackOut.blueMultiplier = 1;
						blackOut.redMultiplier = 1;
						blackOut.greenMultiplier = 1;
						superweapon.transform.colorTransform = blackOut;
						count(nemesisCounter, nemesisesKilled);
					}
					else
					{
						fieldsCounted++;
						nemesisCounter.text = "?";
					}
				}
				else if(fieldsCounted > 3)
				{
					removeEventListener(Event.ENTER_FRAME, tally);
				}
			}
		}
		
		private function count(field:TextField, countMax:uint)
		{
			countingText = field;
			countingNum = 0;
			countingMax = countMax;
			countingDone = false;
			addEventListener(Event.ENTER_FRAME, countUp, false, 0, true);
		}
		
		private function countUp(e:Event)
		{
			countingNum += Math.ceil(countingMax/60);
			if(countingNum > countingMax) countingNum = countingMax;
			countingText.text = "" + countingNum;
			if(countingNum == countingMax) 
			{
				removeEventListener(Event.ENTER_FRAME, countUp);
				fieldsCounted++;
				countingDone = true;
			}
		}
		
		private function buttonHandler(e:Event):void
		{
			if(toTitleBox.pressed)
			{
				toTitle = true;
				removeEventListener(Event.ENTER_FRAME, buttonHandler);
			}
			else if(playAgainBox.pressed)
			{
				playAgain = true;
				removeEventListener(Event.ENTER_FRAME, buttonHandler);
			}
		}
	}
	
}
