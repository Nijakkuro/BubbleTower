if(os_browser==browser_not_a_browser)
{
	MakeTowerTexture();
}

_sphere = new sBallMesh();
_gameField = new sGameField();
_cylindricRaycast = new sCylindricRaycastLine();

_cylinderRadius = _gameField._cylinderRadius;
_cylinderHeight = _gameField._cylinderHeight;

_cylinderZ2 = _gameField._fieldH;
_cylinderZ1 = -_gameField._ballDiameter * 2;
_cylinderHeight = _cylinderZ2 - _cylinderZ1;
_cylinderCZ = _cylinderZ1 + _cylinderHeight * 0.5;

/*
var asp = _cylinderHeight;
//var asp = _cylinderRadius * 2 * pi / 4;
//var asp = (_cylinderRadius * 1.5 - _cylinderRadius);
//var asp = (2 * pi * _cylinderRadius * 1.5) / (_cylinderHeight + 128 + rh*2);
//var asp = (2 * pi * _cylinderRadius) / _cylinderHeight;
//var asp = (2 * pi * _cylinderRadius*1.5) / (_cylinderRadius * 1.5 - _cylinderRadius);
//var asp = (2 * pi * _cylinderRadius*1.5) / 64;
var str = string_replace(string_format(asp, 8, 8), ".", ",");
show_message(str);
clipboard_set_text(string_trim(str));
*/

_tower = new sTowerMesh(_cylinderZ2, _cylinderZ1, 64, _cylinderRadius, _cylinderRadius * 1.5);

_drawSpheres = function()
{
	//return;
	
	_sphere.DrawInstancesBegin();
	
	var outPos = [0, 0];
	
	var s = (_gameField._ballDiameter - 0.25) / 100;
	var n = _gameField._cellNumTotal;
	var i = 0;
	var grid = _gameField._grid;
	var sphere = _sphere;
	repeat(n) {
		var ball = grid[i];
		if(ball!=undefined) {
			sphere.DrawInstance(ball.Pos3D_X, ball.Pos3D_Y, ball.Pos3D_Z, ball.ColorIndex);
		}
		i++;
	}
	
	_sphere.DrawInstancesEnd();
	
	var px = -lengthdir_x(_gameField._wrapRadius, obj_Camera.ZAngle);
	var py = -lengthdir_y(_gameField._wrapRadius, obj_Camera.ZAngle);
	_sphere.Draw(px, py, -_gameField._ballDiameter * 1.5, 0);
}

_drawSpheresDepth = function()
{
	_sphere.DrawDepthInstancesBegin();
	
	var outPos = [0, 0];
	
	var s = (_gameField._ballDiameter - 0.25) / 100;
	var n = _gameField._cellNumTotal;
	var i = 0;
	var grid = _gameField._grid;
	var sphere = _sphere;
	repeat(n) {
		var ball = grid[i];
		if(ball!=undefined) {
			sphere.DrawDepthInstance(ball.Pos3D_X, ball.Pos3D_Y, ball.Pos3D_Z);
		}
		i++;
	}
	
	_sphere.DrawDepthInstancesEnd();
	
	var px = -lengthdir_x(_gameField._wrapRadius, obj_Camera.ZAngle);
	var py = -lengthdir_y(_gameField._wrapRadius, obj_Camera.ZAngle);
	_sphere.DrawDepth(px, py, -_gameField._ballDiameter * 1.5);
}


_result = [ 0, 0, 0, 0, 0, 0 ];

_drawRay = function() {
	if(!_hit) {
		return;
	}
	
	var posZ = _cylinderZ1 + _gameField._ballRadius;
	var cylinderRadius = _gameField._wrapRadius;
	var cylinderFullSpinLen = _gameField._fieldW;
	var startPosAngle =  -obj_Camera.ZAngle + 180;
	
	var rayAngle = -_gameField.GetCannonAngle();
	var rayThickness = _gameField._ballRadius / 2;
	var raySegmentLen = _gameField._ballRadius;
	
	var traceLen = _gameField.GetCannonTraceLength();
	_cylindricRaycast.Draw( 0, 0, posZ,
		cylinderRadius, cylinderFullSpinLen, startPosAngle,
		rayAngle, rayThickness, raySegmentLen, traceLen
	);
	
	var idx = _gameField.GetCannonTraceCellIndex();
	if(idx!=-1)
	{
		var px = _gameField._positionsLUT3D_X[idx];
		var py = _gameField._positionsLUT3D_Y[idx];
		var pz = _gameField._positionsLUT3D_Z[idx];
		var s = 0.1;
		_sphere.Draw(px, py, pz, 0);
	}
}

