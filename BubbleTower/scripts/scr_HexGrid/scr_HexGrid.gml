global.LUT_hex_cell_even = [
	[  0, -1 ],
	[  1, -1 ],
	[ -1,  0 ],
	[  1,  0 ],
	[  1,  1 ],
	[  0,  1 ]
];

global.LUT_hex_cell_not_even = [
	[ -1, -1 ],
	[  0, -1 ],
	[ -1,  0 ],
	[  1,  0 ],
	[  0,  1 ],
	[ -1,  1 ]
];

function sBall(color) constructor
{
	Color = color;
	Locked = false;
	OffsetX = 0;
	OffsetY = 0;
	VelocityX = 0;
	VelocityY = 0;
	
	Step = function()
	{
		//OffsetX = lengthdir_x(8, current_time * 0.1);
		//OffsetY = lengthdir_y(8, current_time * 0.1);
	}
}


function sHexGrid() constructor
{
	//    (1)(2)
	//  (6)(0)(3)
	//   (5)(4)
	
	_ballDiameter = 10;
	_ballRadius = _ballDiameter / 2;
	_cellNumX = 24;
	_cellNumY = 18;
	_cellNumTotal = _cellNumX * _cellNumY;
	
	_ballStepX = _ballDiameter;
	_ballOffsetX = _ballRadius;
	_ballStepY = sqrt(3) * _ballRadius;
	
	_fieldW = _ballStepX * _cellNumX;
	_fieldH = _ballStepY * _cellNumY - _ballStepY + _ballDiameter;
	
	_grid = array_create(_cellNumTotal, undefined);
	
	_angleStep = 360 / _cellNumX;
	_angleHalfStep = _angleStep / 2;
	_wrapRadius = _ballRadius / dtan(_angleHalfStep);
	_cylinderRadius = _wrapRadius - _ballRadius;
	_cylinderHeight = _fieldH + _ballDiameter * 2;
	
	_createBalls = function(rowNum)
	{
		var cellNum = rowNum * _cellNumX;
		for(var i=0; i<cellNum; i++)
		{
			if(irandom(1))
			{
				var color = choose(
					#FF0000, #FFFF00, #00FF00, #00FFFF, #0000FF//, #FF00FF, c_orange
				);
				_grid[i] = new sBall(color);
			}
		}
	}
	
	_createBalls(10);
	
	Convert2DTo3D = function(px, py, outPos)
	{
		var anglePos = (px / _fieldW) * 360;
		outPos[@ 0] = lengthdir_x(_wrapRadius, anglePos);
		outPos[@ 1] = lengthdir_y(_wrapRadius, anglePos);
		outPos[@ 2] = _fieldH - py;// - _ballRadius;
	}
	
	Convert3DTo2D = function(px, py, pz, outPos)
	{
		var dir = point_direction(0, 0, px, py);
		outPos[@ 0] = (dir / 360) * _fieldW;
		outPos[@ 1] = _fieldH - pz;
	}
	
	_cannonY = _cylinderHeight - _ballRadius;
	SetCannonPosition = function(angle)
	{
		_cannonX = angle_normalize360(angle) / 360 * _fieldW;
	}
	
	_rayTargetPosX = 0;
	_rayTargetPosY = 0;
	SetRayTargetPos = function(px, py)
	{
		_rayTargetPosX = px;
		_rayTargetPosY = py;
	}
	
	GetRayAngle = function()
	{
		var angle1 = (_cannonX / _fieldW) * 360;
		var angle2 = (_rayTargetPosX / _fieldW) * 360;
		var posDiff = angle_difference(angle1, angle2) / 360 * _fieldW;
		return point_direction(0, _cannonY, posDiff, _rayTargetPosY) - 90;
	}
	
	_positionsLUT2D_X = array_create(_cellNumTotal);
	_positionsLUT2D_Y = array_create(_cellNumTotal);
	_positionsLUT3D_X = array_create(_cellNumTotal);
	_positionsLUT3D_Y = array_create(_cellNumTotal);
	_positionsLUT3D_Z = array_create(_cellNumTotal);
	_createPositionsLUT = function()
	{
		var k = 0;
		for(var j=0; j<_cellNumY; j++)
		{
			var py = j * _ballStepY + _ballRadius;
			var pxOffset = j%2==0 ? 0 : _ballOffsetX;
			for(var i=0; i<_cellNumX; i++)
			{
				var px = i * _ballStepX + pxOffset;
				_positionsLUT2D_X[k] = px;
				_positionsLUT2D_Y[k] = py;
				k++;
			}
		}
		
		var pos3d = [];
		for(var i=0; i<_cellNumTotal; i++)
		{
			var px = _positionsLUT2D_X[i];
			var py = _positionsLUT2D_Y[i];
			Convert2DTo3D(px, py, pos3d);
			_positionsLUT3D_X[i] = pos3d[0];
			_positionsLUT3D_Y[i] = pos3d[1];
			_positionsLUT3D_Z[i] = pos3d[2];
		}
	}
	
	_createPositionsLUT();
	
	GetCellPos2D = function(cx, cy, outPos)
	{
		var i = cy * _cellNumX + cx;
		outPos[@ 0] = _positionsLUT2D_X[i];
		outPos[@ 1] = _positionsLUT2D_Y[i];
	}
	
	GetCellPos3D = function(cx, cy, outPos)
	{
		var i = cy * _cellNumX + cx;
		outPos[@ 0] = _positionsLUT3D_X[i];
		outPos[@ 1] = _positionsLUT3D_Y[i];
		outPos[@ 2] = _positionsLUT3D_Z[i];
	}
	
	GetCell = function(cx, cy)
	{
		return _grid[ cy * _cellNumX + (cx % _cellNumX + _cellNumX) % _cellNumX ];
	}
	
	CleanUp = function()
	{
		
	}
	
	Step = function()
	{
		var pos3d = [];
		for(var i=0; i<_cellNumTotal; i++)
		{
			var cell = _grid[i];
			if(cell!=undefined)
			{
				cell.Step();
			}
		}
	}
	
	Draw = function(px, py)
	{
		var scl = 2;
		
		var r = _ballRadius * scl-1;
		
		var x1 = px;
		var y1 = py;
		var x2 = x1 + _fieldW * scl;
		var y2 = y1 + _fieldH * scl;
		
		draw_set_color(c_black);
		draw_rectangle(x1, y1, x2, y2 + _ballDiameter * scl * 2, false);
		
		for(var i=0; i<_cellNumTotal; i++)
		{
			var ball = _grid[i];
			if(ball!=undefined)
			{
				draw_set_color(ball.Color);
				var posX = (_positionsLUT2D_X[i] + ball.OffsetX) * scl;
				var posY = (_positionsLUT2D_Y[i] + ball.OffsetY) * scl;
				draw_circle(px + posX, py + posY, r, false);
			}
		}
		
		
		draw_set_color(c_red);
		draw_rectangle(x1, y1, x2, y2, true);
		
		draw_rectangle(x1, y2, x2, y2 + _ballDiameter * scl * 2, true);
		
		draw_set_color(c_white);
		draw_circle(x1 + _cannonX * scl, y1 + _cannonY * scl, r, false);
		
		draw_line(x1 + _cannonX * scl, y1 + _cannonY * scl, x1 + _rayTargetPosX * scl, y1 + _rayTargetPosY * scl);
		
		_drawSelectedCell(px, py, scl);
	}
	
	_snapToIndex = function(px, py, outPos)
	{
		var size = _ballRadius;
		var cellSizeX = size; //size * sqrt(3) / 2;
		var cellSizeY = ( size * (2 / sqrt(3)) ) / 2; //size / 2;
	
		py -= size; //cellSizeY * 2;
	
		var ix = floor(px / cellSizeX);
		var iy = floor(py / cellSizeY);
		
		if(iy%3==1) {
			var dx = px - ix * cellSizeX;
			var dy = py - iy * cellSizeY;
			var diag = ( (iy%6==1) + (ix%2==0) ) % 2;
			var addIY = dy > (diag ? lerp(0, cellSizeY, dx/cellSizeX) : lerp(cellSizeY, 0, dx/cellSizeX));
			iy += addIY ? 1 : -1;
		}
		
		if(iy%3==2) {
			iy++;
		}
		
		if( (ix%2) == (iy%6!=3) ) {
			ix++;
		}
		
		var colIdx = wrap((ix div 2), 0, _cellNumX);
		var rowIdx = iy div 3;
		if(colIdx<0 || colIdx>=_cellNumX || rowIdx<0 || rowIdx>=_cellNumY) {
			return -1;
		}
		
		outPos[@ 0] = ix * cellSizeX;
		outPos[@ 1] = iy * cellSizeY + _ballRadius;
		
		return rowIdx * _cellNumX + colIdx;
	}
	
	_drawSelectedCell = function(px, py, scl)
	{
		if(!device_mouse_check_button(0, mb_left)) {
			return;
		}
		
		var x1 = px;
		var y1 = py;
		var x2 = x1 + _fieldW * scl;
		var y2 = y1 + _fieldH * scl;
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		
		if(!point_in_rectangle(mx, my, x1, y1, x2, y2))
		{
			return;
		}
		
		var r = _ballRadius * scl;
		
		
		var outPos = [ 0, 0 ];
		var i = _snapToIndex((mx - px) / scl, (my - py)/scl, outPos);
		if(i==-1)
		{
			return;
		}
		
		var cx = px + _positionsLUT2D_X[i] * scl;
		var cy = py + _positionsLUT2D_Y[i] * scl;
		//var cx = outPos[0] * scl + px;
		//var cy = outPos[1] * scl + px;
		
		
		draw_set_color(c_white);
		//draw_set_alpha(0.5);
		draw_circle(cx, cy, r, true);
		draw_set_alpha(1);
		
		draw_set_color(c_white);
		draw_circle(mx, my, 2, false);
		
		draw_set_colour(c_maroon);
		draw_text(4, 4, $"index = {i}");
	}
	
	WrapCylinderRayCast = function(ox, oy, oz, vx, vy, vz, outResult)
	{
		static col = [ 0, 0, 0, 0 ];
		
		var dist2d = point_distance(0, 0, vx, vy);
		if(dist2d<0.0000001) {
			return false;
		}
		
		if(line_circle_collision_point(ox, oy, ox + vx, oy + vy, 0, 0, _wrapRadius, col)) {
			outResult[@ 0] = col[0];
			outResult[@ 1] = col[1];
			outResult[@ 2] = oz + point_distance(ox, oy, col[0], col[1]) * (vz / dist2d);
			return true;
		}
		return false;
	}
}

