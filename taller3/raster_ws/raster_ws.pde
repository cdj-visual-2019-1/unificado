import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean antiAlia = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = JAVA2D;

// 4. Window dimension
int dim = 9;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);  
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();  
  popStyle();
  popMatrix();
  
}


float edgeFunction(Vector a, Vector b, Vector c) {
  return (c.y() - a.y()) * (b.x() - a.x()) - (c.x() - a.x()) * (b.y() - a.y());
}

boolean arePositive(float a, float b, float c) {
  return Float.compare(a, 0) >= 0 && Float.compare(b, 0) >= 0 && Float.compare(c, 0) >= 0;
}

boolean areNegative(float a, float b, float c) {
  return Float.compare(a, 0) <= 0 && Float.compare(b, 0) <= 0 && Float.compare(c, 0) <= 0;
}

int antiAlising(Vector p, int reposition, boolean positive){  
  int subPixelsInTriangle = 0;
  int delta = reposition/4;
  Vector leftTop = new Vector(p.x()-delta, p.y()-delta);
  Vector leftBottom = new Vector(p.x()-delta, p.y()+delta);
  Vector rightTop = new Vector(p.x()+delta, p.y()-delta);
  Vector rightBottom = new Vector(p.x()+delta, p.y()+delta);  
  
  float w0leftTop = edgeFunction(v1, v2, leftTop);
  float w1leftTop = edgeFunction(v2, v3, leftTop);
  float w2leftTop = edgeFunction(v3, v1, leftTop);
  
  float w0leftBottom = edgeFunction(v1, v2, leftBottom);
  float w1leftBottom = edgeFunction(v2, v3, leftBottom);
  float w2leftBottom = edgeFunction(v3, v1, leftBottom);
  
  float w0rightTop = edgeFunction(v1, v2, rightTop);
  float w1rightTop = edgeFunction(v2, v3, rightTop);
  float w2rightTop = edgeFunction(v3, v1, rightTop);
  
  float w0rightBottom = edgeFunction(v1, v2, rightBottom);
  float w1rightBottom = edgeFunction(v2, v3, rightBottom);
  float w2rightBottom = edgeFunction(v3, v1, rightBottom);
  if(positive){
    if(arePositive(w0leftTop,w1leftTop,w2leftTop)){
     subPixelsInTriangle += 1.0;
    }
    if(arePositive(w0leftBottom,w1leftBottom,w2leftBottom)){
     subPixelsInTriangle += 1.0;
    }
    if(arePositive(w0rightTop,w1rightTop,w2rightTop)){
     subPixelsInTriangle += 1.0;
    }
    if(arePositive(w0rightBottom,w1rightBottom,w2rightBottom)){
     subPixelsInTriangle += 1.0;
    } 
  }else{
    if(areNegative(w0leftTop,w1leftTop,w2leftTop)){
     subPixelsInTriangle += 1.0;
    }
    if(areNegative(w0leftBottom,w1leftBottom,w2leftBottom)){
     subPixelsInTriangle += 1.0;
    }
    if(areNegative(w0rightTop,w1rightTop,w2rightTop)){
     subPixelsInTriangle += 1.0;
    }
    if(areNegative(w0rightBottom,w1rightBottom,w2rightBottom)){
     subPixelsInTriangle += 1.0;
    }
  }
  
  return subPixelsInTriangle*64;
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  if (debug) {
    final int INIT = -int(pow(2, n)) / 2;
    final int LIMIT = -INIT;    
    final int reposition = (width / (2 * LIMIT));    
    final float area = edgeFunction(v1, v2, v3); 
    //println(area);
    float w0, w1, w2, r, g , b, alpha;
    Vector p;
    for (int i = INIT; i < LIMIT; i++) {      
      for (int j = INIT; j < LIMIT; j++) {
        p = new Vector(reposition * (i + 0.5), reposition * (j + 0.5));
        
        w0 = edgeFunction(v1, v2, p);
        w1 = edgeFunction(v2, v3, p);
        w2 = edgeFunction(v3, v1, p);
        
        alpha = antiAlising(p,reposition,arePositive(w0, w1, w2));
        
        if (arePositive(w0, w1, w2) || areNegative(w0, w1, w2)) {  
          
          r = 255 * (w0 / area);
          g = 255 * (w1 / area);
          b = 255 * (w2 / area);
          pushStyle();          
          stroke(255, 255, 0, 0);
          if(antiAlia)
            fill(r, g, b, alpha);
          else
            fill(r, g, b);
          square(i, j, 1);          
          popStyle();
        }
      }
    }
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == 'a')
    antiAlia = !antiAlia;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
