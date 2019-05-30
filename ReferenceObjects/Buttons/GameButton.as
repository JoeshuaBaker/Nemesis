package  ReferenceObjects.Buttons {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import Sounds.*;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	
	public class GameButton extends MovieClip
	{
		var uiClick:UIClick = new UIClick();
		var uiMouseover:UIMouseover = new UIMouseover();
		public var pressedField:TextField = new TextField();
		public var inputField:TextField = new TextField();
		public var inputText:String = "";
		public var pressed:Boolean = false;
		public var code:uint = 0;
		public var disabled:Boolean = false;

		public function GameButton() 
		{
			stop();
			addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
			
			addEventListener(Event.ENTER_FRAME, updateText, false, 0, true);
			pressedField.y = -45;
			addChild(pressedField);
			pressedField.visible = false;
			
			inputField.type = TextFieldType.INPUT;
			inputField.x = 45;
			addChild(inputField)
			inputField.text = "0";
			inputField.textColor = 0xFF0000;
			inputField.addEventListener(KeyboardEvent.KEY_DOWN, getTextFromField, false, 0, true);
			inputField.visible = false;
			
		}
		
		function mOver(event:MouseEvent) 
		{
			gotoAndStop(2);
			//uiMouseover.play();
		}
		
		function mOut(event:MouseEvent) 
		{
			gotoAndStop(1);
		}
		
		function mDown(event:MouseEvent) 
		{
			gotoAndStop(3);
			//uiClick.play();
			if(pressed)
				pressed = false;
			else
				pressed = true;
		
		}
		
		public function depress():void
		{
			pressed = false;
		}
		
		function updateText(event:Event)
		{
			if(pressed)
			{
				pressedField.text = "On";
				pressedField.textColor = 0x66FF00;
			}
			else
			{
				pressedField.text = "Off";
				pressedField.textColor = 0xFF0000;
			}
		}
		
		function getTextFromField(e:KeyboardEvent)
		{
			if(e.keyCode == 13)
			{
				inputText = inputField.text;
				inputField.textColor = 0x66FF00;
			}
			else
			{
				inputField.textColor = 0xFF0000;
			}
		}
		
		public function disable()
		{
			removeEventListener(MouseEvent.MOUSE_OUT, mOut);
			removeEventListener(MouseEvent.MOUSE_OVER, mOver);
			removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
			var greyOut:ColorTransform = new ColorTransform();
			greyOut.redOffset = -100;
			this.transform.colorTransform = greyOut;
			disabled = true;
		}
		
		public function lightUp()
		{
			var lightup:ColorTransform = new ColorTransform();
			lightup.redOffset = 50;
			this.transform.colorTransform = lightup;
		}
		
		public function resetColor()
		{
			var reset:ColorTransform = new ColorTransform();
			this.transform.colorTransform = reset;
		}
		
		public function enable()
		{
			//also resets the button
			addEventListener(MouseEvent.MOUSE_OUT, mOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
			var reset:ColorTransform = new ColorTransform();
			this.transform.colorTransform = reset;
			pressed = false;
			disabled = false;
			inputText = "";
			inputField.text = "0";
			inputField.textColor = 0x66FF00;
		}

	}
	
}
