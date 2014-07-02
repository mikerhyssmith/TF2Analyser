import java.util.*;
import java.sql.Time;

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
        
        int timePosition = data[i].indexOf(": ");
        Time time = new Time(Integer.valueOf(data[i].substring(timePosition-8, timePosition-6)), 
                              Integer.valueOf(data[i].substring(timePosition-5, timePosition-3)),
                              Integer.valueOf(data[i].substring(timePosition-2, timePosition)));
        
        String eventDesc =  data[i].substring(timePosition+2);
        
        int killedPosition = eventDesc.indexOf(" killed ");
        int withPosition = eventDesc.indexOf(" with ");
        
        String killer = eventDesc.substring(0,killedPosition);
        String victim = eventDesc.substring(killedPosition+8, withPosition);
        String weaponName;
        Boolean crit;
        
        if(eventDesc.endsWith("(crit)"){
          crit=true;
          weaponName = eventDesc.substring(withPosition+6, eventDesc.length -6); 
        }
        else{
          weaponName = eventDesc.substring(withPosition+6);
        }
        
        KillEvent currentEvent = new KillEvent(time,killer,victim,weaponName,crit);
      }
    }
    return false;
  }
  
  
  public String[] getData(){
    return data;
  }
}
