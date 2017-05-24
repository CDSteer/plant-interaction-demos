//Cameron Steer

import processing.serial.*;
import processing.opengl.*;

import java.util.ArrayList;
import java.util.List;

boolean cali = true;
int caliX1, caliX2, caliY1, caliY2;

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

List<Particle> particle = new ArrayList<Particle>(5);
float current;
float reseed = random(0,.2);
int gapX, gapY;

void setup() {
  size(g_winW, g_winH, P3D);
  x =  g_winW/2;
  y =  10;
  noStroke();
  println(Serial.list());
  g_serial = new Serial(this, "/dev/tty.usbmodem1421", 115200, 'N', 8, 1.0);
  colorMode(RGB,100);
  background(0);
}

void draw(){
  background(0);
  blur(50);
  
  if (xAccel < caliX1 && xAccel < caliX2){
    x = x - 5;
    particle.add(new Particle(x,y));
  } else if (xAccel > caliX1 && xAccel > caliX2) {
    x = x + 5;
    particle.add(new Particle(x,y));
  }

  if (yAccel < caliY1 && yAccel < caliY2){
    y++;
    particle.add(new Particle(x,y));
  } else if (yAccel > caliY1 && yAccel > caliY2) {
    y--;
    particle.add(new Particle(x,y));
  } 
    
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
  
//  if (xAccel == caliX1 || xAccel == caliX2 && yAccel == caliY1 || yAccel == caliY2){
//    particle.clear();
//  }
  
 // We need to read in all the avilable data so graphing doesn't lag behind
  while (g_serial.available() >= 2*6+2) {
    processSerialData();
  } 
  
  
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


