float angle = PI/180.0;
import controlP5.*;

ControlP5 cp5;
PGraphics pg;
int tra = 8;

void setup(){
  size(700,700);
  pg = createGraphics(700, 700); 
  cp5 = new ControlP5(this);
  cp5.addSlider("tra").setPosition(10,10).setRange(0,12);
}

void draw(){
  pg.beginDraw();
  pg.background(255);
  pg.translate(width/2, height/2);
  
  pg.rotate(angle);
    
  for (int i=0; i < 8; i++){
    pg.fill(0);
    pg.circle(0, 0, 100);
    pg.translate(tra,tra);
    pg.fill(100);
    pg.circle(0, 0, 100);
    pg.translate(tra,tra);
    pg.fill(170);
    pg.circle(0, 0, 100);
  }
  pg.endDraw();
  image(pg, 0, 0); 
  angle += 0.01;
  
}
