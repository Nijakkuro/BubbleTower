/// package: gml_utils
/// version: 1
/// dependencies: -
/// author: NikkoTC

#macro singleton_object persistent=true;if(instance_number(object_index)>1){instance_destroy(self);exit;}

#macro singleton_struct __singleton_struct()

/// @ignore
function __singleton_struct()
{
	var structName = instanceof(self);
	var globalName = structName;
	var globalValue = global[$ globalName];
	
	if(!globalValue || is_callable(globalValue) || !is_struct(globalValue))
	{
		global[$ globalName] = self;
		var globalValueNew = global[$ globalName];
	}
	else
	{
		show_error($"Trying to create a new instance of struct {structName} which is marked as singleton.", true);
	}
}

/// @ignore
function __create_arg_arr(argCount)
{
	global.__i = 0;
	global.__n = argCount;
	global.__arr = array_create(argCount);
	return global.__arr;
}

#macro make_argument_array __create_arg_arr(argument_count);repeat(global.__n){global.__arr[global.__i]=argument[global.__i];global.__i++;}

function array_clone(arr)
{
	var n = array_length(arr);
	var arrNew = array_create(n);
	var i = 0;
	repeat(n)
	{
		arrNew[i] = arr[i];
		i++;
	}
	return arrNew;
}

function array_find_index_by_value(array, value, defaultIndex=-1)
{
	var n = array_length(array);
	for(var i=0; i<n; i++)
	{
		if(array[i]==value)
		{
			return i;
		}
	}
	return defaultIndex;
}

function struct_get_name_by_value(struct, value)
{
	var names = struct_get_names(struct);
	var i = 0;
	repeat(array_length(names))
	{
		var name = names[i];
		if(struct[$ name]==value)
		{
			return name;
		}
		i++;
	}
	
	return undefined;
}

function ds_list_delete_item(list, item)
{
	var i = ds_list_find_index(list, item);
	if(i!=-1)
	{
		ds_list_delete(list, i);
		return true;
	}
	
	return false;
}

function ds_map_find_key(map, value)
{
	var keys = ds_map_keys_to_array(map);
	var n = array_length(keys);
	for(var i=0; i<n; i++)
	{
		var key = keys[i];
		if(map[? key]==value)
		{
			return key;
		}
	}
	return undefined;
}

function move_towards_point_step(xTo, yTo, step)
{
	var d = point_distance(x, y, xTo, yTo);
	if(d>step)
	{
		var vx = (xTo - x) / d;
		var vy = (yTo - y) / d;
		x += vx * step;
		y += vy * step;
		return true;
	}
	else
	{
		x = xTo;
		y = yTo;
		return false;
	}
}


// math function

function wrap(val, valMin, valMax)
{
	var len = valMax - valMin;
	if(len>0)
	{
		var wrappedVal = (val - valMin) mod len;
		return valMin + (wrappedVal<0 ? wrappedVal + len : wrappedVal);
	}
	
	return valMax;
}

// Returns angle in the range [0; 360).
function angle_normalize360(angle)
{
	var angleNorm = angle mod 360;
	return angleNorm<0 ? angleNorm + 360 : angleNorm;
}

// Returns angle in the range (-180; 180].
function angle_normalize180(angle)
{
	var angleNorm = angle_normalize360(angle);
	return angleNorm > 180 ? angleNorm-360 : angleNorm;
}

function value_step_to(from, to, step)
{
	var dx = (to - from);
	return abs(dx)>step ? (from + sign(dx) * step) : to;
}


// string functions

function string_remove_prefix(str, prefixStr)
{
	if(string_starts_with(str, prefixStr))
	{
		return string_delete(str, 1, string_length(prefixStr));
	}
	return str;
}


// json functions

function json_load_from_file(filename)
{
	var buffer = buffer_load(filename);
	if(buffer==-1)
	{
		show_debug_message("Error: Can not load file '"+filename+"'.");
		return undefined;
	}

	var jsonString = buffer_read(buffer, buffer_text);
	buffer_delete(buffer);
	
	var parsedData = undefined;
	try // 'try' does not work for json_parse :(
	{
		parsedData = json_parse(jsonString);
	}
	
	return parsedData;
}

function json_save_to_file(json, filename, prettify=true)
{
	var jsonString = json_stringify(json, prettify);
	var buffer = buffer_create(string_byte_length(jsonString), buffer_fixed, 1);
	buffer_write(buffer, buffer_text, jsonString);
	buffer_save(buffer, filename);
	buffer_delete(buffer);
}


