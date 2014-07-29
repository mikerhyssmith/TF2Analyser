import java.sql.Time;

class DefendEvent extends Event{
  
  String defender;
  String defendedObject;
  
  
  public DefendEvent(Time time, String defender, String defendedObject){
    
    super(EventTypes.DEFEND, time);
          
    this.defender = defender;
    this.defendedObject = defendedObject;
  }
  
  public String getDefender(){
    return defender;
  }
  
  public String getDefendedObject(){
    return defendedObject;
  }
  

}
