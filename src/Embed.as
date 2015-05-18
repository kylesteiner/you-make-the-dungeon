package {

    import flash.utils.Dictionary;
    import starling.textures.*;

    public class Embed {


            [Embed(source='assets/backgrounds/background.png')] public static var grid_background:Class;
            [Embed(source='assets/backgrounds/char_hud_stretch.png')] public static const char_hud:Class;
            [Embed(source='assets/backgrounds/new_static_bg.png')] public static var static_background:Class;
            [Embed(source='assets/backgrounds/tile_hud.png')] public static const tile_hud:Class;
            [Embed(source='assets/backgrounds/tutorial_shifted.png')] public static const tutorial_hud:Class;
            [Embed(source='assets/backgrounds/tile_hud_tutorial.png')] public static const tutorial_tile_hud:Class;
            [Embed(source='assets/backgrounds/panning_tutorial.png')] public static const tutorial_panning:Class;
            [Embed(source='assets/backgrounds/popup.png')] public static const popup_background:Class;

            [Embed(source='assets/effects/large/fow_6.png')] public static var fog:Class;
            [Embed(source='assets/effects/large/hl_blue.png')] public static var hl_blue:Class;
            [Embed(source='assets/effects/large/hl_green.png')] public static var hl_green:Class;
            [Embed(source='assets/effects/large/hl_red.png')] public static var hl_red:Class;
            [Embed(source='assets/effects/large/hl_yellow.png')] public static var hl_yellow:Class;
            [Embed(source='assets/effects/large/hl_green_new.png')] public static var hl_green_new:Class;
            [Embed(source='assets/effects/large/check_bordered.png')] public static var check_bordered:Class;
            [Embed(source='assets/effects/large/check_unbordered.png')] public static var check_unbordered:Class;

            [Embed(source='assets/entities/large/door.png')] public static var entity_door:Class;
            [Embed(source='assets/entities/large/new_healing.png')] public static var entity_healing:Class;
            [Embed(source='assets/entities/large/hero.png')] public static var entity_hero:Class;
            [Embed(source='assets/entities/large/new_key.png')] public static var entity_key:Class;
            [Embed(source='assets/entities/large/enemy_1.png')] public static var entity_fighter:Class;
            [Embed(source='assets/entities/large/enemy_2.png')] public static var entity_mage:Class;

            [Embed(source='assets/fonts/BebasNeueRegular.otf', embedAsCFF="false", fontFamily="Bebas")] public static const bebas_font:Class;
            [Embed(source='assets/fonts/LeagueGothicRegular.otf', embedAsCFF="false", fontFamily="League")] public static const league_font:Class;

            [Embed(source='assets/animations/cursor/cursor_small.png')] public static const icon_cursor:Class;
            [Embed(source='assets/animations/cursor/cursor_small_2.png')] public static const icon_cursor_2:Class;

            [Embed(source='assets/icons/medium/mute_bgm.png')] public static const icon_mute_bgm:Class;
            [Embed(source='assets/icons/medium/mute_sfx.png')] public static const icon_mute_sfx:Class;
            [Embed(source='assets/icons/medium/reset.png')] public static const icon_reset:Class;
            [Embed(source='assets/icons/medium/run.png')] public static const icon_run:Class;
            [Embed(source='assets/icons/medium/end_run.png')] public static const icon_end:Class;
            [Embed(source='assets/icons/attack.png')] public static const icon_atk:Class;
            [Embed(source='assets/icons/health.png')] public static const icon_health:Class;
            [Embed(source='assets/icons/stamina.png')] public static const icon_stamina:Class;
            [Embed(source='assets/icons/gold.png')] public static const icon_gold:Class;

            [Embed(source='assets/tiles/clean/tile_e.png')] public static var tile_e:Class;
            [Embed(source='assets/tiles/clean/tile_ew.png')] public static var tile_ew:Class;
            [Embed(source='assets/tiles/clean/tile_n.png')] public static var tile_n:Class;
            [Embed(source='assets/tiles/clean/tile_ne.png')] public static var tile_ne:Class;
            [Embed(source='assets/tiles/clean/tile_new.png')] public static var tile_new:Class;
            [Embed(source='assets/tiles/clean/tile_none.png')] public static var tile_none:Class;
            [Embed(source='assets/tiles/clean/tile_ns.png')] public static var tile_ns:Class;
            [Embed(source='assets/tiles/clean/tile_nse.png')] public static var tile_nse:Class;
            [Embed(source='assets/tiles/clean/tile_nsew.png')] public static var tile_nsew:Class;
            [Embed(source='assets/tiles/clean/tile_nsw.png')] public static var tile_nsw:Class;
            [Embed(source='assets/tiles/clean/tile_nw.png')] public static var tile_nw:Class;
            [Embed(source='assets/tiles/clean/tile_s.png')] public static var tile_s:Class;
            [Embed(source='assets/tiles/clean/tile_se.png')] public static var tile_se:Class;
            [Embed(source='assets/tiles/clean/tile_sew.png')] public static var tile_sew:Class;
            [Embed(source='assets/tiles/clean/tile_sw.png')] public static var tile_sw:Class;
            [Embed(source='assets/tiles/clean/tile_w.png')] public static var tile_w:Class;

            [Embed(source='floordata/main_floor.txt', mimeType="application/octet-stream")] public static const mainFloor:Class;

            [Embed(source='floordata/floor0.txt', mimeType="application/octet-stream")] public static const floor0:Class;
            [Embed(source='floordata/floor1.txt', mimeType="application/octet-stream")] public static const floor1:Class;
            [Embed(source='floordata/floor2.txt', mimeType="application/octet-stream")] public static const floor2:Class;
            [Embed(source='floordata/floor3.txt', mimeType="application/octet-stream")] public static const floor3:Class;
            [Embed(source='floordata/floor4.txt', mimeType="application/octet-stream")] public static const floor4:Class;
            [Embed(source='floordata/floor5.txt', mimeType="application/octet-stream")] public static const floor5:Class;
            [Embed(source='floordata/floor6.txt', mimeType="application/octet-stream")] public static const floor6:Class;
            [Embed(source='floordata/floor7.txt', mimeType="application/octet-stream")] public static const floor7:Class;
            [Embed(source='floordata/floor8.txt', mimeType="application/octet-stream")] public static const floor8:Class;
            [Embed(source='floordata/floor9.txt', mimeType="application/octet-stream")] public static const floor9:Class;
            [Embed(source='floordata/floor10.txt', mimeType="application/octet-stream")] public static const floor10:Class;
            [Embed(source='floordata/floor11.txt', mimeType="application/octet-stream")] public static const floor11:Class;
            [Embed(source='tilerates/floor0.txt', mimeType="application/octet-stream")] public static const tiles0:Class;
            [Embed(source='tilerates/floor1.txt', mimeType="application/octet-stream")] public static const tiles1:Class;
            [Embed(source='tilerates/floor2.txt', mimeType="application/octet-stream")] public static const tiles2:Class;
            [Embed(source='tilerates/floor3.txt', mimeType="application/octet-stream")] public static const tiles3:Class;
            [Embed(source='tilerates/floor4.txt', mimeType="application/octet-stream")] public static const tiles4:Class;
            [Embed(source='tilerates/floor5.txt', mimeType="application/octet-stream")] public static const tiles5:Class;
            [Embed(source='tilerates/floor6.txt', mimeType="application/octet-stream")] public static const tiles6:Class;
            [Embed(source='tilerates/floor7.txt', mimeType="application/octet-stream")] public static const tiles7:Class;
            [Embed(source='tilerates/floor8.txt', mimeType="application/octet-stream")] public static const tiles8:Class;
            [Embed(source='tilerates/floor9.txt', mimeType="application/octet-stream")] public static const tiles9:Class;
            [Embed(source='tilerates/floor10.txt', mimeType="application/octet-stream")] public static const tiles10:Class;
            [Embed(source='tilerates/floor11.txt', mimeType="application/octet-stream")] public static const tiles11:Class;
            [Embed(source='assets/transitions/floor0.png')] public static const transitions0:Class;
            [Embed(source='assets/transitions/floor1.png')] public static const transitions1:Class;
            [Embed(source='assets/transitions/floor2.png')] public static const transitions2:Class;
            [Embed(source='assets/transitions/floor3.png')] public static const transitions3:Class;
            [Embed(source='assets/transitions/floor4.png')] public static const transitions4:Class;
            [Embed(source='assets/transitions/floor5.png')] public static const transitions5:Class;
            [Embed(source='assets/transitions/floor6.png')] public static const transitions6:Class;
            [Embed(source='assets/transitions/floor7.png')] public static const transitions7:Class;
            [Embed(source='assets/transitions/floor8.png')] public static const transitions8:Class;
            [Embed(source='assets/transitions/floor9.png')] public static const transitions9:Class;
            [Embed(source='assets/transitions/floor_final.png')] public static const transitionsFinal:Class;
            [Embed(source='assets/transitions/floor_final_exp.png')] public static const transitionsFinalExp:Class;

            [Embed(source='assets/animations/character/idle/character_0.png')] public static const characterIdleAnim0:Class;
            [Embed(source='assets/animations/character/idle/character_1.png')] public static const characterIdleAnim1:Class;
            [Embed(source='assets/animations/character/idle/character_2.png')] public static const characterIdleAnim2:Class;
            //[Embed(source='assets/animations/character/idle/character_3.png')] public static const characterIdleAnim3:Class;

            [Embed(source='assets/animations/character/move/character_move_0.png')] public static const characterMoveAnim0:Class;
            [Embed(source='assets/animations/character/move/character_move_1.png')] public static const characterMoveAnim1:Class;

            [Embed(source='assets/backgrounds/combat_background.png')] public static const combatBackground:Class;
            [Embed(source='assets/backgrounds/combat_shadow.png')] public static const combatShadow:Class;

            [Embed(source='assets/animations/character/combat_idle/char_ci_0.png')] public static const charCombatIdleAnim0:Class;
            [Embed(source='assets/animations/character/combat_idle/char_ci_1.png')] public static const charCombatIdleAnim1:Class;
            [Embed(source='assets/animations/character/combat_idle/char_ci_2.png')] public static const charCombatIdleAnim2:Class;

            [Embed(source='assets/animations/character/combat_attack/char_ca_0.png')] public static const charCombatAtkAnim0:Class;
            [Embed(source='assets/animations/character/combat_attack/char_ca_1.png')] public static const charCombatAtkAnim1:Class;
            //[Embed(source='assets/animations/character/combat_attack/char_ca_2.png')] public static const charCombatAtkAnim2:Class;
            //[Embed(source='assets/animations/character/combat_attack/char_ca_3.png')] public static const charCombatAtkAnim3:Class;

            [Embed(source='assets/animations/character/combat_faint/char_cf_0.png')] public static const charCombatFaintAnim0:Class;
            [Embed(source='assets/animations/character/combat_faint/char_cf_1.png')] public static const charCombatFaintAnim1:Class;

            [Embed(source='assets/animations/fighter/idle/fighter_idle_0.png')] public static const enemyFighterCombatIdleAnim0:Class;
            [Embed(source='assets/animations/fighter/idle/fighter_idle_1.png')] public static const enemyFighterCombatIdleAnim1:Class;
            [Embed(source='assets/animations/fighter/idle/fighter_idle_2.png')] public static const enemyFighterCombatIdleAnim2:Class;

            [Embed(source='assets/animations/mage/idle/mage_idle_0.png')] public static const enemyMageCombatIdleAnim0:Class;
            [Embed(source='assets/animations/mage/idle/mage_idle_1.png')] public static const enemyMageCombatIdleAnim1:Class;
            [Embed(source='assets/animations/mage/idle/mage_idle_2.png')] public static const enemyMageCombatIdleAnim2:Class;

            [Embed(source='assets/animations/generic/attack/attack_0.png')] public static const genericAttackAnim0:Class;
            [Embed(source='assets/animations/generic/attack/attack_1.png')] public static const genericAttackAnim1:Class;
            [Embed(source='assets/animations/generic/attack/attack_2.png')] public static const genericAttackAnim2:Class;
            [Embed(source='assets/animations/generic/attack/attack_3.png')] public static const genericAttackAnim3:Class;

            [Embed(source='assets/sfx/floor_complete_new.mp3')] public static const sfxFloorComplete:Class;
            [Embed(source='assets/sfx/tile_move.mp3')] public static const sfxTileMove:Class;
            [Embed(source='assets/sfx/tile_failure_new.mp3')] public static const sfxTileFailure:Class;
            [Embed(source='assets/sfx/floor_begin.mp3')] public static const sfxFloorBegin:Class;
            [Embed(source='assets/sfx/button_press.mp3')] public static const sfxButtonPress:Class;
            [Embed(source='assets/sfx/floor_reset.mp3')] public static const sfxFloorReset:Class;
            [Embed(source='assets/sfx/combat_failure_new.mp3')] public static const sfxCombatFailure:Class;
            [Embed(source='assets/sfx/combat_success_long.mp3')] public static const sfxCombatSuccess:Class;
            [Embed(source='assets/sfx/level_up.mp3')] public static const sfxLevelUp:Class;
            [Embed(source='assets/sfx/attack.mp3')] public static const sfxAttack:Class;

            [Embed(source='assets/bgm/diving-turtle.mp3')] public static const bgmDivingTurtle:Class;
            [Embed(source='assets/bgm/gentle-thoughts-2.mp3')] public static const bgmGentleThoughts:Class;
            [Embed(source='assets/bgm/glow-in-the-dark.mp3')] public static const bgmGlowInTheDark:Class;
            [Embed(source='assets/bgm/lovers-walk.mp3')] public static const bgmLoversWalk:Class;
            [Embed(source='assets/bgm/oriental-drift.mp3')] public static const bgmOrientalDrift:Class;

            // Currently unused
            [Embed(source='assets/bgm/warm-interlude.mp3')] public static const bgmWarmInterlude:Class;

            public static function setupTextures():Dictionary {
    			var textures:Dictionary = new Dictionary();
    			var scale:int = Util.REAL_TILE_SIZE / Util.PIXELS_PER_TILE;
    			textures[Util.GRID_BACKGROUND] = Texture.fromEmbeddedAsset(grid_background);
    			textures[Util.STATIC_BACKGROUND] = Texture.fromEmbeddedAsset(static_background);
    			textures[Util.TUTORIAL_BACKGROUND] = Texture.fromEmbeddedAsset(tutorial_hud);
    			textures[Util.TUTORIAL_PAN] = Texture.fromEmbeddedAsset(tutorial_panning);
    			textures[Util.TUTORIAL_TILE] = Texture.fromEmbeddedAsset(tutorial_tile_hud);
    			textures[Util.POPUP_BACKGROUND] = Texture.fromEmbeddedAsset(popup_background);

    			textures[Util.CHARACTER] = Texture.fromBitmap(new entity_hero(), true, false, scale);
    			textures[Util.DOOR] = Texture.fromBitmap(new entity_door(), true, false, scale);
    			textures[Util.HEALING] = Texture.fromBitmap(new entity_healing(), true, false, scale);
    			textures[Util.KEY] = Texture.fromBitmap(new entity_key(), true, false, scale);
    			textures[Util.MONSTER_1] = Texture.fromBitmap(new entity_fighter(), true, false, scale);
    			textures[Util.MONSTER_2] = Texture.fromBitmap(new entity_mage(), true, false, scale);

    			textures[Util.TILE_E] = Texture.fromBitmap(new tile_e(), true, false, scale);
    			textures[Util.TILE_EW] = Texture.fromBitmap(new tile_ew(), true, false, scale);
    			textures[Util.TILE_N] = Texture.fromBitmap(new tile_n(), true, false, scale);
    			textures[Util.TILE_NE] = Texture.fromBitmap(new tile_ne(), true, false, scale);
    			textures[Util.TILE_NEW] = Texture.fromBitmap(new tile_new(), true, false, scale);
    			textures[Util.TILE_NONE] = Texture.fromBitmap(new tile_none(), true, false, scale);
    			textures[Util.TILE_NS] = Texture.fromBitmap(new tile_ns(), true, false, scale);
    			textures[Util.TILE_NSE] = Texture.fromBitmap(new tile_nse(), true, false, scale);
    			textures[Util.TILE_NSEW] = Texture.fromBitmap(new tile_nsew(), true, false, scale);
    			textures[Util.TILE_NSW] = Texture.fromBitmap(new tile_nsw(), true, false, scale);
    			textures[Util.TILE_NW] = Texture.fromBitmap(new tile_nw(), true, false, scale);
    			textures[Util.TILE_S] = Texture.fromBitmap(new tile_s(), true, false, scale);
    			textures[Util.TILE_SE] = Texture.fromBitmap(new tile_se(), true, false, scale);
    			textures[Util.TILE_SEW] = Texture.fromBitmap(new tile_sew(), true, false, scale);
    			textures[Util.TILE_SW] = Texture.fromBitmap(new tile_sw(), true, false, scale);
    			textures[Util.TILE_W] = Texture.fromBitmap(new tile_w(), true, false, scale);

    			textures[Util.TILE_FOG] = Texture.fromBitmap(new fog(), true, false, scale);
    			textures[Util.TILE_HL_Y] = Texture.fromBitmap(new hl_yellow(), true, false, scale);
    			textures[Util.TILE_HL_R] = Texture.fromBitmap(new hl_red(), true, false, scale);
    			textures[Util.TILE_HL_G] = Texture.fromBitmap(new hl_green(), true, false, scale);
    			textures[Util.TILE_HL_B] = Texture.fromBitmap(new hl_blue(), true, false, scale);
    			textures[Util.TILE_HL_G_NEW] = Texture.fromBitmap(new hl_green_new(), true, false, scale);
    			textures[Util.TILE_CHECK_B] = Texture.fromBitmap(new check_bordered(), true, false, scale);
    			textures[Util.TILE_CHECK_UB] = Texture.fromBitmap(new check_unbordered(), true, false, scale);

    			// WARNING: ICONS ARE NOT SCALED LIKE THE TILES
    			textures[Util.ICON_CURSOR] = Texture.fromBitmap(new icon_cursor(), true, false, 1);
    			textures[Util.ICON_MUTE_BGM] =  Texture.fromBitmap(new icon_mute_bgm(), true, false, 1);
    			textures[Util.ICON_MUTE_SFX] = Texture.fromBitmap(new icon_mute_sfx(), true, false, 1);
    			textures[Util.ICON_RESET] = Texture.fromBitmap(new icon_reset(), true, false, 1);
    			textures[Util.ICON_RUN] = Texture.fromBitmap(new icon_run(), true, false, 1);
                textures[Util.ICON_END] = Texture.fromBitmap(new icon_end(), true, false, 1);
    			textures[Util.ICON_ATK] = Texture.fromBitmap(new icon_atk(), true, false, 1);
    			textures[Util.ICON_HEALTH] = Texture.fromBitmap(new icon_health(), true, false, 1);
                textures[Util.ICON_STAMINA] = Texture.fromBitmap(new icon_stamina(), true, false, 1);
                textures[Util.ICON_GOLD] = Texture.fromBitmap(new icon_gold(), true, false, 1);

    			textures[Util.TILE_HUD] = Texture.fromEmbeddedAsset(tile_hud);
    			textures[Util.CHAR_HUD] = Texture.fromEmbeddedAsset(char_hud);

    			textures[Util.COMBAT_BG] = Texture.fromEmbeddedAsset(combatBackground);
    			textures[Util.COMBAT_SHADOW] = Texture.fromEmbeddedAsset(combatShadow);
    			return textures;
    		}

    		public static function setupAnimations():Dictionary {
    			var tAnimations:Dictionary = new Dictionary();

    			var cursorDict:Dictionary = new Dictionary();
    			var cursorVector:Vector.<Texture> = new Vector.<Texture>();
    			cursorVector.push(Texture.fromEmbeddedAsset(icon_cursor));
    			cursorVector.push(Texture.fromEmbeddedAsset(icon_cursor_2));
    			cursorDict[Util.ICON_CURSOR] = cursorVector;
    			tAnimations[Util.ICON_CURSOR] = cursorDict;

    			var genericDict:Dictionary = new Dictionary();
    			var genericVector:Vector.<Texture> = new Vector.<Texture>();
    			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim0));
    			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim1));
    			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim2));
    			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim3));
    			genericDict[Util.GENERIC_ATTACK] = genericVector;
    			tAnimations[Util.GENERIC_ATTACK] = genericDict;

    			var charDict:Dictionary = new Dictionary();
    			var charVector:Vector.<Texture> = new Vector.<Texture>();
    			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim0));
    			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim1));
    			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim2));
    			charDict[Util.CHAR_IDLE] = charVector;

    			var charMoveVector:Vector.<Texture> = new Vector.<Texture>();
    			charMoveVector.push(Texture.fromEmbeddedAsset(characterMoveAnim0));
    			charMoveVector.push(Texture.fromEmbeddedAsset(characterMoveAnim1));
    			charDict[Util.CHAR_MOVE] = charMoveVector;

    			var charCombatIdleVector:Vector.<Texture> = new Vector.<Texture>();
    			charCombatIdleVector.push(Texture.fromEmbeddedAsset(charCombatIdleAnim0));
    			charCombatIdleVector.push(Texture.fromEmbeddedAsset(charCombatIdleAnim1));
    			charCombatIdleVector.push(Texture.fromEmbeddedAsset(charCombatIdleAnim2));
    			charDict[Util.CHAR_COMBAT_IDLE] = charCombatIdleVector;

    			var charCombatAttackVector:Vector.<Texture> = new Vector.<Texture>();
    			charCombatAttackVector.push(Texture.fromEmbeddedAsset(charCombatAtkAnim0));
    			charCombatAttackVector.push(Texture.fromEmbeddedAsset(charCombatAtkAnim1));
    			charDict[Util.CHAR_COMBAT_ATTACK] = charCombatAttackVector;

    			var charCombatFaintVector:Vector.<Texture> = new Vector.<Texture>();
    			charCombatFaintVector.push(Texture.fromEmbeddedAsset(charCombatFaintAnim0));
    			charCombatFaintVector.push(Texture.fromEmbeddedAsset(charCombatFaintAnim1));
    			charDict[Util.CHAR_COMBAT_FAINT] = charCombatFaintVector;
    			tAnimations[Util.CHARACTER] = charDict;

    			var fighterDict:Dictionary = new Dictionary();
    			var fighterVector:Vector.<Texture> = new Vector.<Texture>();
    			fighterVector.push(Texture.fromEmbeddedAsset(enemyFighterCombatIdleAnim0));
    			fighterVector.push(Texture.fromEmbeddedAsset(enemyFighterCombatIdleAnim2));
    			fighterDict[Util.ENEMY_COMBAT_IDLE] = fighterVector;
    			fighterDict[Util.ENEMY_COMBAT_ATTACK] = fighterVector;

    			var fighterFaintVector:Vector.<Texture> = new Vector.<Texture>();
    			fighterFaintVector.push(Texture.fromEmbeddedAsset(enemyFighterCombatIdleAnim0));
    			fighterDict[Util.ENEMY_COMBAT_FAINT] = fighterFaintVector;
    			tAnimations[Util.MONSTER_1] = fighterDict;

    			var mageDict:Dictionary = new Dictionary();
    			var mageVector:Vector.<Texture> = new Vector.<Texture>();
    			mageVector.push(Texture.fromEmbeddedAsset(enemyMageCombatIdleAnim0));
    			mageVector.push(Texture.fromEmbeddedAsset(enemyMageCombatIdleAnim2));
    			mageDict[Util.ENEMY_COMBAT_IDLE] = mageVector;
    			mageDict[Util.ENEMY_COMBAT_ATTACK] = mageVector;

    			var mageFaintVector:Vector.<Texture> = new Vector.<Texture>();
    			mageFaintVector.push(Texture.fromEmbeddedAsset(enemyMageCombatIdleAnim0));
    			mageDict[Util.ENEMY_COMBAT_FAINT] = mageFaintVector;
    			tAnimations[Util.MONSTER_2] = mageDict;

    			return tAnimations;
    		}

    		public static function setupFloors():Dictionary {
    			var tFloors:Dictionary = new Dictionary();

    			// TODO: pass in unintialized vars
    			//		 currently can only read a level once
    			//		 and then crash if you try to reuse the dictionary
    			//		 need to read in the text files each level load :(
    			tFloors[Util.FLOOR_0] = new Array(new floor0(), new tiles0(), Texture.fromEmbeddedAsset(transitions0));
    			tFloors[Util.FLOOR_1] = new Array(new floor1(), new tiles1(), Texture.fromEmbeddedAsset(transitions1));
    			tFloors[Util.FLOOR_2] = new Array(new floor2(), new tiles2(), Texture.fromEmbeddedAsset(transitions2));
    			tFloors[Util.FLOOR_3] = new Array(new floor3(), new tiles3(), Texture.fromEmbeddedAsset(transitions4));
    			tFloors[Util.FLOOR_4] = new Array(new floor4(), new tiles4(), Texture.fromEmbeddedAsset(transitions5));
    			tFloors[Util.FLOOR_5] = new Array(new floor5(), new tiles5(), Texture.fromEmbeddedAsset(transitions7));
    			tFloors[Util.FLOOR_6] = new Array(new floor6(), new tiles6(), Texture.fromEmbeddedAsset(transitions8));
    			tFloors[Util.FLOOR_7] = new Array(new floor7(), new tiles7(), Texture.fromEmbeddedAsset(transitions9));
    			tFloors[Util.FLOOR_8] = new Array(new floor8(), new tiles8(), Texture.fromEmbeddedAsset(transitionsFinalExp));
    			tFloors[Util.FLOOR_9] = new Array(new floor9(), new tiles9(), Texture.fromEmbeddedAsset(transitionsFinal));
    			tFloors[Util.FLOOR_10] = new Array(new floor10(), new tiles10(), Texture.fromEmbeddedAsset(transitions0));
    			tFloors[Util.FLOOR_11] = new Array(new floor11(), new tiles11(), Texture.fromEmbeddedAsset(transitions0));

                tFloors[Util.MAIN_FLOOR] = new mainFloor();

    			return tFloors;
    		}

    		public static function setupBGM():Array {
    			var tBgm:Array = new Array();

    			tBgm.push(new bgmDivingTurtle());
    			tBgm.push(new bgmGentleThoughts());
    			tBgm.push(new bgmGlowInTheDark());
    			tBgm.push(new bgmLoversWalk());
    			tBgm.push(new bgmOrientalDrift());

    			return tBgm;
    		}

    		public static function setupSFX():Dictionary {
    			var tSfx:Dictionary = new Dictionary();

    			tSfx[Util.FLOOR_COMPLETE] = new sfxFloorComplete();
    			tSfx[Util.TILE_MOVE] = new sfxTileMove();
    			tSfx[Util.TILE_FAILURE] = new sfxTileFailure();
    			tSfx[Util.FLOOR_BEGIN] = new sfxFloorBegin();
    			tSfx[Util.BUTTON_PRESS] = new sfxButtonPress();
    			tSfx[Util.FLOOR_RESET] = new sfxFloorReset();
    			tSfx[Util.COMBAT_FAILURE] = new sfxCombatFailure();
    			tSfx[Util.COMBAT_SUCCESS] = new sfxCombatSuccess();
    			tSfx[Util.LEVEL_UP] = new sfxLevelUp();
    			tSfx[Util.SFX_ATTACK] = new sfxAttack();

    			return tSfx;
    		}

    }

}
