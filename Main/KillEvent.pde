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
}