// log functions

#macro log_error_show_messages true

function log_error(str)
{
	var clsName = is_struct(self) ? instanceof(self) : object_get_name(object_index);
	var errorStr = "Error: " + clsName + " : " + str;
	show_debug_message(errorStr);
	if(log_error_show_messages)
	{
		show_message(errorStr);
	}
}

function log_warning(str)
{
	var clsName = is_struct(self) ? instanceof(self) : object_get_name(object_index);
	show_debug_message("Warning: " + clsName + " : " + str);
}

function log_info(str)
{
	var clsName = is_struct(self) ? instanceof(self) : object_get_name(object_index);
	show_debug_message("Info: " + clsName + " : " + str);
}


// matrix functions

global.__matrix_identity = matrix_build_identity();
#macro matrix_identity global.__matrix_identity

#macro MAT_TX 12
#macro MAT_TY 13
#macro MAT_TZ 14
#macro MAT_SX 0
#macro MAT_SY 5
#macro MAT_SZ 10

function matrix_build_view_simple(sizeX, sizeY, depthBegin, depthEnd, offsetX=0, offsetY=0, scaleX=1, scaleY=1)
{
	return [
		scaleX, 0, 0, 0, 
		0, scaleY, 0, 0,
		0, 0, 1, 0,
		-sizeX / 2 + offsetX, -sizeY / 2 + offsetY, (depthBegin - depthEnd)/2, 1
	];
}

function matrix_build_projection_ortho_fix(sizeX, sizeY, znear=1, zfar=16000, scaleX=1, scaleY=1)
{
	var mat = matrix_build_projection_ortho(sizeX, sizeY, znear, zfar);
	mat[0] *= scaleX;
	mat[5] = -mat[5] * scaleY;
	
	if(os_type==os_linux || os_type==os_gxgames || os_type==os_android)
	{
		mat[5] = -mat[5];
	}
	
	return mat;
}

function matrix_build_projection_perspective_fov_fix(fov, aspect, zNear, zFar)
{
	var projMat = matrix_build_projection_perspective_fov(fov, aspect, zNear, zFar);
	if(os_type==os_linux || os_type==os_gxgames || os_type==os_android)
	{
		projMat[5] = -projMat[5]; // flip Z-Axis to Up-positive/Down-negative
	}
	
	return projMat;
}

function matrix_build_projection_perspective_fov_fix_out(fov, aspect, zNear, zFar, outMatrix)
{
	matrix_build_projection_perspective_fov(fov, aspect, zNear, zFar, outMatrix);
	if(os_type==os_linux || os_type==os_gxgames || os_type==os_android || os_type==os_windows) {
		outMatrix[@ 5] = -outMatrix[@ 5]; // flip Z-Axis to Up-positive/Down-negative
	}
}

global.__matrix_view_stack = ds_stack_create();
global.__matrix_proj_stack = ds_stack_create();

function matrix_viewproj_push()
{
	ds_stack_push(global.__matrix_view_stack, matrix_get(matrix_view));
	ds_stack_push(global.__matrix_proj_stack, matrix_get(matrix_projection));
}

function matrix_viewproj_pop()
{
	var v = ds_stack_pop(global.__matrix_view_stack);
	var p = ds_stack_pop(global.__matrix_proj_stack);
	matrix_set(matrix_view, v);
	matrix_set(matrix_projection, p);
}

function world_to_screen(x, y, z, viewMatrix, projMatrix, screenW=window_get_width(), screenH=window_get_height())
{
	var mView = viewMatrix;
	var mProj = projMatrix;
	var outX = -1;
	var outY = -1;

	if (mProj[15] == 0) //This is a perspective projection
	{
		var w = mView[2] * x + mView[6] * y + mView[10] * z + mView[14];
		// If you try to convert the camera's "from" position to screen space, you will
		// end up dividing by zero (please don't do that)
		//if (w <= 0) return [-1, -1];
		if (w == 0)
		{
			return [-1, -1];
		}
	
		outX = mProj[8] + mProj[0] * (mView[0] * x + mView[4] * y + mView[8] * z + mView[12]) / w;
		outY = mProj[9] + mProj[5] * (mView[1] * x + mView[5] * y + mView[9] * z + mView[13]) / w;
	}
	else //This is an ortho projection
	{
		outX = mProj[12] + mProj[0] * (mView[0] * x + mView[4] * y + mView[8]  * z + mView[12]);
		outY = mProj[13] + mProj[5] * (mView[1] * x + mView[5] * y + mView[9]  * z + mView[13]);
	}

	return [
		(0.5 + 0.5 * outX) * screenW,
		(0.5 + 0.5 * outY) * screenH
	];
}


