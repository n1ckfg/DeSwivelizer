class SwivelHeader {
  
  byte[] headerBytes;
  String headerString;
  String headerAsciiString;
  
  SwivelHeader(byte[] b) {
    headerBytes = b;
    headerString = new String(b);
    headerAsciiString = "<HEADER>\n" + stringToAscii(headerString) + "\n</HEADER>\n";
  }

}
