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

function sBall(index, color, colorIndex=0) constructor
{
	Index = index;
	Color = color;
	ColorIndex = colorIndex;
	Locked = false;
	OffsetX = 0;
	OffsetY = 0;
	VelocityX = 0;
	VelocityY = 0;
	
	Pos3D_X = 0;
	Pos3D_Y = 0;
	Pos3D_Z = 0;
	
	Moved = true;
	
	Step = function()
	{
		static outPos = [ 0, 0, 0 ];
		if(self.Moved)
		{
			var i = self.Index;
			var gf = global.game_field;
			var px = gf._positionsLUT2D_X[i];
			var py = gf._positionsLUT2D_Y[i];
			
			OffsetX *= 0.9;
			OffsetY *= 0.9;
			
			if(OffsetX < 0.01 && OffsetY < 0.01)
			{
				OffsetX = 0;
				OffsetY = 0;
				self.Moved = false;
			}
			
			gf.Convert2DTo3D(px + self.OffsetX, py + self.OffsetY, outPos);
			self.Pos3D_X = outPos[0];
			self.Pos3D_Y = outPos[1];
			self.Pos3D_Z = outPos[2];
		}
	}
}

global.game_field = undefined;
function sGameField() constructor {
	global.game_field = self;
	//      (1)(2)
	//    (6)(0)(3)
	//     (5)(4)
	
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
	
	_angleStep = 360 / _cellNumX;
	_angleHalfStep = _angleStep / 2;
	_wrapRadius = _ballRadius / dtan(_angleHalfStep);
	_cylinderRadius = _wrapRadius - _ballRadius;
	_cylinderHeight = _fieldH + _ballDiameter * 2;
	
	_grid = array_create(_cellNumTotal, undefined);
	
	
	// create balls
	_createBalls = function(rowNum) {
		var colors = [ #FF0000, #FFFF00, #00FF00, #00FFFF, #0000FF ];
		var cellNum = rowNum * _cellNumX;
		for(var i=0; i<cellNum; i++) {
			if(irandom(1)) {
				var colorIndex = irandom(4);
				var color = colors[colorIndex];
				_grid[i] = new sBall(i, color, colorIndex);
			}
		}
	}
	_createBalls(_cellNumY/2);
	
	
	// coord conversion
	Convert2DTo3D = function(px, py, outPos) {
		var anglePos = (px / _fieldW) * 360;
		outPos[@ 0] = lengthdir_x(_wrapRadius, anglePos);
		outPos[@ 1] = lengthdir_y(_wrapRadius, anglePos);
		outPos[@ 2] = _fieldH - py;
	}
	
	Convert3DTo2D = function(px, py, pz, outPos) {
		var dir = point_direction(0, 0, px, py);
		outPos[@ 0] = (dir / 360) * _fieldW;
		outPos[@ 1] = _fieldH - pz;
	}
	
	
	// cannon
	_cannonX = 0;
	_cannonY = _cylinderHeight - _ballRadius;
	_cannonAngle = 0;
	_cannonTraceLength = 100;
	_cannonTraceResultX = 0;
	_cannonTraceResultY = 0;
	_cannonTraceCellIndex = -1;
	
	SetCannonPositionByAngle = function(angle) {
		_cannonX = angle_normalize360(angle) / 360 * _fieldW;
	}
	
	SetCannonAngleByTargetPos = function(px, py) {
		if(py>_fieldH + _ballRadius) {
			return false;
		}
		
		var angle1 = (_cannonX / _fieldW) * 360;
		var angle2 = (px / _fieldW) * 360;
		var posDiff = angle_difference(angle2, angle1) / 360 * _fieldW;
		_cannonAngle = point_direction(0, _cannonY, posDiff, py) - 90;
		return true;
	}
	
	SetCannonAngleByWrapCylinderRaycast = function(ox, oy, oz, vx, vy, vz) {
		static col = [ 0, 0, 0, 0 ];
		
		var dist2d = point_distance(0, 0, vx, vy);
		if(dist2d<0.0000001) {
			return false;
		}
		
		if(line_circle_collision_point(ox, oy, ox + vx, oy + vy, 0, 0, _wrapRadius, col)) {
			var resX = col[0];
			var resY = col[1];
			var resZ = oz + point_distance(ox, oy, col[0], col[1]) * (vz / dist2d);
			
			static res2 = [ 0, 0 ];
			Convert3DTo2D(resX, resY, resZ, res2);
			return SetCannonAngleByTargetPos(res2[0], res2[1]);
		}
		return false;
	}
	
	// Вычисляет позицию, на которую прилетит шарик при выстреле из пушки из текущей позиции и направления
	CannonTrace = function() {
		
		// пушка расположена ниже чем шестиугольное поле шариков
		var startX = _cannonX;
		var startY = _cannonY;
		
		// направление пушки
		var dirX = lengthdir_x(1, _cannonAngle + 90);
		var dirY = lengthdir_y(1, _cannonAngle + 90);
		
		if(dirY>0) { // пушка направлена от поля
			return false;
		}
		
		var ringRadius = _ballRadius * 1.25;
		var ringRadiusSquared = ringRadius * ringRadius;
		
		var hit = false;
		var bestHitDist = infinity;
		var bestHitY = -infinity;
		
		var grid = _grid; // одномерный массив
		var width = _fieldW; // ширина поля
		var cellNumX = _cellNumX; // количество ячеек по оси X
		var cellNumY = _cellNumY; // количество ячеек по оси Y
		var positionsLUT2D_X = _positionsLUT2D_X;
		var positionsLUT2D_Y = _positionsLUT2D_Y;
		
		var originY = _ballRadius;
		var ballStepY = _ballStepY;
		
		for (var row = cellNumY - 1; row >= 0; row--) {
			var rowCenterY = originY + row * ballStepY;
			
			// Если вся окружность этого и всех верхних рядов целиком выше (меньше по Y),
			// чем уже найденная лучшая точка пересечения, можно завершить поиск.
			if (hit && rowCenterY + ringRadius <= bestHitY) {
				break;
			}
			
			var startIdx = row * cellNumX;
			var cy = positionsLUT2D_Y[startIdx];
			
			// Оцениваем, где луч будет по X, когда достигнет уровня ВЕРХНЕЙ границы кольца шарика
			// (так как стреляем снизу, коллизия вероятнее всего произойдет с нижней части кольца)
			var collisionYEstimate = cy - ringRadius;
			var t = (collisionYEstimate - startY) / dirY; // Параметр t: насколько далеко по лучу нужно пройти, чтобы достичь collisionYEstimate
			var xAtCollision = startX + dirX * t; // Горизонтальная позиция луча в этой точке
			
			for (var col = 0; col < cellNumX; col++) {
				var idx = startIdx + col;
				var ball = grid[idx];
				if (ball==undefined) {
					continue;
				}
				
				var baseCx = positionsLUT2D_X[idx];
				
				var kIdeal = round((xAtCollision - baseCx) / width);
				var kStart = kIdeal - 1;
				var kEnd = kIdeal + 1;
				
				for (var k = kStart; k <= kEnd; k++) {
					var cx = baseCx + k * width;
					var hitDist = ray_circle_collision_point_dist(startX, startY, dirX, dirY, cx, cy, ringRadiusSquared);
					if (hitDist!=-1 && hitDist < bestHitDist) {
						hit = true;
						bestHitDist = hitDist;
						bestHitY = startY + dirY * bestHitDist;
					}
				}
			}
		}
		
		if(hit) {
			var bestHitX = startX + dirX * bestHitDist;
			_cannonTraceResultX = bestHitX;
			_cannonTraceResultY = bestHitY;
			_cannonTraceLength = point_distance(startX, startY, bestHitX, bestHitY);
			_cannonTraceCellIndex = _snapToIndex(bestHitX, bestHitY);
			return true;
		}
		
		return false;
	}
	
	GetCannonAngle = function() { return _cannonAngle; }
	GetCannonTraceLength = function() { return _cannonTraceLength; }
	GetCannonTraceCellIndex = function() { return _cannonTraceCellIndex; }
	
	_cannonShot = false;
	_cannonBallSpeed = 4;
	_cannonBallPos2D_X = 0;
	_cannonBallPos2D_Y = 0;
	_cannonBallPos3D_X = 0;
	_cannonBallPos3D_Y = 0;
	_cannonBallPos3D_Z = 0;
	_cannonBallTargetX = 0;
	_cannonBallTargetY = 0;
	_cannonBallDirX = 0;
	_cannonBallDirY = 0;
	CannonShot = function() {
		_cannonShot = true;
		_cannonBallPos2D_X = _cannonX;
		_cannonBallPos2D_Y = _cannonY;
		_cannonBallTargetX = _cannonTraceResultX;
		_cannonBallTargetY = _cannonTraceResultY;
		var len = point_distance(_cannonBallPos2D_X, _cannonBallPos2D_Y, _cannonBallTargetX, _cannonBallTargetY);
		_cannonBallDirX = (_cannonBallTargetX - _cannonBallPos2D_X) / len;
		_cannonBallDirY = (_cannonBallTargetY - _cannonBallPos2D_Y) / len;
	}
	
	// positions LUT
	_positionsLUT2D_X = array_create(_cellNumTotal);
	_positionsLUT2D_Y = array_create(_cellNumTotal);
	_positionsLUT3D_X = array_create(_cellNumTotal);
	_positionsLUT3D_Y = array_create(_cellNumTotal);
	_positionsLUT3D_Z = array_create(_cellNumTotal);
	_createPositionsLUT = function() {
		var k = 0;
		for(var j=0; j<_cellNumY; j++) {
			var py = j * _ballStepY + _ballRadius;
			var pxOffset = j%2==0 ? 0 : _ballOffsetX;
			for(var i=0; i<_cellNumX; i++) {
				var px = i * _ballStepX + pxOffset;
				_positionsLUT2D_X[k] = px;
				_positionsLUT2D_Y[k] = py;
				k++;
			}
		}
		
		var pos3d = [];
		for(var i=0; i<_cellNumTotal; i++) {
			var px = _positionsLUT2D_X[i];
			var py = _positionsLUT2D_Y[i];
			Convert2DTo3D(px, py, pos3d);
			_positionsLUT3D_X[i] = pos3d[0];
			_positionsLUT3D_Y[i] = pos3d[1];
			_positionsLUT3D_Z[i] = pos3d[2];
		}
	}
	_createPositionsLUT();
	
	
	// cell positions
	GetCellPos2D = function(cx, cy, outPos) {
		var i = cy * _cellNumX + cx;
		outPos[@ 0] = _positionsLUT2D_X[i];
		outPos[@ 1] = _positionsLUT2D_Y[i];
	}
	
	GetCellPos3D = function(cx, cy, outPos) {
		var i = cy * _cellNumX + cx;
		outPos[@ 0] = _positionsLUT3D_X[i];
		outPos[@ 1] = _positionsLUT3D_Y[i];
		outPos[@ 2] = _positionsLUT3D_Z[i];
	}
	
	GetCell = function(cx, cy) {
		return _grid[ cy * _cellNumX + (cx % _cellNumX + _cellNumX) % _cellNumX ];
	}
	
	
	CleanUp = function() {
		
	}
	
	_tmpArr = [ 0, 0, 0 ];
	Step = function() {
		if(_cannonShot) {
			var d = point_distance(_cannonBallPos2D_X, _cannonBallPos2D_Y, _cannonBallTargetX, _cannonBallTargetY);
			if(d <= _cannonBallSpeed) {
				_cannonShot = false;
			} else {
				_cannonBallPos2D_X += _cannonBallDirX * _cannonBallSpeed;
				_cannonBallPos2D_Y += _cannonBallDirY * _cannonBallSpeed;
				
				Convert2DTo3D(_cannonBallPos2D_X, _cannonBallPos2D_Y, _tmpArr);
				_cannonBallPos3D_X = _tmpArr[0];
				_cannonBallPos3D_Y = _tmpArr[1];
				_cannonBallPos3D_Z = _tmpArr[2];
				
				var i = 0;
				repeat(_cellNumTotal) {
					var cell = _grid[i];
					if(cell!=undefined) {
						var cx = _positionsLUT2D_X[i];
						var cy = _positionsLUT2D_Y[i];
						var d = point_distance(_cannonBallPos2D_X, _cannonBallPos2D_Y, cx, cy);
						if(d<_ballDiameter) {
							var vx = (cx - _cannonBallPos2D_X) / d;
							var vy = (cy - _cannonBallPos2D_Y) / d;
							cell.OffsetX = (vx * _ballDiameter) - (cx - _cannonBallPos2D_X);
							cell.OffsetY = (vy * _ballDiameter) - (cy - _cannonBallPos2D_Y);
							cell.Moved = true;
						}
					}
					i++;
				}
			}
		}
		
		var i = 0;
		repeat(_cellNumTotal) {
			var cell = _grid[i];
			if(cell!=undefined) {
				cell.Step();
			}
			i++;
		}
	}
	
	Draw = function(px, py)
	{
		if(display_get_gui_width() < 1200)
		{
			return;
		}
		
		var scl = 3;
		
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
		var cannonX = x1 + _cannonX * scl;
		var cannonY = y1 + _cannonY * scl;
		draw_circle(cannonX, cannonY, r, false);
		
		draw_line(cannonX, cannonY, cannonX + lengthdir_x(scl * _fieldH, _cannonAngle + 90), cannonY + lengthdir_y(scl * _fieldH, _cannonAngle + 90));
		
		draw_set_color(c_red);
		draw_circle(px + _cannonTraceResultX * scl, py + + _cannonTraceResultY * scl, 4, false);
		
		_drawSelectedCell(px, py, scl);
	}
	
	_snapToIndex = function(px, py) {
		
		px = wrap(px, 0, _fieldW); // wrap x
		
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
		
		//outPos[@ 0] = ix * cellSizeX;
		//outPos[@ 1] = iy * cellSizeY + _ballRadius;
		
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
		
		
		//var outPos = [ 0, 0 ];
		var i = _snapToIndex((mx - px) / scl, (my - py)/scl);//, outPos);
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
	
	/*
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
	*/
}

function matrix_transform_vertex_fix(m, x, y, z, w, out)
{
	if(os_browser==browser_not_a_browser) {
		return matrix_transform_vertex(m, x, y, z, w, out);
	}
	
	out[@ 0] = m[0] * x + m[4] * y + m[ 8] * z + m[12] * w;
	out[@ 1] = m[1] * x + m[5] * y + m[ 9] * z + m[13] * w;
	out[@ 2] = m[2] * x + m[6] * y + m[10] * z + m[14] * w;
	out[@ 3] = m[3] * x + m[7] * y + m[11] * z + m[15] * w;
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
	matrix_transform_vertex_fix(mInvViewProj, nx, ny, 0, 1, v0);
	v0[0] /= v0[3];
	v0[1] /= v0[3];
	v0[2] /= v0[3];
	
	static v1 = [ 0, 0, 0, 0 ];
	matrix_transform_vertex_fix(mInvViewProj, nx, ny, 1, 1, v1);
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
	var k = dot_product(px - x1,    py - y1, ldx, ldy);
	
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

function ray_circle_collision_point_dist(ox, oy, dx, dy, cx, cy, crSq) {
	// Вектор от центра окружности к началу луча: F = O - C
	var fx = ox - cx;
	var fy = oy - cy;
	
	// Коэффициенты квадратного уравнения t^2 + 2*b*t + c = 0
	// b = скалярное произведение (F · D)
	//var b = fx * dx + fy * dy;
	var b = dot_product(fx, fy, dx, dy);
	
	// c = |F|^2 - r^2
	//var c = fx * fx + fy * fy - crSq;
	var c = dot_product(fx, fy, fx, fy) - crSq;
	
	// Дискриминант (упрощенный, т.к. a=1)
	// k = b^2 - c
	var k = b * b - c;
	
	// Если дискриминант отрицательный, пересечений нет
	if (k < 0) return -1;
	
	var sqrtK = sqrt(k);
	
	// Находим корни. Нам нужен наименьший t >= 0.
	// t1 = -b - sqrtK
	// t2 = -b + sqrtK
	// Поскольку sqrtK >= 0, t1 всегда <= t2. Проверяем t1 первым.
	return -b - sqrtK;
}

