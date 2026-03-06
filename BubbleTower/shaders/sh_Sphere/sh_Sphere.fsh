varying vec2 v_vTexcoord;

uniform vec4 u_Color;

void main()
{
	gl_FragColor = texture2D( gm_BaseTexture, v_vTexcoord ) * u_Color;
}

/*
	vec2 coord = gl_PointCoord - vec2(0.5);
    if (length(coord) > 0.5) {
        discard; // Make the corners transparent
    }
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red circle
*/

