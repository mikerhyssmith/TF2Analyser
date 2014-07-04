class DeathCount{
  String deathCause;
  int critCount;
  int count;
  
  public DeathCount(String cause){
    critCount =0;
    count =0; 
    this.deathCause = cause;
  }
  
  
  public String getCause(){
    return deathCause;
  }
  public int getCount(){
    return count;
  }
  public int getCritCount(){
    return critCount;
  }
  public void setCount(int count){
    this.count=count;
  }
  public void setCritCount(int count){
    this.critCount = count;
  }
  
  
  public void addCrit(){
    critCount++;
    count++;
  }
  public void addDeath(){
    count++;
  }
}
