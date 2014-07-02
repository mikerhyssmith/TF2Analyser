class FileReader {
  
  String[] data;
  ArrayList<Match> matches;
  Match currentMatch;


  public FileReader(String fileName){
    
    data = loadStrings(fileName);
    matches = new ArrayList<Match>();
  }
  
  public boolean processFile(String[] data){
    boolean matchCreated = false;
    
    for(int i =0; i < data.length; i++)
    {
      //New Match
      if(data[i].startsWith("Map: ")){
        if(matchCreated){
          matches.add(currentMatch);
        }
        
        String mapName = data[i].substring(5);
        currentMatch = new Match(mapName);
        matchCreated = true;
      }
      
      //Kills
      if(data[i].contains(" killed ") && data[i].contains(" with ")){
        
        
        
      }
      
      
    }
    return false;
  }
  
  
  public String[] getData(){
    return data;
  }
}
