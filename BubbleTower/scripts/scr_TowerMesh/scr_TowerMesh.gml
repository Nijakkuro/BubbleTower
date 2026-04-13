function VertexBufferAddRing(vbuff, z1, r1, z2, r2, tx1, tx2, ty1, ty2, steps=48)
{
	// 00 --- 10
	// |  \    |
	// |    \  |
	// 01 --- 11
	
	var txw = tx2 - tx1;
	
	var crossProduct = function(a, b, out)
	{
		out[@ 0] = a[1] * b[2] - a[2] * b[1];
		out[@ 1] = a[2] * b[0] - a[0] * b[2];
		out[@ 2] = a[0] * b[1] - a[1] * b[0];
	}
	
	var vbuffAddVertex = function(vbuff, v, vt, vn, vtan)
	{
		vertex_position_3d(vbuff, v[0], v[1], v[2]);
		vertex_texcoord(vbuff, vt[0], vt[1]);
		vertex_normal(vbuff, vn[0], vn[1], vn[2]);
		vertex_float3(vbuff, vtan[0], vtan[1], vtan[2]);
	}
	
	var step = 360 / steps;
	var maxR = max(r1, r2);
	var txShift0 = ( 1.0 - r1 / maxR ) / steps / 2;
	var txShift1 = ( 1.0 - r2 / maxR ) / steps / 2;
	
	var l = point_distance(r1, z1, r2, z2);
	var btan2dlen = (r2 - r1) / l;
	var btanz = (z2 - z1) / l;
	
	var v_0 = [ [ 0, 0, z1 ], [ 0, 0, z1 ] ];
	var v_1 = [ [ 0, 0, z2 ], [ 0, 0, z2 ] ];
	
	var t_0 = [ [ 0, ty1 ], [ 0, ty1 ] ];
	var t_1 = [ [ 0, ty2 ], [ 0, ty2 ] ];
	
	var tan_ = [ [ 0, 0, 0 ], [ 0, 0, 0 ] ];
	var btan = [ [ 0, 0, btanz ], [ 0, 0, btanz ] ];
	var norm = [ [ 0, 0, 0 ], [ 0, 0, 0 ] ];
	
	var i = 0;
	var j0 = 1;
	repeat(steps+1)
	{
		var angle = i - 45;
		
		var j1 = 1 - j0;
		
		var v00 = v_0[ j0 ];
		var v01 = v_1[ j0 ];
		var v10 = v_0[ j1 ];
		var v11 = v_1[ j1 ];
		
		var t00 = t_0[ j0 ];
		var t01 = t_1[ j0 ];
		var t10 = t_0[ j1 ];
		var t11 = t_1[ j1 ];
		
		var tan0 = tan_[ j0 ];
		var tan1 = tan_[ j1 ];
		
		var btan0 = btan[ j0 ];
		var btan1 = btan[ j1 ];
		
		var norm0 = norm[ j0 ];
		var norm1 = norm[ j1 ];
		
		v10[ 0 ] = lengthdir_x(r1, angle);
		v10[ 1 ] = lengthdir_y(r1, angle);
		
		v11[ 0 ] = lengthdir_x(r2, angle);
		v11[ 1 ] = lengthdir_y(r2, angle);
		
		var quarter = ((i-step) div 90) * 0.25;
		
		var txl = ( (i - step) / 360 + txShift0 - quarter ) * 4;
		var txr = ( i / 360 - txShift0 - quarter ) * 4;
		txl = txl * txw + tx1;
		txr = txr * txw + tx1;
		
		var txl2 = ( (i - step) / 360 + txShift1 - quarter ) * 4;
		var txr2 = ( i / 360 - txShift1 - quarter ) * 4;
		txl2 = txl2 * txw + tx1;
		txr2 = txr2 * txw + tx1;
		
		t00[ 0 ] = txl;
		t01[ 0 ] = txl2;
		t10[ 0 ] = txr;
		t11[ 0 ] = txr2;
		
		tan1[ 0 ] = -dsin(angle);
		tan1[ 1 ] = -dcos(angle);
		
		btan1[ 0 ] = lengthdir_x(btan2dlen, angle);
		btan1[ 1 ] = lengthdir_y(btan2dlen, angle);
		
		crossProduct(tan1, btan1, norm1);
		
		if(i!=0)
		{
			vbuffAddVertex(vbuff, v00, t00, norm0, tan0);
			vbuffAddVertex(vbuff, v10, t10, norm1, tan1);
			vbuffAddVertex(vbuff, v11, t11, norm1, tan1);
			
			vbuffAddVertex(vbuff, v00, t00, norm0, tan0);
			vbuffAddVertex(vbuff, v11, t11, norm1, tan1);
			vbuffAddVertex(vbuff, v01, t01, norm0, tan0);
		}
		
		i += step;
		j0 = j1;
	}
}

function sTowerMesh(z1, z2, addHeight, r1, r2) constructor {
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_texcoord();
	vertex_format_add_normal();
	vertex_format_add_custom(vertex_type_float3, vertex_usage_texcoord);
	_vformat = vertex_format_end();
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);
	
	var tx1 = ( 8/256 ) / 4;
	var tx2 = ( (8+240)/256 ) / 4;
	var tx3 = tx1 + 0.25;
	var tx4 = tx2 + 0.25;
	
	var r3 = r2 - 2;
	VertexBufferAddRing(vbuff, z1 + addHeight, r3, z1 + 10, r3, tx3, tx4, 0, (192-32)/512);
	
	VertexBufferAddRing(vbuff, z1 + 10, r3, z1 + 10, r2, tx3, tx4, 0, 0);
	
	VertexBufferAddRing(vbuff, z1 + 10, r2, z1, r2, tx3, tx4, (192-32)/512, 192/512);
	
	VertexBufferAddRing(vbuff, z1, r2, z1, r1, tx3, tx4, 192/512, 248/512);
	
	VertexBufferAddRing(vbuff, z1, r1, z2, r1, tx1, tx2, 0, 2);
	
	VertexBufferAddRing(vbuff, z2, r1, z2, r2, tx3, tx4, 264/512, 320/512);
	
	VertexBufferAddRing(vbuff, z2, r2, z2 - 10, r2, tx3, tx4, 320/512, (320+32)/512);
	
	VertexBufferAddRing(vbuff, z2 - 10, r3, z2 - addHeight, r3, tx3, tx4, (320+32)/512, 1);
	
	vertex_end(vbuff);
	vertex_freeze(vbuff);
	_vbuff = vbuff;
	
	var spr = os_browser==browser_not_a_browser ? sprite_add("tower.png", 1, false, false, 0, 0) : -1;
	_spr = spr!=-1 ? spr : tex_Tower;
	_texture = sprite_get_texture(_spr, 0);
	
	_shader = sh_Tower;
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
	
	CleanUp = function() {
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	Draw = function() {
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
		
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
	}
	
	
	_sh_Distance_u_DirLightNearFarClip = shader_get_uniform(sh_Distance, "u_DirLightNearFarClip");
	DrawDepth = function() {
		shader_set(sh_Distance);
		var dl = obj_DirectionalLight;
		shader_set_uniform_f(_sh_Distance_u_DirLightNearFarClip, dl.NearClip, dl.FarClip);
		vertex_submit(_vbuff, pr_trianglelist, _texture);
		shader_reset();
	}
}

