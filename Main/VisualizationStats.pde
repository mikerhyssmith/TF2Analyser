class VisualizationStats {
  
  public ArrayList<Match> matches;
  String mostPopularWeapon;
  String percentCrits;
  String mostKills;
  String mostDeaths;
  Hashtable<String,DeathCount> deaths;
  
  public VisualizationStats(ArrayList<Match> matches,Hashtable<String,DeathCount> deaths){
    
    this.matches = matches;
    this.deaths = deaths;
    
    getInitialStats();
    
  }
  
  public void getInitialStats(){
    
    mostPopularWeapon = getMostPopularWeapon(0);
    System.out.println(mostPopularWeapon);
    //percentCrits = getPercentCrits() + "%";
   // mostKills = getMostKills();
    //mostDeaths = getMostDeaths();
    
  }
  
  public String getMostPopularWeapon(int match){

     //Set up iterator for deaths
    int maxKills = 0;
    String mostUsedWeapon = "";
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    //Work out the highest kill value
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      if(death.getCount()>maxKills){
        maxKills = death.getCount();
        mostUsedWeapon = death.getCause();
      }
    }
    return mostUsedWeapon;
    
  }
  
  public int getPercentCrits(int match){
    
    
    return 0;
  }
  
  public String getMostKills(){

    return "";    
  }
  
  public String getMostDeaths(){
    
    return "";
  }
  
  
  
  
}
