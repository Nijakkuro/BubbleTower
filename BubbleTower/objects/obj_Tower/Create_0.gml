_cylinder = new sCylinder();
_sphere = new sSphere();
_gameField = new sGameField();
_cylindricRaycast = new sCylindricRaycastLine();

_cylinderRadius = _gameField._cylinderRadius;
_cylinderHeight = _gameField._cylinderHeight;

_cylinderZ2 = _gameField._fieldH;
_cylinderZ1 = -_gameField._ballDiameter * 2;
_cylinderHeight = _cylinderZ2 - _cylinderZ1;
_cylinderCZ = _cylinderZ1 + _cylinderHeight * 0.5;

_drawSpheres = function()
{
	var outPos = [0, 0];
	
	var s = (_gameField._ballDiameter - 0.25) / 100;
	var n = _gameField._cellNumTotal;
	for(var i=0; i<n; i++)
	{
		var ball = _gameField._grid[i];
		if(ball!=undefined)
		{
			var px = _gameField._positionsLUT2D_X[i];
			var py = _gameField._positionsLUT2D_Y[i];
			//var pz = _gameField._positionsLUT3D_Z[i];
			
			_gameField.Convert2DTo3D(px + ball.OffsetX, py + ball.OffsetY, outPos);
			px = outPos[0];
			py = outPos[1];
			var pz = outPos[2];
			
			_sphere.Draw(px, py, pz, s, s, s, ball.Color);
		}
	}
	
	var px = -lengthdir_x(_gameField._wrapRadius, obj_Camera.ZAngle);
	var py = -lengthdir_y(_gameField._wrapRadius, obj_Camera.ZAngle);
	_sphere.Draw(px, py, -_gameField._ballDiameter * 1.5, s, s, s, c_white);
}

_result = [ 0, 0, 0, 0, 0, 0 ];

_drawTower = function()
{
	var s = (_cylinderRadius * 2)/100;
	
	_cylinder.Draw(0, 0, _cylinderCZ, s, s, _cylinderHeight / 100);
	
	s = s + 0.3;//25;
	
	_cylinder.Draw(0, 0, _cylinderCZ + _cylinderHeight, s, s, _cylinderHeight / 100);
	
	_cylinder.Draw(0, 0, _cylinderCZ - _cylinderHeight, s, s, _cylinderHeight / 100);
	
	s = (_cylinderRadius * 2 + 1)/100;
	_cylinder.Draw(0, 0, _cylinderZ1 + _gameField._ballRadius * 4, s, s, 0.001);
}

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
	
	var traceLen = 10000;
	_cylindricRaycast.Draw( 0, 0, posZ,
		cylinderRadius, cylinderFullSpinLen, startPosAngle,
		rayAngle, rayThickness, raySegmentLen, traceLen
	);
}

// CLEAN UP
_cleanUp = function()
{
	_cylinder.CleanUp();
	_sphere.CleanUp();
	_cylindricRaycast.CleanUp();
	_gameField.CleanUp();
}

_ray = [ 0, 0, 0, 0, 0, 0 ];
_hit = false;
_hitPos = [ 0, 0, 0 ];
_hitPos2D = [ 0, 0 ];

// STEP
_step = function()
{
	_gameField.SetCannonPositionByAngle(obj_Camera.ZAngle-180);
	
	_hit = false;
	if(device_mouse_check_button(0, mb_left))
	{
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		var gw = display_get_gui_width();
		var gh = display_get_gui_height();
		screen_to_world_ray_perspective(mx, my, obj_Camera._viewMat, obj_Camera._projMat, gw, gh, _ray);
		
		if(_gameField.SetCannonAngleByWrapCylinderRaycast(_ray[0], _ray[1], _ray[2], _ray[3], _ray[4], _ray[5]))
		{
			_hit = true;
		}
	}
	
	/*
	if(_hit)
	{
		_gameField.Convert3DTo2D(_hitPos[0], _hitPos[1], _hitPos[2], _hitPos2D);
		_gameField.SetCannonAngleByTargetPos(_hitPos2D[0], _hitPos2D[1]);
	}
	*/
	
	_gameField.Step();
}

// DRAW
_draw = function()
{
	_drawTower();
	_drawSpheres();
	
	//if(_hit)
	//{
	//	_sphere.Draw(_hitPos[0], _hitPos[1], _hitPos[2], 0.1, 0.1, 0.1, c_orange);
	//}
	
	_drawRay();
}

// DRAW GUI
_drawGUI = function()
{
	_gameField.Draw(4, 4);
	
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

