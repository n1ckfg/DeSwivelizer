class SwivelFooter {
  
  byte[] footerBytes;
  String footerString;
  String footerAsciiString;
  
  SwivelFooter(byte[] b) {
    footerBytes = b;
    footerString = new String(b);
    footerAsciiString = "<FOOTER>\n" + stringToAscii(footerString) + "\n</FOOTER>\n";
  }
  
}
