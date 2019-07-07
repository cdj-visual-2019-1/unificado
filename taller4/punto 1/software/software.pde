import processing.video.*;
Movie movie;
PImage newImage;
PShape can;
float angle;
int option = 0;

//Border mask
float[][] maskB = { {-1, -1, -1}, {-1, 8, -1}, {-1, -1, -1} };

//focus mask
float[][] maskF = { { 0, -1, 0}, {-1, 5, -1}, { 0, -1, 0} };


//blur mask
float[][] maskBl = { {1/9.0, 1/9.0, 1/9.0}, {1/9.0, 1/9.0, 1/9.0}, {1/9.0, 1/9.0, 1/9.0} };


void setup() {
  size(640, 640, P3D);

  movie = new Movie(this, "video.mp4");
  movie.loop();

  newImage = createImage(1280, 720, RGB);
}

void draw() {    
  background(0);

  if (movie.pixels.length != 0) {
    switch (option) {
    case 0:
      newImage = movie;
      break ;
    case 1:      
      newImage = applyMatrix(movie, maskB);
      break ;
    case 2:      
      newImage = applyMatrix(movie,maskF);
      break;
    case 3:
      newImage = applyMatrix(movie,maskBl);
      break;
    }
  }
  can = createCan(180, 400, 32, newImage);

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

PImage applyMatrix(PImage image, float[][] mask ) {
  image.loadPixels();
  PImage newImage = new PImage(image.width, image.height, RGB); 

  int maskSize = mask.length;
  for (int x = 0; x < newImage.width; x++) {
    for (int y = 0; y < newImage.height; y++) {
      color c = convolution(x, y, mask, maskSize, image);
      int index = x + (y*newImage.width);      
      newImage.pixels[index] = c;
    }
  }  
  newImage.updatePixels();
  return newImage;
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++) {
    for (int j= 0; j < matrixsize; j++) {
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      
      loc = constrain(loc, 0, img.pixels.length-1);
      
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  
  return color(rtotal, gtotal, btotal);
}

void keyPressed() {
  if (key == 'r') {
    option = 0;
  } else if (key == 'b') {
    option = 1;
  } else if (key == 'f') {
    option = 2;
  } else if (key == 'd') {
    option = 3;
  }
}

void movieEvent(Movie m) {
  m.read();
}
