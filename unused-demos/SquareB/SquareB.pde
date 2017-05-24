// Cameron Steer

import processing.opengl.*;

// Globals
int g_winW             = 1000;   // Window Width
int g_winH             = 700;   // Window Height
float x, y;

void setup() {
  size(g_winW, g_winH, P3D);
  x =  g_winW/2;
  y =  10;
  noStroke();
  colorMode(RGB,100);
  background(0);
}

void draw(){
  background(0);
  blur(50);
  fill(255, 255, 255);
  rect(x, y, 100, 100);
}

void blur(float trans) {
  noStroke();
  fill(0,trans);
  rect(0,0,width,height);
}

void keyPressed(){
  switch (keyCode) {
    case UP:
      y = y - 20;
      break;
    case DOWN:
      y = y + 20;
      break; 
    case LEFT:
      x = x - 20;
      break;
    case RIGHT:
      x = x + 20;
      break; 
    default: 
      break;
  }
}
