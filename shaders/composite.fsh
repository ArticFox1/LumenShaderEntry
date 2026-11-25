#version 330 compatibility

#include "lib/common.glsl"

uniform vec3 shadowLightPosition;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;

uniform float viewWidth;
uniform float viewHeight;

in vec2 texcoord;

 /*
 const int colortex0Format = RGB16;
 */

const vec3 BlockLightColor = vec3(1.0);
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

	vec3 screenPos = vec3(texcoord.xy, depth);
	vec3 ndcPos = screenPos * 2.0 - 1.0; // normalized device coordinates (NDC); [-1.0, 1.0]
	vec3 viewPos = projectAndDivide(gbufferProjectionInverse, ndcPos); // position in view space
	vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz; // position relative to the feet of the player
	vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
	vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
	shadowClipPos.z -= 0.001;
	shadowClipPos.xyz = distortShadowClipPos(shadowClipPos.xyz);
	vec3 shadowNdcPos = shadowClipPos.xyz / shadowClipPos.w;
	vec3 shadowScreenPos = shadowNdcPos * 0.5 + 0.5;

	vec3 shadow = getShadow(shadowScreenPos);

	vec3 blocklight = light.r * BlockLightColor;
	vec3 skylight = light.g * SkyLightColor;
	vec3 sunlight = mix(SunLightColor,ShadowLightColor,(dot(sunPos,normal)-1)*-0.5*(1-shadow));
	color.rgb *= blocklight + skylight + sunlight + Ambient;
}