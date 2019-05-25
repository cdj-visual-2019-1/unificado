import processing.video.*;
PGraphics orig, mod;
Movie original;
PImage gray;
int last;

//Border mask
float[][] masks = { {-1, -1, -1}, {-1,  8, -1}, {-1, -1, -1} };

//focus mask                    
//float[][] masks = { { 0, -1, 0}, {-1, 5, -1}, { 0, -1, 0} };
                    
//blur mask
//float[][] masks = { {1/9.0, 1/9.0, 1/9.0}, {1/9.0, 1/9.0, 1/9.0}, {1/9.0, 1/9.0, 1/9.0} };

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

PImage applyMask(PImage movie, float mask[][]) {
  PImage image = createImage(movie.width, movie.height, RGB);
  image.loadPixels();
  movie.loadPixels();
  
  int maskSize = mask.length;
  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      color c = convolution(x, y, mask, maskSize, movie);
      int index = x + (y*image.width);      
      image.pixels[index] = c;
    }
  }  
  image.updatePixels();
  return image;
}

void setup() {
  size(1200, 500);
  orig = createGraphics(550,400);
  mod = createGraphics(550,400);
  //original = new Movie(this, "/home/dagofonseca/Videos/demo2.mp4");
  original = new Movie(this, "video.mp4"); 
  original.loop();  
}

void draw() { 
  background(150);
  orig.beginDraw();  
  orig.image(original, 0, 0, 550, 400);
  orig.endDraw();
  image(orig, 20, 20); 
  
  mod.beginDraw();
  gray = applyMask(original, masks);  
  mod.image(gray, 0, 0, 550, 400);  
  mod.endDraw();
  image(mod, 590, 20);
  
  fill(0);
  text("FrameRate: " + frameRate , 30, 480); 
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
