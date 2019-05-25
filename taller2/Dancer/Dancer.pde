PImage dancer, background;

void setup()
{
  size(1024,800);
  dancer = loadImage("dancer.png"); 
  background = loadImage("background.png"); 
  fill(0,250,0);
}

void draw()
{
  background(255);
  image(background, 0, 0);
  image(dancer, mouseX, 0);  
}
