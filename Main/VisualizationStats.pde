class VisualizationStats {
  
  public ArrayList<Match> matches;
  String mostPopularWeapon;
  String percentCrits;
  String mostKills;
  String mostDeaths;
  Hashtable<String,DeathCount> deaths;
  DataProcessor reader;
  
  public VisualizationStats(ArrayList<Match> matches,DataProcessor reader){
    
    this.matches = matches;
    this.deaths = reader.getAllDeaths();
    this.reader = reader;
    
    getInitialStats();
    
  }
  
  public void getInitialStats(){
    
    mostPopularWeapon = getMostPopularWeapon(0);
    System.out.println(mostPopularWeapon);
    percentCrits = getPercentCrits(1,"") + "%";
    System.out.println(percentCrits);
   // mostKills = getMostKills();
    //mostDeaths = getMostDeaths();
    
  }
  
  public String getMostPopularWeapon(int match){
    
    if(match == -1 ){
      deaths = reader.getAllDeaths();
      System.out.println("All Matches, All Players");
      
    }else if (match != -1 ){
      deaths = reader.getMatchDeaths(match);
      System.out.println("Match: " + match + " All Players");
      
    }

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
  
  public int getPercentCrits(int match, String playerName){
    //If match is -1 get data for all matches.
    //If player name is "" get data for all players.
    
    Hashtable<String,DeathCount> deaths = new Hashtable<String,DeathCount>();
    
    if(match == -1 && playerName.equals("")){
      deaths = reader.getAllDeaths();
      System.out.println("All Matches, All Players");
      
    }else if (match != -1 && playerName.equals("")){
      deaths = reader.getMatchDeaths(match);
      System.out.println("Match: " + match + " All Players");
      
      
    }else if (match == -1 && !playerName.equals("")){
      deaths = reader.getDeaths(playerName,-1);
      System.out.println("All Matches " + "Players " + playerName);
      
    }else{
      deaths = reader.getDeaths(playerName,match);
      System.out.println("All Matches " + "Players " + playerName);
    }
    
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    int critCount =0;
    int totalCount=0;
    //Work out the highest kill value
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      critCount = critCount + death.getCritCount();
      totalCount = totalCount + death.getCount();
      
    }
    
    double percentage =  (double) critCount/totalCount *100;
    int roundedPercent = (int) percentage;
    
    return roundedPercent;
  }
  
  /*
  public String getMostKills(int match){

    if(match == -1 ){
      deaths = reader.getAllDeaths();
      System.out.println("All Matches, All Players");
      
    }else if (match != -1 ){
      deaths = reader.getMatchDeaths(match);
      System.out.println("Match: " + match + " All Players");
      
    }
     Hashtable<String,int> killCount = new Hashtable<String,int>();
     //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    //Work out the highest kill value
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      if (killCount.containsKey(key)) {
        int currentKillCount = killCount.get(key) + 1;
      }else{
       
      } 
    }
    return mostUsedWeapon;    
  }
  }
  
  public String getMostDeaths(){
    
    return "";
  }
  */
  
  
  
}
