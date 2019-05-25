import processing.video.*;
PGraphics orig, mod;
Movie original;
PImage gray;

PImage convertTogray(PImage movie){
  PImage grayMovie = createImage(movie.width, movie.height, RGB);
  grayMovie.loadPixels();
  movie.loadPixels();
  float red, blue, green, sum;
  int dimension = movie.width * movie.height;
  for(int i = 0; i < dimension; i+=1){
    red = red(movie.pixels[i]);
    blue = blue(movie.pixels[i]);
    green = green(movie.pixels[i]);
    sum = 0.2126*red +  0.7152*green + 0.0722*blue;     
    grayMovie.pixels[i] = color(sum);    
  }
  grayMovie.updatePixels();
  return grayMovie;
}

void setup() {
  size(1200, 500);
  orig = createGraphics(550,400);
  mod = createGraphics(550,400);
  original = new Movie(this, "video.mp4");  
  original.loop();  
}

void draw() {  
  orig.beginDraw();  
  orig.image(original, 0, 0, 550, 400);
  orig.endDraw();
  image(orig, 20, 20);
  
  mod.beginDraw();
  gray = convertTogray(original);  
  mod.image(gray, 0, 0, 550, 400);
  mod.endDraw();
  image(mod, 590, 20);
  println("FrameRate: " + frameRate +"   FrameCount: " + frameCount); 
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
