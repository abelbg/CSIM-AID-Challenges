// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Interactive Selection
// http://www.genarts.com/karl/papers/siggraph91.html

// The class for our "Figure", contains DNA sequence, fitness value, position on screen

// Fitness Function f(t) = t (where t is "time" mouse rolls over Figure)

class Figure {

  DNA dna;     // Figure's DNA
  float fitness;    // How good is this Figure?
  float x, y;       // Position on screen
  int wh = 70;      // Size of square enclosing Figure
  boolean rolloverOn; // Are we rolling over this Figure?


  Rectangle r;

  //AB. Create a new Figure
  Figure(DNA dna_, float x_, float y_) {
    dna = dna_;
    x = x_; 
    y = y_;
    fitness = 1;
    // Using java.awt.Rectangle (see: http://java.sun.com/j2se/1.4.2/docs/api/java/awt/Rectangle.html)
    r = new Rectangle(int(x-wh/2), int(y-wh/2), int(wh), int(wh));//AB
  //AB
  }

  // Display the Figure
  void display() {

    pushMatrix();
    translate(x, y);
    noStroke();

    //AB
    figure = new FractalRoot(frameCount);
    figure.drawShape();
    //AB

    // Draw the bounding box
    stroke(0.25);
    if (rolloverOn) fill(0, 0.25);
    else noFill();
    rectMode(CENTER);
    rect(0, 0, wh, wh);
    popMatrix();

    // Display fitness value
    textAlign(CENTER);
    if (rolloverOn) fill(0);
    else fill(0.25);
    text(int(fitness), x, y+55);
  }

  float getFitness() {
    return fitness;
  }

  DNA getDNA() {
    return dna;
  }

  // Increment fitness if mouse is rolling over Figure
  void rollover(int mx, int my) {
    if (r.contains(mx, my)) {
      rolloverOn = true;
      fitness += 0.25;
    } else {
      rolloverOn = false;
    }
  }
  
  //AB
  class FractalRoot {
    int _numSides = int(map(dna.genes[0],0,1,3,10)); //Variable of interest: number of sides
    int size = int(map(dna.genes[5],0,1,20,30)); //Variable of interest: pixel size

    PointObj[] pointArr = {};
    Branch rootBranch;
    
    FractalRoot(float startAngle) {
      float centX = 0;
      float centY = 0;
      float angleStep = 360.0f/_numSides;
      for (float i = 0; i<720; i+=angleStep) {
        float x = centX + (size * cos(radians(i))); 
        float y = centY + (size * sin(radians(i)));
        pointArr = (PointObj[])append(pointArr, new PointObj(x, y));
      }
      rootBranch = new Branch(0, 0, pointArr);
    }
  
    void drawShape() {
      rootBranch.drawMe();
    }
  }
  
  class Branch { // Constructs Branch Object
    int _maxlevels = int(map(dna.genes[4],0,1,2,5));

    int level, num;
    PointObj[] outerPoints = {};
    PointObj[] midPoints = {};
    PointObj[] projPoints = {};
    Branch[] myBranches = {};
  
    Branch(int lev, int n, PointObj[] points) {
      level = lev;
      num = n;
      outerPoints = points;
      midPoints = calcMidPoints();
      projPoints = calcStrutPoints();
      
      if ((level+1) < _maxlevels) {
        Branch childBranch = new Branch(level+1, 0, projPoints);
        myBranches = (Branch[])append(myBranches, childBranch);
        
        for (int k = 0; k < outerPoints.length; k++) {
          int nextk = k-1;
          if (nextk < 0) { nextk += outerPoints.length; }
          PointObj[] newPoints = { projPoints[k], midPoints[k],
                     outerPoints[k], midPoints[nextk], projPoints[nextk] };
          childBranch = new Branch(level+1, k+1, newPoints);
          myBranches = (Branch[])append(myBranches, childBranch);
        }   
      }   
    }
      
    // Functions to calculate the midpoints of a set of vertices
  
    PointObj[] calcMidPoints() {
      PointObj[] mpArray = new PointObj[outerPoints.length];
      for (int i = 0; i < outerPoints.length; i++) {
        int nexti = i+1;
        if (nexti == outerPoints.length) { nexti = 0; }
        PointObj thisMP = calcMidPoint(outerPoints[i], outerPoints[nexti]);
      mpArray[i] = thisMP;
      }
    return mpArray;
    }
  
    PointObj calcMidPoint(PointObj end1, PointObj end2) {
      float mx, my;
      if (end1.x > end2.x) {
        mx = end2.x + ((end1.x - end2.x)/2);
      } else {
        mx = end1.x + ((end2.x - end1.x)/2);
      }
      if (end1.y > end2.y) {
        my = end2.y + ((end1.y - end2.y)/2);
      } else {
        my = end1.y + ((end2.y - end1.y)/2);
      }
      return new PointObj(mx, my);
      }
      
    PointObj[] calcStrutPoints() {
      PointObj[] strutArray = new PointObj[midPoints.length];
      for (int i = 0; i < midPoints.length; i++) {
        int nexti = i+3;
        if (nexti >= midPoints.length) { nexti -= midPoints.length; }
          PointObj thisSP = calcProjPoint(midPoints[i], outerPoints[nexti]);
          strutArray[i] = thisSP;
        }
      return strutArray;
    }
    
    PointObj calcProjPoint(PointObj mp, PointObj op) {
      float px, py;
      float adj, opp;
      if (op.x > mp.x) {
        opp = op.x - mp.x;
      } else {
        opp = mp.x - op.x;
      }
      if (op.y > mp.y) {
        adj = op.y - mp.y;
      } else {
        adj = mp.y - op.y;
      }
      if (op.x > mp.x) {
        px = mp.x + (opp * _strutFactor);
      } else {
        px = mp.x - (opp * _strutFactor);
      }
      if (op.y > mp.y) {
        py = mp.y + (adj * _strutFactor);
      } else {
        py = mp.y - (adj * _strutFactor);
      }
      return new PointObj(px,py);
    }
  
    void drawMe() { // Branch draws itself
      color c = color(dna.genes[1],dna.genes[2],dna.genes[3]);
      stroke(c);  // Variable of interest: color
      strokeWeight(0.5);
      // draw outer shape
      for (int i = 0; i < outerPoints.length; i++) {
        int nexti = i+1;
        if (nexti == outerPoints.length) { nexti = 0; }
        line(outerPoints[i].x, outerPoints[i].y, outerPoints[nexti].x, outerPoints[nexti].y);
      }
  
      for (int k = 0; k < myBranches.length; k++) {
        myBranches[k].drawMe();
      }
    }
  }

  // Object class to store an x,y position
  class PointObj { 
    float x, y;
    PointObj(float ex, float why) {
    x = ex; y = why;
    }
  }
  
  //AB
}
