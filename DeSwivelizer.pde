import peasy.*;

PeasyCam cam;

String filePath = "Beastie2.rsrc";
String[] rawData;
ArrayList<Float> allFloats;
ArrayList<PVector> points;
PShape shp;

float scale = 5;
int start = 0;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 100);
  
  rawData = loadStrings(filePath);
  allFloats = new ArrayList<Float>();
  points = new ArrayList<PVector>();
  
  for (String s : rawData) {
    for (int i=start; i<s.length()-4; i+=4) {
      byte[] bytes = new byte[4];
      bytes[0] = (byte) s.charAt(i);
      bytes[1] = (byte) s.charAt(i+1);
      bytes[2] = (byte) s.charAt(i+2);
      bytes[3] = (byte) s.charAt(i+3);
        
      allFloats.add(asFloat(bytes));
    }
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
  shp.strokeWeight(4);
  for (PVector p : points) {
    shp.vertex(p.x, p.y, p.z);
  }
  shp.endShape();
}

void draw() {
  background(0);
  shape(shp);
}
