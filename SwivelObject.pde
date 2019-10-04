class SwivelObject {

  String rawData;
  String[] lines;
  int index;
  
  SwivelObject(String s) {
    rawData = s; 
    lines = rawData.split(" ");
    index = parseInt(lines[0]);
  }
  
}
