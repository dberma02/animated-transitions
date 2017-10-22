/*
 *
 *
 */
 
 class BarToPie {
   
   ArrayList<CoreData> coreData;
   Constants consts;
   
   public BarToPie(ArrayList coreData, Constants consts) {
     this.coreData = coreData;
     this.consts = consts;
   }
   
   public void renderPieGraph() {
     drawArcs();
     drawWedges();
   }
   
   public void activate() {
     retractLines();
   }
   
   private void drawAxes() {
     line(consts.OFFSET, consts.CHARTBOTTOM, consts.OFFSET + consts.CHARTWIDTH, consts.CHARTBOTTOM);
     line(consts.OFFSET, consts.OFFSET, consts.OFFSET, consts.OFFSET + consts.CHARTHEIGHT);
   }

   private void drawArcs() {
     noFill();
     for(CoreData cd : coreData) {
       arc(consts.CENT.x, consts.CENT.y,
       consts.RAD, consts.RAD,
       cd.startTheta, cd.endTheta);
     }
   }
   
   private void drawWedges() {
     PVector startPoint;
     PVector endPoint;
     PVector c = consts.CENT;
     
     for(CoreData cd : coreData) {
       startPoint = getPoint(cd.startTheta);
       endPoint = getPoint(cd.endTheta);
       
       //check on simpler dataset that this is working
       line(c.x, c.y, startPoint.x, startPoint.y);
       line(c.x, c.y, endPoint.x, endPoint.y);
     }
   }
   
   private void drawTangents() {
     for(CoreData cd : coreData) {
       float realTheta = cd.endTheta - cd.startTheta;
       float midTheta = cd.startTheta + (realTheta / 2); 
       PVector tanPoint = getPoint(midTheta);
       
     }
   }
   
   private void retractLines() {
     
     
   }
   
   private int quadrant(float theta) {

    if(theta < PI/2) {
       return 1; 
    } else if(theta < PI) {
      return 2;
    } else if(theta < 1.5*PI) {
      return 3;
    } else {
      return 4;
    }
  }

  private PVector getPoint(float theta) {
    PVector point = new PVector(0,0);

    float cx = consts.CENT.x;
    float cy = consts.CENT.y;
    float r = consts.RAD;

    if (quadrant(theta) == 1) {
      point.x = cx + .5* r * cos(theta);
      point.y = cy - .5* r * sin(theta);
    } else if(quadrant(theta) == 2) {
      theta = PI - theta;
      point.x = cx - .5* r * cos(theta);
      point.y = cy - .5* r * sin(theta);
    } else if(quadrant(theta) == 3) {
      theta = theta - PI;
      point.x = cx - .5* r * cos(theta);
      point.y = cy + .5* r * sin(theta);
    } else {
      theta = 2*PI - theta;
      point.x = cx + .5* r * cos(theta);
      point.y = cy + .5* r * sin(theta);
    }
    return point;
  }
   
   
   
 }