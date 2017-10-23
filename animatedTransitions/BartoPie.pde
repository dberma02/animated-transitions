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
   
   private void drawPositionedLines() {
     for(CoreData cd : coreData) {
       float realTheta = cd.endTheta - cd.startTheta;
       float midTheta = cd.startTheta + (realTheta / 2);
       
       PVector midPoint = getPoint(midTheta);
       PVector tanTop = new PVector(midPoint.x, midPoint.y - (.5*cd.scaledHeight));
       PVector tanBottom = new PVector(midPoint.x, midPoint.y + (.5*cd.scaledHeight));
       
       println("top x, y ", tanTop.x, " ", tanTop.y);
       line(tanTop.x, tanTop.y, tanBottom.x, tanBottom.y);
       
       PVector tanPoint = getPoint(midTheta);
       
     }
   }
   
   public boolean consolidateBars(int iteration) {
     float lerpValue = 1;
     for (CoreData data : coreData) {
       PVector topLeft = new PVector(data.barRef.x, data.barRef.y);
       PVector topRight = new PVector(data.barRef.x + consts.BARWIDTH, data.barRef.y);
       PVector bottomLeft = new PVector(data.barRef.x, 
                                        consts.CHARTBOTTOM);
       PVector bottomRight = new PVector(data.barRef.x + consts.BARWIDTH, 
                                        consts.CHARTBOTTOM);   
       PVector midTop = new PVector (data.barRef.x + consts.BARWIDTH/2, data.barRef.y);
                                        
       lerpValue = 1- iteration *.02;                               
       PVector left = PVector.lerp(topLeft, midTop, lerpValue);
       PVector right = PVector.lerp(topRight, midTop, lerpValue);
         
       line(left.x, topLeft.y, left.x, bottomLeft.y);
       line(right.x, topRight.y, right.x, bottomRight.y);
     }
     
     if (lerpValue <= 0) {
       return true;
     }
     
     return false;
   }
   
   public boolean scaleLines(int iteration) {
     background(255);
     drawAxes();
     float lerpValue = 0; 
     for (CoreData cp: coreData) {       
       PVector uPoint = new PVector(cp.barRef.x + (consts.BARWIDTH/2), cp.barRef.y);
       //lerp towards scaled line ref
       PVector bottom = new PVector(cp.barRef.x + (consts.BARWIDTH/2), consts.CHARTBOTTOM);
       
       lerpValue = iteration*.008;
       PVector lpos = PVector.lerp(uPoint, cp.scaledLineRef, lerpValue);

       line(bottom.x, bottom.y, lpos.x, lpos.y);
       println("lerp: " + lerpValue);
       
       fill(255);
     }

     if (lerpValue > 1) {
       return true;
     }   
     
     return false;
   }
   
   public boolean moveToTangent(int iteration) {
     float lerpValue = 0;
     for (CoreData cd : coreData) {
       float realTheta = cd.endTheta - cd.startTheta;
       float midTheta = cd.startTheta + (realTheta / 2);
       PVector mid = b2p.getPoint(midTheta);
       
       PVector tangent = new PVector(consts.CENT.y - mid.y, mid.x - consts.CENT.x);
       tangent.normalize();
       tangent.mult(cd.scaledHeight*.5);
       PVector endPointN = new PVector(mid.x - tangent.x, mid.y - tangent.y);
       PVector endPointP = new PVector(mid.x + tangent.x, mid.y + tangent.y);  
         
       PVector beginTop = new PVector(cd.barRef.x + consts.BARWIDTH/2, cd.scaledLineRef.y);
       PVector beginBottom = new PVector(cd.barRef.x + consts.BARWIDTH/2, consts.CHARTBOTTOM);
         
       lerpValue = iteration*.007;
       PVector top = PVector.lerp(beginTop, endPointN, lerpValue);        
       PVector bottom = PVector.lerp(beginBottom, endPointP, lerpValue);
       
       line(top.x, top.y, bottom.x, bottom.y);  
     }
     
     if (lerpValue > 1) {
       return true;
     }
     
     return false;
   }
   
   public boolean drawSlices(int iteration) {
     float lerpValue = 0;
     for (CoreData cd : coreData) {
       PVector p1 = b2p.getPoint(cd.startTheta);
       PVector p2 = b2p.getPoint(cd.endTheta);
         
       lerpValue = iteration*0.06;
       PVector line1 = PVector.lerp(consts.CENT, p1, lerpValue);
       PVector line2 = PVector.lerp(consts.CENT, p2, lerpValue);
         
       line(consts.CENT.x, consts.CENT.y, line1.x, line1.y);
       line(consts.CENT.x, consts.CENT.y, line2.x, line2.y);
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
       PVector mid = getPoint(midTheta);
       
       PVector tangent = new PVector(consts.CENT.y - mid.y, mid.x - consts.CENT.x);
       tangent.normalize();
       tangent.mult(cd.scaledHeight*.5);
       PVector endPointN = new PVector(mid.x - tangent.x, mid.y - tangent.y);
       PVector endPointP = new PVector(mid.x + tangent.x, mid.y + tangent.y);
       
       
       line(endPointN.x, endPointN.y, endPointP.x, endPointP.y);
       
       /////////////////////////////
       //get lines from endpoints, lerp towards center. will need to make a new end condition.
       //fill(#938422);
       PVector realEndPoint1 = getPoint(cd.startTheta);
       PVector realEndPoint2 = getPoint(cd.endTheta);
       
       float rad = consts.RAD;
       PVector cent = consts.CENT;
       
       //???
       
       //get unit vector describing relationship of midpoint to center of circle
       //add some multuple of this unit vector to center to get "center point"
       float sclRad = 100;
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
   