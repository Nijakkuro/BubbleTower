attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord;
attribute vec3 in_TextureCoord2; // tangent

uniform vec4 u_InstanceData; // location and tex coord-x offset

// varying
varying vec2 v_vTexCoord;
varying mat3 v_mTBN;
varying vec3 v_vWorldPos;

// dir light
uniform mat4 u_DirLightViewMat;
uniform mat4 u_DirLightProjMat;
varying vec3 v_vDirLightDepthMapFragmentPos;

mat3 buildTBNMatrix(mat4 model, vec3 normal, vec3 tangent)
{
	vec3 T = normalize(vec3(model * vec4(tangent, 0.0)));
	vec3 N = normalize(vec3(model * vec4(normal, 0.0)));
	vec3 B = cross(N, T);
	return mat3(T, B, N);
}

void calculateDirLightDepthMapFragmentPos(vec3 worldPos)
{
	vec4 lightPosViewSpace = u_DirLightViewMat * vec4(worldPos, 1.0);
	vec4 lightPosScreenSpace = u_DirLightProjMat * lightPosViewSpace;
	v_vDirLightDepthMapFragmentPos = vec3( vec2(lightPosScreenSpace.x, -lightPosScreenSpace.y) * 0.5 + 0.5, lightPosViewSpace.z );
}

void main()
{
	vec4 localPos = vec4( in_Position.xyz + u_InstanceData.xyz, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * localPos;
	
	v_vTexCoord = vec2(in_TextureCoord.x + u_InstanceData.w * 0.125, in_TextureCoord.y);
	
	mat4 model = gm_Matrices[MATRIX_WORLD];
	v_mTBN = buildTBNMatrix(model, in_Normal, in_TextureCoord2);
	v_vWorldPos = (model * localPos).xyz;
	
	calculateDirLightDepthMapFragmentPos(v_vWorldPos);
}

