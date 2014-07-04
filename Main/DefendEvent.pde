import java.sql.Time;

class DefendEvent extends Event{
  
  String defender;
  String defendedObject;
  String team;
  
  
  public DefendEvent(Time time, String defender, String defendedObject, String team){
    
    super(EventTypes.DEFEND, time);
          
    this.defender = defender;
    this.defendedObject = defendedObject;
    this.team = team;

  }
  
  public String getDefender(){
    return defender;
  }
  
  public String getDefendedObject(){
    return defendedObject;
  }
  
  public String getTeam(){
    return team;
  }
}
