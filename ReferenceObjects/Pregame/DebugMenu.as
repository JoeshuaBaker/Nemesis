package ReferenceObjects.Pregame
{
	
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import ReferenceObjects.Buttons.GameButton;
	import ReferenceObjects.Buttons.ToggleBox;
	
	public class DebugMenu extends MovieClip
	{
		public var invincibility:GameButton;
		public var collision:ToggleBox;
		public var hitboxes:ToggleBox;
		public var children:ToggleBox;
		public var meleePlane:ToggleBox;
		var toTitleScreen:GameButton;
		

		public function DebugMenu()
		{
			invincibility = GameButton(getChildByName("invincibilityButton"));
			invincibility.pressedField.visible = true;
			
			toTitleScreen = GameButton(getChildByName("toTitleScreenButton"));
						
			collision = new ToggleBox(-20, -225, false);
			addChild(collision);
			hitboxes = new ToggleBox(-20, -175, false);
			addChild(hitboxes);
			children = new ToggleBox(-20, -125, false);
			addChild(children);
			meleePlane = new ToggleBox(80, -225, false);
			addChild(meleePlane);
			
			addEventListener(Event.ENTER_FRAME, buttonHandler);
			
			
		}
		
		function buttonHandler(e:Event)
		{
			if(toTitleScreen.pressed)
			{
				visible = false;
				toTitleScreen.pressed = false;
			}
		}
	}
	
}
