class VisualizationStats {
  
  public ArrayList<Match> matches;
  String mostPopularWeapon;
  String percentCrits;
  String mostKills;
  String mostDeaths;
  Hashtable<String,DeathCount> deaths;
  DataProcessor reader;
  PFont arial;
  
  
  public VisualizationStats(ArrayList<Match> matches,DataProcessor reader){
    
    this.matches = matches;
    this.deaths = reader.getAllDeaths();
    this.reader = reader;
    arial = createFont("Arial",11,true);
    
    getInitialStats();
    
  }
  
  public void getInitialStats(){
    
    mostPopularWeapon = getMostPopularWeapon(-1);
    System.out.println(mostPopularWeapon);
    percentCrits = getPercentCrits(-1,"") + "%";
    System.out.println(percentCrits);
    mostKills = getMostKills(-1);
    System.out.println(mostKills);
    mostDeaths = getMostDeaths(-1);
    System.out.println(mostDeaths);
    draw();
    
  }
  public void draw(){
    fill(0,128,0,0);
    rect(560, 20, 200, 130, 7);
    //textSize(32);
    textFont(arial);       
    fill(0);
    textAlign(CENTER);
    text("Match Statistics", 660, 40);
    text("Most Effective Weapon: "+ System.getProperty("line.separator")  + mostPopularWeapon, 660, 60); 
    text("Percentage of Crit Kills: " + percentCrits, 660, 95); 
    text("Most Kills: " + mostKills , 660, 115); 
    text("Most Deaths: " + mostDeaths , 660, 135); 
    
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
  
  
  public String getMostKills(int match){
    
    ArrayList<KillEvent> killEvents = new ArrayList<KillEvent>();
    String maxKillsPlayer = "";
    int maxKillsNo = 0;
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    if(match == -1 ){
      for(int i =0; i< matches.size(); i++){
        currentMatch = matches.get(i);
        currentEvents = currentMatch.getEvents();
        for (int j = 0; j < currentEvents.size(); j++) {
          currentEvent = currentEvents.get(j);
          if (currentEvent.getEventType().equals(EventTypes.KILL)) {
            KillEvent kill = (KillEvent) currentEvent;
            killEvents.add(kill);
          }
        }
      }
      
    }else if (match != -1 ){
      currentMatch = matches.get(match);
       currentEvents = currentMatch.getEvents();
        for (int j = 0; j < currentMatch.getEvents().size(); j++) {
          currentEvent = currentEvents.get(j);
          if (currentEvent.getEventType().equals(EventTypes.KILL)) {
               KillEvent kill = (KillEvent) currentEvent;
               killEvents.add(kill);
          }
        }
      
    }
     Hashtable<String,Integer> killCount = new Hashtable<String,Integer>();
     //Set up iterator for deaths
     for(int i =0; i< killEvents.size(); i++){
        KillEvent kill = killEvents.get(i);
        String killer = kill.getKiller();
         if (killCount.containsKey(killer)) {
           int currentKills = killCount.get(killer);
           int newKills = currentKills + 1;
           if(newKills > maxKillsNo){
             maxKillsPlayer = killer;
             maxKillsNo = newKills;
           }
           killCount.put(killer,newKills);
         }else{
            killCount.put(killer,1); 
         }
     }
    if(maxKillsPlayer.length() > 13){
      int nameLength = maxKillsPlayer.length();
      int difference = nameLength - 13;
      String nameSubstring = maxKillsPlayer.substring(0,nameLength-difference);
      maxKillsPlayer = nameSubstring + "..";
      
      
    }
    return maxKillsPlayer + ": " + maxKillsNo;    
  }
  
  public String getMostDeaths(int match){
    
    ArrayList<KillEvent> killEvents = new ArrayList<KillEvent>();
    String maxKillsPlayer = "";
    int maxKillsNo = 0;
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    if(match == -1 ){
      for(int i =0; i< matches.size(); i++){
        currentMatch = matches.get(i);
        currentEvents = currentMatch.getEvents();
        for (int j = 0; j < currentEvents.size(); j++) {
          currentEvent = currentEvents.get(j);
          if (currentEvent.getEventType().equals(EventTypes.KILL)) {
            KillEvent kill = (KillEvent) currentEvent;
            killEvents.add(kill);
          }
        }
      }
      
    }else if (match != -1 ){
      currentMatch = matches.get(match);
       currentEvents = currentMatch.getEvents();
        for (int j = 0; j < currentMatch.getEvents().size(); j++) {
          currentEvent = currentEvents.get(j);
          if (currentEvent.getEventType().equals(EventTypes.KILL)) {
               KillEvent kill = (KillEvent) currentEvent;
               killEvents.add(kill);
          }
        }
      
    }
     Hashtable<String,Integer> killCount = new Hashtable<String,Integer>();
     //Set up iterator for deaths
     for(int i =0; i< killEvents.size(); i++){
        KillEvent kill = killEvents.get(i);
        String killer = kill.getVictim();
         if (killCount.containsKey(killer)) {
           int currentKills = killCount.get(killer);
           int newKills = currentKills + 1;
           if(newKills > maxKillsNo){
             maxKillsPlayer = killer;
             maxKillsNo = newKills;
           }
           killCount.put(killer,newKills);
         }else{
            killCount.put(killer,1); 
         }
     }
     
      if(maxKillsPlayer.length() > 13){
      int nameLength = maxKillsPlayer.length();
      int difference = nameLength - 13;
      String nameSubstring = maxKillsPlayer.substring(0,nameLength-difference);
      maxKillsPlayer = nameSubstring + "..";
      
      
    }
    return maxKillsPlayer + ": " + maxKillsNo;  
  }
  
  
  
  
}
