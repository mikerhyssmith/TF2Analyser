class CaptureEvent extends Event{
  
  String[] capturingPlayers;
  String capturedObject;
  
  public CaptureEvent(Time time, String[] capturingPlayers, String capturedObject){
    
    super(EventTypes.CAPTURE, time);
    this.capturingPlayers = capturingPlayers;
    this.capturedObject = capturedObject;
          
    

  }
}
