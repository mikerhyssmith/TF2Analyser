import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

import processing.core.PApplet;
import processing.core.PFont;

public class VisualizationStats {
	PApplet processing;
  
  public ArrayList<Match> matches;
  String mostPopularWeapon;
  String percentCrits;
  String mostKills;
  String mostDeaths;
  Hashtable<String,DeathCount> deaths;
  DataProcessor reader;
  PFont arial;
  String currentSelectedPlayer = "";
  Area statsArea;
  
  
  public VisualizationStats(PApplet p, ArrayList<Match> matches,DataProcessor reader, Area statsArea){
	  this.processing = p;
	  this.matches = matches;
    this.deaths = reader.getDeaths("",-1);
    this.reader = reader;
    this.statsArea = statsArea;
    arial = processing.createFont("Arial",11,true);
  }
  
  //Initial stats are those considering all matches in the data file
  public void getInitialStats(){
    mostPopularWeapon = getMostPopularWeapon(-1);
    System.out.println(mostPopularWeapon);
    percentCrits = getPercentCrits(-1,"") + "%";
    mostKills = getMostKills(-1);
    mostDeaths = getMostDeaths(-1);
  }
  
  public void draw(){
	  processing.fill(0,128,0,0);
	  processing.rect(statsArea.getX(), statsArea.getY(), statsArea.getWidth(), statsArea.getHeight(), 7);
    //textSize(32);
	  processing.textFont(arial);       
	  processing.fill(0);
	  processing.textAlign(processing.CENTER);
    processing.text("Match Statistics", statsArea.getX()+100, statsArea.getY()+20);
    processing.text("Most Effective Weapon: "+ System.getProperty("line.separator")  + mostPopularWeapon, statsArea.getX()+100, statsArea.getY()+40); 
    processing.text("Percentage of Crit Kills: " + percentCrits, statsArea.getX()+100, statsArea.getY()+75); 
    processing.text("Most Kills: " + mostKills , statsArea.getX()+100, statsArea.getY()+95); 
    processing.text("Most Deaths: " + mostDeaths , statsArea.getX()+100, statsArea.getY()+115); 
    
  }
  
  //Returns weapon with most kills in a match (or in all matches if passed -1)
  public String getMostPopularWeapon(int match){
    
    if(match == -1 ){
      deaths = reader.getDeaths("",-1);
      System.out.println("All Matches, All Players");
      
    }else if (match != -1 ){
      deaths = reader.getDeaths("",match);
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
  
  //Returns percentage of crit deaths
  public int getPercentCrits(int match, String playerName){
    //If match is -1 get data for all matches.
    //If player name is "" get data for all players.
    currentSelectedPlayer = playerName;

    Hashtable<String,DeathCount> deaths = new Hashtable<String,DeathCount>();
    
    //Get deaths based on what match/player is selected
    if(match == -1 && playerName.equals("")){
      deaths = reader.getDeaths("",-1);
    }
    else if (match != -1 && playerName.equals("")){
      deaths = reader.getDeaths("",match);
    }
    else if (match == -1 && !playerName.equals("")){
      deaths = reader.getDeaths(playerName,-1);
    }
    else{
      deaths = reader.getDeaths(playerName,match); 
    }
    
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    int critCount =0;
    int totalCount=0;
    //Work out the highest crit kill value
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
  
  //Returns player with the most kills in a match, or in all matches if passed -1
  public String getMostKills(int match){
    ArrayList<KillEvent> killEvents = new ArrayList<KillEvent>();
    String maxKillsPlayer = "";
    int maxKillsNo = 0;
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;
    
    //Consider all matches if passed -1
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
    }
    //Otherwise just consider selected match
    else if (match != -1 ){
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
    //Handles if the player name is too long to display
    if(maxKillsPlayer.length() > 15){
      int nameLength = maxKillsPlayer.length();
      int difference = nameLength - 15;
      String nameSubstring = maxKillsPlayer.substring(0,nameLength-difference);
      maxKillsPlayer = nameSubstring + "..";
    }
    return maxKillsPlayer + ": " + maxKillsNo;    
  }
  
  //Returns player with most deaths in a match, or player with most deaths out of all matches if passed -1
  public String getMostDeaths(int match){
    ArrayList<KillEvent> killEvents = new ArrayList<KillEvent>();
    String maxKillsPlayer = "";
    int maxKillsNo = 0;
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    //Consider all matches if passed -1
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
    //Handles if the player name is too long to display
    if(maxKillsPlayer.length() > 15){
      int nameLength = maxKillsPlayer.length();
      int difference = nameLength - 15;
      String nameSubstring = maxKillsPlayer.substring(0,nameLength-difference);
      maxKillsPlayer = nameSubstring + "..";
    }
    return maxKillsPlayer + ": " + maxKillsNo;  
  }
  
  //Update the statistics based on what match is selected
  public void updateMatchStatistics(int match){
    mostPopularWeapon = getMostPopularWeapon(match);
    percentCrits = getPercentCrits(match,currentSelectedPlayer) + "%";
    mostKills = getMostKills(match);
    mostDeaths = getMostDeaths(match);
  }
}
