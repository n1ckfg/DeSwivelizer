class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  
  int byteCounter = 0;
  int byteStart = 0;
  ArrayList<SwivelObject> objects;

  float scale = 0.01;
  float strokeWeightVal = 4;

  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    
    byte[] headerBytes, footerBytes;
    
    objects = new ArrayList<SwivelObject>();
    boolean armCreateObject = false;
    
    for (int i=0; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findIndex = findIndexOf(byteArray, "Object".getBytes());
      if (findIndex != -1) {
        if (armCreateObject) {
          armCreateObject = false;
          objects.add(new SwivelObject(byteArray, scale, strokeWeightVal));
        } else {
          armCreateObject = true;
        }        
        byteStart = byteCounter;
      }
    }
  }
  
  void init() {
    for (SwivelObject obj : objects) {
      obj.pointBytesStart++;
      obj.init();
    }
  }
  
  void save() {
    //saveStrings(filePath + ".txt", objStrings);  
  }
  
  void draw() {
    for (SwivelObject obj : objects) {
      obj.draw();
    }
  }

}
