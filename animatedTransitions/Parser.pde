/*
 * Parser class 
 * Dan Berman & Dani Kupfer
 *
 */
 
 class Parser {
   Constants consts;
   float maxValue;
   float totalValue;
   
   public Parser(Constants consts) {
     this.consts = consts;
   }
   
   public ArrayList parse(String file) {
     String[] lines = loadStrings(file);
     String[] headers = split(lines[0], ",");
     
//     int numLines = lines.length-1;
     int numLines = lines.length;
     ArrayList<CoreData> coreInfo = new ArrayList<CoreData>();
     
     maxValue = Integer.MIN_VALUE;
     totalValue = 0;
     
     //Why does num lines not work on small dataset??
     println("numLines: ",numLines);
     for (int i = 1; i < numLines; i++) {
     //for (int i = 1; i < 5; i++) {
       String[] data = split(lines[i], ",");
       CoreData cd = new CoreData(data[0], float(data[1]));
       
       totalValue += float(data[1]);
       
       if (maxValue < float(data[1])) {
         maxValue = float(data[1]);
       }
       
       coreInfo.add(cd);
     }
     
     return coreInfo;
   }
   
   public ArrayList populateCartesian(ArrayList<CoreData> coreData) {
     int size = coreData.size();
  
     float barWidth = consts.CHARTWIDTH/(size * 2 + 1);
     consts.setBarWidth(barWidth);
     
     float startTheta = 0;
     
     println(totalValue);
     int totalBarHeight = 0;
     int i = 0;
     for (CoreData cd : coreData) {
       float barX = consts.OFFSET + barWidth + barWidth*2*i;
       float barY = consts.CHARTBOTTOM - (cd.yValueRaw * (consts.CHARTHEIGHT)/maxValue);
       cd.barRef = new PVector(barX, barY); 
       
       float barHeight = height - barY - consts.OFFSET;
       println("barHeight: ", barHeight);
       println("height: ", height, "BarY ", barY, "offset: ", consts.OFFSET);
       totalBarHeight += barHeight;
       
       
       cd.endTheta = startTheta + cd.yValueRaw * 2 * PI / totalValue;   
       cd.startTheta = startTheta;
       startTheta = cd.endTheta;
       //need to make them out of total value  
       
       i++;
     }
     println("totalHeight ", totalBarHeight);
      consts.SCALOR = (2*PI*consts.RAD) / totalBarHeight;
      
     for (CoreData cd : coreData) {
       PVector unscaledTop = new PVector(cd.barRef.x + consts.BARWIDTH/2, cd.barRef.y);
       float unscaledHeight = height - cd.barRef.y - consts.OFFSET;
       cd.scaledHeight = unscaledHeight * consts.SCALOR;
       float bottom = unscaledTop.y + unscaledHeight;
       cd.scaledLineRef = new PVector(unscaledTop.x, bottom - cd.scaledHeight);
//       cd.scaledLineRef = new PVector(unscaledTop.x, scaledTop.y)
     }
      println("SCALOR: ", consts.SCALOR, " CIRC: ", (2*PI*consts.RAD));
      println("totalHeight: ", totalBarHeight);
     
     return coreData;
   }
   
   public ArrayList populatePolar(ArrayList<CoreData> coreData) {
     return coreData;
   } 
 }