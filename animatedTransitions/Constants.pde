

class Constants {
  float OFFSET = min(width, height) * .05;
  float CHARTBOTTOM = height - OFFSET*4;
  float CHARTRIGHT = width - OFFSET;
  float CHARTWIDTH = width - OFFSET*2;
  float CHARTHEIGHT = height - OFFSET*5;
  float BARWIDTH;
  
  float RAD = min(width, height) * 0.3; 
  PVector CENT = new PVector(width/2, height/2.60);
  //so bar height * scalor will get scaled height,
  //scalsed bar height / scalor will go to original height
  float SCALOR;
  
  public void setBarWidth(float barWidth) {
    BARWIDTH = barWidth;
  }
}