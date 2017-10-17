/*
 * Parser class 
 * Dan Berman & Dani Kupfer
 *
 */
 
 class Parser {
   
   public Parser() {
   }
   
   
   public ArrayList parse(String file) {
     String[] lines = loadStrings(file);
     String[] headers = split(lines[0], ",");
     
     int numLines = lines.length-1;
     ArrayList<CoreData> coreInfo = new ArrayList<CoreData>();
     
     for (int i = 1; i < numLines; i++) {
       String[] data = split(lines[i], ",");
       CoreData cd = new CoreData(data[0], float(data[1]));
       coreInfo.add(cd);
     }
     
     return coreInfo;
   
   }
 }