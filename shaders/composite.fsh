#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex2;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	vec4 normal = texture(colortex2,texcoord);
	color = texture(colortex0, texcoord);
	//color = vec4(light);
}