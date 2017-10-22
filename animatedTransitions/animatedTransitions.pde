import java.util.List;
import java.util.ArrayList;


Parser parser;
ArrayList<CoreData> coreData;
Constants consts;
LineToBar l2b;

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
  movingLine();

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
    PVector p1 = new PVector(100.0, 100.0);
  PVector p2 = new PVector(500.0, 600.0);
  PVector end;
  for (float i = 1; i > 0; i = i - 0.000005) {
    println(i);
      end = PVector.lerp(p1, p2,i);
      fill(0);
      line(p1.x, p1.y, end.x, end.y); 
          background(255);

  }
 
 }