import java.sql.Time;

class CaptureEvent extends Event{
  
  String[] capturingPlayers;
  String capturedObject;
  int eventValue = 5;
  
  public CaptureEvent(Time time, String[] capturingPlayers, String capturedObject){
    super(EventTypes.CAPTURE, time);
    this.capturingPlayers = capturingPlayers;
    this.capturedObject = capturedObject;
  }
  
  public String[] getCapturingPlayers(){
    return capturingPlayers;
  }
  
  public String getCapturedObject(){
    return capturedObject;
  }
  
  public int getValue(){
    return eventValue;
  }
  
}
