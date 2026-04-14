/// package: gml_Vectors
/// version: 1
/// dependencies: -
/// author: NikkoTC

function sVector2(vx=0, vy=0) constructor {
	x = vx;
	y = vy;
	static z = 0;
	static w = 0;
	
	// FUNCTIONS
	
	static Copy = function() {
		return new sVector2(x, y);
	}
	
	static Equals = function(vector) {
		return (x==vector.x && y==vector.y);
	}
	
	static EqualsV = function(vx, vy) {
		return (x==vx && y==vy);
	}
	
	static Length = function() {
		return point_distance(0, 0, x, y);
	}
	
	static Distance = function(vector) {
		return point_distance(x, y, vector.x, vector.y);
	}
	
	static DistanceV = function(vx, vy) {
		return point_distance(x, y, vx, vy);
	}

	static DotProduct = function(vector) {
		return dot_product(x, y, vector.x, vector.y);
	}
	
	static DotProductV = function(vx, vy) {
		return dot_product(x, y, vx, vy);
	}
	
	static DotProductNormalized = function(vector) {
		return dot_product_normalized(x, y, vector.x, vector.y);
	}
	
	static DotProductNormalizedV = function(vx, vy) {
		return dot_product_normalized(x, y, vx, vy);
	}
	
	//----- SELF MODIFIERS
	
	static Normalize = function() {
		var l = point_distance(0, 0, x, y);
		if(l>0.00001) {
			var k = 1.0/l;
			x *= k;
			y *= k;
		} else {
			x = 1;
			y = 0;
		}
		return self;
	}
	
	// clamp
	static Clamp = function(vectorMin, vectorMax) {
		x = clamp(x, vectorMin.x, vectorMax.x);
		y = clamp(y, vectorMin.y, vectorMax.y);
		return self;
	}
	
	static ClampS = function(scalarMin, scalarMax) {
		x = clamp(x, scalarMin, scalarMax);
		y = clamp(y, scalarMin, scalarMax);
		return self;
	}
	
	static ClampV = function(minX, minY, maxX, maxY) {
		x = clamp(x, minX, maxX);
		y = clamp(y, minY, maxY);
		return self;
	}
	
	// lerp
	static Lerp = function(vectorTo, amount) {
		x = lerp(x, vectorTo.x, amount);
		y = lerp(y, vectorTo.y, amount);
		return self;
	}
	
	static LerpS = function(scalarTo, amount) {
		x = lerp(x, scalarTo, amount);
		y = lerp(y, scalarTo, amount);
		return self;
	}
	
	static LerpV = function(toX, toY, amount) {
		x = lerp(x, toX, amount);
		y = lerp(y, toY, amount);
		return self;
	}
	
	// negate
	static Negate = function() {
		x = -x;
		y = -y;
		return self;
	}
	
	// set
	static Set = function(vector) {
		x = vector.x;
		y = vector.y;
		return self;
	}
	
	static SetS = function(s) {
		x = s;
		y = s;
		return self;
	}
	
	static SetV = function(vx, vy) {
		x = vx;
		y = vy;
		return self;
	}
	
	// add
	static Add = function(vector) {
		x += vector.x;
		y += vector.y;
		return self;
	}
	
	static AddS = function(s) {
		x += s;
		y += s;
		return self;
	}
	
	static AddV = function(vx, vy) {
		x += vx;
		y += vy;
		return self;
	}
	
	// subtract
	static Subtract = function(vector) {
		x -= vector.x;
		y -= vector.y;
		return self;
	}
	
	static SubtractS = function(s) {
		x -= s;
		y -= s;
		return self;
	}
	
	static SubtractV = function(vx, vy) {
		x -= vx;
		y -= vy;
		return self;
	}
	
	// multiply
	static Multiply = function(vector) {
		x *= vector.x;
		y *= vector.y;
		return self;
	}
	
	static MultiplyS = function(s) {
		x *= s;
		y *= s;
		return self;
	}
	
	static MultiplyV = function(vx, vy) {
		x *= vx;
		y *= vy;
		return self;
	}
	
	// divide
	static Divide = function(vector) {
		x /= vector.x;
		y /= vector.y;
		return self;
	}
	
	static DivideS = function(s) {
		x /= s;
		y /= s;
		return self;
	}
	
	static DivideV = function(vx, vy) {
		x /= vx;
		y /= vy;
		return self;
	}
	
	// string conversions
	
	static FromString = function(str) {
		var strClean = string_trim(str);
		var sArr = string_split(strClean, ",");
		var sLen = array_length(sArr);
		x = sLen > 0 ? real(sArr[0]) : 0;
		y = sLen > 1 ? real(sArr[1]) : 0;
		return self;
	}
	
	static ToString = function() {
		return string(x) + ", " + string(y);
	}
	
	static FromArray = function(arr)
	{
		x = arr[0];
		y = arr[1];
		return self;
	}
	
	static ToArray = function()
	{
		return [ x, y ];
	}
}


