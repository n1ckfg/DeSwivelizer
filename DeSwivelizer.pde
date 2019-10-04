import peasy.*;

PeasyCam cam;

String filePath = "Beastie2.rsrc";
byte[] rawBinData;
String[] rawTextData;
ArrayList<Float> allFloats;
ArrayList<PVector> points;
PShape shp;

float scale = 0.1;
float strokeWeightVal = 4;
int start = 0;
int markTime = 0;
int timeInterval = 100;
int numBytes = 4;

boolean doLoop = true;
boolean doSaveFile = true;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 100);
  fixClipping();
  
  rawBinData = loadBytes(filePath);
  rawTextData = loadStrings(filePath);   

  if (doSaveFile) {
    //println(textOutput);
    //saveStrings(filePath + ".txt", textOutput);
  }
  
  init();
}

void draw() {
  if (doLoop && millis() > markTime + timeInterval) init();
  background(0);
  shape(shp);
  
  surface.setTitle("" + frameRate);
}

void init() {
  if (doLoop) start++;
  if (start > rawBinData.length-1) start = 0;
  
  allFloats = new ArrayList<Float>();
  points = new ArrayList<PVector>();
  
  for (int i=start; i<rawBinData.length-numBytes; i+=numBytes) {
    byte[] bytes = new byte[numBytes];
    for (int j=0; j<numBytes; j++) {
      bytes[j] = (byte) rawBinData[i+j];
    }
      
    float f = 0;
    f = asFloat(bytes);
    
    allFloats.add(f);
  }
  
  for (int i=0; i<allFloats.size()-3; i+=3) {
    float x = allFloats.get(i);
    float y = allFloats.get(i+1);
    float z = allFloats.get(i+2);
    PVector p = new PVector(x,y,z).mult(scale);
    points.add(p);
  }
  
  shp = createShape();
  shp.beginShape(POINTS);
  shp.stroke(255);
  shp.strokeWeight(strokeWeightVal);
  for (PVector p : points) {
    shp.vertex(p.x, p.y, p.z);
  }
  shp.endShape();
  
  markTime = millis();
}
