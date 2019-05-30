package ReferenceObjects {
	
	import flash.display.MovieClip;
	import GameObjects.Projectiles.WeaponHandler;
	import GameObjects.Enemies.EnemyHandler;
	import collision.CollisionHandler;
	import GameObjects.Players.PlaneGeneric;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.system.System;
	
	
	public class UIOverlay extends MovieClip {
		
		var startTime:Number;
		var framesNumber:Number = 0;
		var fps:TextField = new TextField();
		var children:TextField = new TextField();
		var memory:TextField = new TextField();
		var textSettings:TextFormat = new TextFormat();
		var nemesisFont:NemesisFont = new NemesisFont();
		var player:PlaneGeneric;
		var collisionHandler:CollisionHandler;
		
		public function UIOverlay(_player:PlaneGeneric, _weaponHandler:WeaponHandler, _enemyHandler:EnemyHandler, _collisionHandler:CollisionHandler, _settings:SettingsContainer) {
			if(_settings.fps.pressed) fpsCounter();
			if(_settings.debugMenu.children.pressed) countChildren();
			if(_settings.memory.pressed) showMemory();
			textSettings.font = nemesisFont.fontName;
			player = _player;
			collisionHandler = _collisionHandler;
		}
		
		public function showMemory()
		{
			memory = new TextField();
			addChild(memory);
			memory.x = 550;
			memory.y = -210;
			memory.textColor = 0xFF0000;
			memory.defaultTextFormat = textSettings;
			
			addEventListener(Event.ENTER_FRAME, checkMemory, false, 0, true);
		}
		
		public function checkMemory(e:Event)
		{
			memory.text = Number(System.totalMemory/1048576).toFixed(2) + "Mb";
		}
		
		public function followPlayer()
		{
			x = player.x;
			y = player.y;
		}
		
		private function fpsCounter()
		{
			startTime = getTimer();
			addChild(fps);
			fps.x = 550;
			fps.y = -310;
			fps.textColor = 0xFF0000;
			fps.defaultTextFormat = textSettings;
			 
			addEventListener(Event.ENTER_FRAME, checkFPS, false, 0, true);

		}
		
		function checkFPS(e:Event):void
		{
			var currentTime:Number = (getTimer() - startTime) / 1000;
		 
			framesNumber++;
			 
			if (currentTime > 1)
			{
				fps.text = "FPS: " + (Math.floor((framesNumber/currentTime)*10.0)/10.0);
				startTime = getTimer();
				framesNumber = 0;
			}
		}
		
		private function countChildren()
		{
			addChild(children);
			children.x = 550;
			children.y = -260;
			children.textColor = 0xFF0000;
			children.defaultTextFormat = textSettings;
			 
			addEventListener(Event.ENTER_FRAME, displayChildren, false, 0, true);

		}
		
		function displayChildren(e:Event):void
		{
			children.text = "Obj: " + collisionHandler.countChildren();
		}

	}
	
}
