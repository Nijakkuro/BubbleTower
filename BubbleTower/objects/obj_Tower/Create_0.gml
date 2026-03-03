Radius = 32.9787705636257584;


_cylinder = new sCylinder();

_sphere = new sSphere();

_grid = new sHexGrid();

_calcR = function(angleStep, r)
{
	return r / dtan(angleStep);
}

_cylinderRadius = 1;
_cylinderHeight = 1;

_drawSpheres = function()
{
	var cellNumX = _grid.GetCellNumX();
	var cellNumY = _grid.GetCellNumY();
	
	var angStep = 360 / cellNumX;
	var angOffset = angStep / 2;
	
	var d = 10;
	var r = d/2;
	var radius = _calcR(angStep/2, r);
	
	_cylinderRadius = radius - r;
	
	if(keyboard_check_pressed(vk_space))
	{
		show_debug_message(string_format(_cylinderRadius, 4, 16));
	}
	
	var s = d / 100;
	
	var zStep = sqrt(3)/2 * s * 100;
	
	_cylinderHeight = zStep * (cellNumY + 2);
	var zStart = _cylinderHeight / 2 - r;
	
	for(var j=0; j<cellNumY; j++)
	{
		var pz = zStart - j*zStep;
		
		var angleStart = j%2==0 ? angOffset : 0;
		
		for(var i=0; i<cellNumX; i++)
		{
			var angle = angleStart + i*angStep;
			var px = lengthdir_x(radius, angle);
			var py = lengthdir_y(radius, angle);
			var cell = _grid.GetCell(i, j);
			if(cell!=undefined)
			{
				_sphere.Draw(px, py, pz, s, s, s, cell.Color);
			}
		}
	}
	
	var px = -lengthdir_x(radius, obj_Camera.ZAngle);
	var py = -lengthdir_y(radius, obj_Camera.ZAngle);
	_sphere.Draw(px, py, -zStart, s, s, s, c_white);
}

