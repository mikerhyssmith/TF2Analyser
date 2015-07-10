import java.util.*;
import java.sql.Time;

class Event{
  EventTypes eventType;
  Time eventTime;
  
  public Event(EventTypes eventType, Time eventTime){
    
    this.eventType = eventType;
    this.eventTime = eventTime;
  }
  
  public EventTypes getEventType(){
    return eventType;
  }
  
  public Time getEventTime(){
    return eventTime;
  }
  
  public int getEventValue(){
    return 0;
  
  }
}
