import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.*;

class DataProcessor {

  ArrayList<Match> matches;
  Hashtable<String, DeathCount> deaths;

  public DataProcessor(ArrayList<Match> matches) {
    synchronized(matches){
    this.matches = new ArrayList(matches);
    }
  }

  //Returns deaths of one player in a match, or deaths of one player in all matches if match = -1
  public Hashtable<String, DeathCount> getDeaths(String playerName , int match){
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    deaths = new Hashtable<String, DeathCount>();
    
    //If no match is selected (by passing match=-1), return deaths from all matches
    if(match == -1){
      synchronized(matches){
        //Iterate through all matches
        for (int i = 0; i < matches.size(); i++) {
          currentMatch = matches.get(i);
          currentEvents = currentMatch.getEvents();
          //Iterate through all events in current match
          for (int j = 0; j < currentMatch.getEvents().size(); j++) {
            currentEvent = currentEvents.get(j);
            //Event is only relevent if it is a kill
            if (currentEvent.getEventType().equals(EventTypes.KILL)) {
              KillEvent kill = (KillEvent) currentEvent;
              
              //If no player is selected, return all deaths
              if(playerName.equals("")){
                //If the weapon involved has already been added, just increment kill/crit counter
                if (deaths.containsKey(kill.getWeapon())) {
                  DeathCount count = deaths.get(kill.getWeapon());
                  if (kill.getCrit()) {
                    count.addCrit();
                  } else {
                    count.addDeath();
                  }
                } 
                //Otherwise, add a new death to the hashtable
                else {
                  DeathCount count = new DeathCount(kill.getWeapon());
                  if (kill.getCrit()) {
                    count.addCrit();
                  } else {
                    count.addDeath();
                  }
                  deaths.put(kill.getWeapon(), count);
                }
                
              }
              //Otherwise, return deaths of chosen player
              else {
                //Kill is only relevent if the victim is the chosen player
                if (kill.getVictim().equalsIgnoreCase(playerName)) {
                  //If the weapon involved has already been added, just increment kill/crit counter
                  if (deaths.containsKey(kill.getWeapon())) {
                    DeathCount count = deaths.get(kill.getWeapon());
                    if (kill.getCrit()) {
                      count.addCrit();
                    } else {
                      count.addDeath();
                    }
                  } 
                  //Otherwise, add a new death to the hashtable
                  else {
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
      }
    }
    //Otherwise, return deaths only from the chosen match
    else{
      currentMatch = matches.get(match);
      currentEvents = currentMatch.getEvents();
      //Iterate through all events in the chosen match
      for (int j = 0; j < currentMatch.getEvents().size(); j++) {
        currentEvent = currentEvents.get(j);
        //Event is only relevent if it is a kill
        if (currentEvent.getEventType().equals(EventTypes.KILL)) {
          KillEvent kill = (KillEvent) currentEvent;

          //If no player is selected, return all deaths from the chosen match
          if(playerName.equals("")){
            //If the weapon involved has already been added, just increment kill/crit counter
            if (deaths.containsKey(kill.getWeapon())) {
              DeathCount count = deaths.get(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
            } 
            //Otherwise, add a new death to the hashtable
            else {
              DeathCount count = new DeathCount(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
              deaths.put(kill.getWeapon(), count);
            }      
          }
          //Otherwise, return deaths of chosen player
          else{
            //Kill is only relevent if the victim is the chosen player
            if (kill.getVictim().equalsIgnoreCase(playerName)) {
              //If the weapon involved has already been added, just increment kill/crit counter
              if (deaths.containsKey(kill.getWeapon())) {
                DeathCount count = deaths.get(kill.getWeapon());
                if (kill.getCrit()) {
                  count.addCrit();
                } else {
                  count.addDeath();
                }
              } 
              //Otherwise, add a new death to the hashtable
              else {
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
    return deaths;
  }
  
  
  //Returns all players in a given match
  public String[] getMatchPlayers(int match){  
    synchronized(matches){
      List<String> matchPlayers = new ArrayList<String>();
      ArrayList<Event> matchEvents = new ArrayList<Event>();
      
      //If a match is selected, get the events from it
      if(match !=-1){
        Match currentMatch = matches.get(match);
        matchEvents = currentMatch.getEvents();
      }
      //Otherwise, get events from all matches
      else{
        for(int i = 0 ; i< matches.size(); i++){
          Match currentMatch = matches.get(i);
          matchEvents.addAll(currentMatch.getEvents());
        } 
      }
      
      //Go through all events obtained, and obtain names of all players involved
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
      
      //Convert the list of players into an array
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
