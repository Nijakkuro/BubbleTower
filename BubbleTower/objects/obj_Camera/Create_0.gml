view_enabled = true;
view_visible[0] = true;

_camera = view_camera[0];
var asp = NOGX_get_canvas_width() / NOGX_get_canvas_height();
var gameScreenH = 720;
var gameScreenW = asp * gameScreenH;
camera_set_view_size(_camera, gameScreenW, gameScreenH);
camera_set_view_border(_camera, gameScreenW/2, gameScreenH/2);
camera_set_view_target(_camera, noone);

_smoothFactorX = 8;
_smoothFactorY = 8;

_targetPosX = 0;
_targetPosY = 0;

x = 0; //gameScreenW / 2;
y = -gameScreenH/2; //gameScreenH / 2;

var target = undefined; //instance_find(obj_Player, 0);
_target = target; /*!=noone ? obj_Player : undefined;*/
if(_target!=undefined)
{
	x = _target.x;
	y = _target.y;
}

_x = x;
_y = y;

_endStep = function()
{
	var gameScreenH = 1080;
	var asp = NOGX_get_canvas_width() / NOGX_get_canvas_height();
	var gameScreenW = asp * gameScreenH;
	camera_set_view_size(_camera, gameScreenW, gameScreenH);
	
	if(_target!=undefined)
	{
		_targetPosX = clamp(_target.x, gameScreenW/2, room_width-gameScreenW/2);
		_targetPosY = clamp(_target.y, gameScreenH/2, room_height-gameScreenH/2);
		
		var xTo = _targetPosX;
		var yTo = _targetPosY;
		
		var dx = xTo - _x;
		var dy = yTo - _y;
		
		_x += dx / _smoothFactorX;
		_y += dy / _smoothFactorY;
		
		_x = clamp(_x, gameScreenW/2, room_width-gameScreenW/2);
		_y = clamp(_y, gameScreenH/2, room_height-gameScreenH/2);
		
		x = round(_x);
		y = round(_y);
	}
	else
	{
		//x = room_width / 2;
		//y = room_height / 2;
		
		x = 0; //gameScreenW / 2;
		y = gameScreenH/2; //gameScreenH / 2;
	}
	
	camera_set_view_pos(_camera, x - gameScreenW/2, y - gameScreenH/2);
}

