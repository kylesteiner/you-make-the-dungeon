package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.display.MovieClip;
	import Util;
	import entities.*;
	import mx.utils.StringUtil;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Trap extends Entity {
		public static const BASIC_DESCRIPTION:String = "Deals {0} damage.";
		public static const SHOCK_DESCRIPTION:String = "Deals {0} damage in a line of length {1}.";
		public static const FLAME_DESCRIPTION:String = "Deals {0} damage in a circle of radius {1}.";
		public static const NO_DESCRIPTION:String = "Something has gone wrong and this trap does not have a type.";

		public static const AREA_KEY:String = "damage_radius";
		public static const ANIMATION_KEY:String = "damage_animation";
		public static const SOUND_KEY:String = "trigger_sound";

		public var type:String;
		public var damage:int;
		public var radius:int;
		public var distributionFunctions:Dictionary;
		public var distribution:Function;
		public var animationVector:Vector.<Texture>;
		public var triggerSound:String;

		public function Trap(g_x:int, g_y:int, texture:Texture, type:String, damage:int, radius:int=0) {
			super(g_x, g_y, texture);
			this.type = type;
			this.damage = damage;
			this.radius = radius;
			this.distributionFunctions = setupFunctionDict();
			this.distribution = distributionFunctions[type][AREA_KEY];
			this.animationVector = distributionFunctions[type][ANIMATION_KEY];
			this.triggerSound = distributionFunctions[type][SOUND_KEY];

			addOverlay();
		}

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();
			// Ideally would have access to textures to put here
			var damageText:TextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2,
																			Util.SMALL_FONT_SIZE,
																			"-" + this.damage,
																			Util.SMALL_FONT_SIZE);
			// Right and bottom align
			damageText.x = img.width - damageText.width - Entity.INFO_MARGIN;
			damageText.y = img.height - damageText.height - Entity.INFO_MARGIN;
			base.addChild(damageText);

			return base;
		}

		override public function generateDescription():String {
			if (type == Util.BASIC_TRAP) {
				return StringUtil.substitute(BASIC_DESCRIPTION, damage);
			} else if (type == Util.FLAME_TRAP) {
				return StringUtil.substitute(FLAME_DESCRIPTION, damage, radius);
			} else if (type == Util.SHOCK_TRAP) {
				return StringUtil.substitute(SHOCK_DESCRIPTION, damage, radius);
			} else {
				return NO_DESCRIPTION;
			}
		}

		public function generateDamageRadius():Array {
			return distribution();
		}

		public function generateDamageAnimations():Array {
			var tAnim:Array = new Array();
			var animPoints:Array = generateDamageRadius();
			var animPoint:Point;
			var currentAnimation:MovieClip;

			for each (animPoint in animPoints) {
				currentAnimation = new MovieClip(animationVector);
				currentAnimation.x = Util.grid_to_real(animPoint.x);
				currentAnimation.y = Util.grid_to_real(animPoint.y);
				currentAnimation.loop = false;
				tAnim.push(currentAnimation);
			}

			return tAnim;
		}

		public function setupFunctionDict():Dictionary {
			var tFunc:Dictionary = new Dictionary();

			var basicArray:Dictionary = new Dictionary();
			basicArray[AREA_KEY] = generateBasicRadius;
			basicArray[ANIMATION_KEY] = Assets.animations[Util.TRAPS][Util.BASIC_TRAP];
			basicArray[SOUND_KEY] = Util.SFX_BASIC_TRAP;
			tFunc[Util.BASIC_TRAP] = basicArray;

			var flameArray:Dictionary = new Dictionary();
			flameArray[AREA_KEY] = generateFlameRadius;
			flameArray[ANIMATION_KEY] = Assets.animations[Util.TRAPS][Util.FLAME_TRAP];
			flameArray[SOUND_KEY] = Util.SFX_FLAME_TRAP;
			tFunc[Util.FLAME_TRAP] = flameArray;

			var shockArray:Dictionary = new Dictionary();
			shockArray[AREA_KEY] = generateShockRadius;
			shockArray[ANIMATION_KEY] = Assets.animations[Util.TRAPS][Util.SHOCK_TRAP];
			shockArray[SOUND_KEY] = Util.SFX_SHOCK_TRAP;
			tFunc[Util.SHOCK_TRAP] = shockArray;

			return tFunc;
		}

		public function generateBasicRadius():Array {
			var points:Array = new Array();

			points.push(new Point(grid_x, grid_y));

			return points;
		}

		public function generateFlameRadius():Array {
			var points:Array = new Array();

			var px:int; var py:int;
			for (px = grid_x - radius; px <= grid_x + radius; px++) {
				for (py = grid_y - radius; py <= grid_y + radius; py++) {
					if (Math.abs(px - grid_x) + Math.abs(py - grid_y) > radius) {
						continue;
					}
					if (px >= 0 && px < Util.gridWidth && py >= 0 && py < Util.gridHeight) {
						points.push(new Point(px, py));
					}
				}
			}

			return points;
		}

		public function generateShockRadius():Array {
			var points:Array = new Array();

			var px:int; var py:int;
			for (px = grid_x - radius; px <= grid_x + radius; px++) {
				if (px >= 0 && px < Util.gridWidth && py >= 0 && py < Util.gridHeight) {
					points.push(new Point(px, grid_y));
				}
			}

			for (py = grid_y - radius; py <= grid_y + radius; py++) {
				if (px >= 0 && px < Util.gridWidth && py >= 0 && py < Util.gridHeight && py != grid_y) {
					points.push(new Point(grid_x, py));
				}
			}

			return points;
		}
	}
}
