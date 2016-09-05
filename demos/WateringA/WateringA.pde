// Maurice Ribble
// 6-28-2009
// http://www.glacialwanderer.com/hobbyrobotics

// This takes data off the serial port and graphs it.
// There is an option to log this data to a file.

// I wrote an arduino app that sends data in the format expected by this app.
// The arduino app sends accelerometer and gyroscope data.

//Edited by Cameron Steer

import processing.serial.*;
import processing.opengl.*;

import java.util.ArrayList;
import java.util.List;

boolean cali = true;
int caliX1, caliX2, caliY1, caliY2;

PImage sunflower, cloud;

int rainNum = 50;
//ArrayList rain = new ArrayList();
List<Rain> rain = new ArrayList<Rain>(50);
ArrayList splash = new ArrayList();
float current;
float reseed = random(0,.2);

// Globals
int g_winW             = 1000;   // Window Width
int g_winH             = 700;   // Window Height
boolean g_dumpToFile   = true;  // Dumps data to c:\\output.txt in a comma seperated format (easy to import into Excel)
boolean g_enableFilter = true;  // Enables simple filter to help smooth out data.

cDataArray g_xAccel    = new cDataArray(200);
cDataArray g_yAccel    = new cDataArray(200);
cDataArray g_zAccel    = new cDataArray(200);
cDataArray g_vRef      = new cDataArray(200);
cDataArray g_xRate     = new cDataArray(200);
cDataArray g_yRate     = new cDataArray(200);
cGraph g_graph         = new cGraph(10, 190, 800, 400);
Serial g_serial;
PFont  g_font;

float x, y;
float waterLvl, waterLvl2, waterLvl3;
boolean isCollision = false;

float sunflowerAX, sunflowerAY;
float sunflowerBX, sunflowerBY;
float sunflowerCX, sunflowerCY;

int oldXAccel, oldYAccel;
int xAccel, yAccel, zAccel, vRef, xRate, yRate;

void setup() {
  size(1000, 700, P3D);
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
  println(Serial.list());
  g_serial = new Serial(this, "/dev/tty.usbmodem1411", 115200, 'N', 8, 1.0);
  g_font = loadFont("ArialMT-20.vlw");
  textFont(g_font, 20);

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

  if (xAccel < caliX1 && xAccel < caliX2){
    x = x - 5;
  } else if (xAccel > caliX1 && xAccel > caliX2) {
    x = x + 5;
  }

//  if (yAccel < 330 && yAccel < 331){
//    y++;
//  } else if (yAccel > 330 && yAccel > 331) {
//    y--;
//  }

  // We need to read in all the avilable data so graphing doesn't lag behind
  while (g_serial.available() >= 2*6+2) {
    processSerialData();
  }

  strokeWeight(1);
  fill(255, 255, 255);
//  g_graph.drawGraphBox();
//
//  strokeWeight(1.5);
//  stroke(255, 0, 0);
//  g_graph.drawLine(g_xAccel, 0, 1024);
//  stroke(0, 255, 0);
//  g_graph.drawLine(g_yAccel, 0, 1024);
//  stroke(0, 0, 255);
//  g_graph.drawLine(g_zAccel, 0, 1024);
//  stroke(255, 255, 0);
//  g_graph.drawLine(g_vRef, 0, 1024);
//  stroke(255, 0, 255);
//  g_graph.drawLine(g_xRate, 0, 1024);
//  stroke(0, 255, 255);
//  g_graph.drawLine(g_yRate, 0, 1024);
}

// This reads in one set of the data from the serial port
void processSerialData() {
  int inByte = 0;
  int curMatchPos = 0;
  int[] intBuf = new int[2];

  intBuf[0] = 0xAD;
  intBuf[1] = 0xDE;

  while (g_serial.available() < 2); // Loop until we have enough bytes
  inByte = g_serial.read();

  // This while look looks for two bytes sent by the client 0xDEAD
  // This allows us to resync the server and client if they ever
  // loose sync.  In my testing I haven't seen them loose sync so
  // this could be removed if you need to, but it is a good way to
  // prevent catastrophic failure.
  while(curMatchPos < 2) {
    if (inByte == intBuf[curMatchPos]) {
      ++curMatchPos;
      if (curMatchPos == 2)
        break;
      while (g_serial.available() < 2); // Loop until we have enough bytes
      inByte = g_serial.read();
    } else {
      if (curMatchPos == 0) {
        while (g_serial.available() < 2); // Loop until we have enough bytes
        inByte = g_serial.read();
      } else {
        curMatchPos = 0;
      }
    }
  }

  while (g_serial.available() < 2*6);  // Loop until we have a full set of data
  // This reads in one set of data
  {
    byte[] inBuf = new byte[2];

    oldXAccel = xAccel;
    oldYAccel = yAccel;

    g_serial.readBytes(inBuf);
    // Had to do some type conversion since Java doesn't support unsigned bytes
    xAccel = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    yAccel = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    zAccel = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    vRef   = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    xRate  = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    yRate  = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);

    System.out.println("X: " + xAccel + " Y: " + yAccel + " Z: " + zAccel);
    if (cali == true){
      caliX1 = xAccel;
      caliX2 = xAccel+1; 
      caliY1 = yAccel;
      caliY2 = yAccel+1;
      cali = false;
      System.out.println(caliX1 + ", "+ caliY1);
    }
  }
}

// This class helps mangage the arrays of data I need to keep around for graphing.
class cDataArray {
  float[] m_data;
  int m_maxSize;
  int m_startIndex = 0;
  int m_endIndex = 0;
  int m_curSize;

  cDataArray(int maxSize) {
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }

  void addVal(float val) {

    if (g_enableFilter && (m_curSize != 0)) {
      int indx;

      if (m_endIndex == 0)
        indx = m_maxSize-1;
      else
        indx = m_endIndex - 1;

      m_data[m_endIndex] = getVal(indx)*.5 + val*.5;
    } else {
      m_data[m_endIndex] = val;
    }

    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }

  float getVal(int index) {
    return m_data[(m_startIndex+index)%m_maxSize];
  }

  int getCurSize() {
    return m_curSize;
  }

  int getMaxSize() {
    return m_maxSize;
  }
}

void blur(float trans) {
  noStroke();
  fill(0,trans);
  rect(0,0,width,height);
}

// This class takes the data and helps graph it
class cGraph {
  float m_gWidth, m_gHeight;
  float m_gLeft, m_gBottom, m_gRight, m_gTop;

  cGraph(float x, float y, float w, float h) {
    m_gWidth     = w;
    m_gHeight    = h;
    m_gLeft      = x;
    m_gBottom    = g_winH - y;
    m_gRight     = x + w;
    m_gTop       = g_winH - y - h;
  }

  void drawGraphBox() {
    stroke(0, 0, 0);
    rectMode(CORNERS);
    rect(m_gLeft, m_gBottom, m_gRight, m_gTop);
  }

  void drawLine(cDataArray data, float minRange, float maxRange) {
    float graphMultX = m_gWidth/data.getMaxSize();
    float graphMultY = m_gHeight/(maxRange-minRange);

    for(int i=0; i<data.getCurSize()-1; ++i) {
      float x0 = i*graphMultX+m_gLeft;
      float y0 = m_gBottom-((data.getVal(i)-minRange)*graphMultY);
      float x1 = (i+1)*graphMultX+m_gLeft;
      float y1 = m_gBottom-((data.getVal(i+1)-minRange)*graphMultY);
      line(x0, y0, x1, y1);
    }
  }
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