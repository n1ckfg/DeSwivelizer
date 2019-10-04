class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  
  int byteCounter = 0;
  int byteStart = 0;
  ArrayList<SwivelObject> objects;

  float scale = 0.01;
  float strokeWeightVal = 4;

  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);
    
    byte[] headerBytes, footerBytes;

    objects = new ArrayList<SwivelObject>();
    
    byte[] searchBytes = "Object".getBytes();
    
    boolean armCreateObject = false;
    
    for (int i=0; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findIndex = findIndexOf(byteArray, searchBytes);
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
    
    init();
  }
  
  void init() {
    for (SwivelObject obj : objects) {
      obj.pointBytesStart++;
      obj.init();
    }
  }
  
  void save() {
    saveStrings(filePath + ".txt", rawStrings);  
  }
  
  void draw() {
    for (SwivelObject obj : objects) {
      obj.draw();
    }
  }

}
