// varying
varying vec2 v_vTexCoord;
varying mat3 v_mTBN;
varying vec3 v_vWorldPos;

uniform sampler2D s_RandomRadialOffset;

// view
uniform vec3 u_ViewPos;

// environment
uniform vec3 u_AmbientColor;

// dir light
uniform sampler2D s_DirLightDepth;
uniform vec3 u_DirLightForward;
uniform vec3 u_DirLightColor;
uniform vec2 u_DirLightTextureSize;
uniform vec2 u_DirLightTexelSize;
uniform vec2 u_DirLightNearFarClip;
uniform float u_DirLightShadowBias;
varying vec3 v_vDirLightDepthMapFragmentPos;

float getDirLightValue(vec2 coords)
{
	vec3 distAsColor = texture2D(s_DirLightDepth, coords).rgb;
	float znear = u_DirLightNearFarClip.x;
	float zfar = u_DirLightNearFarClip.y;
	const vec3 undo = vec3(1.0, 256.0, 65536.0) / 16777215.0 * 255.0;
	float dist = dot(distAsColor, undo) * (zfar - znear) + znear;
	return 1.0 - step(u_DirLightShadowBias, v_vDirLightDepthMapFragmentPos.z - dist);
}

float getDirLightValueSmooth()
{
	vec2 ts = u_DirLightTexelSize;
	vec2 offs = ( texture2D( s_RandomRadialOffset, mod(gl_FragCoord.xy, 128.0) * (1.0/128.0) ).xy - 0.5 ) * ts * 1.5;
	vec2 coords = v_vDirLightDepthMapFragmentPos.xy + offs;
	
	float l0 = getDirLightValue( coords );
	float l1 = getDirLightValue( coords + vec2(-ts.x,   0.0) );
	float l2 = getDirLightValue( coords + vec2( ts.x,   0.0) );
	float l3 = getDirLightValue( coords + vec2(  0.0, -ts.y) );
	float l4 = getDirLightValue( coords + vec2(  0.0,  ts.y) );
	return (l0 + l1 + l2 + l3 + l4) * 0.2;
}

float getSpecularValue(float specular, vec3 normal, vec3 eyeNorm)
{
	vec3 reflectDir = reflect(u_DirLightForward, normal);
	float spec = pow(max(dot(-eyeNorm, reflectDir), 0.0), 16.0);
	return specular * 4.0 * spec;
}

void applyRimLight(inout vec3 color, vec3 normal, vec3 rimLightColor, vec3 eyeNorm)
{
	float rimLightPower = 2.0;
	float rimLightIntensity = dot(eyeNorm, -normal);
	rimLightIntensity = 1.0 - rimLightIntensity;
	rimLightIntensity = max(0.0, rimLightIntensity);
	rimLightIntensity = pow(rimLightIntensity, rimLightPower) * 0.4;
	color += rimLightColor * rimLightIntensity;
}

void main()
{
	vec4 de = texture2D( gm_BaseTexture, v_vTexCoord );
	vec4 ns = texture2D( gm_BaseTexture, v_vTexCoord + vec2(0.5, 0.0) );
	
	vec3 diffuse = de.rgb;
	vec3 emission = diffuse * (1.0 - de.a);
	vec3 normal = normalize( v_mTBN * /*normalize*/(ns.rgb * 2.0 - 1.0) );
	float specular = 1.0 - ns.a;
	float light = getDirLightValueSmooth();
	
	vec3 eyeNorm = normalize(v_vWorldPos - u_ViewPos);
	float diffuseValue = max(dot(-normal, u_DirLightForward), 0.0) * light;
	float specularValue = getSpecularValue(specular, normal, eyeNorm);
	vec3 color = diffuse * (u_AmbientColor + u_DirLightColor * (diffuseValue + specularValue)) + emission;
	
	applyRimLight(color, normal, u_AmbientColor, eyeNorm);
	
	gl_FragColor = vec4(color, 1.0);
}

