class SwivelObject {

  String objString;
  String[] objLines;
  byte[] pointBytes;
  int pointBytesStart = 0;

  int index;
  
  int indexLoc = 0;
  int pointsLoc = 33;
  
  int numBytes = 4;
  float scale = 0.1;
  float strokeWeightVal = 4;
  
  ArrayList<Float> allFloats;
  ArrayList<PVector> points;
  PShape shp;
  
  SwivelObject(String s, float _scale, float _strokeWeightVal) {
    objString = s; 
    scale = _scale;
    strokeWeightVal = _strokeWeightVal;
    
    objLines = objString.split(" ");
    index = parseInt(objLines[0]);
  }

  void init() { 
    pointBytes = String.join("", objLines).getBytes();
    if (pointBytesStart > pointBytes.length-1) pointBytesStart = 0;
    
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
    shp.beginShape(POINTS);
    shp.stroke(255);
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
