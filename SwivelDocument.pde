class SwivelDocument {
  
  String filePath;
  byte[] rawBytes;
  String[] rawStrings;
  String[] asciiStrings;
  
  int byteCounter, byteStart, headerEndIndex, footerStartIndex;
  boolean armMakeObject = false;
  ArrayList<SwivelObject> objects;
  ArrayList<Integer> startIndices;
  ArrayList<Integer> endIndices;
  
  // Every object block contains its name in ascii. 
  // By default it's [ Object ] followed by an index number
  // The index numbers are often sequential--but not always!
  // Keep a string version so we can increment the index.
  String beginObjectString = "Object";
  byte[] beginObjectBytes = beginObjectString.getBytes();

  // Every object block contains a material block with its name in ascii.
  // By default it's [ plastic ].
  // We're not using materials so this can be treated as object end.
  byte[] endObjectBytes = "plastic".getBytes();
  
  // We need to discard bytes after this entry
  byte[] middleObjectSplitBytes = "SWVL".getBytes();

  // The header block also contains one mention of [ Object ]
  SwivelHeader header;
  SwivelFooter footer;
  
  SwivelDocument(String _filePath) {
    filePath = _filePath;
    rawBytes = loadBytes(filePath);
    rawStrings = loadStrings(filePath);
    asciiStrings = stringsToAscii(rawStrings);
    
    objects = new ArrayList<SwivelObject>();
    startIndices = new ArrayList<Integer>();
    endIndices = new ArrayList<Integer>();
    
    byteStart = 0;
    byteCounter = 0;

    for (int i=0; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findStartIndex = findIndexOf(byteArray, (beginObjectString + 1).getBytes());   
      if (findStartIndex != -1) {
        headerEndIndex = byteStart + findStartIndex;
        break;
      }
    }
    
    byteStart = headerEndIndex;
    byteCounter = headerEndIndex;
    
    for (int i=headerEndIndex; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findStartIndex = findIndexOf(byteArray, beginObjectBytes);   
      if (findStartIndex != -1) {
        startIndices.add(byteStart + findStartIndex);
        byteStart = byteCounter;
      }
    }
    
    byteStart = headerEndIndex;
    byteCounter = headerEndIndex;
    
    for (int i=headerEndIndex; i<rawBytes.length; i++) {
      byteCounter++;
      byte[] byteArray = new byte[byteCounter - byteStart];
      System.arraycopy(rawBytes, byteStart, byteArray, 0, byteCounter - byteStart);
      
      int findEndIndex = findIndexOf(byteArray, endObjectBytes);   
      if (findEndIndex != -1) {
        endIndices.add(byteStart + findEndIndex);
        byteStart = byteCounter;
      }
    }
    
    endIndices.remove(0);
        
    println("startIndices size: " + startIndices.size() + "   endIndices size: " + endIndices.size());
    println("\nstartIndices: " + startIndices + "\n\nendIndices: " + endIndices + "\n");
    
    if (startIndices.size() == endIndices.size()) {
      footerStartIndex = endIndices.get(endIndices.size()-1);
      
      for (int i=0; i<startIndices.size(); i++) {
        int start = startIndices.get(i);
        int end = endIndices.get(i);
        byte[] byteArray = new byte[end - start];
        System.arraycopy(rawBytes, start, byteArray, 0, end - start);
        
        int split = findIndexOf(byteArray, middleObjectSplitBytes);
        
        if (split != -1) {
          byte[] newByteArray = new byte[split];        
          System.arraycopy(rawBytes, start, newByteArray, 0, split);
          objects.add(new SwivelObject(newByteArray, extractIndexNumber(newByteArray)));
        } else {
          objects.add(new SwivelObject(byteArray, extractIndexNumber(byteArray)));
        }
      }
      
      byte[] headerBytes = new byte[headerEndIndex];
      System.arraycopy(rawBytes, 0, headerBytes, 0, headerEndIndex);
      header = new SwivelHeader(headerBytes);
  
      byte[] footerBytes = new byte[rawBytes.length - footerStartIndex];
      System.arraycopy(rawBytes, footerStartIndex, footerBytes, 0, rawBytes.length - footerStartIndex);
      footer = new SwivelFooter(footerBytes);
      
      println("\n\nFound objects: " + objects.size());
      println("Header size: " + header.headerBytes.length + "   footer size: " + footer.footerBytes.length);
      
      init();
      save();
    } else {
      println("ERROR: start and end indices do not match.");
      exit();
    }
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
  
  int extractIndexNumber(byte[] bytes) {
    String s = new String(bytes);
    String ss = s.split("   ")[0];
    String sss = ss.split("Object")[1];
    return parseInt(sss);
  }

}