// CLEAN UP
_cleanUp = function()
{
	_tower.CleanUp();
	_sphere.CleanUp();
	_cylindricRaycast.CleanUp();
	_gameField.CleanUp();
}

_ray = [ 0, 0, 0, 0, 0, 0 ];
_hit = false;
_hitPos = [ 0, 0, 0 ];
_hitPos2D = [ 0, 0 ];

_rotateLB = false;
_rotate = false;
_rotationControlZonePercentage = 0.175;
_angleSpeed = 0;

_mouseMoved = false;
_mousePrevX = 0;
_mousePrevY = 0;

// STEP
_step = function()
{
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
	_angleSpeed *= 0.8;
	_gameField.SetCannonPositionByAngle(obj_Camera.ZAngle-180);
	
	// trace
	
	if(!_rotate)
	{
		if(_mouseMoved || device_mouse_check_button(0, mb_left))
		{
			var gw = display_get_gui_width();
			var gh = display_get_gui_height();
			screen_to_world_ray_perspective(mx, my, obj_Camera._viewMat, obj_Camera._projMat, gw, gh, _ray);
			
			_hit = false;
			if(_gameField.SetCannonAngleByWrapCylinderRaycast(_ray[0], _ray[1], _ray[2], _ray[3], _ray[4], _ray[5]))
			{
				_hit = _gameField.CannonTrace();
			}
		}
		
		if(_hit && device_mouse_check_button_released(0, mb_left))
		{
			_hit = false;
			_gameField.CannonShot();
		}
	}
	else
	{
		_hit = false;
	}
	
	// update game field
	_gameField.Step();
}

_drawOther = true;

// DRAW
_draw = function()
{
	if(keyboard_check_pressed(vk_space))
	{
		_drawOther = !_drawOther;
	}
	
	_tower.Draw();
	
	if(!_drawOther)
	{
		return;
	}
	
	//_drawTower();
	_drawSpheres();
	
	if(_hit)
	{
		_sphere.Draw(_hitPos[0], _hitPos[1], _hitPos[2], 0);
	}
	
	_drawRay();
	
	if(_gameField._cannonShot) {
		var px = _gameField._cannonBallPos3D_X;
		var py = _gameField._cannonBallPos3D_Y;
		var pz = _gameField._cannonBallPos3D_Z;
		var s = 0.1;
		_sphere.Draw(px, py, pz, 0);
	}
}

_drawDepth = function()
{
	_tower.DrawDepth();
	
	if(!_drawOther)
	{
		return;
	}
	
	_drawSpheresDepth();
	
	if(_gameField._cannonShot) {
		var px = _gameField._cannonBallPos3D_X;
		var py = _gameField._cannonBallPos3D_Y;
		var pz = _gameField._cannonBallPos3D_Z;
		var s = 0.1;
		_sphere.DrawDepth(px, py, pz);
	}
}

// DRAW GUI
_drawGUI = function()
{
	//_gameField.Draw(4, 4);
	
	var gw = display_get_gui_width();
	var gh = display_get_gui_height();
	
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text(gw/2, 16, $"FPS = {fps}");
	draw_text(gw/2, 36, $"FPS real = {fps_real}");
	
	/*
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	var gw = display_get_gui_width();
	var gh = display_get_gui_height();
	screen_to_world_ray_perspective(mx, my, obj_Camera._viewMat, obj_Camera._projMat, gw, gh, _result);
	
	draw_set_color(c_white);
	draw_text(512, 32, $"CameraPos = {obj_Camera.x}, {obj_Camera.y}, {obj_Camera.z}");
	draw_text(512, 64, _result);
	*/
}

