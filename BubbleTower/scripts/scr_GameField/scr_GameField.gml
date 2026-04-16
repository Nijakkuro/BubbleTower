//      (1)(2)
//    (6)(0)(3)
//     (5)(4)

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

//#macro BALL_DIAMETER 10
//#macro BALL_RADIUS 5

function sBall(gameField, index, colorIndex=0) constructor
{
	GameField = gameField;
	
	CellIndex = index;
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
	
	Step = function() {
		static outPos = [ 0, 0, 0 ];
		if(Moved) {
			var i = CellIndex;
			var gf = GameField;
			var px = gf.PositionsLUT2D_X[i];
			var py = gf.PositionsLUT2D_Y[i];
			
			OffsetX *= 0.9;
			OffsetY *= 0.9;
			
			if(OffsetX < 0.01 && OffsetY < 0.01) {
				OffsetX = 0;
				OffsetY = 0;
				Moved = false;
			}
			
			gf.Convert2DTo3D(px + OffsetX, py + OffsetY, outPos);
			Pos3D_X = outPos[0];
			Pos3D_Y = outPos[1];
			Pos3D_Z = outPos[2];
		}
	}
}

function sGameFieldCannon(gameField) constructor {
	_gameField = gameField;
	
	_posAngle = 0;
	_pos2D = new sVector2(0, _gameField.CylinderHeight - _gameField.BallRadius);
	_pos3D = new sVector(0, 0, -_gameField.BallDiameter * 1.5);
	_angle = 0;
	
	_traceResultCellIndex = -1;
	_traceResultPos2D = new sVector2();
	_traceResultLength = 100;
	
	_shot = false;
	_ballSpeed = 4;
	_ballDir = new sVector2();
	_ballTargetCellIndex = -1;
	_ballTargetPos2D = new sVector2();
	_ballPos2D = new sVector2();
	_ballPos3D = new sVector();
	
	SetPositionByAngle = function(angle) {
		_posAngle = angle_normalize360(angle);
		_pos2D.x = _posAngle / 360 * _gameField.FieldW;
		_pos3D.x = lengthdir_x(_gameField.WrapRadius, _posAngle);
		_pos3D.y = lengthdir_y(_gameField.WrapRadius, _posAngle);
	}
	
	SetAngleByTargetPos = function(px, py) {
		if(py > _gameField.FieldH + _gameField.BallRadius) {
			return false;
		}
		
		var angle1 = (_pos2D.x / _gameField.FieldW) * 360;
		var angle2 = (px / _gameField.FieldW) * 360;
		var posDiff = angle_difference(angle2, angle1) / 360 * _gameField.FieldW;
		_angle = point_direction(0, _pos2D.y, posDiff, py) - 90;
		return true;
	}
	
	SetAngleByWrapCylinderRaycast = function(ox, oy, oz, vx, vy, vz) {
		static col = [ 0, 0, 0, 0 ];
		
		var dist2d = point_distance(0, 0, vx, vy);
		if(dist2d<0.0000001) {
			return false;
		}
		
		if(line_circle_collision_point(ox, oy, ox + vx, oy + vy, 0, 0, _gameField.WrapRadius, col)) {
			var resX = col[0];
			var resY = col[1];
			var resZ = oz + point_distance(ox, oy, col[0], col[1]) * (vz / dist2d);
			
			static res2 = [ 0, 0 ];
			_gameField.Convert3DTo2D(resX, resY, resZ, res2);
			return SetAngleByTargetPos(res2[0], res2[1]);
		}
		return false;
	}
	
	// Вычисляет позицию, на которую прилетит шарик при выстреле из пушки из текущей позиции и направления
	Trace = function() {
		
		// пушка расположена ниже чем шестиугольное поле шариков
		var startX = _pos2D.x;
		var startY = _pos2D.y;
		
		// направление пушки
		var dirX = lengthdir_x(1, _angle + 90);
		var dirY = lengthdir_y(1, _angle + 90);
		
		if(dirY>0) { // пушка направлена от поля
			return false;
		}
		
		var ringRadius = _gameField.BallRadius * 1.25;
		var ringRadiusSquared = ringRadius * ringRadius;
		
		var hit = false;
		var bestHitDist = infinity;
		var bestHitY = -infinity;
		
		var grid = _gameField.Grid; // одномерный массив
		var width = _gameField.FieldW; // ширина поля
		var cellNumX = _gameField.CellNumX; // количество ячеек по оси X
		var cellNumY = _gameField.CellNumY; // количество ячеек по оси Y
		var positionsLUT2D_X = _gameField.PositionsLUT2D_X;
		var positionsLUT2D_Y = _gameField.PositionsLUT2D_Y;
		
		var originY = _gameField.BallRadius;
		var ballStepY = _gameField.BallStepY;
		
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
			_traceResultPos2D.x = bestHitX;
			_traceResultPos2D.y = bestHitY;
			_traceResultLength = point_distance(startX, startY, bestHitX, bestHitY);
			_traceResultCellIndex = _gameField.Pos2DToIndexCell(bestHitX, bestHitY);
			return true;
		}
		
		bestHitY = 0;
		var bestHitX = startX + dirX * (startY - bestHitY);
		_traceResultPos2D.x = bestHitX;
		_traceResultPos2D.y = bestHitY;
		_traceResultLength = point_distance(startX, startY, bestHitX, bestHitY);
		_traceResultCellIndex = _gameField.Pos2DToIndexCell(bestHitX, bestHitY);
		
		return true;
	}
	
	GetAngle = function() { return _angle; }
	GetTraceLength = function() { return _traceResultLength; }
	GetTraceCellIndex = function() { return _traceResultCellIndex; }
	CanShot = function() { return _traceResultCellIndex!=-1 && !_shot; }
	
	Reset = function() {
		_traceResultCellIndex = -1;
	}
	
	Shot = function() {
		if(!CanShot()) {
			return;
		}
		
		_shot = true;
		_ballTargetCellIndex = _traceResultCellIndex;
		_ballPos2D.Set(_pos2D);
		_ballPos3D.Set(_pos3D);
		_ballTargetPos2D.Set(_traceResultPos2D);
		
		var len = point_distance(_ballPos2D.x, _ballPos2D.y, _ballTargetPos2D.x, _ballTargetPos2D.y);
		_ballDir.Set(_ballTargetPos2D).Subtract(_ballPos2D).DivideS(len);
	}
	
	Step = function() {
		if(!_shot) {
			return;
		}
		
		var ballDiameter = _gameField.BallDiameter;
		var grid = _gameField.Grid;
		var cellNumTotal = _gameField.CellNumTotal;
		var positionsLUT2D_X = _gameField.PositionsLUT2D_X;
		var positionsLUT2D_Y = _gameField.PositionsLUT2D_Y;
		
		var d = point_distance(_ballPos2D.x, _ballPos2D.y, _ballTargetPos2D.x, _ballTargetPos2D.y);
		var stop = d <= _ballSpeed;
		
		_ballPos2D.x += _ballDir.x * _ballSpeed;
		_ballPos2D.y += _ballDir.y * _ballSpeed;
		var posX = _ballPos2D.x;
		var posY = _ballPos2D.y;
		
		static ballPos3D = [ 0, 0, 0 ];
		_gameField.Convert2DTo3D(posX, posY, ballPos3D);
		_ballPos3D.FromArray(ballPos3D);
		
		var i = 0;
		repeat(cellNumTotal) {
			var cell = grid[i];
			if(cell!=undefined) {
				var cx = positionsLUT2D_X[i];
				var cy = positionsLUT2D_Y[i];
				var d = point_distance(posX, posY, cx, cy);
				if(d < ballDiameter) {
					var vx = (cx - posX) / d;
					var vy = (cy - posY) / d;
					cell.OffsetX = (vx * ballDiameter) - (cx - posX);
					cell.OffsetY = (vy * ballDiameter) - (cy - posY);
					cell.Moved = true;
				}
			}
			i++;
		}
		
		if(stop) {
			_shot = false;
			var ball = _gameField.AddBall(_ballTargetCellIndex, 0);
			ball.OffsetX = posX - positionsLUT2D_X[_ballTargetCellIndex];
			ball.OffsetY = posY - positionsLUT2D_Y[_ballTargetCellIndex];
		}
	}
	
	Draw = function() {
		
		var pos = _shot ? _ballPos3D : _pos3D;
		var colorIndex = 0;
		BallMesh().Draw(pos.x, pos.y, pos.z, colorIndex);
		
		if(!_shot && _traceResultCellIndex!=-1) {
			var cylinderRadius = _gameField.WrapRadius;
			var cylinderFullSpinLen = _gameField.FieldW;
			var startPosAngle = -_posAngle;// -obj_Camera.ZAngle + 180;
			
			var rayAngle = -_angle;
			var rayThickness = _gameField.BallRadius / 2;
			var raySegmentLen = _gameField.BallRadius;
			
			var traceLen = _traceResultLength;
			
			CylindricRaycastLineMesh().Draw( 0, 0, pos.z,
				cylinderRadius, cylinderFullSpinLen, startPosAngle,
				rayAngle, rayThickness, raySegmentLen, traceLen
			);
			
			var idx = GetTraceCellIndex();
			if(idx!=-1) {
				var px = _gameField.PositionsLUT3D_X[idx];
				var py = _gameField.PositionsLUT3D_Y[idx];
				var pz = _gameField.PositionsLUT3D_Z[idx];
				BallMesh().Draw(px, py, pz, 0);
			}
		}
	}
	
	DrawDepth = function() {
		var pos = _shot ? _ballPos3D : _pos3D;
		BallMesh().DrawDepth(pos.x, pos.y, pos.z);
	}
}

