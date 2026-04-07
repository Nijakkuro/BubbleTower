/*
font_enable_effects(fnt_Default_2, true, {
	outlineEnable: true,
	outlineDistance: 2.5,
	outlineColour: #113377
});
*/

global._texGroupsRooms = ds_map_create();
//ds_map_add( global._texGroupsRooms, room_Ending, [ "texgroup_ending" ] );


function room_goto_with_transition(nextRoom, transitionObject=obj_RoomTransitionBase, transitionParams={})
{
	if(room_transition_in_progress())
	{
		return;
	}
	
	transitionObject = transitionObject ?? obj_RoomTransitionBase;
	
	if(!object_is_ancestor(transitionObject, obj_RoomTransitionBase) && transitionObject!=obj_RoomTransitionBase)
	{
		show_error($"transitionObject must be an ancestor of {nameof(obj_RoomTransitionBase)}", false);
	}
	
	if(instance_number(obj_RoomTransitionBase)!=0)
	{
		return;
	}
	
	if(room!=room_Init)
	{
		room_set_viewport(nextRoom, 0, true, view_xport[0], view_yport[0], view_wport[0], view_hport[0]);
	}
	
	transitionParams.Room = nextRoom;
	transitionParams.TextureGroups = global._texGroupsRooms[? nextRoom];
	return instance_create_depth(0, 0, -1000, transitionObject, {
		Params: transitionParams
	});
}

global._room_transition_inst_counter = 0;
function room_transition_in_progress()
{
	return global._room_transition_inst_counter>0;
}


#macro GLOBAL_PAUSE (global._glb_pause|0)
global._glb_pause = false;

#macro GAMEPLAY_PAUSE (global._gp_pause|0)
global._gp_pause = false;


#macro CCore global._sCCore
CCore = sCCore;

