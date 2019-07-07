PImage normalImg, img;
PShape can;
float angle;

int selectImage = 2;

PShader texShader;

void setup() {
  size(700, 700, P3D);  
  normalImg = loadImage("brickwall_normal.jpg");
  img = loadImage("brickwall.jpg");
  texShader = loadShader("frag.glsl", "vert.glsl");
}

void draw() {    
  background(0); 
  switch (selectImage) {
    case 1:
      resetShader();
      can = createCan(150, 300, 32, img);
      pointLight(255, 255, 255, width/2, height/2, 20);
      break;
    case 2:
      can = createCan(150, 300, 32, img);
      texShader.set("normalMap", normalImg);
      shader(texShader);
      pointLight(255, 255, 255, width/2, height/2, 200);
      break;
  }
   

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape(); 
  return sh;
}

void keyPressed() {
  if (key == 'r') {
    selectImage = 1;
  } else if (key == 'a') {
    selectImage = 2;
  }
}
