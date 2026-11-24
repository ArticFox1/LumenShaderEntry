#version 330 compatibility

uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;

in vec2 texcoord;

 /*
 const int colortex0Format = RGB16;
 */

const vec3 BlockLightColor = vec3(1.0, 0.5, 0.08);
const vec3 SkyLightColor = vec3(0.05, 0.15, 0.3);
const vec3 SunLightColor = vec3(1);
const vec3 ShadowLightColor = vec3(0.2,0.1,0.4);
const vec3 Ambient = vec3(0.1);

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	vec2 light = texture(colortex1,texcoord).rg;
	vec3 normal = texture(colortex2,texcoord).rgb * 2 - 1;
	vec3 sunPos = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);

	color = texture(colortex0, texcoord);
	color.rgb = pow(color.rgb, vec3(2.2));

	vec3 depth = texture(depthtex0,texcoord).rgb;
	if (depth.r == 1) return;

	vec3 blocklight = light.r * BlockLightColor;
	vec3 skylight = light.g * SkyLightColor;
	vec3 sunlight = mix(SunLightColor,ShadowLightColor,(dot(sunPos,normal)-1)*-0.5);
	color.rgb *= blocklight + skylight + sunlight + Ambient;
}