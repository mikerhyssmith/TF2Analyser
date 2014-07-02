import java.util.*;

class Event{
  EventTypes eventType;
  Date eventTime;
  
  public Event(EventTypes eventType, Date eventTime){
    this.eventType = eventType;
    
  }
  
  public EventTypes getEventType(){
    return eventType;
  }
  
  public Date getEventTime(){
    return eventTime;
  }
