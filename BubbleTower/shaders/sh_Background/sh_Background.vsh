attribute vec3 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;

void main()
{
	vec3 pos = in_Position * 1000.0;
	vec4 localPos = vec4( pos.x, pos.y, pos.z, 1.0);
	
	mat4 wvm = gm_Matrices[MATRIX_WORLD_VIEW];
	
	// Remove translation data.
	wvm[3][0] = 0.0;
	wvm[3][1] = 0.0;
	wvm[3][2] = 0.0;
	
	gl_Position = gm_Matrices[MATRIX_PROJECTION] * wvm * localPos;
	v_vTexcoord = in_TextureCoord;
}