// collision utils

function get_line_intersection(x1, y1, x2, y2, x3, y3, x4, y4, outXY)
{
	var dx1 = x2 - x1;
	var dy1 = y2 - y1;
	var dx2 = x4 - x3;
	var dy2 = y4 - y3;
	
	var s = (-dy1 * (x1 - x3) + dx1 * (y1 - y3)) / (-dx2 * dy1 + dx1 * dy2);
	var t = ( dx2 * (y1 - y3) - dy2 * (x1 - x3)) / (-dx2 * dy1 + dx1 * dy2);
	
	if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
	{
		// Collision detected
		outXY[@ 0] = x1 + (t * dx1);
		outXY[@ 1] = y1 + (t * dy1);
		return true;
	}
	
	return false; // No collision
}

function get_line_intersection_no_limit(x1, y1, x2, y2, x3, y3, x4, y4, outXY)
{
	var dx1 = x2 - x1;
	var dy1 = y2 - y1;
	var dx2 = x4 - x3;
	var dy2 = y4 - y3;
	
	var t = ( dx2 * (y1 - y3) - dy2 * (x1 - x3)) / (-dx2 * dy1 + dx1 * dy2);
	
	outXY[@ 0] = x1 + (t * dx1);
	outXY[@ 1] = y1 + (t * dy1);
}


// busy indicator

function draw_dotted_circle_busy_indicator(cx, cy, radius=64,
	dotMinRadius=6, dotMaxRadius=12, dotColorFrom=#49a8d1, dotColorTo=c_white,
	outlineColor=c_black, outlineSize=2)
{
	var time = current_time * 0.001;
	for(var i=0; i<360; i+=45)
	{
		var dx = cx + lengthdir_x(radius, i);
		var dy = cy + lengthdir_y(radius, i);
		var value = 1 - frac( i/360 + time );
		var r = lerp(dotMinRadius, dotMaxRadius, value);
		
		draw_set_colour(outlineColor);
		draw_circle(dx, dy, r + outlineSize, false);
		
		draw_set_colour(merge_colour(dotColorFrom, dotColorTo, value));
		draw_circle(dx, dy, r, false);
	}
}


// vertex

function vertex_pos_col(vBuff, vx, vy, vz, vc, va)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_color(vBuff, vc, va);
}

function vertex_pos_tex(vBuff, vx, vy, vz, tx, ty)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_texcoord(vBuff, tx, ty);
}

function vertex_pos_tex_col(vBuff, vx, vy, vz, tx, ty, vc, va)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_texcoord(vBuff, tx, ty);
	vertex_color(vBuff, vc, va);
}

function vertex_pos_tex_norm(vBuff, vx, vy, vz, tx, ty, nx, ny, nz)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_texcoord(vBuff, tx, ty);
	vertex_normal(vBuff, nx, ny, nz);
}

function vertex_pos_tex_norm_tan(vBuff, vx, vy, vz, tx, ty, nx, ny, nz, tanX, tanY, tanZ)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_texcoord(vBuff, tx, ty);
	vertex_normal(vBuff, nx, ny, nz);
	vertex_float3(vBuff, tanX, tanY, tanZ);
}

function vertex_pos_tex_norm_tan_col(vBuff, vx, vy, vz, tx, ty, nx, ny, nz, tanX, tanY, tanZ, vc, va)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_texcoord(vBuff, tx, ty);
	vertex_normal(vBuff, nx, ny, nz);
	vertex_float3(vBuff, tanX, tanY, tanZ);
	vertex_color(vBuff, vc, va);
}

function vertex_pos_tex_norm_col(vBuff, vx, vy, vz, tx, ty, nx, ny, nz, vc, va)
{
	vertex_position_3d(vBuff, vx, vy, vz);
	vertex_texcoord(vBuff, tx, ty);
	vertex_normal(vBuff, nx, ny, nz);
	vertex_color(vBuff, vc, va);
}

