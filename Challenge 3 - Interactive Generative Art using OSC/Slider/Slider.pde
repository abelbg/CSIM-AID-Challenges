import controlP5.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ControlP5 cp5;

int levels = 3;
int sides = 30;
float size = 400;
float thickness = 100;
float strut = 0.2;
Slider abc;

void setup() {
  size(600,1000);
  noStroke();
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,1200);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("sides")
     .setPosition(80,80)
     .setSize(400, 40)
     .setRange(3, 10)
     .setValue(3)
     .setNumberOfTickMarks(8)
     .setSliderMode(Slider.FLEXIBLE)
     ;
     
  cp5.addSlider("levels")
     .setPosition(80,280)
     .setSize(400, 40)
     .setRange(2, 6)
     .setNumberOfTickMarks(5)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  
  cp5.addSlider("thickness")
     .setPosition(80,480)
     .setSize(400, 40)
     .setRange(0.25,5)
     .setValue(1)
     ;

  cp5.addSlider("size")
     .setPosition(80,680)
     .setSize(400, 40)
     .setRange(50, 400)
     .setValue(400)
     ;
     
  cp5.addSlider("strut")
     .setPosition(80,880)
     .setSize(400, 40)
     .setRange(-1.0, 2)
     .setValue(0)
     ;
}

void draw() {
  
  fill(0);
  rect(0,0,width,200);
  
  /* create osc message */  
  OscMessage sidesMessage = new OscMessage("/sides");
  sidesMessage.add(sides); 
  /* send the message */
  oscP5.send(sidesMessage, myRemoteLocation);
  
  fill(40);
  rect(0,200,width,200);

  OscMessage levelsMessage = new OscMessage("/levels");
  levelsMessage.add(levels); /* add an int to the osc message */
  oscP5.send(levelsMessage, myRemoteLocation);
  
  fill(80);
  rect(0,400,width,200);
  
  OscMessage thicknessMessage = new OscMessage("/thickness");
  thicknessMessage.add(thickness); 
  oscP5.send(thicknessMessage, myRemoteLocation);
  
  fill(120);
  rect(0,600,width,200);
  
  OscMessage sizeMessage = new OscMessage("/size");
  sizeMessage.add(size); 
  oscP5.send(sizeMessage, myRemoteLocation);
  
  fill(160);
  rect(0,800,width,200);
  
  OscMessage strutMessage = new OscMessage("/strut");
  strutMessage.add(strut); 
  oscP5.send(strutMessage, myRemoteLocation);
 
}