// Cylindrical hexagonal grid
function sGameField() constructor {
	BallDiameter = 10;
	BallRadius = BallDiameter / 2;
	CellNumX = 24;
	CellNumY = 18;
	CellNumTotal = CellNumX * CellNumY;
	
	BallOffsetX = BallRadius;
	BallStepX = BallDiameter;
	BallStepY = sqrt(3) * BallRadius;
	
	FieldW = BallStepX * CellNumX;
	FieldH = BallStepY * CellNumY - BallStepY + BallDiameter;
	
	_angleStep = 360 / CellNumX;
	_angleHalfStep = _angleStep / 2;
	
	WrapRadius = BallRadius / dtan(_angleHalfStep);
	CylinderRadius = WrapRadius - BallRadius;
	CylinderHeight = FieldH + BallDiameter * 2;
	RotationAngle = 0;
	
	Grid = array_create(CellNumTotal, undefined);
	
	AddBall = function(cellIndex, colorIndex) {
		if(Grid[cellIndex]!=undefined) {
			delete Grid[cellIndex];
		}
		var ball = new sBall(self, cellIndex, colorIndex);
		Grid[cellIndex] = ball;
		return ball;
	}
	
	RemoveBall = function(cellIndex) {
		if(Grid[cellIndex]!=undefined) {
			delete Grid[cellIndex];
			Grid[cellIndex] = undefined;
		}
	}
	
	// create balls
	_createBalls = function(rowNum) {
		var cellNum = rowNum * CellNumX;
		for(var i=0; i<cellNum; i++) {
			if(irandom(1)) {
				var colorIndex = irandom(4);
				AddBall(i, colorIndex);
			}
		}
	}
	
	// positions LUT
	PositionsLUTAngle = array_create(CellNumTotal);
	PositionsLUT2D_X = array_create(CellNumTotal);
	PositionsLUT2D_Y = array_create(CellNumTotal);
	PositionsLUT3D_X = array_create(CellNumTotal);
	PositionsLUT3D_Y = array_create(CellNumTotal);
	PositionsLUT3D_Z = array_create(CellNumTotal);
	_initPositionsLUT = function() {
		var k = 0;
		for(var j=0; j<CellNumY; j++) {
			var py = j * BallStepY + BallRadius;
			var pxOffset = j%2==0 ? 0 : BallOffsetX;
			for(var i=0; i<CellNumX; i++) {
				var px = i * BallStepX + pxOffset;
				PositionsLUT2D_X[k] = px;
				PositionsLUT2D_Y[k] = py;
				PositionsLUTAngle[k] = wrap(px/FieldW * 360, 0, 360);
				k++;
			}
		}
		
		var pos3d = [];
		for(var i=0; i<CellNumTotal; i++) {
			var px = PositionsLUT2D_X[i];
			var py = PositionsLUT2D_Y[i];
			Convert2DTo3D(px, py, pos3d);
			PositionsLUT3D_X[i] = pos3d[0];
			PositionsLUT3D_Y[i] = pos3d[1];
			PositionsLUT3D_Z[i] = pos3d[2];
		}
	}
	
	SetRotationAngle = function(angle) {
		RotationAngle = angle;
	}
	
	// cell positions
	GetCellPos2D = function(cx, cy, outPos) {
		var i = cy * CellNumX + cx;
		outPos[@ 0] = PositionsLUT2D_X[i];
		outPos[@ 1] = PositionsLUT2D_Y[i];
	}
	
	GetCellPos3D = function(cx, cy, outPos) {
		var i = cy * CellNumX + cx;
		outPos[@ 0] = PositionsLUT3D_X[i];
		outPos[@ 1] = PositionsLUT3D_Y[i];
		outPos[@ 2] = PositionsLUT3D_Z[i];
	}
	
	// coord conversion
	Convert2DTo3D = function(px, py, outPos) {
		var anglePos = (px / FieldW) * 360;
		outPos[@ 0] = lengthdir_x(WrapRadius, anglePos);
		outPos[@ 1] = lengthdir_y(WrapRadius, anglePos);
		outPos[@ 2] = FieldH - py;
	}
	
	Convert3DTo2D = function(px, py, pz, outPos) {
		var dir = point_direction(0, 0, px, py);
		outPos[@ 0] = (dir / 360) * FieldW;
		outPos[@ 1] = FieldH - pz;
	}
	
	// Returns snapped cell index of hexagonal 2d grid by position.
	Pos2DToIndexCell = function(px, py) {
		px = wrap(px, 0, FieldW); // wrap by x
		
		var size = BallRadius;
		var cellSizeX = size;
		var cellSizeY = ( size * (2 / sqrt(3)) ) / 2;
		
		py -= size;
		
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
		
		var colIdx = wrap((ix div 2), 0, CellNumX);
		var rowIdx = iy div 3;
		if(colIdx<0 || colIdx>=CellNumX || rowIdx<0 || rowIdx>=CellNumY) {
			return -1;
		}
		
		return rowIdx * CellNumX + colIdx;
	}
	
	// cell data
	GetCell = function(cx, cy) {
		return Grid[ cy * CellNumX + (cx % CellNumX + CellNumX) % CellNumX ];
	}
	
	// update
	Step = function() {
		var i = 0;
		repeat(CellNumTotal) {
			if(Grid[i]!=undefined) {
				Grid[i].Step();
			}
			i++;
		}
	}
	
	// init
	_createBalls(CellNumY/2);
	_initPositionsLUT();
}