function screen_to_world_ray_perspective(x, y, viewMatrix, projMatrix, screenW, screenH, outResult)
{
	static mViewProj = matrix_build_identity();
	matrix_multiply(viewMatrix, projMatrix, mViewProj);
	
	static mInvViewProj = matrix_build_identity();
	matrix_inverse(mViewProj, mInvViewProj);
	
	var nx = ( 2.0 * x / screenW ) - 1.0;
	var ny = ( 2.0 * y / screenH ) - 1.0;
	
	static v0 = [ 0, 0, 0, 0 ];
	matrix_transform_vertex(mInvViewProj, nx, ny, 0, 1, v0);
	v0[0] /= v0[3];
	v0[1] /= v0[3];
	v0[2] /= v0[3];
	
	static v1 = [ 0, 0, 0, 0 ];
	matrix_transform_vertex(mInvViewProj, nx, ny, 1, 1, v1);
	v1[0] /= v1[3];
	v1[1] /= v1[3];
	v1[2] /= v1[3];
	
	// origin at near clip plane
	outResult[@ 0] = v0[0];
	outResult[@ 1] = v0[1];
	outResult[@ 2] = v0[2];
	
	// normalized direction vector
	var d = point_distance_3d(v0[0], v0[1], v0[2], v1[0], v1[1], v1[2]);
	outResult[@ 3] = ( v1[0] - v0[0] ) / d;
	outResult[@ 4] = ( v1[1] - v0[1] ) / d;
	outResult[@ 5] = ( v1[2] - v0[2] ) / d;
}

