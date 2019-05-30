package ReferenceObjects {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import ReferenceObjects.Buttons.ToggleBox;
	
	
	public class IntelScreen extends MovieClip {
		
		private var settings:SettingsContainer;
		public var enemyPlane:InfoPane;
		public var smallBoat:InfoPane;
		public var battleship:InfoPane;
		public var blob:InfoPane;
		public var beam:InfoPane;
		public var chain:InfoPane;
		public var returnBox:ToggleBox;
		private var panes:Vector.<InfoPane>;
		
		public function IntelScreen(_settings:SettingsContainer) 
		{
			visible = false;
			settings = _settings;
			stop();
			
			
			enemyPlane = new InfoPane(2);
			enemyPlane.x = -181;
			enemyPlane.y = -121.5;
			addChild(enemyPlane);
			
			smallBoat = new InfoPane(3);
			smallBoat.x = 0;
			smallBoat.y = -121.5;
			addChild(smallBoat);
			
			battleship = new InfoPane(4);
			battleship.x = 181;
			battleship.y = -121.5;
			addChild(battleship);
			
			blob = new InfoPane();
			blob.x = -181;
			blob.y = 125.5;
			addChild(blob);
			
			beam = new InfoPane();
			beam.x = 0;
			beam.y = 125.5;
			addChild(beam);
			
			chain = new InfoPane();
			chain.x = 181;
			chain.y = 125.5;
			addChild(chain);
			
			returnBox = new ToggleBox(-260, -245, false);
			addChild(returnBox);
			returnBox.visible = false;
			
			addEventListener(Event.ENTER_FRAME, handlePanes, false, 0, true);
			panes = new <InfoPane>[enemyPlane, smallBoat, battleship, blob, beam, chain];
		}
	
		public function updatePanes():void
		{
			if( settings.nemesisesRevealed[0] )
			{
				blob.declassify(1);
			}
			if( settings.nemesisesRevealed[1] )
			{
				beam.declassify(2);
			}
			if( settings.nemesisesRevealed[2] )
			{
				chain.declassify(3);
			}
		}
		
		private function handlePanes(e:Event):void
		{
			if(visible)
			{
				for(var i:uint = 0; i < panes.length; ++i)
				{
					if(panes[i].pressed)
					{
						transition(i + 2);
						panes[i].pressed = false;
					}
				}
				
				if(currentFrame > 1)
				{
					if(returnBox.pressed)
					{
						returnBox.changeState(false);
						transition(1);
					}
				}
			}
		}
		
		private function transition(type:uint = 1):void
		{
			gotoAndStop(type);
			if(type == 1)
				enablePanes();
			else
				disablePanes();
		}
		
		private function disablePanes():void
		{
			for(var i:uint = 0; i < panes.length; ++i)
			{
				panes[i].disable();
			}
			returnBox.visible = true;
		}
		
		private function enablePanes():void
		{
			for(var i:uint = 0; i < panes.length; ++i)
			{
				panes[i].enable();
			}
			returnBox.visible = false;
		}
	
	}
}