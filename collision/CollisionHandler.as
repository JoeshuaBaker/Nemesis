package collision
{
	import GameObjects.Enemies.*;
	import GameObjects.Projectiles.*
	import GameObjects.Players.*;
	import Interfaces.Collidable;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import ReferenceObjects.SettingsContainer;
	import Sounds.SoundHandler;

	public class CollisionHandler extends MovieClip
	{

		private var playerBullets:ProjectileCollisionGroup;
		private var playerBulletsArray:Array;
		private var collideWithPlayer:CollisionList;
		private var collideWithPlayerArray:Array;
		private var enemiesArray:Array;
		public var player:PlaneGeneric;
		public var playerMode:uint = 0;
		public var precise:Boolean = false;
		var testShape:Shape;
		var numOfCollisions:uint = 0;
		private var soundHandler:SoundHandler;


		public function CollisionHandler( newPlayer:PlaneGeneric, _settings:SettingsContainer, _soundHandler:SoundHandler )
		{
			precise = _settings.debugMenu.collision.pressed;
			player = newPlayer;
			soundHandler = _soundHandler;
			
			testShape = new Shape();
			addChild(testShape);
			
			if(player is BasicPlane)
				playerMode = 0;
			else if(player is SniperPlane)
				playerMode = 1;
			else if(player is MeleePlane)
				playerMode = 2;
			else if(player is SawPlane)
				playerMode = 3;
			
			if(precise)
			{
				playerBullets = new ProjectileCollisionGroup();
				playerBullets.alphaThreshold = .99;
	
				collideWithPlayer = new CollisionList(player);
				collideWithPlayer.alphaThreshold = .99;
			}
			else
			{
				playerBulletsArray = new Array();
				enemiesArray = new Array();
				collideWithPlayerArray = new Array();
			}
		}
		
		public function addList(object:Collidable, listCode:uint)
		{
			if(precise)
			{
				switch(listCode)
				{
					case 0:
					playerBullets.addItem(object);
					break;
					
					case 1:
					collideWithPlayer.addItem(object);
					break;
				}
			}
			else
			{
				switch(listCode)
				{
					case 0:
					if(object is Projectile)
						playerBulletsArray.push(object);
					else
						enemiesArray.push(object);
					break;
					
					case 1:
					collideWithPlayerArray.push(object);
					break;
				}
			}
		}
		
		public function countChildren():uint
		{
			return (precise) ? playerBullets.numChildren + collideWithPlayer.numChildren : playerBulletsArray.length + enemiesArray.length + collideWithPlayerArray.length;
		}
		
		public function removeList(object:Collidable, listCode:uint)
		{
			if(precise)
			{
				switch(listCode)
				{
					case 0:
					if(playerBullets.isInList(object))
						playerBullets.removeItem(object);
					break;
					
					case 1:
					if(collideWithPlayer.isInList(object))
						collideWithPlayer.removeItem(object);
					break;
				}
			}
			else
			{
				var index:uint = 0;
				switch(listCode)
				{
					case 0:
					if(object is Projectile)
					{
						index = playerBulletsArray.indexOf(object);
						if(index == -1) return;
						playerBulletsArray.splice(index, 1);
					}
					else
					{
						index = enemiesArray.indexOf(object);
						if(index == -1) return;
						enemiesArray.splice(index, 1);
					}
					break;
					
					case 1:
					index = collideWithPlayerArray.indexOf(object);
					if(index == -1) return;
					collideWithPlayerArray.splice(index, 1);
					break;
				}
			}
		}
		
		public function checkAllCollisions():Array
		{
			var collisionArray:Array = new Array();
			var collisionObject:Object;
			var colCounter:uint = 0;
			if(player is SawPlane)
			{
				for(var i:int = collideWithPlayerArray.length - 1; i >= 0; --i)
				{
					if(((Math.abs(player.x - collideWithPlayerArray[i].x) < 200 &&
					   Math.abs(player.y - collideWithPlayerArray[i].y) < 100) ||
					   collideWithPlayerArray[i] is ChainDrone) &&
					   checkCollisionSAT(player, collideWithPlayerArray[i]))
					  
					{
						collisionObject = {object1:player, object2:collideWithPlayerArray[i]};
						collisionArray.push(collisionObject);
						if(player.health > 0) soundHandler.playSfx(4);
					}
					if((player as SawPlane).sawblade1.visible)
					{
						if(checkCollisionSAT((player as SawPlane).sawblade1, collideWithPlayerArray[i]))
						{
							collisionObject = {object1:player, object2:collideWithPlayerArray[i]};
							(player as SawPlane).sawblade1.makeSparks(collideWithPlayerArray[i] is SmallBoat || collideWithPlayerArray[i] is Battleship);
							collisionArray.push(collisionObject);
						}
					}
					if((player as SawPlane).sawblade2.visible)
					{
						if(checkCollisionSAT((player as SawPlane).sawblade2, collideWithPlayerArray[i]))
						{
							collisionObject = {object1:player, object2:collideWithPlayerArray[i]};
							(player as SawPlane).sawblade2.makeSparks(collideWithPlayerArray[i] is SmallBoat || collideWithPlayerArray[i] is Battleship);
							collisionArray.push(collisionObject);
						}
					}
				}

			}
			else
			{
				for(var n:int = collideWithPlayerArray.length - 1; n >= 0; --n)
				{
					if((Math.abs(player.x - collideWithPlayerArray[n].x) < 200 && 
					   Math.abs(player.y - collideWithPlayerArray[n].y) < 100) ||
					   collideWithPlayerArray[n] is ChainDrone)
					{
						if(checkCollisionSAT(player, collideWithPlayerArray[n]))
						{
							collisionObject = {object1:player, object2:collideWithPlayerArray[n]};
							collisionArray.push(collisionObject);
							if(player.health > 0 && !(player is MeleePlane)) soundHandler.playSfx(4);
						}
					}
				}
			}			
			
			var object1:MovieClip;
			var object2:MovieClip;
			var object1X:Number;
			var object1Y:Number;
			
			for(var j:int = playerBulletsArray.length - 1; j >= 0; --j)
			{
				object1 = playerBulletsArray[j];
				object1X = object1.x;
				object1Y = object1.y;
				
				for(var k:int = enemiesArray.length - 1; k >= 0; --k)
				{
					object2 = enemiesArray[k];
					
					if((Math.abs(object1X - object2.x) < 100 
			  		&& Math.abs(object1Y - object2.y) < 50)
					|| object1 is SniperBullet)
					{
						if(checkCollisionSAT((object1 as Collidable), (object2 as Collidable)))
						{
							collisionObject = {object1:object1, object2:object2};
							collisionArray.push(collisionObject);							
						}
					}
				}
			}
			return collisionArray;
		}
		
		public function checkCollisionSAT(object1:Collidable, object2:Collidable):Boolean
		{
			if(object1.isHitPoly() && object2.isHitPoly())
			{
				//two hit polys
				var normalsObj1:Vector.<Vector2d> = getNormals(object1);
				var normalsObj2:Vector.<Vector2d> = getNormals(object2);
				var allNormals:Vector.<Vector2d> = normalsObj1.concat(normalsObj2);
				var obj1Vectors:Vector.<Vector2d> = getVectors(object1);
				var obj2Vectors:Vector.<Vector2d> = getVectors(object2);
				var obj1MinMax:Object;
				var obj2MinMax:Object;
				
				if (pnpolyVector(obj1Vectors, (object2 as MovieClip).x, (object2 as MovieClip).y) || pnpolyVector(obj2Vectors, (object1 as MovieClip).x, (object1 as MovieClip).y)) return true;
				for(var i:int = allNormals.length - 1; i >= 0; --i)
				{
					obj1MinMax = getMinMax(obj1Vectors, allNormals[i]);
					obj2MinMax = getMinMax(obj2Vectors, allNormals[i]);
					if(obj1MinMax.max < obj2MinMax.min || obj2MinMax.max < obj1MinMax.min) return false;
				}
				return true;
			}		
			else if((object1.isHitPoly() && object2.isHitCircle()) || (object1.isHitCircle() && object2.isHitPoly()))
			{
				//poly and circle case
				//https://gamedevelopment.tutsplus.com/tutorials/collision-detection-using-the-separating-axis-theorem--gamedev-169
				//revamp this to actually work
				//maybe check if collision post-rotation is coming through properly first...
				var poly:Vector.<Point>;
				var circle:Vector.<Number>; //[0] = x, [1] = y, [2] = r
				
				if(object1.isHitPoly())
				{
					poly = object1.getHitPoly();
					circle = object2.getHitCircle();
				}
				else
				{
					poly = object2.getHitPoly();
					circle = object1.getHitCircle();
				}
				var center:Point = new Point(circle[0], circle[1]);
				
				
				for(var n:int = poly.length - 2; n >= 0; --n)
				{
					//trace(distToSegment(center, poly[n], poly[n+1]) + " vs.(<) " + circle[2]);
					if(distToSegment(center, poly[n], poly[n + 1]) < circle[2])
					   return true;
				}
				if(distToSegment(center, poly[poly.length - 1], poly[0]) < circle[2]) return true;
				else
					//return false;
					return pnpoly(poly, center.x, center.y);
				
			}
			else if(object1.isHitCircle() && object2.isHitCircle())
			{
				//circle and circle case
				var circle1:Vector.<Number> = object1.getHitCircle();
				var circle2:Vector.<Number> = object2.getHitCircle();
				return ((circle2[0] - circle1[0])*(circle2[0] - circle1[0]) + (circle2[1] - circle1[1])*(circle2[1] - circle1[1]) <= (circle1[2] + circle2[2])*(circle1[2] + circle2[2]));
				
			}
			else
				return false;
		}

		private function pnpoly(vert:Vector.<Point>, testx:Number, testy:Number):Boolean
		{
		  var i:int = 0;
		  var j:int = 0;
		  var c:Boolean = false;
		  var nvert:int = vert.length;
		  for (i = 0, j = nvert-1; i < nvert; j = i++) {
			if ( ((vert[i].y>testy) != (vert[j].y>testy)) &&
			 (testx < (vert[j].x-vert[i].x) * (testy-vert[i].y) / (vert[j].y-vert[i].y) + vert[i].x) )
			   c = !c;
		  }
		  return c;
		}
		
		private function pnpolyVector(vert:Vector.<Vector2d>, testx:Number, testy:Number):Boolean
		{
		  var i:int = 0;
		  var j:int = 0;
		  var c:Boolean = false;
		  var nvert:int = vert.length;
		  for (i = 0, j = nvert-1; i < nvert; j = i++) {
			if ( ((vert[i].y>testy) != (vert[j].y>testy)) &&
			 (testx < (vert[j].x-vert[i].x) * (testy-vert[i].y) / (vert[j].y-vert[i].y) + vert[i].x) )
			   c = !c;
		  }
		  return c;
		}


		private function sqr(x:Number):Number { return x * x }
		private function dist2(v:Point, w:Point):Number { return sqr(v.x - w.x) + sqr(v.y - w.y) }
		private function dist(v:Point, w:Point):Number { return Math.sqrt(dist2(v, w)); }
		private function distToSegmentSquared(p:Point, v:Point, w:Point):Number {
		  var l2:Number = dist2(v, w);
		  if (l2 == 0) return dist2(p, v);
		  var t:Number = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
		  t = Math.max(0, Math.min(1, t));
		  return dist2(p, new Point(v.x + t * (w.x - v.x), v.y + t * (w.y - v.y) ) );
		}
		public function distToSegment(p:Point, v:Point, w:Point):Number { return Math.sqrt(distToSegmentSquared(p, v, w)); }
		
		private function getNormals(object:Collidable):Vector.<Vector2d>
		{
			var normals:Vector.<Vector2d> = new Vector.<Vector2d>();
			var vertexes:Vector.<Point> = object.getHitPoly();
			var currentNormal:Vector2d;
			for(var i:int = vertexes.length - 2; i >= 0; --i)
			{
				currentNormal = new Vector2d(vertexes[i].x - vertexes[i + 1].x, vertexes[i].y - vertexes[i + 1].y);
				normals.push(currentNormal.getLeftNorm());
			}
			currentNormal = new Vector2d(vertexes[vertexes.length - 1].x - vertexes[0].x, vertexes[vertexes.length - 1].y - vertexes[0].y);
			normals.push(currentNormal.getLeftNorm());
			return normals;

		}
		
		private function getMinMax(vecs:Vector.<Vector2d>, axis:Vector2d):Object
		{
			
			var min:Number = vecs[0].dotProduct(axis);
			var minIndex:uint = 0;
			var max:Number = min;
			var maxIndex:uint = 0;
			var currProj:Number;
			
			for(var i:int = vecs.length - 1; i >= 1; --i)
			{
				currProj = vecs[i].dotProduct(axis);
				if(min > currProj)
				{
					min = currProj;
					minIndex = i;
				}
				else if(currProj > max)
				{
					max = currProj;
					maxIndex = i
				}
			}
			var minMax = {min:min, minIndex:minIndex, max:max, maxIndex:maxIndex};
			minMax[min] = min;
			minMax[minIndex] = minIndex;
			minMax[max] = max;
			minMax[maxIndex] = maxIndex;
			return minMax;
		}
		
		private function getVectors(object:Collidable):Vector.<Vector2d>
		{
			var vecs_box:Vector.<Vector2d> = new Vector.<Vector2d>();
			var hitPoly:Vector.<Point> = object.getHitPoly();
			for(var i = hitPoly.length - 1; i >= 0; --i)
				vecs_box.push(new Vector2d(hitPoly[i].x, hitPoly[i].y));
							  
			return vecs_box;

		}
		
		public function dealDamageCol(colArray:Array)
		{
			
			for(var i:int = colArray.length - 1; i >= 0; --i)
			{
				colArray[i].object2.collide(colArray[i].object1);
				colArray[i].object1.collide(colArray[i].object2);
				playSfx(colArray[i].object1);
			}
		}
		
		private function playSfx(object:Object):void
		{
			if(object is Bullet)
			{
				if( (object as Bullet).isShotgunBullet )
				{
					soundHandler.playSfx(9, new Point( (object as MovieClip).x, (object as MovieClip).y), 0.5);
				}
				else if( (object as Bullet).isBasicBullet )
				{
					soundHandler.playSfx(10, new Point( (object as MovieClip).x, (object as MovieClip).y));
				}
			}
		}
		
		/*
		public function dealDamage(colArray:Array)
		{
			var object1:Object;
			var object2:Object;
			
			for (var i: int = colArray.length - 1; i >= 0; --i)
			{
			
				object1 = colArray[i].object1;
				object2 = colArray[i].object2;
					
				if( !(colArray[i].object1 is Projectile) && (colArray[i].object2 is Projectile) )
				{
					object2 = colArray[i].object1;
					object1 = colArray[i].object2;
				}
				else if(colArray[i].object1 is EnemyPlane && colArray[i].object2 is PlaneGeneric && !(colArray[i].object2 is EnemyPlane))
				{
					object1 = colArray[i].object2;
					object2 = colArray[i].object1;
				}
				else if( colArray[i].object1 is Projectile && colArray[i].object2 is Projectile )
					trace("error! Both objects in a collision are projectiles");
				
				switch(playerMode)
				{
					case 0:
					if (object1 is Bullet && (object2 is PlaneGeneric || object2 is SmallBoat || object2 is Battleship))
					{
						object2.getHit(object1.getDamage());
						object1.removeThis(numOfCollisions); //this is a bullet for sure
						colArray.splice(i, 1);
						numOfCollisions++;
						continue;
					}
					else if(object1 is Bullet && object2 is BulletNemesis)
					{
						if(Math.abs(object2.x - object1.x) <= 12 && Math.abs(object2.y - object1.y) <= 12)
						{
							object2.getHit(object1.getDamage());
							object1.removeThis(numOfCollisions);
							trace("nemesis got shot in core");
						}
						else
						{
							var angle:Number = 90 + Math.atan2(object2.y - object1.y, object2.x - object1.x)*(180/Math.PI);
							object1.removeThis(-1, angle);
							//what happens if it hits the shell?
						}
						colArray.splice(i, 1);
						numOfCollisions++;
						continue;
					}
					break;
					
					case 1:
					if ( object1 is SniperBullet && object1.currentFrame <= 2 && (object2 is PlaneGeneric || object2 is SmallBoat || object2 is Battleship || object2 is BlobNemesis))
					{
						object1.spawnHitMarker( Math.abs(object2.y - object1.y - 8)*-1 );
						object2.getHit(object1.getDamage());
						colArray.splice(i, 1);
						continue;
					}
					else if (object1 is Bullet && (object2 is PlaneGeneric || object2 is SmallBoat || object2 is Battleship || object2 is BlobNemesis))
					{
						object2.getHit(object1.getDamage());
						object1.removeThis(numOfCollisions); //this is a bullet for sure
						colArray.splice(i, 1);
						numOfCollisions++;
						continue;
					}
					break;
					
					case 2:
					break;
					
					case 3:
					break;
					
					default:
					trace("collision handler failed to find player mode properly");
					break;
				}
				
				if ( object1 is Bullet && object1.isEnemyBullet && object2 is PlaneGeneric)
				{
					object2.getHit(object1.getDamage());
					object1.removeThis(numOfCollisions); //this is a bullet for sure;
					colArray.splice(i, 1);
					numOfCollisions++;
					continue;
				}
				
				else if (object1 is PlaneGeneric && (object2 is PlaneGeneric || object2 is SmallBoat || object2 is Battleship || object2 is Nemesis))
				{
					if(object1 is MeleePlane || object1 is SawPlane)
					{
						if(object2 is SmallBoat || object2 is Battleship)
						{
							object2.getHit(object1.getDamage() / 6);
							object1.makeSparks(true);
						}
						else
						{
							object2.getHit(object1.getDamage());
							object1.makeSparks(false);
						}
					}
					else
					{
						if(object2 is Nemesis)
						{
							object1.getHit(object2.getDamage());
						}
						else
						{
							object1.getHit(object2.getDamage());
							object2.getHit(object1.getDamage());
						}
					}
					continue;
				}
				
				else if (object1 is Missile && object2 is PlaneGeneric)
				{
					object1.blowUp();
					continue;
				}
				
				else if (object1 is SlugExplosion && object2 is PlaneGeneric)
				{
					object2.getHit(object1.getDamage());
					object1.inactive();
					continue;
				}
				
				else if (object1 is NemesisBeam && object2 is PlaneGeneric)
				{
					object2.getHit(object1.getDamage());
					continue;
				}
				
				else if(object1 is SlugExplosion && object2 is SmallBoat || object2 is Battleship)
				{
					object2.getHit(object1.getDamage()/2);
					continue;
				}
			}
		}*/
		
		public function upkeep()
		{
			if(precise)
			{
				dealDamageCol(playerBullets.checkCollisions());
				dealDamageCol(collideWithPlayer.checkCollisions());
			}
			else
			{
				dealDamageCol(checkAllCollisions());
			}
		}
	}
}