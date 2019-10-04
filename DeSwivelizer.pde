import peasy.*;

PeasyCam cam;

String filePath = "Beastie2.rsrc";
SwivelDocument swivel;

int markTime = 0;
int timeInterval = 100;

boolean doLoop = true;
boolean doSaveFile = true;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 100);
  fixClipping();    
  
  swivel = new SwivelDocument(filePath);
}

void draw() {
  if (doLoop && millis() > markTime + timeInterval) {
    swivel.init();
    markTime = millis();
  }
  background(0);
  
  swivel.draw();
  
  surface.setTitle("" + frameRate);
}
