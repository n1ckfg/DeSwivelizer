// This contains geometry.

class SwivelObject {

  byte[] objBytes;
  String objString;
  String objAsciiString;
  
  byte[] pointBytes;
  int pointBytesStart = 0;
  color col;

  int index = 0;
  int indexLoc = 0;
  int pointsLoc = 0;
  
  int numBytes = 4;
  float scale = 0.01;
  float strokeWeightVal = 6;
  
  ArrayList<Float> allFloats;
  ArrayList<PVector> points;
  PShape shp;
    
  SwivelObject(byte[] b, int _index) {
    objBytes = b;
    objString = new String(objBytes);

    index = _index;
    objAsciiString = "<OBJECT_" + index + ">\n" + stringToAscii(objString) + "\n</OBJECT_" + index + ">\n";

    col = color(127 + random(127), 127 + random(127), 127 + random(127));
    
    init();
    print(" -- init object " + index);
  }

  void init() { 
    pointBytes = objBytes;
    if (pointBytesStart > pointBytes.length-numBytes) pointBytesStart = 0;
    
    allFloats = new ArrayList<Float>();
    points = new ArrayList<PVector>();
    
    for (int i=pointBytesStart; i<pointBytes.length-numBytes; i+=numBytes) {
      byte[] bytes = new byte[numBytes];
      for (int j=0; j<numBytes; j++) {
        bytes[j] = (byte) pointBytes[i+j];
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
    shp.beginShape(LINES);
    shp.stroke(col);
    shp.strokeWeight(strokeWeightVal);
    for (PVector p : points) {
      shp.vertex(p.x, p.y, p.z);
    }
    shp.endShape();  
  }
   
  void draw() {
    shape(shp);
  }
  
}
