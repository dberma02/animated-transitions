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
     
     int numLines = lines.length;
     ArrayList<CoreData> coreInfo = new ArrayList<CoreData>();
     
     maxValue = Integer.MIN_VALUE;
     totalValue = 0;
     for (int i = 1; i < numLines; i++) {
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
     
     int i = 0;
     for (CoreData cd : coreData) {
       float barX = consts.OFFSET + barWidth + barWidth*2*i;
       float barY = consts.CHARTBOTTOM - (cd.yValueRaw * (consts.CHARTHEIGHT)/maxValue);
       cd.barRef = new PVector(barX, barY); 

       cd.endTheta = startTheta + cd.yValueRaw * 2 * PI / totalValue;
       cd.startTheta = startTheta;
       startTheta = cd.endTheta;
       
       i++;
     }
     return coreData;
   }
 
 
   public ArrayList populatePolar(ArrayList<CoreData> coreData) {
     return coreData;
   }
}