class Player {
  
  
  String name;
  ArrayList<Event> events;
  String[] deaths;
  String[] kills;
  int NoOfDefences;
  int NoOfCaptures;
  String team;
  
  Player(String name, String team){
    this.name = name;
    events = new ArrayList<Event>();
    this.team = team;
    
  }
  
  void addEvent(Event event){
    
    events.add(event);
    
  }
}
