package ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import ReferenceObjects.AnimationSymbols.KeyLight;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class KeyPrompt extends MovieClip {
		
		private var light:KeyLight;
		public var pressed:Boolean = false;
		[Embed(source="/../ASSETS/Nemesis.ttf",
        fontName = "Nemesis",
        mimeType = "application/x-font",
        advancedAntiAliasing="true",
        embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		private var nemesisFormat:TextFormat;
		public var noticeText:TextField;
		
		public function KeyPrompt(type:uint) {
			stop();
			light = new KeyLight();
			nemesisFormat = new TextFormat("Nemesis", 12, 0x4DFDFC);
			noticeText = new TextField();
			noticeText.defaultTextFormat = nemesisFormat;
			noticeText.y = -60;
			noticeText.x = -25;
			noticeText.width = 100;
			noticeText.wordWrap = true;
			noticeText.text = "";
			addChild(noticeText);
			addChild(light);
			switch(type)
			{
				case 1:
				gotoAndStop(1);
				x = 0;
				noticeText.text = "To";
				break;
				
				case 2:
				gotoAndStop(3);
				x = 100;
				noticeText.text = "Unlock";
				break;
				
				case 3:
				gotoAndStop(5);
				x = 200;
				noticeText.text = "Console";
				break;
				
				case 4:
				gotoAndStop(7);
				x = -200;
				noticeText.text = "Press";
				break;
				
				case 5:
				gotoAndStop(9);
				x = -100;
				noticeText.text = "Keys";
				break;
			}
		}
		
		public function lightUp():void
		{
			light.play();
			pressed = true;
		}
	}
	
}
