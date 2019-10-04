class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  String[] objStrings;

  ArrayList<SwivelObject> objects;
  ArrayList<Float> allFloats;
  ArrayList<PVector> points;
  PShape shp;
  float scale = 0.1;
  float strokeWeightVal = 4;

  int numBytes = 4;
  int bytesStart = 0;

  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);   
    objStrings = String.join("", rawStrings).split("Object");
  
    objects = new ArrayList<SwivelObject>();
    
    init();
    
    for (String s : objStrings) {
      SwivelObject obj = new SwivelObject(s);
      println(obj.index + " " + obj.lines.length);
      objects.add(obj);
    }
  }
 
  void init() { 
    if (bytesStart > rawBytes.length-1) bytesStart = 0;
    
    allFloats = new ArrayList<Float>();
    points = new ArrayList<PVector>();
    
    for (int i=bytesStart; i<rawBytes.length-numBytes; i+=numBytes) {
      byte[] bytes = new byte[numBytes];
      for (int j=0; j<numBytes; j++) {
        bytes[j] = (byte) rawBytes[i+j];
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
  
  void save() {
    saveStrings(filePath + ".txt", objStrings);  
  }
  
  void draw() {
    shape(shp);
  }

}