function sVector(vx=0, vy=0, vz=0) constructor {
	x = vx;
	y = vy;
	z = vz;
	static w = 1;
	
	// FUNCTIONS
	
	static Copy = function() {
		return new sVector(x, y, z);
	}
	
	static Equals = function(vector) {
		return (x==vector.x && y==vector.y && z==vector.z);
	}
	
	static EqualsV = function(vx, vy, vz) {
		return (x==vx && y==vy && z==vz);
	}
	
	static Length2D = function() {
		return point_distance(0, 0, x, y);
	}
	
	static Length = function() {
		return point_distance_3d(0, 0, 0, x, y, z);
	}
	
	static Distance = function(vector) {
		return point_distance_3d(x, y, z, vector.x, vector.y, vector.z);
	}
	
	static DistanceV = function(vx, vy, vz) {
		return point_distance_3d(x, y, z, vx, vy, vz);
	}
	
	static DotProduct = function(vector) {
		return dot_product_3d(x, y, z, vector.x, vector.y, vector.z);
	}
	
	static DotProductV = function(vx, vy, vz) {
		return dot_product_3d(x, y, z, vx, vy, vz);
	}
	
	static DotProductNormalized = function(vector) {
		return dot_product_3d_normalized(x, y, z, vector.x, vector.y, vector.z);
	}
	
	static DotProductNormalizedV = function(vx, vy, vz) {
		return dot_product_3d_normalized(x, y, z, vx, vy, vz);
	}
	
	static CrossProduct = function(vector) {
		var cx = y * vector.z - z * vector.y;
		var cy = z * vector.x - x * vector.z;
		var cz = x * vector.y - y * vector.x;
		return new sVector(cx, cy, cz);
	}
	
	static CrossProductV = function(vx, vy, vz) {
		var cx = y * vz - z * vy;
		var cy = z * vx - x * vz;
		var cz = x * vy - y * vx;
		return new sVector(cx, cy, cz);
	}
	
	static CrossProductNormalized = function(vector) {
		var cx = y * vector.z - z * vector.y;
		var cy = z * vector.x - x * vector.z;
		var cz = x * vector.y - y * vector.x;
		var vec = new sVector(cx, cy, cz);
		return vec.Normalize();
	}
	
	static CrossProductNormalizedV = function(vx, vy, vz) {
		var cx = y * vz - z * vy;
		var cy = z * vx - x * vz;
		var cz = x * vy - y * vx;
		var vec = new sVector(cx, cy, cz);
		return vec.Normalize();
	}
	
	//----- SELF MODIFIERS
	
	static Normalize = function() {
		var l = point_distance_3d(0, 0, 0, x, y, z);
		if(l>0.00001) {
			var k = 1.0/l;
			x *= k;
			y *= k;
			z *= k;
		} else {
			x = 1;
			y = 0;
			z = 0;
		}
		return self;
	}
	
	// clamp
	static Clamp = function(vectorMin, vectorMax) {
		x = clamp(x, vectorMin.x, vectorMax.x);
		y = clamp(y, vectorMin.y, vectorMax.y);
		z = clamp(z, vectorMin.z, vectorMax.z);
		return self;
	}
	
	static ClampS = function(scalarMin, scalarMax) {
		x = clamp(x, scalarMin, scalarMax);
		y = clamp(y, scalarMin, scalarMax);
		z = clamp(z, scalarMin, scalarMax);
		return self;
	}
	
	static ClampV = function(minX, minY, minZ, maxX, maxY, maxZ) {
		x = clamp(x, minX, maxX);
		y = clamp(y, minY, maxY);
		z = clamp(z, minZ, maxZ);
		return self;
	}
	
	// lerp
	static Lerp = function(vector, amount) {
		x = lerp(x, vector.x, amount);
		y = lerp(y, vector.y, amount);
		z = lerp(z, vector.z, amount);
		return self;
	}
	
	static LerpS = function(scalarTo, amount) {
		x = lerp(x, scalarTo, amount);
		y = lerp(y, scalarTo, amount);
		z = lerp(z, scalarTo, amount);
		return self;
	} 
	
	static LerpV = function(toX, toY, toZ, amount) {
		x = lerp(x, toX, amount);
		y = lerp(y, toY, amount);
		z = lerp(z, toZ, amount);
		return self;
	}
	
	static Negate = function() {
		x = -x;
		y = -y;
		z = -z;
		return self;
	}
	
	// set
	static Set = function(vector) {
		x = vector.x;
		y = vector.y;
		z = vector.z;
		return self;
	}
	
	static SetS = function(s) {
		x = s;
		y = s;
		z = s;
		return self;
	}
	
	static SetV = function(vx, vy, vz) {
		x = vx;
		y = vy;
		z = vz;
		return self;
	}
	
	// add
	static Add = function(vector) {
		x += vector.x;
		y += vector.y;
		z += vector.z;
		return self;
	}
	
	static AddS = function(s) {
		x += s;
		y += s;
		z += s;
	}
	
	static AddV = function(vx, vy, vz) {
		x += vx;
		y += vy;
		z += vz;
		return self;
	}
	
	// subtract
	static Subtract = function(vector) {
		x -= vector.x;
		y -= vector.y;
		z -= vector.z;
		return self;
	}
	
	static SubtractS = function(s) {
		x -= s;
		y -= s;
		z -= s;
		return self;
	}
	
	static SubtractV = function(vx, vy, vz) {
		x -= vx;
		y -= vy;
		z -= vz;
		return self;
	}
	
	// multiply
	static Multiply = function(vector) {
		x *= vector.x;
		y *= vector.y;
		z *= vector.z;
		return self;
	}
	
	static MultiplyS = function(s) {
		x *= s;
		y *= s;
		z *= s;
		return self;
	}
	
	static MultiplyV = function(vx, vy, vz) {
		x *= vx;
		y *= vy;
		z *= vz;
		return self;
	}
	
	// divide
	static Divide = function(vector) {
		x /= vector.x;
		y /= vector.y;
		z /= vector.z;
		return self;
	}
	
	static DivideS = function(s) {
		x /= s;
		y /= s;
		z /= s;
		return self;
	}
	
	static DivideV = function(vx, vy, vz) {
		x /= vx;
		y /= vy;
		z /= vz;
		return self;
	}
	
	// transforms
	static Transform = function(transform) {
		var mat = transform.ToMatrix();
		var v = matrix_transform_vertex(mat, x, y, z);
		x = v[0];
		y = v[1];
		z = v[2];
		return self;
	}
	
	static TransformMat = function(matrix) {
		var v = matrix_transform_vertex(matrix, x, y, z);
		x = v[0];
		y = v[1];
		z = v[2];
		return self;
	}
	
	static Rotate = function(rotator) {
		var mat = rotator.ToMatrix();
		var v = matrix_transform_vertex(mat, x, y, z);
		x = v[0];
		y = v[1];
		z = v[2];
		return self;
	}
	
	// string conversions
	
	static FromString = function(str) {
		var strClean = string_trim(str);
		var sArr = string_split(strClean, ",");
		var sLen = array_length(sArr);
		x = sLen > 0 ? real(sArr[0]) : 0;
		y = sLen > 1 ? real(sArr[1]) : 0;
		z = sLen > 2 ? real(sArr[2]) : 0;
		return self;
	}
	
	static ToString = function() {
		return string(x) + ", " + string(y) + ", " + string(z);
	}
	
	static FromArray = function(arr)
	{
		x = arr[0];
		y = arr[1];
		z = arr[2];
		return self;
	}
	
	static ToArray = function()
	{
		return [ x, y, z ];
	}
}

