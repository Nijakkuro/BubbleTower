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
}

function sHexGrid() constructor
{
	//    (1)(2)
	//  (6)(0)(3)
	//   (5)(4)
	
	_x = 24;
	_y = 24;
	
	_ballRadius = 24;
	
	_shiftX = _ballRadius * 2;
	_rx2 = -_ballRadius;
	_ry2 = sqrt(3) * _ballRadius;
	
	_cellNumX = 20;
	_cellNumY = 20;
	_cellNumTotal = _cellNumX * _cellNumY;
	_grid = array_create(_cellNumTotal, undefined);
	
	_x = - _cellNumX * _ballRadius;
	_w = _ballRadius * _cellNumX * 2;
	_y = 0;
	_h = _ry2 * _cellNumY;
	
	for(var i=0; i<_cellNumTotal/2; i++)
	{
		var color = choose(
			#FF0000, #FFFF00, #00FF00, #00FFFF, #0000FF//, #FF00FF, c_orange
		);
		_grid[i] = new sBall(color);
	}
	
	GetCell = function(cx, cy)
	{
		return _grid[ cy * _cellNumX + (cx % _cellNumX + _cellNumX) % _cellNumX ];
	}
	
	_selectIdx = -1;
	
	Step = function()
	{
		/*
		_selectIdx = -1;
		var idx = -1;
		for(var j=0; j<_cellNumY; j++)
		{
			var posX = px + (j%2==0 ? rx2 : 0);
			var posY = py + (ry2 * j);
			
			for(var i=0; i<_cellNumX; i++)
			{
				var ball = GetCell(i, j);
				if(ball!=undefined)
				{
					if(point_in_circle(mouse_x, mouse_y, posX, posY, r))
					{
						_selectIdx = idx;
						return;
					}
					draw_set_color(ball.Color);
					draw_circle(posX, posY, r-2, false);
				}
				posX += shiftX;
				idx++;
			}
		}
		*/
	}
	
	Draw = function()
	{
		var r = _ballRadius;
		var shiftX = _shiftX;
		var rx2 = _rx2;
		var ry2 = _ry2;
		
		var px = _x + _ballRadius;
		var py = _y + _ballRadius;
		
		for(var j=0; j<_cellNumY; j++)
		{
			var posX = px + (j%2==0 ? rx2 : 0);
			var posY = py + (ry2 * j);
			
			for(var i=0; i<_cellNumX; i++)
			{
				var ball = GetCell(i, j);
				if(ball!=undefined)
				{
					draw_set_color(ball.Color);
					draw_circle(posX, posY, r-2, false);
				}
				posX += shiftX;
			}
		}
		
		draw_set_color(c_white);
		var x1 = _x;
		var y1 = _y+1;
		var x2 = x1 + _w;
		var y2 = y1 + _h;
		draw_rectangle(x1, y1, x2, y2, true);
	}
}

