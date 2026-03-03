// Script
function sSphere() constructor {

	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	vertex_format_add_normal();
	vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord);
	_vformat = vertex_format_end();
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);

	var s = 50;
	
	var stepCount = 32;
	var step = 360 / stepCount;
	var halfStepCount = stepCount / 2;
	var sideTextureRepeat = 4;
	var sideTextureHalfRepeat = sideTextureRepeat / 2;
	
	for(var i=0; i<stepCount; i++)
	{
		var angle1 = step * i;
		var lx1 = lengthdir_x(s, angle1);
		var ly1 = lengthdir_y(s, angle1);
		
		var angle2 = step * (i+1);
		var lx2 = lengthdir_x(s, angle2);
		var ly2 = lengthdir_y(s, angle2);
		
		var angle3 = step * (i+0.5);
		
		var tx1 = (angle1 * sideTextureRepeat) / 360;
		var tx2 = (angle2 * sideTextureRepeat) / 360;
		var tx3 = (angle3 * sideTextureRepeat) / 360;
		
		var nx1 = dcos(angle1);
		var ny1 = -dsin(angle1);
		
		var nx2 = dcos(angle2);
		var ny2 = -dsin(angle2);
		
		var nx3 = dcos(angle3);
		var ny3 = -dsin(angle3);
		
		var tanX1 = ny1;
		var tanY1 = -nx1;
		
		var tanX2 = ny2;
		var tanY2 = -nx2;
		
		var tanX3 = ny3;
		var tanY3 = -nx3;
		
		for(var j=0; j<halfStepCount; j++)
		{
			var pitch1 = step * j;
			var pitch2 = step * (j+1);
			var lz1 = -lengthdir_x(s, pitch1);
			var lz2 = -lengthdir_x(s, pitch2);
			
			var nz1 = -dcos(pitch1);
			var nz2 = -dcos(pitch2);
			
			var k1 = dsin(pitch1);
			var k2 = dsin(pitch2);
			
			var ty1 = 1 - (pitch1 * sideTextureHalfRepeat) / 180;
			var ty2 = 1 - (pitch2 * sideTextureHalfRepeat) / 180;
			
			if(j==0)
			{
				vertex_pos_tex_norm_tan(vbuff, lx1 * k2, ly1 * k2, lz2, tx1, ty2, nx1 * k2, ny1 * k2, nz2, tanX1, tanY1, 0);
				vertex_pos_tex_norm_tan(vbuff, lx2 * k2, ly2 * k2, lz2, tx2, ty2, nx2 * k2, ny2 * k2, nz2, tanX2, tanY2, 0);
				vertex_pos_tex_norm_tan(vbuff, 0, 0, lz1, tx3, ty1, nx3 * k1, ny3 * k1, nz1, tanX3, tanY3, 0);
			}
			else if(j==halfStepCount-1)
			{
				vertex_pos_tex_norm_tan(vbuff, lx2 * k1, ly2 * k1, lz1, tx2, ty1, nx2 * k1, ny2 * k1, nz1, tanX2, tanY2, 0);
				vertex_pos_tex_norm_tan(vbuff, lx1 * k1, ly1 * k1, lz1, tx1, ty1, nx1 * k1, ny1 * k1, nz1, tanX1, tanY1, 0);
				vertex_pos_tex_norm_tan(vbuff, 0, 0, lz2, tx3, ty2, nx3 * k2, ny3 * k2, nz2, tanX3, tanY3, 0);
			}
			else
			{
				vertex_pos_tex_norm_tan(vbuff, lx1 * k2, ly1 * k2, lz2, tx1, ty2, nx1 * k2, ny1 * k2, nz2, tanX1, tanY1, 0);
				vertex_pos_tex_norm_tan(vbuff, lx2 * k2, ly2 * k2, lz2, tx2, ty2, nx2 * k2, ny2 * k2, nz2, tanX2, tanY2, 0);
				vertex_pos_tex_norm_tan(vbuff, lx1 * k1, ly1 * k1, lz1, tx1, ty1, nx1 * k1, ny1 * k1, nz1, tanX1, tanY1, 0);
					
				vertex_pos_tex_norm_tan(vbuff, lx2 * k1, ly2 * k1, lz1, tx2, ty1, nx2 * k1, ny2 * k1, nz1, tanX2, tanY2, 0);
				vertex_pos_tex_norm_tan(vbuff, lx1 * k1, ly1 * k1, lz1, tx1, ty1, nx1 * k1, ny1 * k1, nz1, tanX1, tanY1, 0);
				vertex_pos_tex_norm_tan(vbuff, lx2 * k2, ly2 * k2, lz2, tx2, ty2, nx2 * k2, ny2 * k2, nz2, tanX2, tanY2, 0);
			}
		}
	}
	
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	_vbuff = vbuff;
	
	_texture = sprite_get_texture(spr_Default, 0);
	//_textureS = sprite_get_texture(spr_Default, 1);
	//_textureN = sprite_get_texture(spr_Default, 2);
	
	_shader = sh_Sphere;
	_s_SpecularMap = shader_get_sampler_index(_shader, "s_SpecularMap");
	_s_NormalMap = shader_get_sampler_index(_shader, "s_NormalMap");
	_u_Color = shader_get_uniform(_shader, "u_Color");
	
	_matrix = matrix_build_identity();
	
	CleanUp = function() {
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	Draw = function(dx, dy, dz, sx, sy, sz, color) {
		static matrixSave = matrix_build_identity();
		
		matrix_build(dx, dy, dz, 0, 0, 0, sx, sy, sz, _matrix);
		
		matrix_get(matrix_world, matrixSave);
		matrix_set(matrix_world, _matrix);
		
		shader_set(_shader);
		//texture_set_stage(_s_SpecularMap, _textureS);
		//texture_set_stage(_s_NormalMap, _textureN);
		shader_set_uniform_f(_u_Color, color_get_red(color)/255, color_get_green(color)/255, color_get_blue(color)/255, 1);
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
		
		matrix_set(matrix_world, matrixSave);
	}
}

