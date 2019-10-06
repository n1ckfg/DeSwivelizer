class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  String[] asciiStrings;
  
  int byteCounter, byteStart;
  
  ArrayList<Integer> objectStartIndices;
  ArrayList<Integer> objectEndIndices;
  ArrayList<SwivelObject> objects;
  
  // Every object block contains its name in ascii. 
  // By default it's [ Object ] followed by a number
  byte[] beginObjectBlock = "Object".getBytes();
  
  // Every object block contains a material block with its name in ascii.
  // By default it's [ plastic ].
  // We're not using materials so this can be treated as object end.
  byte[] endObjectBlock = "plastic".getBytes();

  // The header block also contains one mention of [ Object ]
  SwivelHeader header;
  int headerEndIndex;
  SwivelFooter footer;
  int footerStartIndex;
  
  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);
    asciiStrings = stringsToAscii(rawStrings);
    
    objects = new ArrayList<SwivelObject>();
    objectStartIndices = new ArrayList<Integer>();
    objectEndIndices = new ArrayList<Integer>();
    
    // 1. Loop through and find all the indices.
    byteCounter = 0;
    byteStart = 0;
    for (int i=0; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findStartIndex = findIndexOf(byteArray, beginObjectBlock);
      int findEndIndex = findIndexOf(byteArray, endObjectBlock);

      if (findStartIndex != -1 && findEndIndex != -1) {
        objectStartIndices.add(byteCounter + findStartIndex);
        objectEndIndices.add(byteCounter + findEndIndex);
        byteStart = byteCounter;
      }
    }
    
    headerEndIndex = objectStartIndices.get(1); // remember that the header block also contains one mention of [ Object ]
    footerStartIndex = objectEndIndices.get(objectEndIndices.size()-1);
      
    println("Found " + objectStartIndices.size() + " start indices: " + objectStartIndices);
    println("\nFound " + objectEndIndices.size() + " end indices: " + objectEndIndices);
    println("\nObjects: " + "???");
    println("Header size: " + headerEndIndex + ", footer size: " + (rawBytes.length - footerStartIndex));

    // 2. Build objects.   
    for (int i=0; i<objectStartIndices.size(); i++) {
      int start = objectStartIndices.get(i);
      int end = objectEndIndices.get(i);
      
      byte[] byteArray = new byte[end];
      System.arraycopy(rawBytes, start, byteArray, 0, end);
      objects.add(new SwivelObject(byteArray, objects.size()+1));
    }

    println("\nBuilt " + objects.size() + " objects.");
    println("Footer begins at " + footerStartIndex);

    byte[] headerBytes = new byte[headerEndIndex];
    System.arraycopy(rawBytes, 0, headerBytes, 0, headerEndIndex);
    header = new SwivelHeader(headerBytes);
    println("Header size: " + header.headerBytes.length);

    byte[] footerBytes = new byte[footerStartIndex];
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
    
    saveStrings(filePath + "_format.txt", objStrings);
    saveStrings(filePath + "_dump.txt", asciiStrings);  
  }
  
  void draw() {
    for (SwivelObject obj : objects) {
      obj.draw();
    }
  }

}
