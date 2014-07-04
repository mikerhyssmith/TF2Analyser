import java.util.ArrayList;
import java.util.Hashtable;

class DataProcessor {

  ArrayList<Match> matches;
  Hashtable<String, DeathCount> deaths;

  public DataProcessor(ArrayList<Match> matches) {
    this.matches = matches;
  }

  public Hashtable<String, DeathCount> getDeaths(String playerName) {
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    deaths = new Hashtable<String, DeathCount>();

    for (int i = 0; i < matches.size(); i++) {

      currentMatch = matches.get(i);
      currentEvents = currentMatch.getEvents();

      for (int j = 0; j < currentMatch.getEvents().size(); j++) {
        currentEvent = currentEvents.get(j);
        if (currentEvent.getEventType().equals(EventTypes.KILL)) {
          KillEvent kill = (KillEvent) currentEvent;
          if (kill.getVictim().equalsIgnoreCase(playerName)) {
            if (deaths.containsKey(kill.getWeapon())) {
              DeathCount count = deaths.get(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
            } else {
              DeathCount count = new DeathCount(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
              deaths.put(kill.getWeapon(), count);
            }

          }
        }
      }

    }

    return deaths;
  }
  
  public Hashtable<String, DeathCount> getMatchDeaths(int matchNumber) {
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    deaths = new Hashtable<String, DeathCount>();

      currentMatch = matches.get(matchNumber);
      currentEvents = currentMatch.getEvents();

      for (int j = 0; j < currentMatch.getEvents().size(); j++) {
        currentEvent = currentEvents.get(j);
        if (currentEvent.getEventType().equals(EventTypes.KILL)) {
          KillEvent kill = (KillEvent) currentEvent;
            if (deaths.containsKey(kill.getWeapon())) {
              DeathCount count = deaths.get(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
            } else {
              DeathCount count = new DeathCount(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
              deaths.put(kill.getWeapon(), count);
            }
        }
      }

    return deaths;
  }
  
  public String[] getMatchPlayers(int match){
    
    
  }
  
  

}
