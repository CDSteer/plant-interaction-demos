import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import processing.opengl.*; 
import java.util.ArrayList; 
import java.util.List; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Wind extends PApplet {

// Maurice Ribble
// 6-28-2009
// http://www.glacialwanderer.com/hobbyrobotics

// This takes data off the serial port and graphs it.
// There is an option to log this data to a file.

// I wrote an arduino app that sends data in the format expected by this app.
// The arduino app sends accelerometer and gyroscope data.

//Edited by Cameron Steer







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
float waterLvl;
boolean isCollision = false;

int oldXAccel, oldYAccel;
int xAccel, yAccel, zAccel, vRef, xRate, yRate;

List<Particle> particle = new ArrayList<Particle>(50);
float current;
float reseed = random(0,.2f);

public void setup() {
  size(g_winW, g_winH, P3D);
  x =  g_winW/2;
  y =  10;
  noStroke();
  println(Serial.list());
  g_serial = new Serial(this, "/dev/tty.usbmodem1421", 115200, 'N', 8, 1.0f);
  //textFont(g_font, 20);

  // This draws the graph key info
  strokeWeight(1.5f);
  stroke(255, 0, 0);     line(20, 420, 35, 420);
  stroke(0, 255, 0);     line(20, 440, 35, 440);
  stroke(0, 0, 255);     line(20, 460, 35, 460);
  //stroke(255, 255, 0);   line(20, 480, 35, 480);
  //stroke(255, 0, 255);   line(20, 500, 35, 500);
  //stroke(0, 255, 255);   line(20, 520, 35, 520);
  fill(0, 0, 0);
  //text("xAccel", 40, 430);
  //text("yAccel", 40, 450);
  //text("zAccel", 40, 470);
  //text("vRef", 40, 490);
  //text("xRate", 40, 510);
  //text("yRate", 40, 530);

  colorMode(RGB,100);
  background(0);
}

public void draw(){
  background(0);
  blur(50);

  if ((millis()-current)/1000>reseed&&particle.size()<150) {
    particle.add(new Particle(x,y));
    reseed = random(0,.2f);
    current = millis();
  }

  for (int i=0 ; i<particle.size() ; i++) {
    Particle particleT = (Particle)particle.get(i);
    particleT.calculate(xAccel, yAccel);
    particleT.draw();
  }

  if (xAccel < 324 && xAccel < 325){
    x = x - 5;
  } else if (xAccel > 324 && xAccel > 325) {
    x = x + 5;
  }

  if (yAccel < 317 && yAccel < 318){
    y++;
  } else if (yAccel > 317 && yAccel > 318) {
    y--;
  }

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
public void processSerialData() {
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

    g_xAccel.addVal(xAccel);
    g_yAccel.addVal(yAccel);
    g_zAccel.addVal(zAccel);
    g_vRef.addVal(vRef);
    g_xRate.addVal(xRate);
    g_yRate.addVal(yRate);
    System.out.println("X: " + xAccel + " Y: " + yAccel + " Z: " + zAccel);
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

  public void addVal(float val) {

    if (g_enableFilter && (m_curSize != 0)) {
      int indx;

      if (m_endIndex == 0)
        indx = m_maxSize-1;
      else
        indx = m_endIndex - 1;

      m_data[m_endIndex] = getVal(indx)*.5f + val*.5f;
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

  public float getVal(int index) {
    return m_data[(m_startIndex+index)%m_maxSize];
  }

  public int getCurSize() {
    return m_curSize;
  }

  public int getMaxSize() {
    return m_maxSize;
  }
}

public void blur(float trans) {
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

  public void drawGraphBox() {
    stroke(0, 0, 0);
    rectMode(CORNERS);
    rect(m_gLeft, m_gBottom, m_gRight, m_gTop);
  }

  public void drawLine(cDataArray data, float minRange, float maxRange) {
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

public boolean isCollidingCircleRectangle(
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


public class Particle {
  PVector position,pposition,speed;
  float col;

  public Particle(float x, float y) {
    position = new PVector(random(x,x+140), 89);
    pposition = position;
    speed = new PVector(0,0);
    col = random(30,100);
  }

  public void draw() {
    stroke(100,col);
    strokeWeight(2);
    line(position.x,position.y,pposition.x,pposition.y);
    ellipse(position.x,position.y,5,5);
  }

  public void calculate(float xA, float yA) {
    //position = new PVector(position.x + xA, position.y + yAccel);
    position.x = position.x + xA/10;
    position.y = position.y + yA/10;
    //gravity();

  }

  public void gravity() {
    speed.y += 1;
    speed.x += .0001f;
    position.add(speed);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Wind" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
