package  Sounds{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.display.MovieClip;
	import GameObjects.Players.PlaneGeneric;
	import flash.geom.Point;
	import Sounds.Sfx.*;
	
	public class SoundHandler extends MovieClip{
		private var sfxChannel:SoundChannel;
		private var sfxTransform:SoundTransform;
		private var sfxVolume:Number;
		
		private var musicChannel:SoundChannel;
		private var musicTransform:SoundTransform;
		private var musicVolume:Number;
		private var musicPlaying:int = 0;
		private var musicOnDeck:uint = 0;
		private var musicArray:Array;
		private var sfxArray:Array;
		private var planeMode:uint = 0;
		private var fadingIn:Boolean = false;
		private var fadingOut:Boolean = false;
		private var nemesisRepeat:Boolean = false;
		
		//music
		private var mainTheme:MainTheme = new MainTheme();
		private var beamNemesis:BeamNemesis = new BeamNemesis();
		private var blobNemesis:BlobNemesis = new BlobNemesis();
		private var chainNemesis:ChainNemesis = new ChainNemesis();
		private var resultsScreen:ResultsScreen = new ResultsScreen();
		
		//the wake because its an abberant monster disgusting
		private var wake:Wake = new Wake();
		private var wakeChannel:SoundChannel;
		private var wakeTransform:SoundTransform;
		private var wakePlaying:Boolean = false;
		
		//sfx
		private var battleshipExplode:BattleshipExplode = new BattleshipExplode();	//0
		private var boostOn:BoostOn = new BoostOn();								//1
		private var boostOff:BoostOff = new BoostOff();								//2
		private var regen:Regen = new Regen();										//3
		private var takeDmg:TakeDmg = new TakeDmg();								//4
		private var shootPlayerBullet:ShootPlayerBullet = new ShootPlayerBullet();	//5
		private var woosh:Woosh = new Woosh();										//6
		private var arsusBeam:ArsusBeam = new ArsusBeam();							//7
		private var arsusBlast:ArsusBlast = new ArsusBlast();						//8
		private var arsusBlastHit:ArsusBlastHit = new ArsusBlastHit();				//9
		private var keenerHit:KeenerHit = new KeenerHit();							//10
		private var enemyShoot:EnemyShoot = new EnemyShoot();						//11
		private var enemyPlaneDeath:EnemyPlaneDeath = new EnemyPlaneDeath();		//12
		private var missileHatch:MissileHatch = new MissileHatch();					//13
		private var missileFire:MissileFire = new MissileFire();					//14
		private var deathExplode:DeathExplode = new DeathExplode();					//15
		private var deathCrash:DeathCrash = new DeathCrash();						//16
		private var sawShoot:SawShoot = new SawShoot();								//17
		private var battleshipFire:BattleshipFire = new BattleshipFire();			//18
		private var shellHit:ShellHit = new ShellHit();								//19
		private var beamDie:BeamDie = new BeamDie();								//20
		private var chainWoosh:ChainWoosh = new ChainWoosh();						//21
		private var missileExplosion:MissileExplosion = new MissileExplosion();		//22
		private var blobDie:BlobDie = new BlobDie();								//23
		private var blobAbsorb:BlobAbsorb = new BlobAbsorb();						//24
		private var capsule:Capsule = new Capsule();								//25
		private var beamCharge:BeamCharge = new BeamCharge();						//26
		private var beamClose:BeamClose = new BeamClose();							//27
		private var beamOpen:BeamOpen = new BeamOpen();								//28
		private var beamShoot:BeamShoot = new BeamShoot();							//29
		private var chainDie:ChainDie = new ChainDie();								//30
		private var droneDie:DroneDie = new DroneDie();								//31
		
		private var sfxChannels:Vector.<SoundChannel>;
		private var sfxPointer:uint = 0;
		
		private var player:PlaneGeneric;
		private const NEAR_FILTER:Number = 320;
		private const MAX_DISTANCE:Number = 960;
		private const RANGE:Number = NEAR_FILTER + MAX_DISTANCE;

		public function SoundHandler(_sfxVolume:Number, _musicVolume:Number, _planeMode:uint, _player:PlaneGeneric) 
		{
			sfxVolume = _sfxVolume;
			musicVolume = _musicVolume;
			planeMode = _planeMode;
			player = _player;
			
			sfxTransform = new SoundTransform(sfxVolume, 0);
			musicTransform = new SoundTransform(musicVolume, 0);
			wakeChannel = new SoundChannel();
			wakeTransform = new SoundTransform(0.1, 0);
			
			sfxChannels = new Vector.<SoundChannel>();
			for(var i:int = 0; i < 10; ++i)
			{
				sfxChannels.push(new SoundChannel());
			}
			
			musicArray = new Array(null, mainTheme, beamNemesis, blobNemesis, chainNemesis, resultsScreen);
			sfxArray = new Array(battleshipExplode, boostOn, boostOff, regen, takeDmg, shootPlayerBullet, woosh, arsusBeam, arsusBlast, arsusBlastHit, keenerHit, 
								 enemyShoot, enemyPlaneDeath, missileHatch, missileFire, deathExplode, deathCrash, sawShoot, battleshipFire, shellHit, beamDie,
								 chainWoosh, missileExplosion, blobDie, blobAbsorb, capsule, beamCharge, beamClose, beamOpen, beamShoot, chainDie, droneDie);
		}
		
		private function modulate(audioSource:Point, volDamp:Number = 1):SoundTransform
		{
			var modVolume:Number;
			var pan:Number;
			var radialDistance:Number = dist(new Point(player.x, player.y), audioSource);
			if(radialDistance > RANGE) modVolume = 0;
			else if(radialDistance < NEAR_FILTER)
			{
				modVolume = (sfxVolume*volDamp);
			}
			else
			{
				radialDistance -= NEAR_FILTER;
				modVolume = (sfxVolume*volDamp)*((MAX_DISTANCE - radialDistance)/MAX_DISTANCE);
			}
			
			var xDistance:Number = audioSource.x - player.x;
			if( xDistance > RANGE) pan = 1;
			else if( xDistance < (RANGE*-1)) pan = -1;
			else
			{
				pan = (xDistance/RANGE);
			}
			return new SoundTransform(modVolume, pan);
			
		}
		
		public function wakeSound():void
		{
			if(wakeChannel == null)
			{
				wakeChannel = wake.play(0, 99999, wakeTransform);
			}
			if(player.y > 250 && player.health > 0)
			{
				if(!wakePlaying)
				{
					wakePlaying = true;
					wakeChannel = wake.play(0, 99999, wakeTransform);
				}
				else if(player.y < 370)
				{
					wakeTransform.volume = (player.y - 250)/450.0;
					wakeChannel.soundTransform = wakeTransform;
				}
			}
			else
			{
				wakeChannel.soundTransform.volume = 0;
				wakeChannel.stop();
				wakePlaying = false;
			}
		}
		
		private function sqr(x:Number):Number { return x * x }
		private function dist2(v:Point, w:Point):Number { return sqr(v.x - w.x) + sqr(v.y - w.y) }
		private function dist(v:Point, w:Point):Number { return Math.sqrt(dist2(v, w)); }
		
		public function playSfx(sfxCode:uint, audioSource:Point = null, volDamp:Number = 1):void
		{
			if(audioSource == null)
			{
				sfxChannels[sfxPointer] = sfxArray[sfxCode].play(0, 1, new SoundTransform(sfxVolume*volDamp, 0));
			}
			else
			{
				sfxChannels[sfxPointer] = sfxArray[sfxCode].play(0, 1, modulate(audioSource, volDamp));
			}
			sfxPointer++;
			if(sfxPointer == 10) sfxPointer = 0;
		}
		
		public function fadeMusic(musicCode:uint):void
		{
			if(musicPlaying == 0)
			{
				playMusic(musicCode);
				musicTransform.volume = 0;
				musicChannel.soundTransform = musicTransform;
				addEventListener(Event.ENTER_FRAME, fadeInMusic, false, 0, true);
				fadingIn = true;
				fadingOut = false
			}
			else
			{
				musicOnDeck = musicCode;
				addEventListener(Event.ENTER_FRAME, fadeOutMusic, false, 0, true);
				fadingOut = true;
				fadingIn = false;
			}
		}
		
		private function fadeInMusic(e:Event):void
		{
			musicTransform.volume += 0.005;
			musicChannel.soundTransform = musicTransform;
			if(musicTransform.volume >= musicVolume)
			{
				musicTransform.volume = musicVolume;
				removeEventListener(Event.ENTER_FRAME, fadeInMusic);
				fadingIn = false;
			}
		}
		
		private function fadeOutMusic(e:Event):void
		{
			musicTransform.volume -= 0.005;
			musicChannel.soundTransform = musicTransform;
			if(musicTransform.volume <= 0)
			{
				playMusic(musicOnDeck);
				musicTransform.volume = 0;
				musicChannel.soundTransform = musicTransform;
				removeEventListener(Event.ENTER_FRAME, fadeOutMusic);
				addEventListener(Event.ENTER_FRAME, fadeInMusic, false, 0, true);
				fadingOut = false;
				fadingIn = true;
			}
		}
		
		private function playMusic(musicCode:uint, repeat:Boolean = false):void
		{
			if(musicCode == 0)
			{
				musicChannel.stop();
				musicChannel = null;
				musicPlaying = -1;
				return;
			}
			if(musicCode == 5) repeat = true;
			
			musicPlaying = musicCode;
			if(repeat)  musicChannel = musicArray[musicCode].play(0, 99999, musicTransform);
			else musicChannel = musicArray[musicCode].play(0, 1, musicTransform);
			
			if(!repeat)
			{
				musicChannel.addEventListener(Event.SOUND_COMPLETE, changeTrack, false, 0, true);
			}
		}
		
		//quick and dirty
		private function changeTrack(e:Event)
		{
			if(musicPlaying == -1 || musicPlaying == 5)
			{
				return;
			}
			else if(musicPlaying == 1 || ((musicPlaying == 2 || musicPlaying == 3 || musicPlaying == 4) && !nemesisRepeat))
			{
				if(musicPlaying != 1) nemesisRepeat = true;
				switch(planeMode)
				{
					case 1:
					fadeMusic(2);
					break;
					
					case 2:
					fadeMusic(3);
					break;
					
					case 3:
					case 4:
					fadeMusic(4);
					break;
					
					default:
					trace("changing the track fucked up my dude");
					break;
				}
			}
			else
			{
				fadeMusic(1);
				nemesisRepeat = false;
			}
		}
		
		public function cleanUp()
		{
			playMusic(0);
			if(fadingIn) removeEventListener(Event.ENTER_FRAME, fadeInMusic);
			if(fadingOut) removeEventListener(Event.ENTER_FRAME, fadeOutMusic);
			//sfxChannel.stop();
		}

	}
	
}