function sGameFieldRenderer(gameField) constructor {
	_gameField = gameField;
	_ballsToDraw = array_create(_gameField.CellNumX * _gameField.CellNumY, -1);
	_ballsToDrawNum = 0;
	
	UpdateBallsToDraw = function() {
		var i = 0;
		var j = 0;
		var grid = _gameField.Grid;
		var positionsLUTAngle = _gameField.PositionsLUTAngle;
		var posAngle = _gameField.RotationAngle;
		var ballsToDraw = _ballsToDraw;
		repeat(_gameField.CellNumTotal) {
			if(grid[i]!=undefined && abs(angle_difference(positionsLUTAngle[i], posAngle)) < 135) {
				ballsToDraw[j] = i;
				j++;
			}
			i++;
		}
		_ballsToDrawNum = j;
	}
	
	// main
	Draw = function() {
		var i = 0;
		var grid = _gameField.Grid;
		var mesh = BallMesh();
		
		mesh.DrawInstancesBegin();
		
		var ballsToDraw = _ballsToDraw;
		repeat(_ballsToDrawNum) {
			var ball = grid[ballsToDraw[i]];
			mesh.DrawInstance(ball.Pos3D_X, ball.Pos3D_Y, ball.Pos3D_Z, ball.ColorIndex);
			i++;
		}
		
		mesh.DrawInstancesEnd();
	}
	
	// draw depth for shadow mapping
	DrawDepth = function() {
		var i = 0;
		var grid = _gameField.Grid;
		var mesh = BallMesh();
		
		mesh.DrawDepthInstancesBegin();
		
		var ballsToDraw = _ballsToDraw;
		repeat(_ballsToDrawNum) {
			var ball = grid[ballsToDraw[i]];
			mesh.DrawDepthInstance(ball.Pos3D_X, ball.Pos3D_Y, ball.Pos3D_Z);
			i++;
		}
		
		mesh.DrawDepthInstancesEnd();
	}
}

