varying vec2 v_vTexcoord;

void main()
{
	gl_FragData[0] = texture2D( gm_BaseTexture, v_vTexcoord );
}

