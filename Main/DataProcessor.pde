import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.*;
class DataProcessor {

  ArrayList<Match> matches;
  Hashtable<String, DeathCount> deaths;

  public DataProcessor(ArrayList<Match> matches) {
    System.out.println("Entered DataProcessor");
    synchronized(matches){
    this.matches = new ArrayList(matches);
    }
  }

  public Hashtable<String, DeathCount> getDeaths(String playerName , int match) {
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    deaths = new Hashtable<String, DeathCount>();
    if(match == -1){
      synchronized(matches){
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
    }
    
    }else{
       currentMatch = matches.get(match);
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
  
  public  Hashtable<String, DeathCount> getMatchDeaths(int matchNumber) {
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    deaths = new Hashtable<String, DeathCount>();

      currentMatch = matches.get(matchNumber);
      currentEvents = currentMatch.getEvents();
      synchronized(matches){
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
      }
    return deaths;
  }
  
  public  Hashtable<String, DeathCount> getAllDeaths() {
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;
    deaths = new Hashtable<String, DeathCount>();
    
    for(int i =0; i< matches.size(); i++){
      currentMatch = matches.get(i);
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
    }
  return deaths;
 }

  
  public String[] getMatchPlayers(int match){
    
    synchronized(matches){
    List<String> matchPlayers = new ArrayList<String>();
    Match currentMatch = matches.get(match);
    ArrayList<Event> matchEvents = currentMatch.getEvents();
    for(int i = 0; i< matchEvents.size(); i++){
      Event currentEvent = matchEvents.get(i);
      if (currentEvent.getEventType().equals(EventTypes.KILL)) {
        KillEvent kill = (KillEvent) currentEvent;
        String nameOne = kill.getKiller();
        String nameTwo = kill.getVictim();
        if(!matchPlayers.contains(nameOne)){
          matchPlayers.add(nameOne);
        }
        if(!matchPlayers.contains(nameTwo)){
          matchPlayers.add(nameTwo);
        }
     }
    }
    
    Iterator<String> it = matchPlayers.iterator();
    String[] players = new String[matchPlayers.size()];
    int counter = 0;
    while(it.hasNext()){
      players[counter] = it.next();
      counter++;
      
    }
    
    return players;
    }
  }
  

}
