#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D shadowtex0;

in vec2 texcoord;

layout(location = 0) out vec4 color;

void main() {
  //color = texture(shadowtex0, texcoord); return;
  color = texture(colortex0, texcoord);
  color.rgb = pow(color.rgb, vec3(0.454545454545454545));
}