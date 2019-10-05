class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  String[] asciiStrings;
  
  int byteCounter, byteStart;
  int objCounter = 0;
  int headerEndIndex = 0;
  int footerStartIndex = 0;
  
  SwivelHeader header;
  SwivelFooter footer;
  ArrayList<SwivelObject> objects;
  
  // Every object block contains its name in ascii. 
  // By default it's [ Object ] followed by a number
  byte[] beginObjectBlock = "Object".getBytes();
  
  // Every object block contains a material block with its name in ascii.
  // By default it's [ plastic ].
  // We're not using materials so this can be treated as object end.
  byte[] endObjectBlock = "plastic".getBytes();

  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);
    asciiStrings = stringsToAscii(rawStrings);
    
    objects = new ArrayList<SwivelObject>();
    
    byteCounter = 0;
    byteStart = 0;
    for (int i=0; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findIndex = findIndexOf(byteArray, beginObjectBlock);
      
      if (findIndex != -1) {
        if (headerEndIndex == 0) headerEndIndex = byteCounter;
        byteStart = byteCounter;
        objCounter++;
      }
    }
    
    println("Found " + objCounter + " objects.");

    boolean armObject = false;
    
    byteCounter = 0;
    byteStart = 0;
    for (int i=0; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findIndex = findIndexOf(byteArray, beginObjectBlock);
      
      if (findIndex != -1) {
        armObject = true;
      }
      
      findIndex = findIndexOf(byteArray, endObjectBlock);
      
      if (findIndex != -1 && armObject) {
        byteStart = byteCounter;
        armObject = false;
        objects.add(new SwivelObject(byteArray, objects.size()));
        if (objects.size() == objCounter && footerStartIndex == 0) footerStartIndex = byteCounter;
      }
    }

    println("\nBuilt " + objects.size() + " objects.");

    byte[] headerBytes = new byte[headerEndIndex];
    System.arraycopy(rawBytes, 0, headerBytes, 0, headerEndIndex);
    header = new SwivelHeader(headerBytes);
    println("Header size: " + header.headerBytes.length);

    byte[] footerBytes = new byte[rawBytes.length - footerStartIndex];
    System.arraycopy(rawBytes, footerStartIndex, footerBytes, 0, rawBytes.length - footerStartIndex);
    footer = new SwivelFooter(footerBytes);
    println("Footer size: " + footer.footerBytes.length);
    
    
    init();
    save();
  }
  
  void init() {
    for (SwivelObject obj : objects) {
      obj.pointBytesStart++;
      obj.init();
    }
  }
  
  void save() {
    String[] objStrings = new String[objects.size() + 2];
    objStrings[0] = header.headerAsciiString;
    for (int i=1; i<objects.size()+1; i++) {
      objStrings[i] = objects.get(i-1).objAsciiString;
    }
    objStrings[objStrings.length-1] = footer.footerAsciiString;
    
    saveStrings(filePath + "_objects.txt", objStrings);
    saveStrings(filePath + ".txt", asciiStrings);  
    
    
  }
  
  void draw() {
    for (SwivelObject obj : objects) {
      obj.draw();
    }
  }

}
