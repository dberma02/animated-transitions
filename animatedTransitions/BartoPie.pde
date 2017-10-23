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
       println("startTheta! ",cd.startTheta);
       arc(consts.CENT.x, consts.CENT.y,
       2*consts.RAD, 2*consts.RAD,
       cd.startTheta, cd.endTheta);
     }
   }
   
   
   public void newCenter() {
      PVector c = new PVector(.5* width, .5* height);
      float midTheta = PI+1;
      float r1 = 100;
      PVector mid = getPoint(midTheta, .5*r1);
      float sclr = 2;
      stroke(0);
      arc(c.x,c.y, r1, r1, 0,2*PI);
      fill(0);
      ellipse(mid.x, mid.y, 10, 10);
      noFill();
      println("MID: ", mid);

      stroke(#ff0000);
      arc(c.x, c.y, r1, r1, PI/2, PI);
      
      
      PVector rUnit = new PVector(c.x + mid.x, c.y - mid.y);
      println("SCALE: ", rUnit);
      rUnit.normalize();
      PVector sclRad = rUnit.mult(sclr);

      PVector c2 = mid.add(sclRad);
      ellipse(c2.x, c2.y, 20,20);
      
  
     
   }
   
   private void drawWedges() {
     PVector startPoint;
     PVector endPoint;
     PVector c = consts.CENT;
     
     for(CoreData cd : coreData) {
       startPoint = getPoint(cd.startTheta, consts.RAD);
       endPoint = getPoint(cd.endTheta, consts.RAD);
       
       //check on simpler dataset that this is working
       line(c.x, c.y, startPoint.x, startPoint.y);
       line(c.x, c.y, endPoint.x, endPoint.y);
     }
   }
   
   private void drawPositionedLines() {
     for(CoreData cd : coreData) {
       float realTheta = cd.endTheta - cd.startTheta;
       float midTheta = cd.startTheta + (realTheta / 2);
       
       PVector midPoint = getPoint(midTheta, consts.RAD);
       PVector tanTop = new PVector(midPoint.x, midPoint.y - (.5*cd.scaledHeight));
       PVector tanBottom = new PVector(midPoint.x, midPoint.y + (.5*cd.scaledHeight));
       
       println("top x, y ", tanTop.x, " ", tanTop.y);
       line(tanTop.x, tanTop.y, tanBottom.x, tanBottom.y);
       
       PVector tanPoint = getPoint(midTheta, consts.RAD);
       
     }
   }
   
   public boolean scaleLines(int iteration) {
     background(255);
     drawAxes();
     float lerpValue = 0; 
     println(iteration);
     for (CoreData cp: coreData) {       
       PVector uPoint = new PVector(cp.barRef.x + (consts.BARWIDTH/2), cp.barRef.y);
       //lerp towards scaled line ref
       PVector bottom = new PVector(cp.barRef.x + (consts.BARWIDTH/2), height - consts.OFFSET);
       
       // should start at 0
       lerpValue = iteration*.02;
       PVector lpos = PVector.lerp(uPoint, cp.scaledLineRef, lerpValue);
     

      
     //  line(uPoint.x, uPoint.y, bottom.x, bottom.y);
       line(bottom.x, bottom.y, lpos.x, lpos.y);
       
       fill(255);
    //   ellipse(uPoint.x + consts.BARWIDTH/2, leftP.barRef.y, 0.01*width*lerpValue, 0.01*width*lerpValue);
     }

     if (lerpValue > 1) {
       return true;
     }   
     
     return false;
   }
    
   
   private void drawTangents() {
     for(CoreData cd : coreData) {
       float realTheta = cd.endTheta - cd.startTheta;
       float midTheta = cd.startTheta + (realTheta / 2);
       PVector mid = getPoint(midTheta, consts.RAD);
       
       PVector tangent = new PVector(consts.CENT.y - mid.y, mid.x - consts.CENT.x);
       tangent.normalize();
       tangent.mult(cd.scaledHeight*.5);
       PVector endPointN = new PVector(mid.x - tangent.x, mid.y - tangent.y);
       PVector endPointP = new PVector(mid.x + tangent.x, mid.y + tangent.y);
       
       
       line(endPointN.x, endPointN.y, endPointP.x, endPointP.y);
       
       /////////////////////////////////////////////////////////////////////////
       
       
       
       //get lines from endpoints, lerp towards center. will need to make a new end condition.
       //fill(#938422);
       PVector realEndPoint1 = getPoint(cd.startTheta, consts.RAD);
       PVector realEndPoint2 = getPoint(cd.endTheta, consts.RAD);
       
       float rad = consts.RAD;
       PVector cent = consts.CENT;
       
       //???
       
       //get unit vector describing relationship of midpoint to center of circle
       //add some multuple of this unit vector to center to get "center point"
       float sclRad = 1;
       float startTheta = cd.startTheta / (sclRad*rad);
       float endTheta = cd.endTheta / (sclRad*rad);
       PVector r_unit = new PVector(mid.x - consts.CENT.x, mid.y + consts.CENT.y);
       r_unit.normalize();
       PVector sclR = r_unit.mult(sclRad);
 //      ellipse(cent.sub(sclR).x, cent.sub(sclR).y, 20, 20);
       println(endPointN, endPointP);

    //   arc(cent.sub(sclR).x, cent.sub(sclR).y, rad*sclRad, rad*sclRad, startTheta, endTheta);
       

       
       
       
       
       
       
     }
   }
   
   //I think this is all wrong
   private void drawTangentsBad() {
     float bigRad = 1; 
     println("tabgent");
      for(CoreData cd : coreData) {
        float realTheta = cd.endTheta - cd.startTheta;
        float midTheta = cd.startTheta + (realTheta / 2);
        PVector angleUnit = PVector.fromAngle(midTheta);
        
        float startTheta = cd.startTheta / bigRad;
        float endTheta = cd.endTheta / bigRad;
        float cpScalor = bigRad * consts.RAD;
        PVector cpScaled = angleUnit.mult(cpScalor);
        
        println(cpScaled.x,cpScaled.y);
        fill(#157749);
        arc(cpScaled.x,cpScaled.y, bigRad, bigRad, startTheta, endTheta, PIE);
        
        
        
        
        
       //float realTheta = cd.endTheta - cd.startTheta;
       //float midTheta = cd.startTheta + (realTheta / 2);
       
       //PVector midPoint = getPoint(midTheta);
       //PVector tanTop = new PVector(midPoint.x, midPoint.y - (.5*cd.scaledHeight));
       //PVector tanBottom = new PVector(midPoint.x, midPoint.y + (.5*cd.scaledHeight));
       
       //println("top x, y ", tanTop.x, " ", tanTop.y);
       //line(tanTop.x, tanTop.y, tanBottom.x, tanBottom.y);
       
       //PVector tanPoint = getPoint(midTheta);
       
     }
     
   }
   
   
   private void retractLines() {
     
     
   }
   
   private int quadrant(float theta) {
    println("Quadrant theta: ", theta);
    if(theta < PI/2) {
      println("Quadrant 1");
       return 1; 
    } else if(theta < PI) {
      println("Quadrant 2");
      return 2;
    } else if(theta < 1.5*PI) {
      println("Quadrant 3");
      return 3;
    } else {
      println("Quadrant 4");
      return 4;
    }
  }

  private PVector getPoint(float theta, PVector c, float rad) {
    PVector point = new PVector(0,0);

    float cx = c.x;
    float cy = c.y;
    float r = rad;

    if (quadrant(theta) == 1) {
      point.x = cx + r * cos(theta);
      point.y = cy - r * sin(theta);
    } else if(quadrant(theta) == 2) {
      theta = PI - theta;
      point.x = cx - r * cos(theta);
      point.y = cy - r * sin(theta);
    } else if(quadrant(theta) == 3) {
      theta = theta - PI;
      point.x = cx - r * cos(theta);
      point.y = cy + r * sin(theta);
    } else {
      theta = 2*PI - theta;
      point.x = cx + r * cos(theta);
      point.y = cy + r * sin(theta);
    }
    return point;
  }

}
   