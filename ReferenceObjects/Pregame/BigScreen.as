package  ReferenceObjects.Pregame
{
	
	import flash.display.MovieClip;
	import ReferenceObjects.Buttons.GameButton;
	import ReferenceObjects.SettingsContainer;
	import ReferenceObjects.Buttons.KeyPrompt;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ReferenceObjects.IntelScreen;
	
	
	public class BigScreen extends MovieClip {
		
		public var bulletPlaneFrame:uint = 798;
		public var sniperPlaneFrame:uint = 804;
		public var meleePlaneFrame:uint = 812;
		public var bulletInfoFrame:uint = 822;
		public var sniperInfoFrame:uint = 828;
		public var meleeInfoFrame:uint = 834;
		public var enemyInfoFrame:uint = 840;
		public var creditsFrame:uint = 848;
		public var settingsFrame:uint = 852;
		
		public var settings:SettingsContainer;
		public var intel:IntelScreen;
		
		public var leftKey:KeyPrompt;
		public var upKey:KeyPrompt;
		public var rightKey:KeyPrompt;
		public var xKey:KeyPrompt;
		public var cKey:KeyPrompt;
		
		public var secretRect:MovieClip;
		
		public function BigScreen() {
			stop();
			settings = new SettingsContainer();
			intel = new IntelScreen(settings);
			addChild(intel);
			addChild(settings);
			leftKey = new KeyPrompt(1);
			upKey = new KeyPrompt(2);
			rightKey = new KeyPrompt(3);
			xKey = new KeyPrompt(4);
			cKey = new KeyPrompt(5);
		}
		
		public function clearMenus():void
		{
			settings.visible = false;
			intel.visible = false;
		}
		
		public function addKeys():void
		{
			addChild(leftKey);
			addChild(upKey);
			addChild(rightKey);
			addChild(xKey);
			addChild(cKey);
		}
		
		public function updateKeys(keyCode:uint):Boolean
		{
			switch(keyCode)
			{
				case 1:
				leftKey.gotoAndStop(2);
				leftKey.lightUp();
				leftKey.noticeText.text = "Rotate Left.";
				break;
				
				case 2:
				upKey.gotoAndStop(4);
				upKey.lightUp();
				upKey.noticeText.text = "Accelerate Forward.";
				break;
				
				case 3:
				rightKey.gotoAndStop(6);
				rightKey.lightUp();
				rightKey.noticeText.text = "Rotate Right.";
				break;
				
				case 4:
				xKey.gotoAndStop(8);
				xKey.lightUp();
				xKey.noticeText.text = "Primary Weapon.";
				break;
				
				case 5:
				cKey.gotoAndStop(10);
				cKey.lightUp();
				cKey.noticeText.text = "Secondary Weapon.";
				break;
			}
			
			if(leftKey.pressed && upKey.pressed && rightKey.pressed && xKey.pressed && cKey.pressed)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function clearKeys():void
		{
			removeChild(leftKey);
			removeChild(upKey);
			removeChild(rightKey);
			removeChild(xKey);
			removeChild(cKey);
		}
		
	}
	
}
