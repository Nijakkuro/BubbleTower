attribute vec3 in_Position;
varying float v_vDistance;

uniform vec4 u_InstanceData; // location and tex coord-x offset

void main()
{
	vec4 localPos =  vec4( in_Position.xyz + u_InstanceData.xyz, 1.0);
	vec4 worldPosCamSpace = gm_Matrices[MATRIX_WORLD_VIEW] * localPos;
	v_vDistance = worldPosCamSpace.z;
	//gl_Position = gm_Matrices[MATRIX_PROJECTION] * worldPosCamSpace;
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * localPos;
}

