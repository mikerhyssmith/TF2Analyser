import java.util.ArrayList;

public class Player {
  String name;
  ArrayList<Event> events;
  String[] deaths;
  String[] kills;
  int NoOfDefences;
  int NoOfCaptures;
  String team;
  
  public Player(String name, String team){
    
    this.name = name;
    events = new ArrayList<Event>();
    this.team = team; 
  }
  
  public void addEvent(Event event){
    events.add(event);
  }
}
