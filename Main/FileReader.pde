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
  
 public boolean processFile(String[] data) {

    for (int i = 0; i < data.length; i++) {
      // New Match
      if (data[i].startsWith("Map: ")) {
       
        String mapName = data[i].substring(5);
        currentMatch = new Match(mapName);
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
      }
    }
    matches.add(currentMatch);
    return false;
  }

  public String[] getData() {
    return data;
  }
  public ArrayList<Match> getMatches(){
    return matches;
  }
  
  
  
}
