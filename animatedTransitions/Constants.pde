

class Constants {
  float OFFSET = min(width, height) * .05;
  float CHARTBOTTOM = height - OFFSET;
  float CHARTRIGHT = width - OFFSET;
  float CHARTWIDTH = width - OFFSET*2;
  float CHARTHEIGHT = height - OFFSET*2;
  float BARWIDTH;
  
  float RAD = min(width, height) * .8; 
  PVector CENT = new PVector(width/2, height/2);
  
  public void setBarWidth(float barWidth) {
    BARWIDTH = barWidth;
  }
}