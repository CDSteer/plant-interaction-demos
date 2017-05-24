//Cameron Steer

import processing.opengl.*;

import java.util.ArrayList;
import java.util.List;

PImage sunflower, cloud;

int rainNum = 50;
//ArrayList rain = new ArrayList();
List<Rain> rain = new ArrayList<Rain>(50);
ArrayList splash = new ArrayList();
float current;
float reseed = random(0,.2);

// Globals
int g_winW = 1000;   // Window Width
int g_winH = 700;   // Window Height

float x, y;
float waterLvl, waterLvl2, waterLvl3;
boolean isCollision = false;

float sunflowerAX, sunflowerAY;
float sunflowerBX, sunflowerBY;
float sunflowerCX, sunflowerCY;


void setup() {
  size(g_winW, g_winH, P3D);
  cloud = loadImage("rec/cloud.png");
  sunflower = loadImage("rec/sunflower.png");
  x =  g_winW/2;
  y =  10;
  noStroke();
  sunflowerAX = 100; 
  sunflowerAY = 550;
  
  sunflowerBX = 400; 
  sunflowerBY = 550;
  
  sunflowerCX = 750; 
  sunflowerCY = 550;

  colorMode(RGB,100);
  background(0);
  rain.add(new Rain(x, y));
  current = millis();
}

void draw(){
  background(0);
  blur(50);
  image(cloud, x, y);
  image(sunflower, sunflowerAX, sunflowerAY);
  image(sunflower, sunflowerBX, sunflowerBY);
  image(sunflower, sunflowerCX, sunflowerCY);

  if ((millis()-current)/1000>reseed&&rain.size()<150) {
    rain.add(new Rain(x,y));
    reseed = random(0,.2);
    current = millis();
  }

  for (int i=0 ; i<rain.size() ; i++) {
    Rain rainT = (Rain)rain.get(i);
    rainT.calculate();
    rainT.draw();
    if (rainT.position.y>height) {
      for (int k = 0 ; k<random(5,10); k++) {
        splash.add(new Splash(rainT.position.x,height));
      }
      rain.remove(i);
      float rand = random(0,100);
      if (rand>10&&rain.size()<150)
      rain.add(new Rain(x,y));
    }
  }

  fill(255, 255, 255);
  rect(70, 700, 20, -155);
  rect(350, 700, 20, -155);
  rect(700, 700, 20, -155);

  for (Rain rainT : rain) {
    if (rainT.position.y > 540){
      isCollision = isCollidingCircleRectangle(rainT.position.x, rainT.position.y, 5, sunflowerAX, sunflowerAY, 116.0, 149.0);
      if (isCollision == true){
        if (waterLvl >= -155){
          waterLvl = waterLvl - .4;
        }
      }
      if (waterLvl > -155){
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(70, 700, 20, waterLvl);
      
      isCollision = isCollidingCircleRectangle(rainT.position.x, rainT.position.y, 5, sunflowerBX, sunflowerBY, 116.0, 149.0);
      if (isCollision == true){
        if (waterLvl2 >= -155){
          waterLvl2 = waterLvl2 - .4;
        }
      }
      if (waterLvl2 > -155){
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(350, 700, 20, waterLvl2);
      
      isCollision = isCollidingCircleRectangle(rainT.position.x, rainT.position.y, 5, sunflowerCX, sunflowerCY, 116.0, 149.0);
      if (isCollision == true){
        if (waterLvl3 >= -155){
          waterLvl3 = waterLvl3 - .4;
        }
      }
      if (waterLvl3 > -155){
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(700, 700, 20, waterLvl3);
    }
  }
  

  if (waterLvl <= 0){
    waterLvl = waterLvl + .2;
  }
  if (waterLvl2 <= 0){
    waterLvl2 = waterLvl2 + .2;
  }
  if (waterLvl3 <= 0){
    waterLvl3 = waterLvl3 + .2;
  }

  for (int i=0 ; i<splash.size() ; i++){
    Splash spl = (Splash) splash.get(i);
    spl.calculate();
    spl.draw();
    if (spl.position.y>height)
    splash.remove(i);
  }

  strokeWeight(1);
  fill(255, 255, 255);

}

void blur(float trans) {
  noStroke();
  fill(0,trans);
  rect(0,0,width,height);
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

void keyPressed(){
  switch (keyCode) {
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

