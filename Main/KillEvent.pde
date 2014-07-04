import java.sql.Time;

class KillEvent extends Event{
  
  String killer;
  String victim;
  String weapon;
  boolean crit;
  
  public KillEvent(Time time, String killer, String victim, String weapon, boolean crit){
    
    super(EventTypes.KILL, time);
          
    this.killer = killer;
    this.victim = victim;
    this.weapon = weapon;
    this.crit = crit;

  }
  
  public String getKiller(){
    return killer;
  }
  public String getVictim(){
    return victim;
  }
  
  public String getWeapon(){
    return weapon;
  }
  public boolean getCrit(){
    return crit;
  }
}
