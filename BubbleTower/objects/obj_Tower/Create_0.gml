_cylinder = new sCylinder();
_sphere = new sSphere();
_grid = new sHexGrid();
_cylindricRaycast = new sCylindricRaycastLine();

_cylinderRadius = _grid._cylinderRadius;
_cylinderHeight = _grid._cylinderHeight;

_cylinderZ2 = _grid._fieldH;
_cylinderZ1 = -_grid._ballDiameter * 2;
_cylinderHeight = _cylinderZ2 - _cylinderZ1;
_cylinderCZ = _cylinderZ1 + _cylinderHeight * 0.5;

_drawSpheres = function()
{
	var outPos = [0, 0];
	
	var s = (_grid._ballDiameter - 0.25) / 100;
	var n = _grid._cellNumTotal;
	for(var i=0; i<n; i++)
	{
		var ball = _grid._grid[i];
		if(ball!=undefined)
		{
			var px = _grid._positionsLUT2D_X[i];
			var py = _grid._positionsLUT2D_Y[i];
			//var pz = _grid._positionsLUT3D_Z[i];
			
			_grid.Convert2DTo3D(px + ball.OffsetX, py + ball.OffsetY, outPos);
			px = outPos[0];
			py = outPos[1];
			var pz = outPos[2];
			
			_sphere.Draw(px, py, pz, s, s, s, ball.Color);
		}
	}
	
	var px = -lengthdir_x(_grid._wrapRadius, obj_Camera.ZAngle);
	var py = -lengthdir_y(_grid._wrapRadius, obj_Camera.ZAngle);
	_sphere.Draw(px, py, -_grid._ballDiameter * 1.5, s, s, s, c_white);
}

_result = [ 0, 0, 0, 0, 0, 0 ];

_drawTower = function()
{
	var s = (_cylinderRadius * 2)/100;
	
	_cylinder.Draw(0, 0, _cylinderCZ, s, s, _cylinderHeight / 100);
	
	s = s + 0.3;//25;
	
	_cylinder.Draw(0, 0, _cylinderCZ + _cylinderHeight, s, s, _cylinderHeight / 100);
	
	_cylinder.Draw(0, 0, _cylinderCZ - _cylinderHeight, s, s, _cylinderHeight / 100);
}

_drawRay = function()
{
	if(_hit)
	{
		var angle = _grid.GetRayAngle();
		_cylindricRaycast.Draw( 0, 0, _cylinderZ1 + _grid._ballRadius, _grid._wrapRadius, _grid._fieldW, -obj_Camera.ZAngle + 180, angle, _grid._ballRadius / 2, _grid._ballRadius, 10000);
	}
}

// CLEAN UP
_cleanUp = function()
{
	_cylinder.CleanUp();
}

_ray = [ 0, 0, 0, 0, 0, 0 ];
_hit = false;
_hitPos = [ 0, 0, 0 ];
_hitPos2D = [ 0, 0 ];

// STEP
_step = function()
{
	_grid.SetCannonPosition(obj_Camera.ZAngle-180);
	
	_hit = false;
	if(device_mouse_check_button(0, mb_left))
	{
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		var gw = display_get_gui_width();
		var gh = display_get_gui_height();
		screen_to_world_ray_perspective(mx, my, obj_Camera._viewMat, obj_Camera._projMat, gw, gh, _ray);
		
		if(_grid.WrapCylinderRayCast(_ray[0], _ray[1], _ray[2], _ray[3], _ray[4], _ray[5], _hitPos))
		{
			_hit = true;
		}
	}
	
	if(_hit)
	{
		_grid.Convert3DTo2D(_hitPos[0], _hitPos[1], _hitPos[2], _hitPos2D);
		_grid.SetRayTargetPos(_hitPos2D[0], _hitPos2D[1]);
	}
	
	_grid.Step();
}

// DRAW
_draw = function()
{
	_drawTower();
	_drawSpheres();
	
	if(_hit)
	{
		_sphere.Draw(_hitPos[0], _hitPos[1], _hitPos[2], 0.1, 0.1, 0.1, c_orange);
	}
	
	_drawRay();
}

// DRAW GUI
_drawGUI = function()
{
	_grid.Draw(4, 4);
	
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

