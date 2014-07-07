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
  
  public synchronized boolean processFile(String[] data) {
    boolean matchCreated = false;

    for (int i = 0; i < data.length; i++) {
      
      synchronized(matches){
      // New Match
      if (data[i].startsWith("Map: ")) {

        String mapName = data[i].substring(5);
        System.out.println("Map Name: " + mapName);
        currentMatch = new Match(mapName);
        matchCreated = true;
        matches.add(currentMatch);
      }

      // Kills
      if (data[i].contains(" killed ") && data[i].contains(" with ")) {

        int timePosition = data[i].indexOf(": ");
        int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
        int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
        int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
        Time time = new Time(hours,minutes,seconds);
            

        String eventDesc = data[i].substring(timePosition + 2);

        int killedPosition = eventDesc.indexOf(" killed ");
        int withPosition = eventDesc.indexOf(" with ");

        String killer = eventDesc.substring(0, killedPosition);
        String victim = eventDesc.substring(killedPosition + 8,
            withPosition);
        String weaponName;
        Boolean crit = false;

        if (eventDesc.endsWith("(crit)")) {
          crit = true;
          weaponName = eventDesc.substring(withPosition + 6,
              eventDesc.length() - 8);
        } else {
          weaponName = eventDesc.substring(withPosition + 6,eventDesc.length()-1);
        }

        KillEvent currentEvent = new KillEvent(time, killer, victim,
            weaponName, crit);
        currentMatch.addEvent(currentEvent);
      }else  if (data[i].contains(" defended ") && data[i].contains(" for team ")) {
            
        int timePosition = data[i].indexOf(": ");
        int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
        int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
        int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
        Time time = new Time(hours,minutes,seconds);
            
        String eventDesc = data[i].substring(timePosition + 2);
        
        int defendedPosition = eventDesc.indexOf(" defended ");
        int teamPosition = eventDesc.indexOf(" for ");
        
        String defender = eventDesc.substring(0, defendedPosition);
        String team = eventDesc.substring(teamPosition + 5);
        String defendedObject = eventDesc.substring(defendedPosition+14, teamPosition);
        
        DefendEvent currentEvent = new DefendEvent(time,defender,defendedObject,team);
        currentMatch.addEvent(currentEvent);
        }
    }
   }
    return false;
  }


  public String[] getData() {
    return data;
  }
  public synchronized ArrayList<Match> getMatches(){
    System.out.println("Number of Matches " + matches.size());
    return  matches;
  }
  
  
  
}
