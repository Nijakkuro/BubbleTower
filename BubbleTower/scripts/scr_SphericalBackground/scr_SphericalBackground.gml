function sSphericalBackground(spr=undefined) constructor {
	_sprite = spr ?? tex_Bg;
	
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	_vformat = vertex_format_end();
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);
	
	var step = 5;
	var r = 1;
	
	var degX = 360;
	var degY = 60;
	var halfDegY = 60 / 2;
	for(var j=halfDegY; j>-(halfDegY); j-=step)
	{
		var j2 = j - step;
		var rz1 = lengthdir_x(r, j);
		var rz2 = lengthdir_x(r, j2);
		var z1  = lengthdir_y(r, j);
		var z2  = lengthdir_y(r, j2);
		
		var ty1 = 1 - (halfDegY - j) / degY;
		var ty2 = 1 - (halfDegY - (j-step)) / degY;
		
		for(var i=360; i>0; i-=step)
		{
			var i2 = i - step;
			
			var x1 = lengthdir_x(rz1, i);
			var y1 = lengthdir_y(rz1, i);
			
			var x2 = lengthdir_x(rz1, i2);
			var y2 = lengthdir_y(rz1, i2);
			
			var x3 = lengthdir_x(rz2, i);
			var y3 = lengthdir_y(rz2, i);
			
			var x4 = lengthdir_x(rz2, i2);
			var y4 = lengthdir_y(rz2, i2);
			
			
			var tx1 = (360 - i) / 360;
			var tx2 = (360 - (i-step)) / 360;
			
			vertex_pos_tex(vbuff, x2, y2, z1, tx2, ty1);
			vertex_pos_tex(vbuff, x1, y1, z1, tx1, ty1);
			vertex_pos_tex(vbuff, x4, y4, z2, tx2, ty2);
			
			vertex_pos_tex(vbuff, x4, y4, z2, tx2, ty2);
			vertex_pos_tex(vbuff, x1, y1, z1, tx1, ty1);
			vertex_pos_tex(vbuff, x3, y3, z2, tx1, ty2);
		}
	}
	
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	_vbuff = vbuff;
	
	_shader = sh_Background;
	_texture = sprite_get_texture(_sprite, 0);
	
	CleanUp = function() {
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	Draw = function() {
		gpu_set_ztestenable(false);
		gpu_set_zwriteenable(false);
		shader_set(_shader);
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
	}
}

