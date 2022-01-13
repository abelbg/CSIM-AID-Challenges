class FractalRoot {
  PointObj[] pointArr = {};
  Branch rootBranch;
  
  FractalRoot(float startAngle) {
    float centX = width/2;
    float centY = height/2;
    float angleStep = 360.0f/_numSides;
    for (float i = 0; i<360; i+=angleStep) {
      float x = centX + ((_size) * cos(radians(startAngle + i))); //Variables of interest: pixel size (40) + startAngle
      float y = centY +((_size) * sin(radians(startAngle + i)));
      pointArr = (PointObj[])append(pointArr, new PointObj(x, y));
    }
    rootBranch = new Branch(0, 0, pointArr);
  }

  void drawShape() {
    rootBranch.drawMe();
  }
}
