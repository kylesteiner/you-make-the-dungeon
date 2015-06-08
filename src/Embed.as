package {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.textures.Texture;

	public class Embed {
		[Embed(source='assets/backgrounds/menu_bg.png')] public static var menu_background:Class;
		[Embed(source='assets/backgrounds/background.png')] public static var grid_background:Class;
		[Embed(source='assets/backgrounds/game_bg.png')] public static var game_background:Class;
		[Embed(source='assets/backgrounds/panning_tutorial.png')] public static const tutorial_panning:Class;
		[Embed(source='assets/backgrounds/popup.png')] public static const popup_background:Class;
		[Embed(source='assets/backgrounds/summary_bg.png')] public static const summary_background:Class;
		[Embed(source='assets/backgrounds/shop_bg.png')] public static const shop_background:Class;

		[Embed(source='assets/backgrounds/run_phase.png')] public static const run_phase_banner:Class;
		[Embed(source='assets/backgrounds/build_phase.png')] public static const build_phase_banner:Class;

		[Embed(source='assets/backgrounds/run_help.png')] public static const run_help:Class;
		[Embed(source='assets/backgrounds/build_help.png')] public static const build_help:Class;

		[Embed(source='assets/highlights/hl_blue.png')] public static var hl_blue:Class;
		[Embed(source='assets/highlights/hl_tile.png')] public static var hl_tile:Class;
		[Embed(source='assets/highlights/hl_delete.png')] public static var hl_delete:Class;
		[Embed(source='assets/highlights/hl_entity.png')] public static var hl_entity:Class;

		[Embed(source='assets/entities/door.png')] public static var entity_door:Class;
		[Embed(source='assets/entities/new_healing.png')] public static var entity_healing:Class;
		[Embed(source='assets/entities/chest.png')] public static var entity_reward:Class;
		[Embed(source='assets/entities/stamina_heal.png')] public static var entity_stamina_heal:Class;
		[Embed(source='assets/entities/new_key.png')] public static var entity_key:Class;
		[Embed(source='assets/entities/enemy_fighter.png')] public static var entity_fighter:Class;
		[Embed(source='assets/entities/enemy_mage.png')] public static var entity_mage:Class;
		[Embed(source='assets/entities/enemy_archer.png')] public static var entity_archer:Class;
		[Embed(source='assets/entities/enemy_knight.png')] public static var entity_knight:Class;
		[Embed(source='assets/entities/enemy_ninja.png')] public static var entity_ninja:Class;
		[Embed(source='assets/entities/trap_basic.png')] public static var basic_trap:Class;
		[Embed(source='assets/entities/trap_flame_red.png')] public static var flame_trap:Class;
		[Embed(source='assets/entities/trap_flame_blue.png')] public static var flame_trap_blue:Class;
		[Embed(source='assets/entities/trap_shock.png')] public static var shock_trap:Class;

		[Embed(source='assets/fonts/BebasNeueRegular.otf', embedAsCFF="false", fontFamily="Bebas")] public static const bebas_font:Class;
		[Embed(source='assets/fonts/FertigoProRegular.otf', embedAsCFF="false", fontFamily="Fertigo")] public static const fertigo_font:Class;
		[Embed(source='assets/fonts/LeagueGothicRegular.otf', embedAsCFF="false", fontFamily="League")] public static const league_font:Class;

		[Embed(source='assets/animations/cursor/cursor_small.png')] public static const icon_cursor:Class;
		[Embed(source='assets/animations/cursor/cursor_small_2.png')] public static const icon_cursor_2:Class;

		[Embed(source='assets/buttons/24x24/tile_up_active.png')] public static const tile_up_active:Class;
		[Embed(source='assets/buttons/24x24/tile_up_inactive.png')] public static const tile_up_inactive:Class;
		[Embed(source='assets/buttons/24x24/tile_down_active.png')] public static const tile_down_active:Class;
		[Embed(source='assets/buttons/24x24/tile_down_inactive.png')] public static const tile_down_inactive:Class;
		[Embed(source='assets/buttons/24x24/tile_right_active.png')] public static const tile_right_active:Class;
		[Embed(source='assets/buttons/24x24/tile_right_inactive.png')] public static const tile_right_inactive:Class;
		[Embed(source='assets/buttons/24x24/tile_left_active.png')] public static const tile_left_active:Class;
		[Embed(source='assets/buttons/24x24/tile_left_inactive.png')] public static const tile_left_inactive:Class;

		[Embed(source='assets/icons/medium/mute_bgm.png')] public static const icon_mute_bgm:Class;
		[Embed(source='assets/icons/medium/mute_sfx.png')] public static const icon_mute_sfx:Class;
		[Embed(source='assets/icons/sfx_play_lg.png')] public static const icon_sfx_playing:Class;
		[Embed(source='assets/icons/sfx_mute_lg.png')] public static const icon_sfx_muted:Class;
		[Embed(source='assets/icons/bgm_play_lg.png')] public static const icon_bgm_playing:Class;
		[Embed(source='assets/icons/bgm_mute_lg.png')] public static const icon_bgm_muted:Class;
		[Embed(source='assets/icons/medium/reset.png')] public static const icon_reset:Class;
		[Embed(source='assets/icons/medium/run.png')] public static const icon_run:Class;
		[Embed(source='assets/icons/medium/end_run.png')] public static const icon_end:Class;
		[Embed(source='assets/icons/attack.png')] public static const icon_atk:Class;
		[Embed(source='assets/icons/health.png')] public static const icon_health:Class;
		[Embed(source='assets/icons/stamina.png')] public static const icon_stamina:Class;
		[Embed(source='assets/icons/los.png')] public static const icon_los:Class;
		[Embed(source='assets/icons/gold.png')] public static const icon_gold:Class;
		[Embed(source='assets/icons/delete.png')] public static const icon_delete:Class;
		[Embed(source='assets/icons/help_lg.png')] public static const icon_help:Class;
		[Embed(source='assets/icons/cursor_reticle.png')] public static const cursor_reticle:Class;
		[Embed(source='assets/icons/shop_item.png')] public static const shop_item:Class;

		[Embed(source='assets/icons/medium/enemies_menu.png')] public static const enemy_menu:Class;
		[Embed(source='assets/icons/medium/healing_menu.png')] public static const healing_menu:Class;
		[Embed(source='assets/icons/medium/traps_menu.png')] public static const trap_menu:Class;
		[Embed(source='assets/icons/medium/attack.png')] public static const icon_atk_med:Class;
		[Embed(source='assets/icons/medium/health.png')] public static const icon_health_med:Class;
		[Embed(source='assets/icons/medium/los.png')] public static const icon_los_med:Class;
		[Embed(source='assets/icons/medium/stamina.png')] public static const icon_stamina_med:Class;

		[Embed(source='assets/icons/slow_combat_lg.png')] public static const icon_fast_combat:Class;
		[Embed(source='assets/icons/base_combat_lg.png')] public static const icon_slow_combat:Class;
		[Embed(source='assets/icons/red_run_lg.png')] public static const icon_fast_run:Class;
		[Embed(source='assets/icons/slow_run_lg.png')] public static const icon_slow_run:Class;

		[Embed(source='assets/tiles/tile_e.png')] public static var tile_e:Class;
		[Embed(source='assets/tiles/tile_ew.png')] public static var tile_ew:Class;
		[Embed(source='assets/tiles/tile_n.png')] public static var tile_n:Class;
		[Embed(source='assets/tiles/tile_ne.png')] public static var tile_ne:Class;
		[Embed(source='assets/tiles/tile_new.png')] public static var tile_new:Class;
		[Embed(source='assets/tiles/tile_none.png')] public static var tile_none:Class;
		[Embed(source='assets/tiles/tile_ns.png')] public static var tile_ns:Class;
		[Embed(source='assets/tiles/tile_nse.png')] public static var tile_nse:Class;
		[Embed(source='assets/tiles/tile_nsew.png')] public static var tile_nsew:Class;
		[Embed(source='assets/tiles/tile_nsw.png')] public static var tile_nsw:Class;
		[Embed(source='assets/tiles/tile_nw.png')] public static var tile_nw:Class;
		[Embed(source='assets/tiles/tile_s.png')] public static var tile_s:Class;
		[Embed(source='assets/tiles/tile_se.png')] public static var tile_se:Class;
		[Embed(source='assets/tiles/tile_sew.png')] public static var tile_sew:Class;
		[Embed(source='assets/tiles/tile_sw.png')] public static var tile_sw:Class;
		[Embed(source='assets/tiles/tile_w.png')] public static var tile_w:Class;

		[Embed(source='floordata/main_floor.json', mimeType="application/octet-stream")] public static const mainFloor:Class;

		[Embed(source='assets/tutorials/tutorial_nea.png')] public static const tutorial_nea:Class;
		[Embed(source='assets/tutorials/tutorial_exit.png')] public static const tutorial_exit:Class;
		[Embed(source='assets/tutorials/tutorial_move.png')] public static const tutorial_move:Class;
		[Embed(source='assets/tutorials/tutorial_pan.png')] public static const tutorial_pan:Class;
		[Embed(source='assets/tutorials/tutorial_build_hud.png')] public static const tutorial_build_hud:Class;
		[Embed(source='assets/tutorials/tutorial_place.png')] public static const tutorial_place:Class;
		[Embed(source='assets/tutorials/tutorial_start_run.png')] public static const tutorial_start_run:Class;
		[Embed(source='assets/tutorials/tutorial_secondary_build.png')] public static const tutorial_secondary_build:Class;
		[Embed(source='assets/tutorials/tutorial_help.png')] public static const tutorial_help:Class;
		[Embed(source='assets/tutorials/tutorial_enemy.png')] public static const tutorial_enemy:Class;
		[Embed(source='assets/tutorials/tutorial_trap.png')] public static const tutorial_trap:Class;
		[Embed(source='assets/tutorials/tutorial_unlock.png')] public static const tutorial_unlock:Class;
		[Embed(source='assets/tutorials/tutorial_end_run.png')] public static const tutorial_end_run:Class;
		[Embed(source='assets/tutorials/tutorial_speed.png')] public static const tutorial_speed:Class;
		[Embed(source='assets/tutorials/tutorial_health_stamina_1.png')] public static const tutorial_health_stamina:Class;

		[Embed(source='assets/tutorials/tutorial_gold.png')] public static const tutorial_gold:Class;
		[Embed(source='assets/tutorials/tutorial_adventurers.png')] public static const tutorial_adventurers:Class;
		[Embed(source='assets/tutorials/tutorial_spend.png')] public static const tutorial_spend:Class;
		// [Embed(source='assets/tutorials/tutorial_keys.png')] public static const tutorial_keys:Class;

		[Embed(source='assets/tutorials/build_hud_shadow.png')] public static const tutorial_buildhud_shadow:Class;
		[Embed(source='assets/tutorials/place_shadow.png')] public static const tutorial_place_shadow:Class;
		[Embed(source='assets/tutorials/keys.png')] public static const tutorial_keys:Class;
		[Embed(source='assets/tutorials/health_stamina_shadow.png')] public static const tutorial_health_stamina_shadow:Class;
		[Embed(source='assets/tutorials/entity_shadow.png')] public static const tutorial_entity_shadow:Class;
		[Embed(source='assets/tutorials/speed_shadow.png')] public static const tutorial_speed_shadow:Class;
		[Embed(source='assets/tutorials/secondary_build_shadow.png')] public static const tutorial_secondary_build_shadow:Class;

		[Embed(source='assets/animations/character/idle/character_0.png')] public static const characterIdleAnim0:Class;
		[Embed(source='assets/animations/character/idle/character_1.png')] public static const characterIdleAnim1:Class;
		[Embed(source='assets/animations/character/idle/character_2.png')] public static const characterIdleAnim2:Class;

		[Embed(source='assets/animations/character/move/character_move_0.png')] public static const characterMoveAnim0:Class;
		[Embed(source='assets/animations/character/move/character_move_1.png')] public static const characterMoveAnim1:Class;

		[Embed(source='assets/backgrounds/combat_background.png')] public static const combatBackground:Class;
		[Embed(source='assets/backgrounds/combat_shadow.png')] public static const combatShadow:Class;

		[Embed(source='assets/animations/character/combat_idle/char_ci_0.png')] public static const charCombatIdleAnim0:Class;
		[Embed(source='assets/animations/character/combat_idle/char_ci_1.png')] public static const charCombatIdleAnim1:Class;
		[Embed(source='assets/animations/character/combat_idle/char_ci_2.png')] public static const charCombatIdleAnim2:Class;

		[Embed(source='assets/animations/character/combat_attack/char_ca_0.png')] public static const charCombatAtkAnim0:Class;
		[Embed(source='assets/animations/character/combat_attack/char_ca_1.png')] public static const charCombatAtkAnim1:Class;

		[Embed(source='assets/animations/character/combat_faint/char_cf_0.png')] public static const charCombatFaintAnim0:Class;
		[Embed(source='assets/animations/character/combat_faint/char_cf_1.png')] public static const charCombatFaintAnim1:Class;

		[Embed(source='assets/animations/fighter/idle/fighter_idle_0.png')] public static const enemyFighterCombatIdleAnim0:Class;
		[Embed(source='assets/animations/fighter/idle/fighter_idle_1.png')] public static const enemyFighterCombatIdleAnim1:Class;
		[Embed(source='assets/animations/fighter/idle/fighter_idle_2.png')] public static const enemyFighterCombatIdleAnim2:Class;

		[Embed(source='assets/animations/mage/idle/mage_idle_0.png')] public static const enemyMageCombatIdleAnim0:Class;
		[Embed(source='assets/animations/mage/idle/mage_idle_1.png')] public static const enemyMageCombatIdleAnim1:Class;
		[Embed(source='assets/animations/mage/idle/mage_idle_2.png')] public static const enemyMageCombatIdleAnim2:Class;

		[Embed(source='assets/animations/archer/idle/archer_idle_0.png')] public static const enemyArcherCombatIdleAnim0:Class;
		[Embed(source='assets/animations/archer/idle/archer_idle_1.png')] public static const enemyArcherCombatIdleAnim1:Class;

		[Embed(source='assets/animations/ninja/idle/ninja_idle_0.png')] public static const enemyNinjaCombatIdleAnim0:Class;
		[Embed(source='assets/animations/ninja/idle/ninja_idle_1.png')] public static const enemyNinjaCombatIdleAnim1:Class;

		[Embed(source='assets/animations/knight/idle/knight_idle_0.png')] public static const enemyKnightCombatIdleAnim0:Class;

		[Embed(source='assets/animations/generic/new_attack/attack_0.png')] public static const genericAttackAnim0:Class;
		[Embed(source='assets/animations/generic/new_attack/attack_1.png')] public static const genericAttackAnim1:Class;
		[Embed(source='assets/animations/generic/new_attack/attack_2.png')] public static const genericAttackAnim2:Class;
		[Embed(source='assets/animations/generic/new_attack/attack_2.png')] public static const genericAttackAnim3:Class;

		[Embed(source='assets/animations/traps/flame/flame_0.png')] public static const flameTrapAnim0:Class;
		[Embed(source='assets/animations/traps/flame/flame_1.png')] public static const flameTrapAnim1:Class;
		[Embed(source='assets/animations/traps/flame/flame_2.png')] public static const flameTrapAnim2:Class;
		[Embed(source='assets/animations/traps/flame/flame_3.png')] public static const flameTrapAnim3:Class;
		[Embed(source='assets/animations/traps/flame/flame_4.png')] public static const flameTrapAnim4:Class;
		[Embed(source='assets/animations/traps/flame/flame_5.png')] public static const flameTrapAnim5:Class;
		[Embed(source='assets/animations/traps/flame/flame_6.png')] public static const flameTrapAnim6:Class;
		[Embed(source='assets/animations/traps/flame/flame_7.png')] public static const flameTrapAnim7:Class;
		[Embed(source='assets/animations/traps/flame/flame_8.png')] public static const flameTrapAnim8:Class;
		[Embed(source='assets/animations/traps/flame/flame_9.png')] public static const flameTrapAnim9:Class;
		[Embed(source='assets/animations/traps/flame/flame_10.png')] public static const flameTrapAnim10:Class;
		[Embed(source='assets/animations/traps/flame/flame_11.png')] public static const flameTrapAnim11:Class;
		[Embed(source='assets/animations/traps/flame/flame_12.png')] public static const flameTrapAnim12:Class;
		[Embed(source='assets/animations/traps/flame/flame_13.png')] public static const flameTrapAnim13:Class;
		[Embed(source='assets/animations/traps/flame/flame_14.png')] public static const flameTrapAnim14:Class;
		[Embed(source='assets/animations/traps/flame/flame_15.png')] public static const flameTrapAnim15:Class;

		[Embed(source='assets/animations/traps/shock/shock_0.png')] public static const shockTrapAnim0:Class;
		[Embed(source='assets/animations/traps/shock/shock_1.png')] public static const shockTrapAnim1:Class;
		[Embed(source='assets/animations/traps/shock/shock_2.png')] public static const shockTrapAnim2:Class;
		[Embed(source='assets/animations/traps/shock/shock_3.png')] public static const shockTrapAnim3:Class;
		[Embed(source='assets/animations/traps/shock/shock_0a.png')] public static const shockTrapAnim4:Class;
		[Embed(source='assets/animations/traps/shock/shock_1a.png')] public static const shockTrapAnim5:Class;
		[Embed(source='assets/animations/traps/shock/shock_2a.png')] public static const shockTrapAnim6:Class;
		[Embed(source='assets/animations/traps/shock/shock_3a.png')] public static const shockTrapAnim7:Class;

		[Embed(source='assets/animations/traps/basic/basic_0.png')] public static const basicTrapAnim0:Class;

		[Embed(source='assets/icons/medium/health_purchase.png')] public static const health_purchase:Class;
		[Embed(source='assets/icons/medium/attack_purchase.png')] public static const attack_purchase:Class;
		[Embed(source='assets/icons/medium/stamina_purchase.png')] public static const stamina_purchase:Class;
		[Embed(source='assets/icons/medium/los_purchase.png')] public static const los_purchase:Class;

		[Embed(source='assets/sfx/floor_complete_new.mp3')] public static const sfxFloorComplete:Class;
		[Embed(source='assets/sfx/tile_move.mp3')] public static const sfxTileMove:Class;
		[Embed(source='assets/sfx/tile_failure_new.mp3')] public static const sfxTileFailure:Class;
		[Embed(source='assets/sfx/floor_begin.mp3')] public static const sfxFloorBegin:Class;
		[Embed(source='assets/sfx/button_press.mp3')] public static const sfxButtonPress:Class;
		[Embed(source='assets/sfx/tile_remove.mp3')] public static const sfxTileRemove:Class;
		[Embed(source='assets/sfx/combat_failure_new.mp3')] public static const sfxCombatFailure:Class;
		[Embed(source='assets/sfx/combat_success_long.mp3')] public static const sfxCombatSuccess:Class;
		[Embed(source='assets/sfx/level_up.mp3')] public static const sfxLevelUp:Class;
		[Embed(source='assets/sfx/attack.mp3')] public static const sfxAttack:Class;
		[Embed(source='assets/sfx/coin_collect.mp3')] public static const sfxCoinCollect:Class;
		[Embed(source='assets/sfx/spend_gold.mp3')] public static const sfxGoldSpend:Class;
		[Embed(source='assets/sfx/no_gold.mp3')] public static const sfxGoldDeficit:Class;
		[Embed(source='assets/sfx/chest_open_lowhz.mp3')] public static const sfxReward:Class;
		[Embed(source='assets/sfx/door_open.mp3')] public static const sfxDoorOpen:Class;
		[Embed(source='assets/sfx/basic_trap.mp3')] public static const sfxBasicTrap:Class;
		[Embed(source='assets/sfx/flame_trap.mp3')] public static const sfxFlameTrap:Class;
		[Embed(source='assets/sfx/shock_trap.mp3')] public static const sfxShockTrap:Class;
		[Embed(source='assets/sfx/stamina_heal.mp3')] public static const sfxStaminaHeal:Class;
		[Embed(source='assets/sfx/health_heal.mp3')] public static const sfxHeal:Class;
		[Embed(source='assets/sfx/key_get.mp3')] public static const sfxKey:Class;

		[Embed(source='assets/bgm/diving-turtle.mp3')] public static const bgmDivingTurtle:Class;
		[Embed(source='assets/bgm/gentle-thoughts-2.mp3')] public static const bgmGentleThoughts:Class;
		[Embed(source='assets/bgm/glow-in-the-dark.mp3')] public static const bgmGlowInTheDark:Class;
		[Embed(source='assets/bgm/oriental-drift.mp3')] public static const bgmOrientalDrift:Class;
		[Embed(source='assets/bgm/snowfall.mp3')] public static const bgmSnowfall:Class;
		[Embed(source='assets/bgm/seven_nation.mp3')] public static const bgmSevenNation:Class;
		[Embed(source='assets/bgm/pearl_cavern.mp3')] public static const bgmPearlCavern:Class;
		[Embed(source='assets/bgm/warm-interlude.mp3')] public static const bgmWarmInterlude:Class;

		public static function setupTextures():void {
			Assets.textures = new Dictionary();
			var scale:int = Util.REAL_TILE_SIZE / Util.PIXELS_PER_TILE;
			Assets.textures[Util.MENU_BACKGROUND] = Texture.fromEmbeddedAsset(menu_background);
			Assets.textures[Util.GRID_BACKGROUND] = Texture.fromEmbeddedAsset(grid_background);
			Assets.textures[Util.GAME_BACKGROUND] = Texture.fromEmbeddedAsset(game_background);
			//Assets.textures[Util.TUTORIAL_BACKGROUND] = Texture.fromEmbeddedAsset(tutorial_hud);
			//Assets.textures[Util.TUTORIAL_PAN] = Texture.fromEmbeddedAsset(tutorial_panning);
			//Assets.textures[Util.TUTORIAL_TILE] = Texture.fromEmbeddedAsset(tutorial_tile_hud);
			Assets.textures[Util.POPUP_BACKGROUND] = Texture.fromEmbeddedAsset(popup_background);
			Assets.textures[Util.SUMMARY_BACKGROUND] = Texture.fromEmbeddedAsset(summary_background);
			Assets.textures[Util.SHOP_BACKGROUND] = Texture.fromEmbeddedAsset(shop_background);
			Assets.textures[Util.SHOP_ITEM] = Texture.fromEmbeddedAsset(shop_item);
			Assets.textures[Util.RUN_BANNER] = Texture.fromEmbeddedAsset(run_phase_banner);
			Assets.textures[Util.BUILD_BANNER] = Texture.fromEmbeddedAsset(build_phase_banner);
			Assets.textures[Util.RUN_HELP] = Texture.fromEmbeddedAsset(run_help);
			Assets.textures[Util.BUILD_HELP] = Texture.fromEmbeddedAsset(build_help);

			//Assets.textures[Util.CHARACTER] = Texture.fromBitmap(new entity_hero(), true, false, scale);
			//Assets.textures[Util.DOOR] = Texture.fromBitmap(new entity_door(), true, false, scale);
			Assets.textures[Util.HEALING] = Texture.fromBitmap(new entity_healing(), true, false, scale);
			Assets.textures[Util.STAMINA_HEAL] = Texture.fromBitmap(new entity_stamina_heal(), true, false, scale);
			Assets.textures[Util.REWARD] = Texture.fromBitmap(new entity_reward(), true, false, scale);
			Assets.textures[Util.KEY] = Texture.fromBitmap(new entity_key(), true, false, scale);
			Assets.textures[Util.DOOR] = Texture.fromBitmap(new entity_door(), true, false, scale);
			Assets.textures[Util.ENEMY_FIGHTER] = Texture.fromBitmap(new entity_fighter(), true, false, scale);
			Assets.textures[Util.ENEMY_MAGE] = Texture.fromBitmap(new entity_mage(), true, false, scale);
			Assets.textures[Util.ENEMY_KNIGHT] = Texture.fromBitmap(new entity_knight(), true, false, scale);
			Assets.textures[Util.ENEMY_NINJA] = Texture.fromBitmap(new entity_ninja(), true, false, scale);
			Assets.textures[Util.ENEMY_ARCHER] = Texture.fromBitmap(new entity_archer(), true, false, scale);
			Assets.textures[Util.BASIC_TRAP] = Texture.fromBitmap(new basic_trap(), true, false, scale);
			Assets.textures[Util.FLAME_TRAP] = Texture.fromBitmap(new flame_trap(), true, false, scale);
			Assets.textures[Util.FLAME_TRAP_BLUE] = Texture.fromBitmap(new flame_trap_blue(), true, false, scale);
			Assets.textures[Util.SHOCK_TRAP] = Texture.fromBitmap(new shock_trap(), true, false, scale);

			Assets.textures[Util.TILE_E] = Texture.fromBitmap(new tile_e(), true, false, scale);
			Assets.textures[Util.TILE_EW] = Texture.fromBitmap(new tile_ew(), true, false, scale);
			Assets.textures[Util.TILE_N] = Texture.fromBitmap(new tile_n(), true, false, scale);
			Assets.textures[Util.TILE_NE] = Texture.fromBitmap(new tile_ne(), true, false, scale);
			Assets.textures[Util.TILE_NEW] = Texture.fromBitmap(new tile_new(), true, false, scale);
			Assets.textures[Util.TILE_NONE] = Texture.fromBitmap(new tile_none(), true, false, scale);
			Assets.textures[Util.TILE_NS] = Texture.fromBitmap(new tile_ns(), true, false, scale);
			Assets.textures[Util.TILE_NSE] = Texture.fromBitmap(new tile_nse(), true, false, scale);
			Assets.textures[Util.TILE_NSEW] = Texture.fromBitmap(new tile_nsew(), true, false, scale);
			Assets.textures[Util.TILE_NSW] = Texture.fromBitmap(new tile_nsw(), true, false, scale);
			Assets.textures[Util.TILE_NW] = Texture.fromBitmap(new tile_nw(), true, false, scale);
			Assets.textures[Util.TILE_S] = Texture.fromBitmap(new tile_s(), true, false, scale);
			Assets.textures[Util.TILE_SE] = Texture.fromBitmap(new tile_se(), true, false, scale);
			Assets.textures[Util.TILE_SEW] = Texture.fromBitmap(new tile_sew(), true, false, scale);
			Assets.textures[Util.TILE_SW] = Texture.fromBitmap(new tile_sw(), true, false, scale);
			Assets.textures[Util.TILE_W] = Texture.fromBitmap(new tile_w(), true, false, scale);

			//Assets.textures[Util.TILE_FOG] = Texture.fromBitmap(new fog(), true, false, scale);
			//Assets.textures[Util.TILE_HL_Y] = Texture.fromBitmap(new hl_yellow(), true, false, scale);
			//Assets.textures[Util.TILE_HL_R] = Texture.fromBitmap(new hl_red(), true, false, scale);
			//Assets.textures[Util.TILE_HL_G] = Texture.fromBitmap(new hl_green(), true, false, scale);
			Assets.textures[Util.TILE_HL_B] = Texture.fromBitmap(new hl_blue(), true, false, scale);
			Assets.textures[Util.TILE_HL_TILE] = Texture.fromBitmap(new hl_tile(), true, false, scale);
			Assets.textures[Util.TILE_HL_DEL] = Texture.fromBitmap(new hl_delete(), true, false, scale);
			Assets.textures[Util.TILE_HL_ENTITY] = Texture.fromBitmap(new hl_entity(), true, false, scale);

			// WARNING: ICONS ARE NOT SCALED LIKE THE TILES
			Assets.textures[Util.ICON_CURSOR] = Texture.fromBitmap(new icon_cursor(), true, false, 1);
			Assets.textures[Util.ICON_MUTE_BGM] =  Texture.fromBitmap(new icon_mute_bgm(), true, false, 1);
			Assets.textures[Util.ICON_MUTE_SFX] = Texture.fromBitmap(new icon_mute_sfx(), true, false, 1);
			Assets.textures[Util.ICON_RESET] = Texture.fromBitmap(new icon_reset(), true, false, 1);
			Assets.textures[Util.ICON_RUN] = Texture.fromBitmap(new icon_run(), true, false, 1);
			Assets.textures[Util.ICON_END] = Texture.fromBitmap(new icon_end(), true, false, 1);
			Assets.textures[Util.ICON_ATK] = Texture.fromBitmap(new icon_atk(), true, false, 1);
			Assets.textures[Util.ICON_ATK_MED] = Texture.fromBitmap(new icon_atk_med(), true, false, 1);
			Assets.textures[Util.ICON_HEALTH] = Texture.fromBitmap(new icon_health(), true, false, 1);
			Assets.textures[Util.ICON_HEALTH_MED] = Texture.fromBitmap(new icon_health_med(), true, false, 1);
			Assets.textures[Util.ICON_STAMINA] = Texture.fromBitmap(new icon_stamina(), true, false, 1);
			Assets.textures[Util.ICON_STAMINA_MED] = Texture.fromBitmap(new icon_stamina_med(), true, false, 1);
			Assets.textures[Util.ICON_LOS] = Texture.fromBitmap(new icon_los(), true, false, 1);
			Assets.textures[Util.ICON_LOS_MED] = Texture.fromBitmap(new icon_los_med(), true, false, 1);
			Assets.textures[Util.ICON_GOLD] = Texture.fromBitmap(new icon_gold(), true, false, 1);
			Assets.textures[Util.ICON_DELETE] = Texture.fromBitmap(new icon_delete(), true, false, 1);

			Assets.textures[Util.HEALTH_PURCHASE] = Texture.fromBitmap(new health_purchase(), true, false, 1);
			Assets.textures[Util.ATTACK_PURCHASE] = Texture.fromBitmap(new attack_purchase(), true, false, 1);
			Assets.textures[Util.STAMINA_PURCHASE] = Texture.fromBitmap(new stamina_purchase(), true, false, 1);
			Assets.textures[Util.LOS_PURCHASE] = Texture.fromBitmap(new los_purchase(), true, false, 1);

			Assets.textures[Util.ENEMY_MENU] = Texture.fromBitmap(new enemy_menu(), true, false, 1);
			Assets.textures[Util.HEALING_MENU] = Texture.fromBitmap(new healing_menu(), true, false, 1);
			Assets.textures[Util.TRAP_MENU] = Texture.fromBitmap(new trap_menu(), true, false, 1);

			Assets.textures[Util.ICON_SFX_PLAY] = Texture.fromEmbeddedAsset(icon_sfx_playing);
			Assets.textures[Util.ICON_SFX_MUTE] = Texture.fromEmbeddedAsset(icon_sfx_muted);
			Assets.textures[Util.ICON_BGM_PLAY] = Texture.fromEmbeddedAsset(icon_bgm_playing);
			Assets.textures[Util.ICON_BGM_MUTE] = Texture.fromEmbeddedAsset(icon_bgm_muted);

			Assets.textures[Util.ICON_FAST_COMBAT] = Texture.fromEmbeddedAsset(icon_fast_combat);
			Assets.textures[Util.ICON_SLOW_COMBAT] = Texture.fromEmbeddedAsset(icon_slow_combat);
			Assets.textures[Util.ICON_FAST_RUN] = Texture.fromEmbeddedAsset(icon_fast_run);
			Assets.textures[Util.ICON_SLOW_RUN] = Texture.fromEmbeddedAsset(icon_slow_run);
			Assets.textures[Util.ICON_HELP] = Texture.fromBitmap(new icon_help(), true, false, 1);

			Assets.textures[Util.TILE_UP_ACTIVE] = Texture.fromEmbeddedAsset(tile_up_active);
			Assets.textures[Util.TILE_UP_INACTIVE] = Texture.fromEmbeddedAsset(tile_up_inactive);
			Assets.textures[Util.TILE_DOWN_ACTIVE] = Texture.fromEmbeddedAsset(tile_down_active);
			Assets.textures[Util.TILE_DOWN_INACTIVE] = Texture.fromEmbeddedAsset(tile_down_inactive);
			Assets.textures[Util.TILE_RIGHT_ACTIVE] = Texture.fromEmbeddedAsset(tile_right_active);
			Assets.textures[Util.TILE_RIGHT_INACTIVE] = Texture.fromEmbeddedAsset(tile_right_inactive);
			Assets.textures[Util.TILE_LEFT_ACTIVE] = Texture.fromEmbeddedAsset(tile_left_active);
			Assets.textures[Util.TILE_LEFT_INACTIVE] = Texture.fromEmbeddedAsset(tile_left_inactive);

			Assets.textures[Util.COMBAT_BG] = Texture.fromEmbeddedAsset(combatBackground);
			Assets.textures[Util.COMBAT_SHADOW] = Texture.fromEmbeddedAsset(combatShadow);

			Assets.textures[Util.CURSOR_RETICLE] = Texture.fromEmbeddedAsset(cursor_reticle);

			Assets.textures[Util.TUTORIAL_NEA] = Texture.fromEmbeddedAsset(tutorial_nea);
			Assets.textures[Util.TUTORIAL_EXIT] = Texture.fromEmbeddedAsset(tutorial_exit);
			Assets.textures[Util.TUTORIAL_MOVE] = Texture.fromEmbeddedAsset(tutorial_move);
			Assets.textures[Util.TUTORIAL_PAN] = Texture.fromEmbeddedAsset(tutorial_pan);
			Assets.textures[Util.TUTORIAL_BUILD_HUD] = Texture.fromEmbeddedAsset(tutorial_build_hud);
			Assets.textures[Util.TUTORIAL_PLACE] = Texture.fromEmbeddedAsset(tutorial_place);
			Assets.textures[Util.TUTORIAL_START_RUN] = Texture.fromEmbeddedAsset(tutorial_start_run);
			Assets.textures[Util.TUTORIAL_SECONDARY_BUILD] = Texture.fromEmbeddedAsset(tutorial_secondary_build);
			Assets.textures[Util.TUTORIAL_HELP] = Texture.fromEmbeddedAsset(tutorial_help);
			Assets.textures[Util.TUTORIAL_ENEMY] = Texture.fromEmbeddedAsset(tutorial_enemy);
			Assets.textures[Util.TUTORIAL_TRAP] = Texture.fromEmbeddedAsset(tutorial_trap);
			Assets.textures[Util.TUTORIAL_UNLOCK] = Texture.fromEmbeddedAsset(tutorial_unlock);
			Assets.textures[Util.TUTORIAL_END_RUN] = Texture.fromEmbeddedAsset(tutorial_end_run);
			Assets.textures[Util.TUTORIAL_SPEED] = Texture.fromEmbeddedAsset(tutorial_speed);
			Assets.textures[Util.TUTORIAL_HEALTH_STAMINA] = Texture.fromEmbeddedAsset(tutorial_health_stamina);

			Assets.textures[Util.TUTORIAL_GOLD] = Texture.fromEmbeddedAsset(tutorial_gold);
			Assets.textures[Util.TUTORIAL_ADVENTURERS] = Texture.fromEmbeddedAsset(tutorial_adventurers);
			Assets.textures[Util.TUTORIAL_SPEND] = Texture.fromEmbeddedAsset(tutorial_spend);

			Assets.textures[Util.TUTORIAL_BUILDHUD_SHADOW] = Texture.fromEmbeddedAsset(tutorial_buildhud_shadow);
			Assets.textures[Util.TUTORIAL_PLACE_SHADOW] = Texture.fromEmbeddedAsset(tutorial_place_shadow);
			Assets.textures[Util.TUTORIAL_KEYS] = Texture.fromEmbeddedAsset(tutorial_keys);
			Assets.textures[Util.TUTORIAL_HEALTH_STAMINA_SHADOW] = Texture.fromEmbeddedAsset(tutorial_health_stamina_shadow);
			Assets.textures[Util.TUTORIAL_ENTITY_SHADOW] = Texture.fromEmbeddedAsset(tutorial_entity_shadow);
			Assets.textures[Util.TUTORIAL_SPEED_SHADOW] = Texture.fromEmbeddedAsset(tutorial_speed_shadow);
			Assets.textures[Util.TUTORIAL_SECONDARY_BUILD_SHADOW] = Texture.fromEmbeddedAsset(tutorial_secondary_build_shadow);
		}

		public static function setupAnimations():void {
			Assets.animations = new Dictionary();

			var cursorDict:Dictionary = new Dictionary();
			var cursorVector:Vector.<Texture> = new Vector.<Texture>();
			cursorVector.push(Texture.fromEmbeddedAsset(icon_cursor));
			cursorVector.push(Texture.fromEmbeddedAsset(icon_cursor_2));
			cursorDict[Util.ICON_CURSOR] = cursorVector;
			Assets.animations[Util.ICON_CURSOR] = cursorDict;


			var genericDict:Dictionary = new Dictionary();
			var genericVector:Vector.<Texture> = new Vector.<Texture>();
			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim0));
			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim1));
			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim2));
			genericVector.push(Texture.fromEmbeddedAsset(genericAttackAnim3));
			genericDict[Util.GENERIC_ATTACK] = genericVector;
			Assets.animations[Util.GENERIC_ATTACK] = genericDict;


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
			Assets.animations[Util.CHARACTER] = charDict;


			var fighterDict:Dictionary = new Dictionary();
			var fighterVector:Vector.<Texture> = new Vector.<Texture>();
			fighterVector.push(Texture.fromEmbeddedAsset(enemyFighterCombatIdleAnim0));
			fighterVector.push(Texture.fromEmbeddedAsset(enemyFighterCombatIdleAnim2));
			fighterDict[Util.ENEMY_COMBAT_IDLE] = fighterVector;
			fighterDict[Util.ENEMY_COMBAT_ATTACK] = fighterVector;

			var fighterFaintVector:Vector.<Texture> = new Vector.<Texture>();
			fighterFaintVector.push(Texture.fromEmbeddedAsset(enemyFighterCombatIdleAnim0));
			fighterDict[Util.ENEMY_COMBAT_FAINT] = fighterFaintVector;
			Assets.animations[Util.ENEMY_FIGHTER] = fighterDict;


			var mageDict:Dictionary = new Dictionary();
			var mageVector:Vector.<Texture> = new Vector.<Texture>();
			mageVector.push(Texture.fromEmbeddedAsset(enemyMageCombatIdleAnim0));
			mageVector.push(Texture.fromEmbeddedAsset(enemyMageCombatIdleAnim2));
			mageDict[Util.ENEMY_COMBAT_IDLE] = mageVector;
			mageDict[Util.ENEMY_COMBAT_ATTACK] = mageVector;

			var mageFaintVector:Vector.<Texture> = new Vector.<Texture>();
			mageFaintVector.push(Texture.fromEmbeddedAsset(enemyMageCombatIdleAnim0));
			mageDict[Util.ENEMY_COMBAT_FAINT] = mageFaintVector;
			Assets.animations[Util.ENEMY_MAGE] = mageDict;

			var archerDict:Dictionary = new Dictionary();
			var archerVector:Vector.<Texture> = new Vector.<Texture>();
			archerVector.push(Texture.fromEmbeddedAsset(enemyArcherCombatIdleAnim0));
			archerVector.push(Texture.fromEmbeddedAsset(enemyArcherCombatIdleAnim1));
			archerDict[Util.ENEMY_COMBAT_IDLE] = archerVector;
			archerDict[Util.ENEMY_COMBAT_ATTACK] = archerVector;

			var archerFaintVector:Vector.<Texture> = new Vector.<Texture>();
			archerFaintVector.push(Texture.fromEmbeddedAsset(enemyArcherCombatIdleAnim0));
			archerDict[Util.ENEMY_COMBAT_FAINT] = archerFaintVector;
			Assets.animations[Util.ENEMY_ARCHER] = archerDict;


			var ninjaDict:Dictionary = new Dictionary();
			var ninjaVector:Vector.<Texture> = new Vector.<Texture>();
			ninjaVector.push(Texture.fromEmbeddedAsset(enemyNinjaCombatIdleAnim0));
			ninjaVector.push(Texture.fromEmbeddedAsset(enemyNinjaCombatIdleAnim1));
			ninjaDict[Util.ENEMY_COMBAT_IDLE] = ninjaVector;
			ninjaDict[Util.ENEMY_COMBAT_ATTACK] = ninjaVector;

			var ninjaFaintVector:Vector.<Texture> = new Vector.<Texture>();
			ninjaFaintVector.push(Texture.fromEmbeddedAsset(enemyNinjaCombatIdleAnim0));
			ninjaDict[Util.ENEMY_COMBAT_FAINT] = ninjaFaintVector;
			Assets.animations[Util.ENEMY_NINJA] = ninjaDict;


			var knightDict:Dictionary = new Dictionary();
			var knightVector:Vector.<Texture> = new Vector.<Texture>();
			knightVector.push(Texture.fromEmbeddedAsset(enemyKnightCombatIdleAnim0));
			knightDict[Util.ENEMY_COMBAT_IDLE] = knightVector;
			knightDict[Util.ENEMY_COMBAT_ATTACK] = knightVector;

			var knightFaintVector:Vector.<Texture> = new Vector.<Texture>();
			knightFaintVector.push(Texture.fromEmbeddedAsset(enemyKnightCombatIdleAnim0));
			knightDict[Util.ENEMY_COMBAT_FAINT] = knightFaintVector;
			Assets.animations[Util.ENEMY_KNIGHT] = knightDict;


			var trapDict:Dictionary = new Dictionary();
			var basicVector:Vector.<Texture> = new Vector.<Texture>();
			basicVector.push(Texture.fromEmbeddedAsset(basicTrapAnim0));
			trapDict[Util.BASIC_TRAP] = basicVector;

			var shockVector:Vector.<Texture> = new Vector.<Texture>();
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim0));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim1));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim2));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim3));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim4));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim5));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim6));
			shockVector.push(Texture.fromEmbeddedAsset(shockTrapAnim7));
			trapDict[Util.SHOCK_TRAP] = shockVector;

			var flameVector:Vector.<Texture> = new Vector.<Texture>();
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim0));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim1));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim2));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim3));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim4));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim5));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim6));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim7));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim8));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim9));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim10));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim11));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim12));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim13));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim14));
			flameVector.push(Texture.fromEmbeddedAsset(flameTrapAnim15));
			trapDict[Util.FLAME_TRAP] = flameVector;

			Assets.animations[Util.TRAPS] = trapDict;
		}

		public static function setupFloors():void {
			Assets.floors = new Dictionary();
			Assets.floors[Util.MAIN_FLOOR] = (new mainFloor() as ByteArray).toString();
		}

		public static function setupBGM():Array {
			var tBgm:Array = new Array();

			tBgm.push(new bgmGentleThoughts());
			tBgm.push(new bgmGlowInTheDark());
			tBgm.push(new bgmOrientalDrift());
			tBgm.push(new bgmDivingTurtle());
			tBgm.push(new bgmWarmInterlude());
			tBgm.push(new bgmSnowfall());
			tBgm.push(new bgmSevenNation());
			tBgm.push(new bgmPearlCavern());

			return tBgm;
		}

		public static function setupSFX():Dictionary {
			var tSfx:Dictionary = new Dictionary();

			tSfx[Util.FLOOR_COMPLETE] = new sfxFloorComplete();
			tSfx[Util.TILE_MOVE] = new sfxTileMove();
			tSfx[Util.TILE_FAILURE] = new sfxTileFailure();
			tSfx[Util.FLOOR_BEGIN] = new sfxFloorBegin();
			tSfx[Util.BUTTON_PRESS] = new sfxButtonPress();
			tSfx[Util.COMBAT_FAILURE] = new sfxCombatFailure();
			tSfx[Util.COMBAT_SUCCESS] = new sfxCombatSuccess();
			tSfx[Util.LEVEL_UP] = new sfxLevelUp();
			tSfx[Util.SFX_ATTACK] = new sfxAttack();
			tSfx[Util.TILE_REMOVE] = new sfxTileRemove();
			tSfx[Util.COIN_COLLECT] = new sfxCoinCollect();
			tSfx[Util.GOLD_SPEND] = new sfxGoldSpend();
			tSfx[Util.GOLD_DEFICIT] = new sfxGoldDeficit();
			tSfx[Util.REWARD_COLLECT] = new sfxReward();
			tSfx[Util.DOOR_OPEN] = new sfxDoorOpen();
			tSfx[Util.SFX_BASIC_TRAP] = new sfxBasicTrap();
			tSfx[Util.SFX_FLAME_TRAP] = new sfxFlameTrap();
			tSfx[Util.SFX_SHOCK_TRAP] = new sfxShockTrap();
			tSfx[Util.SFX_STAMINA_HEAL] = new sfxStaminaHeal();
			tSfx[Util.SFX_HEAL] = new sfxHeal();
			tSfx[Util.SFX_KEY] = new sfxKey();

			return tSfx;
		}
	}
}
