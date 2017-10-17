import java.util.List;
import java.util.ArrayList;


Parser parser;
ArrayList<CoreData> coreData;

void setup() {
  parser = new Parser();
  coreData = parser.parse("data.csv");
  
  size(800,600);
}


void draw() {
  
}