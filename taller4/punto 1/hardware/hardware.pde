import processing.video.*;
Movie movie;
PImage img;
PShape can;
float angle;
int option = 0;

PShader shader;

void setup() {
  size(640, 640, P3D);  
  movie = new Movie(this, "video.mp4");
  movie.play();
  img = movie;
  shader = loadShader("coloredfrag.glsl");
  can = createCan(200, 400, 32, img);
}

void draw() {    
  background(0);

  if (movie.pixels.length != 0) {
    switch (option) {
    case 0:
      shader = loadShader("coloredfrag.glsl");
      break ;
    case 1:
      shader = loadShader("edgesfrag.glsl");      
      break ;
    case 2:
      shader = loadShader("bwfrag.glsl");
      break;    
    }
  }

  shader(shader);
    
  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;  
  println(frameRate);
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
    option = 0;
  } else if (key == 'b') {
    option = 1;
  } else if (key == 'w') {
    option = 2;
  } 
}


void movieEvent(Movie m) {
  m.read();
}
