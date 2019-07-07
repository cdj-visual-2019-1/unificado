varying vec4 vertColor;
varying vec3 cameraDirection;
varying vec3 lightDirectionReflected;

void main() {
  vec3 direction = normalize(lightDirectionReflected);
  vec3 camera = normalize(cameraDirection);
  float intensity = max(0.0, dot(direction, camera));
  gl_FragColor = vec4(intensity, intensity, intensity, 1) * vertColor;
}