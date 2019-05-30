package ReferenceObjects.Buttons {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class NemesisSlider extends MovieClip {
		
		public var degrees:Number = 1;
		public var value:uint = 1;
		private var bit:MovieClip;
		private const LOW_BOUND:Number = 10;
		private const HIGH_BOUND:Number = 240;
		private var lock:Boolean = true;
		private var valueText:TextField;
		
		[Embed(source="/../ASSETS/Nemesis.ttf",
        fontName = "Nemesis",
        mimeType = "application/x-font",
        advancedAntiAliasing="true",
        embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		public function NemesisSlider(_degrees:uint, _value:uint) {
			degrees = _degrees;
			value = _value;
			bit = MovieClip(getChildByName("bitStage"));
			valueText = new TextField();
			valueText.defaultTextFormat = new TextFormat("Nemesis", 16, 0x990000);
			valueText.embedFonts = true;
			valueText.y = -23;
			valueText.x = 5;
			valueText.selectable = false;
			valueText.alpha = .99;
			addChild(valueText);
			bit.stop();
			
			goto(_value);
			cancel();
			
			addEventListener(MouseEvent.MOUSE_OVER, mOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mDown, false, 0, true);
			addEventListener(Event.ENTER_FRAME, drag, false, 0, true);
		}
		
		public function mOver(e:MouseEvent)
		{
			if(lock)
				bit.gotoAndStop(1);
		}
		
		public function mDown(e:MouseEvent)
		{
			if(mouseY > 0 && mouseY <= 14 && mouseX <= 250)
			{
				bit.gotoAndStop(3);
				lock = false;
			}
		}
		
		public function cancel()
		{
			lock = true;
			value = Math.ceil(degrees*((bit.x - LOW_BOUND) /(HIGH_BOUND - LOW_BOUND)));
			valueText.text = ("" + value);
			bit.gotoAndStop(1);
			bindBit();
		}
		
		private function drag(e:Event)
		{
			if(!lock)
			{
				if(mouseX >= 0 && mouseX <= 250)
				{
					bit.x = mouseX - (mouseX % ((HIGH_BOUND - LOW_BOUND) / degrees));
					bindBit();
					value = Math.ceil(degrees*((bit.x - LOW_BOUND) /(HIGH_BOUND - LOW_BOUND)));
					valueText.text = ("" + value);
				}
				else
				{
					bindBit();
				}
			}
		}
		
		public function goto(_value:uint)
		{
			if(value <= degrees)
			{
				var increment:Number = (HIGH_BOUND - LOW_BOUND)/degrees;
				bit.x = LOW_BOUND + increment * _value;
				value = _value;
				valueText.text = ("" + value);
				bindBit();
			}
		}
		
		private function bindBit()
		{
			if(bit.x < LOW_BOUND)
				bit.x = LOW_BOUND;
			else if(bit.x > HIGH_BOUND)
				bit.x = HIGH_BOUND;
		}
		
		
	}
	
}
