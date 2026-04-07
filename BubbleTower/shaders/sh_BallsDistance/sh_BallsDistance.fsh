precision highp float;

varying float v_vDistance;
uniform vec2 u_DirLightNearFarClip;

vec3 distanceToColor(float dist, float znear, float zfar)
{
	float linearDepth = (dist-znear) / (zfar-znear);
	float longDepth = linearDepth * 16777215.0;
	vec3 depthAsColor = vec3(mod(longDepth, 256.0), mod(longDepth/256.0, 256.0), longDepth / 65536.0);
	depthAsColor = floor(depthAsColor);
	return depthAsColor / 255.0;
}

float colorToDistance(vec3 depthAsColor, float znear, float zfar)
{
	const vec3 undo = vec3(1.0, 256.0, 65536.0) / 16777215.0 * 255.0;
	return dot(depthAsColor, undo) * (zfar - znear) + znear;
}

void main()
{
	vec3 distColor = distanceToColor(v_vDistance, u_DirLightNearFarClip.x, u_DirLightNearFarClip.y);
	gl_FragData[0] = vec4(distColor.rgb, 1.0);
}

