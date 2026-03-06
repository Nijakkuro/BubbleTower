function sCylinder() constructor {
	
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	vertex_format_add_normal();
	vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord);
	_vformat = vertex_format_end();
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);
	
	var s = 50;
	
	var stepCount = 30;
	var step = 360 / stepCount;
	var sideTextureRepeat = 4;
	
	// bottom
	for(var i=0; i<stepCount; i++)
	{
		var angle1 = step * i;
		var lx1 = lengthdir_x(s, angle1);
		var ly1 = lengthdir_y(s, angle1);
		
		var angle2 = step * (i+1);
		var lx2 = lengthdir_x(s, angle2);
		var ly2 = lengthdir_y(s, angle2);
		
		var tx1 = (ly1 / s) * 0.5 + 0.5;
		var ty1 = (lx1 / s) * 0.5 + 0.5;
		
		var tx2 = (ly2 / s) * 0.5 + 0.5;
		var ty2 = (lx2 / s) * 0.5 + 0.5;
		
		vertex_pos_tex_norm_tan(vbuff,   0,   0, -s, 0.5, 0.5, 0, 0, -1, 0, 1, 0);
		vertex_pos_tex_norm_tan(vbuff, lx1, ly1, -s, tx1, ty1, 0, 0, -1, 0, 1, 0);
		vertex_pos_tex_norm_tan(vbuff, lx2, ly2, -s, tx2, ty2, 0, 0, -1, 0, 1, 0);
	}
	
	// side
	for(var i=0; i<stepCount; i++)
	{
		var angle1 = step * i;
		var lx1 = lengthdir_x(s, angle1);
		var ly1 = lengthdir_y(s, angle1);
		
		var angle2 = step * (i+1);
		var lx2 = lengthdir_x(s, angle2);
		var ly2 = lengthdir_y(s, angle2);
		
		var tx1 = (angle1 * sideTextureRepeat) / 360;
		var tx2 = (angle2 * sideTextureRepeat) / 360;
		
		var nx1 = dcos(angle1);
		var ny1 = -dsin(angle1);
		
		var nx2 = dcos(angle2);
		var ny2 = -dsin(angle2);
		
		var tanX1 = ny1;
		var tanY1 = -nx1;
		
		var tanX2 = ny2;
		var tanY2 = -nx2;
		
		vertex_pos_tex_norm_tan(vbuff, lx1, ly1,  s, tx1, 0, nx1, ny1, 0, tanX1, tanY1, 0);
		vertex_pos_tex_norm_tan(vbuff, lx2, ly2,  s, tx2, 0, nx2, ny2, 0, tanX2, tanY2, 0);
		vertex_pos_tex_norm_tan(vbuff, lx1, ly1, -s, tx1, 1, nx1, ny1, 0, tanX1, tanY1, 0);
		
		vertex_pos_tex_norm_tan(vbuff, lx2, ly2, -s, tx2, 1, nx2, ny2, 0, tanX2, tanY2, 0);
		vertex_pos_tex_norm_tan(vbuff, lx1, ly1, -s, tx1, 1, nx1, ny1, 0, tanX1, tanY1, 0);
		vertex_pos_tex_norm_tan(vbuff, lx2, ly2,  s, tx2, 0, nx2, ny2, 0, tanX2, tanY2, 0);
	}
	
	// top
	for(var i=0; i<stepCount; i++)
	{
		var angle1 = step * i;
		var lx1 = lengthdir_x(s, angle1);
		var ly1 = lengthdir_y(s, angle1);
		
		var angle2 = step * (i+1);
		var lx2 = lengthdir_x(s, angle2);
		var ly2 = lengthdir_y(s, angle2);
		
		var tx1 = (ly1 / s) * 0.5 + 0.5;
		var ty1 = 1 - ((lx1 / s) * 0.5 + 0.5);
		
		var tx2 = (ly2 / s) * 0.5 + 0.5;
		var ty2 = 1 - ((lx2 / s) * 0.5 + 0.5);
		
		vertex_pos_tex_norm_tan(vbuff,   0,   0, s, 0.5, 0.5, 0, 0, 1, 0, 1, 0);
		vertex_pos_tex_norm_tan(vbuff, lx2, ly2, s, tx2, ty2, 0, 0, 1, 0, 1, 0);
		vertex_pos_tex_norm_tan(vbuff, lx1, ly1, s, tx1, ty1, 0, 0, 1, 0, 1, 0);
	}
	
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	_vbuff = vbuff;
	
	_texture = sprite_get_texture(spr_DefaultModelTextures, 0);
	_textureS = sprite_get_texture(spr_DefaultModelTextures, 1);
	_textureN = sprite_get_texture(spr_DefaultModelTextures, 2);
	
	_shader = sh_Opaque;
	_s_SpecularMap = shader_get_sampler_index(_shader, "s_SpecularMap");
	_s_NormalMap = shader_get_sampler_index(_shader, "s_NormalMap");
	
	_matrix = matrix_build_identity();
	
	CleanUp = function() {
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	Draw = function(dx, dy, dz, sx, sy, sz) {
		static matrixSave = matrix_build_identity();
		
		matrix_build(dx, dy, dz, 0, 0, 0, sx, sy, sz, _matrix);
		
		matrix_get(matrix_world, matrixSave);
		matrix_set(matrix_world, _matrix);
		
		shader_set(_shader);
		//texture_set_stage(_s_SpecularMap, _textureS);
		//texture_set_stage(_s_NormalMap, _textureN);
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
		
		matrix_set(matrix_world, matrixSave);
	}
}

