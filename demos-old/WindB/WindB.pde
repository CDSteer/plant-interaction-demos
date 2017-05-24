//Cameron Steer
import processing.opengl.*;

import java.util.ArrayList;
import java.util.List;

int delay;

// Globals
int g_winW             = 1000;   // Window Width
int g_winH             = 700;   // Window Height

float x, y;
float waterLvl;
boolean isCollision = false;

int oldXAccel, oldYAccel;
int xAccel, yAccel, zAccel, vRef, xRate, yRate;

List<Particle> particle = new ArrayList<Particle>(5);
float current;
float reseed = random(0,.2);
int gapX, gapY;

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


  for (int i=0 ; i< particle.size() ; i++) {
    gapX = int(random(1, g_winW));
    gapY = int(random(1, g_winH));
    Particle particleT = (Particle)particle.get(i);
    particleT.calculate((gapX), (gapY));
    particleT.draw();
  }
  
  for (int i=0 ; i< particle.size() ; i++) {
    Particle particleT = (Particle)particle.get(i);
    particleT.live();
    if (particleT.isAlive() == false){
      particle.remove(i);
    }
  }
  
  System.out.println(mouseX +", "+ mouseY);
  delay++;
  
//  if (delay == 50){
//    if (mouseX == pmouseX && mouseY == pmouseY){
//      particle.clear();
//    }
//    delay = 0;
//  }
}


void blur(float trans) {
  noStroke();
  fill(0,trans);
  rect(0,0,width,height);
}

void mouseMoved() {
  x = x - 5;
  x = x + 5;
  y++;
  y--;
  particle.add(new Particle(x,y));
}


boolean isCollidingCircleRectangle(
      float circleX,
      float circleY,
      float radius,
      float rectangleX,
      float rectangleY,
      float rectangleWidth,
      float rectangleHeight) {

  float circleDistanceX = abs(circleX - rectangleX - rectangleWidth/2);
  float circleDistanceY = abs(circleY - rectangleY - rectangleHeight/2);

  if (circleDistanceX > (rectangleWidth/2 + radius)) { return false; }
  if (circleDistanceY > (rectangleHeight/2 + radius)) { return false; }

  if (circleDistanceX <= (rectangleWidth/2)) { return true; }
  if (circleDistanceY <= (rectangleHeight/2)) { return true; }

  float cornerDistance_sq = pow(circleDistanceX - rectangleWidth/2, 2) +
                       pow(circleDistanceY - rectangleHeight/2, 2);

  return (cornerDistance_sq <= pow(radius,2));
}