/// @ignore
function sCCore() constructor
{
	singleton_struct;
	
	GameVersion = GM_version;
	var versionArr = string_split(GameVersion, ".");
	GameVersionString = "v" + versionArr[0] + "." + versionArr[1] + "." + versionArr[2];
	DevMode = ( GM_build_type=="run" );
	ShowFPS = DevMode;
	
	Mobile = false;
	
	Step = function()
	{
		if(!DevMode)
		{
			return;
		}
		
		if(keyboard_check_pressed(ord("P")))
		{
			//var buffer = buffer_create(256, buffer_fixed, 1);
			///buffer_peek(buffer, 0, buffer_u8);
		//}
		
		//if(game_get_speed(gamespeed_fps)==60)
		//{
			var newFps = game_get_speed(gamespeed_fps)==60 ? 999 : 60;
			game_set_speed(newFps, gamespeed_fps);
		}
		
		if(keyboard_check_pressed(ord("O")))
		{
			ShowFPS = !ShowFPS;
		}
		
		if(keyboard_check_pressed(ord("T"))) {
			_setGlobalPause(!GLOBAL_PAUSE);
		}
	}
	
	RoomStart = function()
	{
		var roomName = room_get_name(room);
		var levelPrefix = "lvl_";
		var isLevel = string_starts_with(roomName, levelPrefix);
		if(isLevel)
		{
			//CAudio.PlayBGM(mus_BGM_2);
			//instance_create_depth(0, 0, 0, obj_HUD);
			instance_create_depth(0, 0, 0, obj_Camera);
			//obj_TouchInputController.EnableGameplayControls = true;
		}
		else
		{
			instance_create_depth(0, 0, 0, obj_Camera);
			//obj_TouchInputController.EnableGameplayControls = false;
		}
	}
	
	RoomEnd = function()
	{
		// room end
	}
	
	AsyncEventDialog = function()
	{
		//
	}
	
	AsyncEventSocial = function()
	{
		//if(GamePushEventCatcher().CatchEvent())
		//{
		//	return;
		//}
		
		if(DevMode)
		{
			var keys = ds_map_keys_to_array(async_load);
			var n = array_length(keys);
			
			show_debug_message($"ASYNC SOCIAL BEGIN");
			
			for(var i=0; i<n; i++)
			{
				var key = keys[i];
				var val = async_load[? key ];
				show_debug_message($"{key} = {val}");
			}
			
			show_debug_message($"ASYNC SOCIAL END");
		}
	}
	
	/// @ignore
	_setGlobalPause = function(pause)
	{
		var pauseBool = bool(pause);
		if(global._glb_pause==pauseBool)
		{
			return;
		}
		
		global._glb_pause = pauseBool;
		if(global._glb_pause)
		{
			Input.OnGlobalPause();
			Audio.OnGlobalPause();
			AddGameplayPauser();
		}
		else
		{
			RemoveGameplayPauser();
			Audio.OnGlobalResume();
			Input.OnGlobalResume();
		}
	}
	
	/// @ignore
	_gameplayPausers = 0;
	
	AddGameplayPauser = function()
	{
		_gameplayPausers++;
		if(_gameplayPausers==1)
		{
			_pauseGameplay();
		}
	}
	
	RemoveGameplayPauser = function()
	{
		_gameplayPausers = max(_gameplayPausers-1, 0);
		if(_gameplayPausers==0)
		{
			_unpauseGameplay();
		}
	}
	
	/// @ignore
	_pauseGameplay = function()
	{
		global._gp_pause = true;
		time_source_pause(time_source_game);
		InstanceDeactivateAll();
		Display.OnGameplayPause();
		Audio.OnGameplayPause();
		//Input.OnGameplayPause();
	}
	
	/// @ignore
	_unpauseGameplay = function()
	{
		InstanceActivateAll();
		time_source_resume(time_source_game);
		global._gp_pause = false;
		Display.OnGameplayResume();
		Audio.OnGameplayResume();
		//Input.OnGameplayResume();
	}
	
	/// @ignore
	_alwaysActiveInstaces = [];
	
	RegisterAlwaysActiveInstance = function(inst)
	{
		array_push(_alwaysActiveInstaces, inst);
	}
	
	InstanceDeactivateAll = function()
	{
		instance_deactivate_all(true);
		array_foreach(_alwaysActiveInstaces, function(inst){
			instance_activate_object(inst);
		});
	}
	
	InstanceActivateAll = function()
	{
		instance_activate_all();
	}
	
	// INIT
	
	randomize();
	
	/// @ignore
	_inst = instance_create_depth(0, 0, 100000, obj_Core);
	
	// initialize all subsystems {
	Time = new sCTime();
	OptionsSystem = new sCOptionsSystem();
	Localization = new sCLocalization();
	Display = new sCDisplay();
	Audio = new sCAudio();
	//Input = new sCInput();
	//Collision = new sCCollision();
	// }
	
	/// @ignore
	_initChecker = undefined;
	
	_onLanguageChanged = function(languageCode)
	{
		//GamePush_ChangeLanguage(string_lower(languageCode));
	}
	
	if(os_type==os_gxgames || os_browser!=browser_not_a_browser)
	{
		_initChecker = time_source_create(time_source_game, 1, time_source_units_frames, function(){
			if(extension_exists("GamePush"))
			{
				//if(GamePush_InitStatus())
				{
					time_source_destroy(_initChecker);
					struct_remove(self, "_initChecker");
					
					//DevMode = DevMode || GamePush_IsDev();
					ShowFPS = DevMode;
					//Mobile = GamePush_IsMobile();
					
					//var languageCode = GamePush_Language();
					//CLocalizationSettings.Language.Set(languageCode);
					//CLocalizationSettings.Language.BindOnChanged(self, _onLanguageChanged);
					
					show_debug_message("--- initialization finished ---");
					show_debug_message(GM_version);
					room_goto_next();
				}
			}
			else
			{
				time_source_destroy(_initChecker);
				struct_remove(self, "_initChecker");
				
				show_debug_message("--- initialization finished ---");
				show_debug_message(GM_version);
				room_goto_next();
			}
		}, [], -1);
		time_source_start(_initChecker);
	}
	else
	{
		call_later(2, time_source_units_frames, function(){
			room_goto_with_transition(room_next(room), undefined, { SkipHalf: true });
		});
	}
	
	_gameReady = false;
	CallGameReady = function()
	{
		if(!_gameReady)
		{
			//GamePush_GameStart();
			_gameReady = true;
		}
	}
	
	//_pauseHandler = new sGamePushEventHandler(GamePush_CallOnPause, method(self, function(){ _setGlobalPause(true) }));
	//_resumeHandler = new sGamePushEventHandler(GamePush_CallOnResume, method(self, function(){ _setGlobalPause(false) }));
	
	LogInfo = function(str)
	{
		if(DevMode)
		{
			show_debug_message("Info: {0}", str);
		}
	}
	
	LogWarning = function(str)
	{
		if(DevMode)
		{
			show_debug_message("Waring: {0}", str);
		}
	}
	
	LogError = function(str)
	{
		show_debug_message("Error: {0}", str);
	}
	
	/*
	var buffer = buffer_create(256, buffer_fixed, 1);
	show_message(buffer);
	var addr = buffer_get_address(buffer);
	show_message(addr);
	*/
	
	//application_surface_enable(true);
	//application_surface_draw_enable(false);
	shader_reset();
	gpu_set_ztestenable(true);
	gpu_set_zwriteenable(true);
	gpu_set_alphatestenable(true);
	gpu_set_alphatestref(16.0);
	gpu_set_cullmode(cull_counterclockwise);
	
	
	gpu_set_tex_filter(true);
	gpu_set_tex_mip_enable(mip_on);
	gpu_set_tex_mip_filter(tf_linear);
	gpu_set_tex_min_mip(0);
	gpu_set_tex_max_mip(4);
	gpu_set_tex_max_aniso(4);
	
	gpu_set_tex_repeat(true);
	
	//display_reset(0, false);
}

function CCore_Init()
{
	new sCCore();
}

