
function matrix_transform_vertex_fix(m, x, y, z, w, out)
{
	if(os_browser==browser_not_a_browser) {
		return matrix_transform_vertex(m, x, y, z, w, out);
	}
	
	out[@ 0] = m[0] * x + m[4] * y + m[ 8] * z + m[12] * w;
	out[@ 1] = m[1] * x + m[5] * y + m[ 9] * z + m[13] * w;
	out[@ 2] = m[2] * x + m[6] * y + m[10] * z + m[14] * w;
	out[@ 3] = m[3] * x + m[7] * y + m[11] * z + m[15] * w;
}

function screen_to_world_ray_perspective(x, y, viewMatrix, projMatrix, screenW, screenH, outResult)
{
	static mViewProj = matrix_build_identity();
	matrix_multiply(viewMatrix, projMatrix, mViewProj);
	
	static mInvViewProj = matrix_build_identity();
	matrix_inverse(mViewProj, mInvViewProj);
	
	var nx = ( 2.0 * x / screenW ) - 1.0;
	var ny = ( 2.0 * y / screenH ) - 1.0;
	
	static v0 = [ 0, 0, 0, 0 ];
	matrix_transform_vertex_fix(mInvViewProj, nx, ny, 0, 1, v0);
	v0[0] /= v0[3];
	v0[1] /= v0[3];
	v0[2] /= v0[3];
	
	static v1 = [ 0, 0, 0, 0 ];
	matrix_transform_vertex_fix(mInvViewProj, nx, ny, 1, 1, v1);
	v1[0] /= v1[3];
	v1[1] /= v1[3];
	v1[2] /= v1[3];
	
	// origin at near clip plane
	outResult[@ 0] = v0[0];
	outResult[@ 1] = v0[1];
	outResult[@ 2] = v0[2];
	
	// normalized direction vector
	var d = point_distance_3d(v0[0], v0[1], v0[2], v1[0], v1[1], v1[2]);
	outResult[@ 3] = ( v1[0] - v0[0] ) / d;
	outResult[@ 4] = ( v1[1] - v0[1] ) / d;
	outResult[@ 5] = ( v1[2] - v0[2] ) / d;
}

function point_line_projection_2d(px, py, x1, y1, x2, y2, outResult)
{
	var l = point_distance(x1, y1, x2, y2);
	if(l<0.0000001) {
		return false;
	}
	
	var ldx = (x2 - x1) / l;
	var ldy = (y2 - y1) / l;
	var k = dot_product(px - x1,    py - y1, ldx, ldy);
	
	outResult[@ 0] = x1 + ldx * k;
	outResult[@ 1] = y1 + ldy * k;
	return true;
}

function line_circle_collision_point(x1, y1, x2, y2, cx, cy, cr, outResult)
{
	static p = [ 0, 0 ];
	if(point_line_projection_2d(cx, cy, x1, y1, x2, y2, p)) {
		var d = point_distance(cx, cy, p[0], p[1]);
		if(d<=cr) {
			var b = sqrt(cr*cr - d*d);
			var l = point_distance(x1, y1, x2, y2);
			if(l>0.0000001) {
				var vx = (x2 - x1)/l;
				var vy = (y2 - y1)/l;
				outResult[@ 0] = p[0] - vx*b;
				outResult[@ 1] = p[1] - vy*b;
				outResult[@ 2] = p[0] + vx*b;
				outResult[@ 3] = p[1] + vy*b;
				return true;
			}
		}
	}
	
	return false;
}

function ray_circle_collision_point_dist(ox, oy, dx, dy, cx, cy, crSq) {
	// Вектор от центра окружности к началу луча: F = O - C
	var fx = ox - cx;
	var fy = oy - cy;
	
	// Коэффициенты квадратного уравнения t^2 + 2*b*t + c = 0
	// b = скалярное произведение (F · D)
	//var b = fx * dx + fy * dy;
	var b = dot_product(fx, fy, dx, dy);
	
	// c = |F|^2 - r^2
	//var c = fx * fx + fy * fy - crSq;
	var c = dot_product(fx, fy, fx, fy) - crSq;
	
	// Дискриминант (упрощенный, т.к. a=1)
	// k = b^2 - c
	var k = b * b - c;
	
	// Если дискриминант отрицательный, пересечений нет
	if (k < 0) return -1;
	
	var sqrtK = sqrt(k);
	
	// Находим корни. Нам нужен наименьший t >= 0.
	// t1 = -b - sqrtK
	// t2 = -b + sqrtK
	// Поскольку sqrtK >= 0, t1 всегда <= t2. Проверяем t1 первым.
	return -b - sqrtK;
}

