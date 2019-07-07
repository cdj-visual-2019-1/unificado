#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  vec4 col = texture2D(texture, vertTexCoord.st);
  gl_FragColor = col;
  
}