function point_line_projection_2d(px, py, x1, y1, x2, y2, outResult)
{
	var l = point_distance(x1, y1, x2, y2);
	if(l<0.0000001) {
		return false;
	}
	
	var ldx = (x2 - x1) / l;
	var ldy = (y2 - y1) / l;
	var k = dot_product(px - x1,  py - y1, ldx, ldy);
	
	outResult[@ 0] = x1 + ldx * k;
	outResult[@ 1] = y1 + ldy * k;
	return true;
}

function line_circle_collision_point(x1, y1, x2, y2, cx, cy, cr, outResult)
{
	static p = [ 0, 0 ];
	if(point_line_projection_2d(cx, cy, x1, y1, x2, y2, p)) {
		var d = point_distance(cx, cy, p[0], p[1]);
		if(d<=cr) {
			var b = sqrt(cr*cr - d*d);
			var l = point_distance(x1, y1, x2, y2);
			if(l>0.0000001) {
				var vx = (x2 - x1)/l;
				var vy = (y2 - y1)/l;
				outResult[@ 0] = p[0] - vx*b;
				outResult[@ 1] = p[1] - vy*b;
				outResult[@ 2] = p[0] + vx*b;
				outResult[@ 3] = p[1] + vy*b;
				return true;
			}
		}
	}
	
	return false;
}

