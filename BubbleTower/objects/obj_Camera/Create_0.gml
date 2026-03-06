

view_enabled = true;
view_visible[0] = true;

_camera = view_camera[0];
var asp = NOGX_get_canvas_width() / NOGX_get_canvas_height();
var gameScreenH = 720;
var gameScreenW = asp * gameScreenH;
camera_set_view_size(_camera, gameScreenW, gameScreenH);
camera_set_view_border(_camera, gameScreenW/2, gameScreenH/2);
camera_set_view_target(_camera, noone);


x = -1000;
z = 5;//-120;

ZAngle = 180;

XTo = 0;
YTo = 0;
ZTo = 5;

Distance = 280;

_viewMat = matrix_build_identity();
_projMat = matrix_build_identity();

_endStep = function() {
	var dirX = keyboard_check(vk_right) - keyboard_check(vk_left);
	if(dirX!=0) {
		ZAngle -= dirX;
	}
	
	x = -lengthdir_x(Distance, ZAngle);
	y = -lengthdir_y(Distance, ZAngle);
	
	if(instance_number(obj_Tower)>0)
	{
		z = obj_Tower._cylinderCZ + 5;
		ZTo = z;
	}
	
	var asp = NOGX_get_canvas_width() / NOGX_get_canvas_height();
	
	matrix_build_lookat(x, y, z, XTo, YTo, ZTo, 0, 0, 1, _viewMat);
	matrix_build_projection_perspective_fov_fix_out(50, asp, 0.1, 2048, _projMat);
	camera_set_view_mat(_camera, _viewMat);
	camera_set_proj_mat(_camera, _projMat);
}

