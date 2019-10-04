class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  String[] objStrings;

  ArrayList<SwivelObject> objects;

  float scale = 0.1;
  float strokeWeightVal = 4;

  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);   
    objStrings = String.join("", rawStrings).split("Object");
  
    objects = new ArrayList<SwivelObject>();
       
    for (String s : objStrings) {
      SwivelObject obj = new SwivelObject(s, scale, strokeWeightVal);
      objects.add(obj);
    }
  }
  
  void init() {
    for (SwivelObject obj : objects) {
      obj.pointBytesStart++;
      obj.init();
    }
  }
  
  void save() {
    saveStrings(filePath + ".txt", objStrings);  
  }
  
  void draw() {
    for (SwivelObject obj : objects) {
      obj.draw();
    }
  }

}
