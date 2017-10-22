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
   
   public void activate() {
     retractLines();
     
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
   
   private void retractLines() {
     
     
   }
   

   
   
   
 }