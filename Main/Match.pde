import java.util.ArrayList;

class Match {
  
  String mapName;
  ArrayList<Event> events;
  
  public Match(String mapName){
    
    this.mapName = mapName;
    events = new ArrayList<Event>();
  }
  
  public String getMapName(){
    return mapName;
  }
  
  public ArrayList<Event> getEvents(){
    return events;
  }
  
  public void setEvents(ArrayList<Event> events)
  {
    this.events = events;
  }
  
  public void addEvent(Event e){
    events.add(e);
  }
}

