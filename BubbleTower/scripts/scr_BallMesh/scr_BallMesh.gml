global.SkinIndex = 0;

function sBallMesh() constructor {
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	vertex_format_add_normal();
	vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord);
	_vformat = vertex_format_end();
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);
	
	var s = 5;
	var stepCount = 18;
	
	var step = 360 / stepCount;
	var halfStepCount = stepCount / 2;
	var sideTextureRepeat = 1;
	var sideTextureHalfRepeat = 1;//sideTextureRepeat / 2;
	
	for(var i=0; i<stepCount; i++) {
		var angle1 = step * i;
		var lx1 = lengthdir_x(s, angle1 - 90);
		var ly1 = lengthdir_y(s, angle1 - 90);
		
		var angle2 = step * (i+1);
		var lx2 = lengthdir_x(s, angle2 - 90);
		var ly2 = lengthdir_y(s, angle2 - 90);
		
		var angle3 = step * (i+0.5);
		
		var tx1 = ( ( (i<halfStepCount ? angle1 : angle1-180) / 180 ) * (60/64) + (2/64) ) * 0.125;
		var tx2 = ( ( (i<halfStepCount ? angle2 : angle2-180) / 180 ) * (60/64) + (2/64) ) * 0.125;
		var tx3 = ( ( (i<halfStepCount ? angle3 : angle3-180) / 180 ) * (60/64) + (2/64) ) * 0.125;
		
		var nx1 = dcos(angle1 - 90);
		var ny1 = -dsin(angle1 - 90);
		
		var nx2 = dcos(angle2 - 90);
		var ny2 = -dsin(angle2 - 90);
		
		var nx3 = dcos(angle3 - 90);
		var ny3 = -dsin(angle3 - 90);
		
		var tanX1 = ny1;
		var tanY1 = -nx1;
		
		var tanX2 = ny2;
		var tanY2 = -nx2;
		
		var tanX3 = ny3;
		var tanY3 = -nx3;
		
		for(var j=0; j<halfStepCount; j++) {
			var pitch1 = step * j;
			var pitch2 = step * (j+1);
			var lz1 = -lengthdir_x(s, pitch1);
			var lz2 = -lengthdir_x(s, pitch2);
			
			var nz1 = -dcos(pitch1);
			var nz2 = -dcos(pitch2);
			
			var k1 = dsin(pitch1);
			var k2 = dsin(pitch2);
			
			var ty1 = ( (1 - (pitch1 * sideTextureHalfRepeat) / 180) * (60/64) + (2/64) ) * 0.5;
			var ty2 = ( (1 - (pitch2 * sideTextureHalfRepeat) / 180) * (60/64) + (2/64) ) * 0.5;
			
			if(j==0) {
				vertex_pos_tex_norm_tan(vbuff, lx1 * k2, ly1 * k2, lz2, tx1, ty2, nx1 * k2, ny1 * k2, nz2, tanX1, tanY1, 0);
				vertex_pos_tex_norm_tan(vbuff, lx2 * k2, ly2 * k2, lz2, tx2, ty2, nx2 * k2, ny2 * k2, nz2, tanX2, tanY2, 0);
				vertex_pos_tex_norm_tan(vbuff, 0, 0, lz1, tx3, ty1, nx3 * k1, ny3 * k1, nz1, tanX3, tanY3, 0);
			} else if(j==halfStepCount-1) {
				vertex_pos_tex_norm_tan(vbuff, lx2 * k1, ly2 * k1, lz1, tx2, ty1, nx2 * k1, ny2 * k1, nz1, tanX2, tanY2, 0);
				vertex_pos_tex_norm_tan(vbuff, lx1 * k1, ly1 * k1, lz1, tx1, ty1, nx1 * k1, ny1 * k1, nz1, tanX1, tanY1, 0);
				vertex_pos_tex_norm_tan(vbuff, 0, 0, lz2, tx3, ty2, nx3 * k2, ny3 * k2, nz2, tanX3, tanY3, 0);
			} else {
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
	
	_textureSprite = tex_Balls;
	_texture = undefined;
	
	_shader = sh_Balls;
	_u_InstanceData = shader_get_uniform(_shader, "u_InstanceData");
	
	_s_RandomRadialOffset = shader_get_sampler_index(_shader, "s_RandomRadialOffset");
	_s_DirLightDepth = shader_get_sampler_index(_shader, "s_DirLightDepth");
	_u_ViewPos = shader_get_uniform(_shader, "u_ViewPos");
	_u_AmbientColor = shader_get_uniform(_shader, "u_AmbientColor");
	_u_DirLightViewMat = shader_get_uniform(_shader, "u_DirLightViewMat");
	_u_DirLightProjMat = shader_get_uniform(_shader, "u_DirLightProjMat");
	_u_DirLightForward = shader_get_uniform(_shader, "u_DirLightForward");
	_u_DirLightColor = shader_get_uniform(_shader, "u_DirLightColor");
	_u_DirLightNearFarClip = shader_get_uniform(_shader, "u_DirLightNearFarClip");
	_u_DirLightShadowBias = shader_get_uniform(_shader, "u_DirLightShadowBias");
	_u_DirLightTextureSize = shader_get_uniform(_shader, "u_DirLightTextureSize");
	_u_DirLightTexelSize = shader_get_uniform(_shader, "u_DirLightTexelSize");
	
	_matrix = matrix_build_identity();
	
	CleanUp = function() {
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	Draw = function(x, y, z, colorIndex) {
		_texture = sprite_get_texture(_textureSprite, global.SkinIndex);
		shader_set(_shader);
		texture_set_stage(_s_RandomRadialOffset, sprite_get_texture(tex_RandomRadialOffset, 0));
		var dl = obj_DirectionalLight;
		var ambientColor = obj_Environment.AmbientColor;
		texture_set_stage(_s_DirLightDepth, dl.GetDepthTexture());
		shader_set_uniform_f(_u_ViewPos, obj_Camera.x, obj_Camera.y, obj_Camera.z);
		shader_set_uniform_f(_u_AmbientColor, ambientColor[0], ambientColor[1], ambientColor[2]);
		shader_set_uniform_f_array(_u_DirLightViewMat, dl.ViewMat);
		shader_set_uniform_f_array(_u_DirLightProjMat, dl.ProjMat);
		shader_set_uniform_f(_u_DirLightForward, dl.Forward[0], dl.Forward[1], dl.Forward[2]);
		shader_set_uniform_f(_u_DirLightColor, dl.Color[0], dl.Color[1], dl.Color[2]);
		shader_set_uniform_f(_u_DirLightNearFarClip, dl.NearClip, dl.FarClip);
		shader_set_uniform_f(_u_DirLightShadowBias, dl.ShadowBias);
		shader_set_uniform_f(_u_DirLightTextureSize, dl.TextureSizeX, dl.TextureSizeY);
		shader_set_uniform_f(_u_DirLightTexelSize, dl.TexelSizeX, dl.TexelSizeY);
		
		shader_set_uniform_f(_u_InstanceData, x, y, z, colorIndex);
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
	}
	
	DrawDepth = function(x, y, z)
	{
		shader_set(sh_BallsDistance);
		shader_set_uniform_f(_sh_Distance_u_DirLightNearFarClip, obj_DirectionalLight.NearClip, obj_DirectionalLight.FarClip);
		shader_set_uniform_f(_sh_Distance_u_InstanceData, x, y, z, 1);
		vertex_submit(_vbuff, pr_trianglelist, -1);
		shader_reset();
	}
	
	
	DrawInstancesBegin = function() {
		_texture = sprite_get_texture(_textureSprite, global.SkinIndex);
		matrix_set(matrix_world, _matrix);
		shader_set(_shader);
		texture_set_stage(_s_RandomRadialOffset, sprite_get_texture(tex_RandomRadialOffset, 0));
		var dl = obj_DirectionalLight;
		var ambientColor = obj_Environment.AmbientColor;
		texture_set_stage(_s_DirLightDepth, dl.GetDepthTexture());
		shader_set_uniform_f(_u_ViewPos, obj_Camera.x, obj_Camera.y, obj_Camera.z);
		shader_set_uniform_f(_u_AmbientColor, ambientColor[0], ambientColor[1], ambientColor[2]);
		shader_set_uniform_f_array(_u_DirLightViewMat, dl.ViewMat);
		shader_set_uniform_f_array(_u_DirLightProjMat, dl.ProjMat);
		shader_set_uniform_f(_u_DirLightForward, dl.Forward[0], dl.Forward[1], dl.Forward[2]);
		shader_set_uniform_f(_u_DirLightColor, dl.Color[0], dl.Color[1], dl.Color[2]);
		shader_set_uniform_f(_u_DirLightNearFarClip, dl.NearClip, dl.FarClip);
		shader_set_uniform_f(_u_DirLightShadowBias, dl.ShadowBias);
		shader_set_uniform_f(_u_DirLightTextureSize, dl.TextureSizeX, dl.TextureSizeY);
		shader_set_uniform_f(_u_DirLightTexelSize, dl.TexelSizeX, dl.TexelSizeY);
	}
	
	DrawInstance = function(x, y, z, colorIndex) {
		gml_pragma("forceinline");
		shader_set_uniform_f(_u_InstanceData, x, y, z, max(0, round(colorIndex)));
		vertex_submit(_vbuff, pr_trianglelist, _texture);
	}
	
	DrawInstancesEnd = function() {
		gml_pragma("forceinline");
		shader_reset();
	}
	
	
	_sh_Distance_u_DirLightNearFarClip = shader_get_uniform(sh_BallsDistance, "u_DirLightNearFarClip");
	_sh_Distance_u_InstanceData = shader_get_uniform(sh_BallsDistance, "u_InstanceData");
	
	DrawDepthInstancesBegin = function() {
		gml_pragma("forceinline");
		shader_set(sh_BallsDistance);
		shader_set_uniform_f(_sh_Distance_u_DirLightNearFarClip, obj_DirectionalLight.NearClip, obj_DirectionalLight.FarClip);
	}
	
	DrawDepthInstance = function(x, y, z) {
		gml_pragma("forceinline");
		shader_set_uniform_f(_sh_Distance_u_InstanceData, x, y, z, 1);
		vertex_submit(_vbuff, pr_trianglelist, -1);
	}
	
	DrawDepthInstancesEnd = function() {
		gml_pragma("forceinline");
		shader_reset();
	}
}

function BallMesh()
{
	static inst = new sBallMesh();
	return inst;
}

