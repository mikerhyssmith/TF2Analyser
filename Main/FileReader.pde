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
  
  //Processes an array of strings that have been read in from a data file
     public boolean processFile(String[] data) {
        boolean matchCreated = false;
        System.out.println(data.length);
        for (int i = 0; i < data.length; i++) {
          //System.out.println("i" + i);
          synchronized(matches){
            //New match when a new map is detected
            if (data[i].startsWith("Map: ")) {
              String mapName = data[i].substring(5);
              currentMatch = new Match(mapName);
              matchCreated = true;
              matches.add(currentMatch);
            }

            //Detects if a data entry is a kill event
            if (data[i].contains(" killed ") && data[i].contains(" with ")) {
              //Get the time of the event
              int timePosition = data[i].indexOf(": ");
              int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
              int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
              int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
              Time time = new Time(hours,minutes,seconds);
                
              String eventDesc = data[i].substring(timePosition + 2);

              int killedPosition = eventDesc.indexOf(" killed ");
              int withPosition = eventDesc.indexOf(" with ");

              String killer = eventDesc.substring(0, killedPosition);
              String victim = eventDesc.substring(killedPosition + 8,withPosition);
              String weaponName;
              Boolean crit = false;

              if (eventDesc.endsWith("(crit)")) {
                crit = true;
                weaponName = eventDesc.substring(withPosition + 6,eventDesc.length() - 8);
              } else {
                weaponName = eventDesc.substring(withPosition + 6,eventDesc.length()-1);
              }

              KillEvent currentEvent = new KillEvent(time, killer, victim,weaponName, crit);
              currentMatch.addEvent(currentEvent);
            }
            //Detects if a data entry is a defence event
            else if (data[i].contains(" defended ") && data[i].contains(" for team ")) {
                //Get the time of the event
                int timePosition = data[i].indexOf(": ");
                int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
                int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
                int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
                Time time = new Time(hours,minutes,seconds);
                
                String eventDesc = data[i].substring(timePosition + 2);
            
                int defendedPosition = eventDesc.indexOf(" defended ");

            
                String defender = eventDesc.substring(0, defendedPosition);
                String defendedObject = eventDesc.substring(defendedPosition);
              
                DefendEvent currentEvent = new DefendEvent(time,defender,defendedObject);
                System.out.println(defendedObject);
                currentMatch.addEvent(currentEvent);
            }else if(data[i].contains(" captured ")){
              
              //Mr.Sacha[FR], thetitle13, McKlon_347Rs captured the Rocket, Final Cap for team #3
              int timePosition = data[i].indexOf(": ");
                int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
                int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
                int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
                Time time = new Time(hours,minutes,seconds);
                
                String eventDesc = data[i].substring(timePosition + 2);
                int capturedPosition = data[i].indexOf(" captured ");
                System.out.println(capturedPosition);
                
                String capturingPlayers = data[i].substring(timePosition+2, capturedPosition);
                String description = data[i].substring(capturedPosition + 10);
                
                String[] capturingPlayersArray = capturingPlayers.split(",");
                
                CaptureEvent currentEvent = new CaptureEvent(time,capturingPlayersArray,description);
                currentMatch.addEvent(currentEvent);
              
            }
          }
        }
        return false;
      }
  public String[] getData() {
    String[] newArray = new String[data.length];
    for(int i = 0; i< data.length; i++){
       newArray[i] = data[i]; 
    }
    return newArray ;
  }
  
  public ArrayList<Match> getMatches(){
    return new ArrayList<Match>(matches);
  }
}
