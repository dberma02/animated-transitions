import java.util.List;
import java.util.ArrayList;


Parser parser;
ArrayList<CoreData> coreData;
Constants consts;
LineToBar l2b;
BarToPie b2p;
Button line, bar, pie;

// stages
static int LINE_GRAPH = 0;
static int RETRACTING_LINES = 1;
static int DRAWING_TOPS = 2;
static int DRAWING_VERT_LINES = 3;
static int FILLING_BARS = 4;
static int BAR_GRAPH = 5;
static int UNFILLING_BARS = 6;
static int RETRACTING_VERT_LINES = 7;
static int RETRACTING_TOPS = 8;
static int DRAWING_LINES = 9;

static int CONSOLIDATE_BARS = 10;
static int SCALE_LINES = 11;
static int MOVE_TO_TANGENT = 12;
//static int SMOOTH_CIRCLE = 13;
static int DRAW_SLICES = 13;
static int PIE_CHART = 14;


void setup() {
  size(1200,700);
  frameRate(30);
  background(255);
  pixelDensity(displayDensity());
  
  consts = new Constants();
  
  parser = new Parser(consts);
  coreData = parser.parse("dataSmall.csv");
  coreData = parser.populateCartesian(coreData);
 
  l2b = new LineToBar(coreData, consts);
  b2p = new BarToPie(coreData, consts);
  
  b2p.drawTangents();
 //  b2p.drawArcs();
 // b2p.newCenter();
  b2p.drawWedges();



  fill(0);

}

int iteration=0;
int stage = BAR_GRAPH;
//int stage = CONSOLIDATE_BARS;
boolean transitionToBar = false;
boolean transitionToLine = false;
boolean transitionToPie = false;
void draw() {
  
  
  if (stage == LINE_GRAPH) {
    background(255);    
    l2b.renderLineGraph();
  } else if (stage == BAR_GRAPH) {
    background(255);
    l2b.renderBarGraph();
  }
  
  if (transitionToBar) {
    goToBar();
  }
  
  if (transitionToLine) {
    goToLine();
  }
  
  if (transitionToPie) {
    goToPie();
  }
  
  drawGraphButtons();
  checkHighlight();
 
}

void goToBar() {
  
  boolean stageComplete = false;
  if (stage == RETRACTING_LINES) {
    stageComplete = l2b.retractLines(iteration);
  } else if (stage == DRAWING_TOPS) {
    background(255);
    stageComplete = l2b.drawBarTops(iteration);
  } else if (stage == DRAWING_VERT_LINES) {
    stageComplete = l2b.drawVertLines(iteration);
  } else if (stage == FILLING_BARS) {
    stageComplete = l2b.drawRects(iteration);
  }
  
  if (stageComplete) {
    stage++;
    if (stage == BAR_GRAPH) {
      transitionToBar = false;
      iteration = coreData.size()-1;
    } else {
      iteration = 0;
    }
  } else {
    iteration++;
  }
}

//make hollow bars
//retract vert lines
//retratct bar tops
//redraw line graph
void goToLine() {
  
  boolean stageComplete = false;
  int nextStartIteration = 0;
  if (stage == UNFILLING_BARS) {
    stageComplete = unfillBars();
    nextStartIteration = 111;
  } else if (stage == RETRACTING_VERT_LINES) {
    stageComplete = retractVertLines();
    nextStartIteration = 51; 
  } else if (stage == RETRACTING_TOPS) {
    stageComplete = retractTops();
    nextStartIteration = 50;
  } else if (stage == DRAWING_LINES) {
    stageComplete = redrawLineGraph();
  }
  
  if (stageComplete) {
    if (stage == DRAWING_LINES) {
      stage = LINE_GRAPH;
      transitionToLine = false;
    } else {
      stage++;
      iteration = nextStartIteration;
    }
  } else {
    iteration--;
  }
}

void goToPie() {
     if (stage == UNFILLING_BARS) {
        if (unfillBars()) {
          stage = CONSOLIDATE_BARS;
          iteration = 50;
        } else {
          iteration--;
        }
     }
     if (stage == CONSOLIDATE_BARS) {
       println("inside");
       background(255);
       l2b.drawBarTops(iteration);
       boolean completeStage = b2p.consolidateBars(iteration);
       iteration--;
       
       if (completeStage) {
         stage++;
         iteration = 0;
       }
     }
     
     if (stage == SCALE_LINES) {
       background(255);
       boolean completeStage = b2p.scaleLines(iteration);
       iteration ++;
       
       if (completeStage) {
         stage++;
         iteration = 0;
       }
     }
     
     if (stage == MOVE_TO_TANGENT) {
       background(255);
       boolean completeStage = b2p.moveToTangent(iteration);
       iteration++;
       
       if (completeStage) {
         stage++;
         iteration = 0;
       }
     }
     
     if (stage == DRAW_SLICES) {
       boolean completeStage = b2p.drawSlices(iteration);
       iteration++;
       
       if (completeStage)
         stage++;
     } 
     
    //hollow out bars
    //bring lines together to create single vertical lines
    //scale lines
    //reposition lines to be tangent to "circle"
    //curve arcs to make circle
    //create slice lines
}



