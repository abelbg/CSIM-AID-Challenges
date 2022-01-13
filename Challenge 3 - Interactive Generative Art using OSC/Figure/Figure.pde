import processing.sound.*;
import oscP5.*;

AudioIn input;
Amplitude analyzer;
FractalRoot figure;
OscP5 oscP5;

int lf = 10;    // Linefeed in ASCII
float vol;
float _size = 400;
float _stroke = 1;
float _strutNoise = random(10);
float _strutFactor = 0.2;  //Variable of interest, strut factor
int _maxlevels = 3;
int _numSides = 3; //Variable of interest, number of sides

void setup() {
  size(1000, 1000);
  smooth();
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);

  // Start listening to the microphone
  input = new AudioIn(this, 0);  // create an Audio input and grab the 1st channel
  input.start();  // start the Audio Input
  analyzer = new Amplitude(this);  // create a new Amplitude analyzer
  analyzer.input(input);  // patch the input to an volume analyzer
 
}

void draw(){
  
  float vol = analyzer.analyze();  // get the overall volume (between 0 and 1.0)
  vol = map(vol,0,0.5,0.0,1);
  background(255);
  _strutNoise += 0.01;
  _strutFactor = vol;
  figure = new FractalRoot((frameCount/2));
  figure.drawShape();
  
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
 if(theOscMessage.checkAddrPattern("/sides")==true) { 
   _numSides = theOscMessage.get(0).intValue();
 }
 
 else if(theOscMessage.checkAddrPattern("/levels")==true) { 
   _maxlevels = theOscMessage.get(0).intValue();
 }
 
 else if(theOscMessage.checkAddrPattern("/thickness")==true) { 
   _stroke = theOscMessage.get(0).floatValue();
 }
 
  else if(theOscMessage.checkAddrPattern("/size")==true) { 
   _size = theOscMessage.get(0).floatValue();
 }
}
