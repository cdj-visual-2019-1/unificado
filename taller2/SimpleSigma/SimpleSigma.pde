// Sigma Motion
// https://michaelbach.de/ot/mot-sigma/index.html

int rate, squares, squareLength, theFrames, widthRec, heightRec;

void setup() {
  squares = 150;
  squareLength = 120;
  rate = 2;
  theFrames = 60;
  
  size(1000, 500);
  background(255);
  frameRate(theFrames);
  widthRec = 100;
  heightRec = 100;
}

void draw() {
  background(255);
  fill(0);
  text("SIMPLE SIGMA", 450, 30);
  text("With the arrow (UP, DOWN, LEFT, RIGHT) you can rezize the rectangles", 60, 60);
  text("With the keys + and - you can control the velocity", 60, 80);
  
  if (frameCount % rate < (rate / 2)) interchange(squares / 4, squareLength, true);  
  else interchange(squares / 4, squareLength, false);
  
  if (keyPressed) {
    if (key == '+') rate += 2;
    else if (key == '-') rate = rate > 2 ? rate - 2 : rate;
    
    if (keyCode == LEFT) widthRec++;
    else if (keyCode == RIGHT) widthRec = widthRec > 1 ? widthRec - 1 : widthRec;

    if (keyCode == UP) heightRec = heightRec > 10 ? heightRec - 1 : heightRec;
    else if (keyCode == DOWN) heightRec = heightRec < 350 ? heightRec + 1: heightRec;
  }
  
  
}

void interchange(int n, int length, boolean invert) {
  int x, y;
  for (int i = 0; i * widthRec + 30 <= 970 - widthRec; i++) {
    fillColor(invert, i);
    x = 30 + i * widthRec;
    y = 100;
    noStroke();
    rect(x, y, widthRec, heightRec);
  } 
}

void fillColor(boolean invert, int i) {
  if (invert) {
    if (i % 2 == 0) fill(0);
    else fill(255);
  } else {
    if (i % 2 == 0) fill(255);
    else fill(0);
  }
}
