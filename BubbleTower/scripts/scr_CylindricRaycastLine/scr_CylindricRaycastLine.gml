function sCylindricRaycastLine() constructor
{
	vertex_format_begin();
	vertex_format_add_position_3d();
	_vformat = vertex_format_end();
	
	var vbuff = vertex_create_buffer();
	vertex_begin(vbuff, _vformat);
	
	_maxSegmentNum = 100;
	for(var i=0; i<=_maxSegmentNum; i++)
	{
		vertex_position_3d(vbuff, 0, 1, i);
		vertex_position_3d(vbuff, 0, 0, i);
	}
	
	vertex_end(vbuff);
	_vbuff = vbuff;
	vertex_freeze(_vbuff);
	
	CleanUp = function()
	{
		vertex_delete_buffer(_vbuff);
		vertex_format_delete(_vformat);
	}
	
	_matrixSave = matrix_build_identity();
	_matrix = matrix_build_identity();
	_localTransformMatrix = matrix_build_identity();
	
	_shader = sh_CylindricRaycast;
	_u_LocalTransform = shader_get_uniform(_shader, "u_LocalTransform");
	_u_Radius = shader_get_uniform(_shader, "u_Radius");
	_u_FullSpinLength = shader_get_uniform(_shader, "u_FullSpinLength");
	_u_AngleOffsetRad = shader_get_uniform(_shader, "u_AngleOffsetRad");
	_u_Time = shader_get_uniform(_shader, "u_Time");
	
	_texture = sprite_get_texture(tex_RaycastLine, 0);
	
	Draw = function(x, y, z, cylinderRadius, cylinderSpinLen, startPosAngle, rayAngle, rayThickness, raySegmentLen, traceLen)
	{
		var segmentNum = min( round(traceLen / raySegmentLen) , _maxSegmentNum );
		if(segmentNum<=0) {
			return;
		}
		
		matrix_build_fixed(0, 0, 0, rayAngle, 0, 0, 1, rayThickness, raySegmentLen, _localTransformMatrix);
		matrix_build(x, y, z, 0, 0, 0, 1, 1, 1, _matrix);
		
		matrix_get(matrix_world, _matrixSave);
		
		var cullsave = gpu_get_cullmode();
		gpu_set_cullmode(cull_noculling);
		
		shader_set(_shader);
		matrix_set(matrix_world, _localTransformMatrix);
		shader_set_uniform_matrix(_u_LocalTransform);
		shader_set_uniform_f(_u_Radius, cylinderRadius);
		shader_set_uniform_f(_u_FullSpinLength, cylinderSpinLen);
		shader_set_uniform_f(_u_AngleOffsetRad, degtorad(startPosAngle));
		shader_set_uniform_f(_u_Time, CTime.CurrentTime);
		matrix_set(matrix_world, _matrix);
		vertex_submit_ext(_vbuff, pr_trianglestrip, _texture, 0, 2 + segmentNum * 2);
		shader_reset();
		
		gpu_set_cullmode(cullsave);
		
		matrix_set(matrix_world, _matrixSave);
	}
}


function matrix_build_rotation(rx, ry, rz)
{
	var radX =  degtorad(rx);
	var radY = -degtorad(ry);
	var radZ = -degtorad(rz);
	
	var cosX = cos(radX);
	var sinX = sin(radX);
	var rotX =  [
		     1,     0,     0,     0,
		     0,  cosX,  sinX,     0,
		     0, -sinX,  cosX,     0,
		     0,     0,     0,     1
	];
	
	var cosY = cos(radY);
	var sinY = sin(radY);
	var rotY =  [
		  cosY,     0, -sinY,     0,
		     0,     1,     0,     0,
		  sinY,     0,  cosY,     0,
		     0,     0,     0,     1
	];
	
	var cosZ = cos(radZ);
	var sinZ = sin(radZ);
	var rotZ =  [
		  cosZ,  sinZ,     0,     0,
		 -sinZ,  cosZ,     0,     0,
		     0,     0,     1,     0,
		     0,     0,     0,     1
	];
	
	var rotXY = matrix_multiply(rotX, rotY);
	return matrix_multiply(rotXY, rotZ);
}

function matrix_build_fixed(tx, ty, tz, rx, ry, rz, sx, sy, sz, out)
{
	var mr = matrix_build_rotation(rx, ry, rz); //matrix_build_identity();
	static ms = matrix_build_identity();
	//matrix_build(0, 0, 0, rx, ry, rz, 0, 0, 0, mr);
	matrix_build(0, 0, 0, 0, 0, 0, sx, sy, sz, ms);
	
	matrix_multiply(ms, mr, out);
	out[MAT_TX] = tx;
	out[MAT_TY] = ty;
	out[MAT_TZ] = tz;
}

