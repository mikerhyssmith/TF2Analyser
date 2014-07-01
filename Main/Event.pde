class Event{
  EventTypes eventType;
  String eventDescription;
  
  
  
  public Event(EventTypes eventType, String eventDescription){
    this.eventType = eventType;
    
    
  }
  
  public EventTypes getEventType(){
    
    return eventType;
  }
  
  public String getEventDescription(){
    
    return eventDescription;
  }
