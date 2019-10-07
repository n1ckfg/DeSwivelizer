class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  String[] asciiStrings;
  
  int objCounter, byteCounter, byteStart;
  ArrayList<SwivelObject> objects;
  
  // Every object block contains its name in ascii. 
  // By default it's [ Object ] followed by a number
  String beginObjectString = "Object";
  
  // Every object block contains a material block with its name in ascii.
  // By default it's [ plastic ].
  // We're not using materials so this can be treated as object end.
  String endObjectString = "plastic";

  // The header block also contains one mention of [ Object ]
  SwivelHeader header;
  SwivelFooter footer;
  
  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);
    asciiStrings = stringsToAscii(rawStrings);
    
    objects = new ArrayList<SwivelObject>();
    
    // 1. Loop through and find all the indices.
    int objCounter = 1;
    byteStart = findIndexOf(rawBytes, (beginObjectString + objCounter).getBytes());
    byteCounter = byteStart;
    
    for (int i=byteStart; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findStartIndex = findIndexOf(byteArray, (beginObjectString + objCounter).getBytes());
      
      if (findStartIndex != -1) {
        int findEndIndex = findIndexOf(byteArray, endObjectString.getBytes());
        println(findStartIndex + " " + findEndIndex);
        
        if (findEndIndex != -1 && findEndIndex > findStartIndex) {
          int start = findStartIndex;
          int end = findEndIndex;
          println(start + " " + end);
          byte[] objByteArray = new byte[end - start];
          System.arraycopy(rawBytes, start, byteArray, 0, end - start);
          objects.add(new SwivelObject(objByteArray, objCounter));
          objCounter++;
          byteStart = byteCounter;
        }
      }
    }
    
    println("\nFound objects: " + objects.size());

    /*
    headerEndIndex = objectStartIndices.get(1); // remember that the header block also contains one mention of [ Object ]
    footerStartIndex = objectEndIndices.get(objectEndIndices.size()-1);
      
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
    */
    
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
