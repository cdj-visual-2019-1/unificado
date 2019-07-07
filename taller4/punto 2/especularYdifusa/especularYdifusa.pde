PShape can;
float angle;
int x = width, y= 0;

PShader lightShader;

void setup() {
  size(640, 360, P3D);
  can = createCan(100, 200, 32);
  lightShader = loadShader("frag.glsl", "vert.glsl");
}

void draw() {    
  background(0);

  shader(lightShader);

  pointLight(255, 255, 255, x, y, 200);  

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
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
  if (key == 'w') {
    x += 10;
  } else if(key == 'q'){
    x -=10;
  }
  
  if (key == 'p') {
    y += 10;
  } else if(key == 'o'){
    y -=10;
  }  
  
}
