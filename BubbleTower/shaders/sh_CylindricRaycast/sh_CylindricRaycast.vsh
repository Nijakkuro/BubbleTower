attribute vec3 in_Position;

varying vec2 v_vTexcoord;

uniform mat4 u_LocalTransform;
uniform float u_AngleOffsetRad;
uniform float u_Radius;
uniform float u_FullSpinLength;

const float TWO_PI = 6.28318530718;

void main()
{
	vec4 localPos = u_LocalTransform * vec4( in_Position.x, mix(0.5, -0.5, in_Position.y), in_Position.z, 1.0);
	
	float angle = ( localPos.y / u_FullSpinLength ) * TWO_PI + u_AngleOffsetRad;
	
	localPos.x = cos(angle) * u_Radius;
	localPos.y = sin(angle) * u_Radius;
	
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(localPos.xyz, 1.0);
	
	v_vTexcoord = vec2(in_Position.y, -in_Position.z);
}

