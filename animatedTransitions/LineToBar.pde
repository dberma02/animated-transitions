/*
 *
 *
 */
 
 class LineToBar {
   
   ArrayList<CoreData> coreData;
   Constants consts;
   
   public LineToBar(ArrayList coreData, Constants consts) {
     this.coreData = coreData;
     this.consts = consts;
   }
   
   public void renderLineGraph() {
     drawAxes();
     drawLines();
     plotPoints();
   }
   
   public void renderBarGraph() {
     drawAxes();
     for (int i = 0; i < coreData.size(); i++) {
       drawRects(i);
     }
   }
   
   public boolean retractLines(int iteration) {
    background(255);
    drawAxes();
    
    float lerpValue = 0;
  
    for (int i = 0; i < coreData.size()-1; i++) {
       CoreData leftP = coreData.get(i);
       CoreData rightP = coreData.get(i+1);
       
       PVector p1 = new PVector(leftP.barRef.x + (consts.BARWIDTH/2), leftP.barRef.y);
       PVector p2 = new PVector(rightP.barRef.x + (consts.BARWIDTH/2), rightP.barRef.y);
       
       PVector mid = PVector.lerp(p1, p2, 0.5);
       // 
       lerpValue = 1-iteration*.02;

       PVector left = PVector.lerp(p1, mid, lerpValue);
       PVector right = PVector.lerp(p2, mid, lerpValue);
       
       line(p1.x , p1.y, left.x, left.y);
       line(right.x, right.y, p2.x, p2.y);
       
       fill(255);
       ellipse(leftP.barRef.x + consts.BARWIDTH/2, leftP.barRef.y, 0.01*width*lerpValue, 0.01*width*lerpValue);
     }

     if (lerpValue < .0001) {
       return true;
     }   
     
     return false;
   }
   
   public boolean drawBarTops(int iteration) {
    drawAxes();
    float lerpValue = 0;
    
    for (int i = 0; i < coreData.size(); i++) {
       CoreData data = coreData.get(i);
       
       //center of bartop
       PVector mid = new PVector(data.barRef.x + consts.BARWIDTH/2, data.barRef.y);
       //top left corner of bar
       PVector left = new PVector(data.barRef.x, data.barRef.y);
       //top right corner of bar
       PVector right = new PVector(data.barRef.x + consts.BARWIDTH, data.barRef.y);
       
       lerpValue = iteration*.02; 
       
       PVector start = PVector.lerp(mid, left, lerpValue);
       PVector end = PVector.lerp(mid, right, lerpValue);
       
       line(mid.x , mid.y, start.x, start.y);
       line(mid.x, mid.y, end.x, end.y);
      

       }
       if (lerpValue > 1) {
         return true;
    }
    
    return false;
   }
   
   public boolean drawVertLines(int iteration) {
    float lerpValue = 0;
    
    for (int i = 0; i < coreData.size(); i++) {
       CoreData data = coreData.get(i);
       PVector topLeft = new PVector(data.barRef.x, data.barRef.y);
       PVector topRight = new PVector(data.barRef.x + consts.BARWIDTH, data.barRef.y);
       PVector bottomLeft = new PVector(data.barRef.x, 
                                        consts.CHARTBOTTOM);
       PVector bottomRight = new PVector(data.barRef.x + consts.BARWIDTH, 
                                        consts.CHARTBOTTOM);
                                        
       lerpValue = iteration*.009; 
       PVector leftVal = PVector.lerp(topLeft, bottomLeft, lerpValue);
       PVector rightVal = PVector.lerp(topRight, bottomRight, lerpValue);
       
       line(topLeft.x, topLeft.y, leftVal.x, leftVal.y);
       line(topRight.x, topRight.y, rightVal.x, rightVal.y);
    }
    
    if ((iteration+1)*.009 >= 1) {
      return true;
    }
    
    return false;
   }
   
   
   public boolean drawRects(int iteration) {
     CoreData data = coreData.get(iteration);
     fill(10*iteration, 20*iteration, 30*iteration);
     rect(data.barRef.x, data.barRef.y, consts.BARWIDTH, consts.CHARTBOTTOM - data.barRef.y);  
     
     if (iteration+1 == coreData.size()) {
       return true;
     }
     return false;
     
     
   }
      
   
   private void drawAxes() {
     line(consts.OFFSET, consts.CHARTBOTTOM, consts.OFFSET + consts.CHARTWIDTH, consts.CHARTBOTTOM);
     line(consts.OFFSET, consts.OFFSET, consts.OFFSET, consts.OFFSET + consts.CHARTHEIGHT);
   }

   private void drawLines() {
     int size = coreData.size();
     
     for (int i = 0; i < size-1; i++) {
       CoreData leftP = coreData.get(i);
       CoreData rightP = coreData.get(i+1);
       
       line(leftP.barRef.x + (consts.BARWIDTH/2), leftP.barRef.y, 
            rightP.barRef.x + (consts.BARWIDTH/2), rightP.barRef.y);
     }
   }   
   
   private void plotPoints() {
     for (CoreData cd : coreData) {
       fill(255);
       ellipse(cd.barRef.x + (consts.BARWIDTH/2), cd.barRef.y, 0.01*width, 0.01*width);
     }
   }
   
   
   

   
   
   
 }