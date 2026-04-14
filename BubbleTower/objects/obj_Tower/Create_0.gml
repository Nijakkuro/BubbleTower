if(os_browser==browser_not_a_browser) {
	MakeTowerTexture();
}

_gameField = new sGameField();
_gameFieldRenderer = new sGameFieldRenderer(_gameField);
_cannon = new sGameFieldCannon(_gameField);

// cylinder parametres
_cylinderRadius = _gameField._cylinderRadius;
_cylinderHeight = _gameField._cylinderHeight;
_cylinderZ2 = _gameField._fieldH;
_cylinderZ1 = -_gameField._ballDiameter * 2;
_cylinderHeight = _cylinderZ2 - _cylinderZ1;
_cylinderCZ = _cylinderZ1 + _cylinderHeight * 0.5;

// tower mesh
_tower = new sTowerMesh(_cylinderZ2, _cylinderZ1, 64, _cylinderRadius, _cylinderRadius + _gameField._ballDiameter * 1.5 );

// control
_rotateLB = false;
_rotate = false;
_rotationControlZonePercentage = 0.175;
_angleSpeed = 0;
_angleSpeedFade = 0.8;

_mouseMoved = false;
_mousePrevX = 0;
_mousePrevY = 0;

// raycast
_ray = [ 0, 0, 0, 0, 0, 0 ];
_hit = false;

// CLEAN UP
_cleanUp = function() {
	_tower.CleanUp();
}

// STEP
_step = function() {
	// rotate
	
	var pixelRatio = NOGX_get_pixel_ratio();
	var mx = device_mouse_x_to_gui(0) * pixelRatio;
	var my = device_mouse_y_to_gui(0) * pixelRatio;
	_mouseMoved = mx != _mousePrevX || my != _mousePrevY;
	_mousePrevX = mx;
	_mousePrevY = my;
	
	if(!_rotate) {
		if(	device_mouse_check_button_pressed(0, mb_right)
			|| (
					device_mouse_check_button_pressed(0, mb_left)
					&& my > display_get_gui_height() * (1 - _rotationControlZonePercentage)
				)
		) {
			_rotateMouseStartX = mx;
			_rotate = true;
			_rotateLB = device_mouse_check_button_pressed(0, mb_left);
			window_set_cursor(cr_size_we);
		}
	} else {
		if(!device_mouse_check_button(0, _rotateLB ? mb_left : mb_right)) {
			_rotate = false;
			window_set_cursor(cr_default);
		} else {
			var dx = -( mx - _rotateMouseStartX ) * 0.05;
			_rotateMouseStartX = mx;
			_angleSpeed += dx;
		}
	}
	
	obj_Camera.ZAngle += _angleSpeed;
	_angleSpeed *= _angleSpeedFade;
	_gameField.SetRotationAngle(obj_Camera.ZAngle-180);
	_cannon.SetPositionByAngle(_gameField._rotationAngle);
	
	// trace
	
	if(!_rotate) {
		if(_mouseMoved || device_mouse_check_button(0, mb_left)) {
			var gw = display_get_gui_width();
			var gh = display_get_gui_height();
			screen_to_world_ray_perspective(mx, my, obj_Camera._viewMat, obj_Camera._projMat, gw, gh, _ray);
			
			_hit = false;
			if(_cannon.SetAngleByWrapCylinderRaycast(_ray[0], _ray[1], _ray[2], _ray[3], _ray[4], _ray[5])) {
				_hit = _cannon.Trace();
			}
		}
		
		if(_hit && device_mouse_check_button_released(0, mb_left)) {
			_hit = false;
			_cannon.Shot();
		}
	} else {
		_hit = false;
	}
	
	// update game field
	_cannon.Step();
	_gameField.Step();
}

// END STEP
_endStep = function() {
	_gameFieldRenderer.UpdateBallsToDraw();
}

_drawOther = true; // TODO: remove

// DRAW
_draw = function() {
	if(keyboard_check_pressed(vk_space)) {
		_drawOther = !_drawOther;
	}
	
	_tower.Draw();
	
	if(!_drawOther) {
		return;
	}
	
	_gameFieldRenderer.Draw();
	_cannon.Draw();
}

_drawDepth = function() {
	_tower.DrawDepth();
	
	if(!_drawOther) {
		return;
	}
	
	_gameFieldRenderer.DrawDepth();
	_cannon.DrawDepth();
}

// DRAW GUI
_drawGUI = function() {
	var gw = display_get_gui_width();
	var gh = display_get_gui_height();
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text(gw/2, 16, $"FPS = {fps}");
	draw_text(gw/2, 36, $"FPS real = {fps_real}");
}

