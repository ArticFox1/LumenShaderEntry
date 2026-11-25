uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

vec3 distortShadowClipPos(vec3 shadowClipPos) {
  float distortionFactor = length(shadowClipPos.xy);
  distortionFactor += 0.1;

  shadowClipPos.xy /= distortionFactor;
  shadowClipPos.z *= 0.5;
  return shadowClipPos;
}

vec3 getShadow(vec3 shadowScreenPos) {
  float transparent = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);
  
  if (transparent == 1) {
    return vec3(1);
  }

  float opaque = step(shadowScreenPos.z, texture(shadowtex1, shadowScreenPos.xy).r);

  if (opaque == 0) {
    return vec3(0);
  }

  vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);

  return shadowColor.rgb * (1 - shadowColor.a);
}