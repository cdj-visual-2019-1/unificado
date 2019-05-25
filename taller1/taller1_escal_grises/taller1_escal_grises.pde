PGraphics original, segmentada, luma, histograma;
PImage photo, photoGray, photoLuma;
int heightImg, mX, mY, mX2, mY2, clickState;
int[] hist;

PImage grayScale(PImage original, Boolean luma){
  PImage image = createImage(original.width, original.height, RGB);
  original.loadPixels();
  image.loadPixels();
  float red, blue, green, sum, coefRed, coefGreen, coefBlue;  
  int dimension = image.width * image.height;
  if(luma) {
    coefRed = 0.2126;
    coefGreen = 0.7152;
    coefBlue = 0.0722;
  }
  else {
    coefRed = coefGreen = coefBlue = 1.0/3.0; 
  }
  for(int i = 0; i < dimension; i+=1){
    red = red(original.pixels[i]);
    blue = blue(original.pixels[i]);
    green = green(original.pixels[i]);
    sum = coefRed*red + coefGreen*green + coefBlue*blue;     
    image.pixels[i] = color(sum);    
  }
  image.updatePixels();
  return image;
}

int[] createHistogram(PImage image){  
  image.loadPixels();  
  int[] hist = new int[256];  
  int dimension = image.width * image.height;
  
  for(int i = 0; i < dimension; i+=1){       
    int bright = int(brightness(image.pixels[i]));    
    hist[bright] += 1;
  }
  return hist;
}

void drawHistogram(int[] hist, PGraphics frame){
  int histMax = max(hist);
  for (int i = 0; i < frame.width; i += 1) {    
    int which = int(map(i, 0, frame.width, 0, 255)); 
    int y = int(map(hist[which], 0, histMax, frame.height, 0));    
    if(clickState != 0 && isWithinHisto(i)){
      frame.stroke(150);
    } else {
      frame.stroke(255);
    }
    frame.line(i, frame.height, i, y);
  }
}

boolean isWithinHisto(int line){
  if(mX >= 20+line && mX2 <= 20+line && mY > 60+heightImg && mY < 60+2*heightImg 
  || mX <= 20+line && mX2 >= 20+line &&  mY > 60+heightImg && mY < 60+2*heightImg){
    return true;
  }
  return false;
}

void segment(PImage image){
  int dimension = image.width * image.height;
  if(clickState!=0){
    image.loadPixels();     
    for(int i = 0; i < dimension; i+=1){
      int a = int(map(mX - 20, 0, image.width, 0, 255));
      int b = int(map(mX2 - 20, 0, image.width, 0, 255));
      int bright = int(brightness(image.pixels[i]));      
      if(!(bright >= a && bright <= b || bright <= a && bright >= b)){
        image.pixels[i]=color(255);
      }
    } 
  }
}

void setup() {
  size(1040, 650);
  background(20);
  textSize(30);
  photo = loadImage("landscape.jpg");
  //photo = loadImage("mandrill.png");
  //photo = loadImage("lenna.png");  
  //photo = loadImage("cowboys.jpg");
  photo.resize(490,275);
  heightImg = photo.height;
  original = createGraphics(490, heightImg);
  luma = createGraphics(490, heightImg);
  histograma = createGraphics(490, heightImg);
  segmentada = createGraphics(490, heightImg);  
  
  original.beginDraw();
  original.background(170);
  original.image(photo, 0, 0);
  original.endDraw();
    
  luma.beginDraw();
  photoLuma = grayScale(photo, true ); 
  luma.image(photoLuma, 0, 0);
  luma.endDraw(); 
  
  hist = createHistogram(photoLuma);
 
}

void draw() {
  text("Original", 20, 30);
  image(original, 20, 40);
  text("Luma", 530, 30);  
  image(luma, 530, 40); 
  
  histograma.beginDraw();  
  drawHistogram(createHistogram(photoLuma), histograma);
  histograma.endDraw();
  image(histograma, 20, 60+heightImg); 
    
  photoGray = grayScale(photo, true );
  segmentada.beginDraw();  
  segment(photoGray);
  segmentada.image(photoGray, 0, 0);
  segmentada.endDraw();
  
  image(segmentada, 530, 60+heightImg);
   
  
}

void mouseMoved() {  
  if (clickState == 1) {
    mX2 = mouseX;
    mY2 = mouseY;       
  }
}
void mouseClicked() {
  if(clickState == 0){
    mX = mouseX;
    mY = mouseY;    
    clickState = 1;  
  }else if(clickState == 1){
    mX2 = mouseX;
    mY2 = mouseY;
    clickState = 2;
  }
  else{   
    clickState = 0;
  }
}
