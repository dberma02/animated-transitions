public class Button {
  private int xPos, yPos, bWidth, bHeight, fontSize;
  private color c;
  private String text;
  
  Button() {
    xPos = yPos = bWidth = bHeight = 0;
    c = color(0,0,0);
    text = "";
  }
  
  Button(int posX, int posY, int butWidth, int butHeight, color col, 
         String buttonText, int txtSize) {
    xPos = posX;
    yPos = posY;
    bWidth = butWidth;
    bHeight = butHeight;
    c = col;
    text = buttonText;
    fontSize = txtSize;
  }
  
  public void setButton(int posX, int posY, int butWidth, int butHeight, color col, String buttonText, int txtSize) {
    xPos = posX;
    yPos = posY;
    bWidth = butWidth;
    bHeight = butHeight;
    c = col;
    text = buttonText;
    fontSize = txtSize;
  }
  
  public void render() {
    // deal with text (textMode()?)
    
    textAlign(CENTER, CENTER);
    
    fill(c);
    rect(xPos, yPos, bWidth, bHeight);
    
    textSize(fontSize);
    fill(20);
    text(text, xPos, yPos, bWidth, bHeight);
  }
  
  public int getPosX() {
    return xPos;
  }
  
  public int getPosY() {
    return yPos;
  }
  
  public int getButWidth() {
    return bWidth;
  }
  
  public int getButHeight() {
    return bHeight;
  }
  
  public boolean isClicked() {
    if (mouseX >= xPos && mouseX <= (xPos + bWidth) &&
        mouseY >= yPos && mouseY <= (yPos + bHeight)) {
        return true;
    }
    return false;
  }
}