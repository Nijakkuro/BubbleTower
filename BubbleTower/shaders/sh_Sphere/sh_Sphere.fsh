varying vec2 v_vTexcoord;

uniform vec4 u_Color;

void main()
{
	gl_FragColor = texture2D( gm_BaseTexture, v_vTexcoord ) * u_Color;
}

