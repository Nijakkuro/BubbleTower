#macro GameScreenW 1920
#macro GameScreenH 1080

#macro CDisplay global.sCDisplay
CDisplay = sCDisplay;

/// @ignore
function sCDisplay() constructor
{
	singleton_struct;
	
	application_surface_enable(true);
	application_surface_draw_enable(true);
	
	//gpu_set_tex_filter(false);
	//gpu_set_tex_mip_enable(mip_markedonly);
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_one);
	
	_display = instance_create_depth(0, 0, 10000, obj_Display);
	_displayEnd = instance_create_depth(0, 0, -10000, obj_Display_End);
	
	_gameplayPauseSprite = undefined;
	OnGameplayPause = function() {
		if(_gameplayPauseSprite!=undefined) {
			sprite_delete(_gameplayPauseSprite);
		}
		
		var surf = application_surface;
		var w = surface_get_width(surf);
		var h = surface_get_height(surf);
		_gameplayPauseSprite = sprite_create_from_surface(surf, 0, 0, w, h, false, false, 0, 0);
		application_surface_draw_enable(false);
	}
	
	OnGameplayResume = function() {
		if(_gameplayPauseSprite!=undefined) {
			sprite_delete(_gameplayPauseSprite);
			_gameplayPauseSprite = undefined;
			application_surface_draw_enable(true);
		}
	}
	
	BeginStep = function() {
		var w = NOGX_get_canvas_width();
		var h = NOGX_get_canvas_height();
		var asp = w / h;
		var guiH = 720;
		var guiW = guiH * asp;
		display_set_gui_size(guiW, guiH);
	}
	
	DrawBegin = function() {}
	DrawEnd = function() {}
	PostDraw = function() {
		if(!application_surface_is_draw_enabled() && _gameplayPauseSprite!=undefined) {
			var pos = application_get_position();
			var px = pos[0];
			var py = pos[1];
			if(os_type==os_gxgames || os_browser!=browser_not_a_browser) {
				px = 0;
				py = 0;
			}
			var pw = NOGX_get_canvas_width();
			var ph = NOGX_get_canvas_height();
			draw_sprite_stretched_ext(_gameplayPauseSprite, 0, px, py, pw, ph, c_ltgray, 1);
		}
	}
	
	DrawGUIBegin = function() {}
	DrawGUI = function() {}
	DrawGUIEnd = function() {}
}

