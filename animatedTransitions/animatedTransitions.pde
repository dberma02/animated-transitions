import java.util.List;
import java.util.ArrayList;


Parser parser;
ArrayList<CoreData> coreData;
Constants consts;
LineToBar l2b;
BarToPie b2p;

void setup() {
  size(1200,700);
  pixelDensity(displayDensity());
  
  consts = new Constants();
  
  parser = new Parser(consts);
  coreData = parser.parse("data.csv");
  coreData = parser.populateCartesian(coreData);
  
  for (CoreData cd : coreData) {
    println(cd.barRef.x + " " + cd.barRef.y);
  }
  
  l2b = new LineToBar(coreData, consts);
  b2p = new BarToPie(coreData, consts);
  movingLine();
  b2p.drawArcs();
  b2p.drawWedges();

}


void draw() {
/*  for (CoreData cd : coreData) {
           fill(255);
           ellipse(cd.barRef.x + (consts.BARWIDTH/2), cd.barRef.y, 0.01*width, 0.01*width);
    rect(cd.barRef.x, cd.barRef.y, consts.BARWIDTH, consts.CHARTBOTTOM - cd.barRef.y);
  } */
  
  l2b.renderLineGraph();
  

  
}
 
 
 public void movingLine() {

 }