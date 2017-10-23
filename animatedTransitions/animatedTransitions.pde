import java.util.List;
import java.util.ArrayList;


Parser parser;
ArrayList<CoreData> coreData;
Constants consts;
LineToBar l2b;
BarToPie b2p;

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


void setup() {
  size(1200,700);
  frameRate(30);
  background(255);
  pixelDensity(displayDensity());
  
  consts = new Constants();
  
  parser = new Parser(consts);
  coreData = parser.parse("data.csv");
  coreData = parser.populateCartesian(coreData);
 
  l2b = new LineToBar(coreData, consts);
  b2p = new BarToPie(coreData, consts);
  
  //b2p.drawArcs();
  //b2p.drawWedges();
  b2p.drawPositionedLines();
  b2p.drawTangents();

  fill(0);

}

int iteration=0;
int stage = LINE_GRAPH;
//int stage = CONSOLIDATE_BARS;
boolean transitionToBar = false;
boolean transitionToLine = false;
boolean transitionToPie = false;
void draw() {
  
  
  if (stage == LINE_GRAPH) {
    l2b.renderLineGraph();
  }
  
  if (transitionToBar) {
    goToBar();
  }
  
  if (transitionToLine) {
    goToLine();
  }
  
  if (transitionToPie) {
     if (stage == UNFILLING_BARS) {
        if (unfillBars()) {
          stage = CONSOLIDATE_BARS;
          iteration = 51;
        }
        iteration--;
     }
     if (stage == CONSOLIDATE_BARS) {
       background(255);
       l2b.drawBarTops(iteration);
       for (CoreData data : coreData) {
         PVector topLeft = new PVector(data.barRef.x, data.barRef.y);
         PVector topRight = new PVector(data.barRef.x + consts.BARWIDTH, data.barRef.y);
         PVector bottomLeft = new PVector(data.barRef.x, 
                                        consts.CHARTBOTTOM);
         PVector bottomRight = new PVector(data.barRef.x + consts.BARWIDTH, 
                                        consts.CHARTBOTTOM);   
         PVector midTop = new PVector (data.barRef.x + consts.BARWIDTH/2, data.barRef.y);
                                        
         float lerpValue = 1- iteration *.02;                               
         PVector left = PVector.lerp(topLeft, midTop, lerpValue);
         PVector right = PVector.lerp(topRight, midTop, lerpValue);
         
         line(left.x, topLeft.y, left.x, bottomLeft.y);
         line(right.x, topRight.y, right.x, bottomRight.y);
       }
       iteration--;
       
       if (iteration < 0) {
         stage++;
       }
     }
     if (stage == SCALE_LINES) {
       //start points are middle
       
       for (CoreData cd : coreData) {
         PVector unscaledTop = new PVector(cd.barRef.x + consts.BARWIDTH/2, cd.barRef.y);
         //float unscaledHeight = height - cd.barRef.y - consts.OFFSET;
         //float scaledHeight = unscaledHeight * consts.SCALOR;
         //PVector bottom = new PVector(unscaledTop.x, unscaledTop.y + unscaledHeight);
         //PVector scaledTop = new PVector(unscaledTop.x, bottom.y - scaledHeight);
         
         float lerpValue = iteration *.02;                               
         PVector Ltop = PVector.lerp(unscaledTop, cd.scaledLineRef, lerpValue);
         
        line(Ltop.x, Ltop.y, cd.scaledLineRef.x, cd.scaledLineRef.y);

         //Points just for reference
         fill(#166809);
         ellipse(unscaledTop.x, unscaledTop.y, 10, 10);
         ellipse(cd.scaledLineRef.x, cd.scaledLineRef.y, 10, 10);
         
       }
       iteration --;
       
       if (iteration < 0) {
         stage++;
         iteration = 100;
       }
     }
     
    //hollow out bars
    //bring lines together to create single vertical lines
    //scale lines
    //reposition lines to be tangent to "circle"
    //curve arcs to make circle
    //create slice lines
  }
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
  if (stage == LINE_GRAPH) {
    transitionToBar = true;
    stage = RETRACTING_LINES;
  }
  
  if (stage == BAR_GRAPH) {
    iteration = coreData.size()-1;
    transitionToPie = true;
    stage = UNFILLING_BARS;
  }
  
}