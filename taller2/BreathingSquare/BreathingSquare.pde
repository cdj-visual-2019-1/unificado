import controlP5.*;

ControlP5 cp5;
PGraphics pg;
int slider = 255;
float increment = 0.02;
float angle = PI/180.0;


void setup() {
  size(600, 600);
  noStroke();
  rectMode(CENTER);
  pg = createGraphics(600, 600);  
  cp5 = new ControlP5(this);
  cp5.addSlider("slider").setPosition(10,10).setRange(0,255);
  cp5.addSlider("increment").setPosition(10,60).setRange(0.0,0.05);
}

void draw() {
  //logic for central square
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.background(250);
  pg.fill(0,0,255);
  pg.translate(pg.width/2, pg.height/2);
  pg.rotate(angle);  
  pg.rect(0, 0, 350, 350);
  pg.endDraw();
  image(pg, 0, 0);   
  angle += increment;
  if (angle > 180.0){
    angle = PI/180.0;
  }
  
  //corner squares
  color c = color(255, 204, 0, slider);
  fill(c);  
  rect(0, 0, 550, 550);    
  rect(width, 0, 550, 550);
  rect(0, height, 550, 550);
  rect(width, height, 550, 550);
}