boolean unfillBars() {
  if (iteration >= 0) {
    background(255);    
    for (int i = 0; i < iteration; i++) {
      l2b.drawRects(i);  
    }
    for (int i = iteration; i < coreData.size(); i++) {
      l2b.drawBarTops(51);
      l2b.drawVertLines(111);     
    }
  } else {
    return true;
  }
  
  return false;
}

boolean scaleLines() {
  if (iteration >= 0) {
    background(255);    
    b2p.scaleLines(iteration);
  } else {  
    return true;
  }
  
  return false;
}

boolean retractVertLines() {
    background(255);
    l2b.drawBarTops(51);
    if (iteration >= 0) {
      l2b.drawVertLines(iteration);
    } else {
      return true;
    }
    
    return false;
}

boolean retractTops() {
  if (iteration >= 0) {
    background(255);    
    l2b.drawBarTops(iteration);
  } else {  
    return true;
  }
  
  return false;
}

boolean redrawLineGraph() {
  if (iteration >= 0) {
    background(255);
    l2b.retractLines(iteration);
  } else {
    return true;
  }
  
  return false;
  
}

void mouseClicked() {
  if (bar.isClicked() && stage == LINE_GRAPH) {
    transitionToBar = true;
    stage = RETRACTING_LINES;
  }
  
  if (pie.isClicked() && stage == BAR_GRAPH) {
    iteration = coreData.size()-1;
    transitionToPie = true;
    stage = UNFILLING_BARS;
  }
  
  if (line.isClicked() && stage == BAR_GRAPH) {
    iteration = coreData.size()-1;
    transitionToLine = true;
    stage = UNFILLING_BARS;
  }
  
}

void drawGraphButtons() {
  fill(255);
  
  float boxX = consts.OFFSET;
  float boxY =  height - consts.OFFSET*3.5;
  float boxWidth = width - consts.OFFSET*2;
  float boxHeight = consts.OFFSET*3;
  
  int boxOffset = 20;
  
  //button box
  rect(boxX, boxY, boxWidth, boxHeight);
  
  line = new Button(int(boxX + boxOffset + 15), int(boxY + boxOffset), 200, 70, 
                    color(240), "Line Graph", 12);
  line.render();
  
  bar = new Button(int(boxX + (boxOffset + 15) * 2 + 400), int(boxY + boxOffset), 200, 70, 
                   color(240), "Bar Graph", 12);
  bar.render();
  
  pie = new Button(int(boxX + (boxOffset + 15) * 2 + 400*2 + 20), int(boxY + boxOffset), 200, 70, 
                   color(240), "Pie Graph", 12);
  pie.render();
}

void checkHighlight() {
  if (stage == BAR_GRAPH) {
    highlightBars();
  } else if (stage == LINE_GRAPH) {
    highlightPoints();
  } else if (stage == PIE_CHART) {
    highlightSlices();
  } 
}

void highlightBars() {
  for (CoreData cd : coreData) {
    if (mouseX >= cd.barRef.x && mouseX <= (cd.barRef.x + consts.BARWIDTH) && 
        mouseY >= cd.barRef.y && mouseY <= consts.CHARTBOTTOM) {
          fill(186, 149, 233);   
          rect(cd.barRef.x, cd.barRef.y, consts.BARWIDTH, consts.CHARTBOTTOM-cd.barRef.y);
          fill(0);
          text("(" + cd.xValueRaw + ", " + cd.yValueRaw + ")", mouseX, mouseY-10);          
        }
  }
}

void highlightPoints() {
  for (CoreData cd : coreData) {
    if (dist(mouseX, mouseY, cd.barRef.x+consts.BARWIDTH/2, cd.barRef.y) < 0.01*width) {
      fill(186, 149, 233);
      ellipse(cd.barRef.x + (consts.BARWIDTH/2), cd.barRef.y, 0.01*width, 0.01*width);
      fill(0);
      text("(" + cd.xValueRaw + ", " + cd.yValueRaw + ")", mouseX, mouseY-10);        
    }
  } 
}


void highlightSlices() {
  for (CoreData cd : coreData) {
    
    
  }
  
}