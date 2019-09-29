String filePath = "Beastie2.rsrc";
String[] rawData;

void setup() {
  size(800, 600, P3D);
  rawData = loadStrings(filePath);
  
  for (String s : rawData) {
    println(s);
  }
}

void draw() {
  background(0);
}
