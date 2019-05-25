boolean mouse = false;

void setup(){
  size(700, 400);  
}

void draw(){
  background(255);  
  stroke(0);
  rect(0, 50, 699, 300);
  drawLines(mouse);
  strokeWeight(4);
  stroke(255,0,0);
  line(0, height/2 - 40, width, height/2 - 40);
  line(0, height/2 + 40, width, height/2 + 40);
}

void drawLines(boolean isMouse){
  if (!isMouse){
    strokeWeight(1);
    stroke(0);
    line(0, 50, width, 350);
    line(width, 50, 0, 350);
    line(width/2, 50, width/2, 350);
    line(width/2 + 50, 50, width/2 - 50, 350);
    line(width/2 - 50, 50, width/2 + 50, 350);  
    line(width/2 + 150, 50, width/2 - 150, 350);
    line(width/2 - 150, 50, width/2 + 150, 350);  
    line(width/2 + 250, 50, width/2 - 250, 350);
    line(width/2 - 250, 50, width/2 + 250, 350);  
    line(0, 100, width, 300);
    line(0, 300, width, 100);
    line(0, height/2 - 40, width, height/2 + 40);
    line(0, height/2 + 40, width, height/2 - 40);
  }  
}

void mouseClicked(){
  mouse = !mouse;
}
