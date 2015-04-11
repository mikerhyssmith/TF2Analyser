import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.Enumeration; 
import java.util.Hashtable; 
import controlP5.*; 
import java.sql.Time; 
import java.util.Enumeration; 
import java.util.Hashtable; 
import java.util.ArrayList; 
import java.util.Hashtable; 
import java.util.List; 
import java.util.*; 
import java.sql.Time; 
import java.util.*; 
import java.sql.Time; 
import java.util.*; 
import java.sql.Time; 
import java.sql.Time; 
import java.util.ArrayList; 
import java.sql.Time; 
import java.util.concurrent.TimeUnit; 
import java.io.*; 
import java.util.Hashtable; 
import java.util.HashMap; 
import java.util.*; 
import treemap.*; 
import controlP5.*; 
import java.text.Normalizer; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TF2Analyser extends PApplet {



ControlP5 cP5;
ControlP5 barControl;
ControlP5 nodeControl;

DropdownList d1, d2;

BarGraph graph;
NodeGraph nGraph;
CircleGraph circleGraph;
VisualizationStats vs;
TreeGraph treeGraph;

int col;
String filename;
Area graphArea;
Area statsArea;
UserInterface UI;

//File input ant processing
FileReader reader;
DataProcessor processor;
boolean fileLoaded;
boolean dataProcessed;

//Data
String[] players;
ArrayList<Match> matches;
Hashtable<String, DeathCount> deaths;

int currentMatchNo = 0;

boolean drawBarGraph = false;
boolean drawNodeGraph = false;
boolean drawnTreeMap = false;

//TF2 Analyser logo file
PImage logo;
static final int WINDOWWIDTH=1000;
static final int WINDOWHEIGHT=600;

public void setup() {
  size(WINDOWWIDTH,WINDOWHEIGHT);
  logo = loadImage("logo.png");
  smooth();
  background(128);
  frameRate(25);
  cP5 = new ControlP5(this);
  barControl = new ControlP5(this);
  nodeControl = new ControlP5(this);
  
  UI = new UserInterface(cP5);
  
  //Define containing areas for various features
  graphArea = new Area(900,500,0,100);
  statsArea = new Area(200,130,width-250,20);
}

public void draw(){
  //Colour the background
  background(128);
  
  //Draw the logo if neither graph is displayed
  if(!drawBarGraph&&!drawNodeGraph){
    image(logo, WINDOWWIDTH/2 - logo.width/2, WINDOWHEIGHT/2-logo.height/2, logo.width, logo.height);
  }
  
  //Display file loaded message
  if(fileLoaded){
    UI.fileLoadedUI();
    fileLoaded = false;
  }

  //Draw bargraph, if selected
  if(drawBarGraph){
    graph.draw();
  }
  //Draw node graph, if selected
  if(drawNodeGraph){
    circleGraph.draw();
  }

  if(drawnTreeMap){
    treeGraph.draw();
  }
  //Draw the UI
  UI.UIDraw();
}

public void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) { 
    
    //Respond to load file command
    if(theEvent.controller().name()=="Load File") {
      //Remove menu options relevant to already-drawn graphs
      if(drawNodeGraph || drawBarGraph){
        UI.removeVisualizationStats();
        UI.removeOptions();
      }
      //Stop drawing graph
      drawNodeGraph = false;
      drawBarGraph = false;
      //Open file selection menu
      selectInput("Select a file to process:", "fileSelected");
    }
    //Section for menus
  }else if (theEvent.isGroup()) {
    //Graph selection menu
    if (theEvent.group().name() == "VisualizationChoice") {
      
      //When bar graph is selected:
      if(theEvent.group().value() == 0){
        drawBarGraph=true;
        drawNodeGraph=false;
        
        //Obtain death info from all matches
        deaths = processor.getDeaths("",-1);

        //Add menu options for altering bar graph data set
        UI.addVisualizationOptions(players,matches,false);
        
        //Create the bar graph
        createBarGraph();
        
        UI.drawVisualizationStats(vs);
        vs.getInitialStats();
      }
      //When the node graph is selected
      else if(theEvent.group().value() == 1)  {
        drawBarGraph = false;
        drawNodeGraph = true;
        
        //Obtain death info from all matches
        deaths = processor.getDeaths("",-1);
        
        //Add menu options for altering node graph data set
        //UI.addVisualizationOptions(players,matches,true); 
        //Hide summary info box
        //UI.removeVisualizationStats();
  
        //nGraph = new NodeGraph(graphArea, nodeControl);

        circleGraph = new CircleGraph(graphArea.getWidth(), graphArea.getHeight(),deaths, 5, 100);
      }else if(theEvent.group().value() ==2){
        treeGraph = new TreeGraph(processor.getDeaths("",-1));
        drawnTreeMap = true;

      }
    }
    
    //Match selection menu
    if(theEvent.group().name() == "MatchChoice"){
      int matchNumber = (int)theEvent.group().value();
      updateVisualisationMatch(matchNumber);
    }
    //Player selection menu
    if(theEvent.group().name()=="PlayerChoice"){
      int playerNumber = (int)theEvent.group().value();
      String playerName;
      if(playerNumber == 0){
        playerName = "";
      }else{
         playerName = UI.getPlayer(playerNumber);
      }
      updateVisualisationPlayer(playerName);
    }
  }
}

public void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    filename = selection.getAbsolutePath();
    
    //Read in data from loaded file
    reader = new FileReader(filename);
    reader.processFile(reader.getData());
    fileLoaded = true;

    //Process data from file
    processor = new DataProcessor(reader.getMatches());
    
    //Get list of players from processed data
    players = processor.getMatchPlayers(0);
    matches = reader.getMatches();
    //Add player list to UI
    dataProcessed = true;
  }
}

public void drawMatchTimeline(int matchNumber, String playerName){
  drawNodeGraph = false;
  if(nGraph.getPlayerEvents(playerName,matches.get(matchNumber).getEvents()).size() >0){
    nGraph.dataSelection(matches.get(matchNumber).getEvents(),playerName);
    drawNodeGraph = true;
  }
}

//Update procedure when a different match is selected
public void updateVisualisationMatch(int matchNumber){
  currentMatchNo = matchNumber;
  
  //When nodegraph is selected
  if(drawNodeGraph){
    //UI.updatePlayerDropDown(currentMatchNo);
  }else if(drawBarGraph){ 
    //If all matches are selected
    if(currentMatchNo == 0){
      //Get death data from all matches
      deaths = processor.getDeaths("",-1);
      //Update summary data to show overall summary
      vs.updateMatchStatistics(-1);
      UI.drawVisualizationStats(vs);
      //Update player selection options
      UI.updatePlayerDropDown(-1);
    }
    else{
      //Get death data for chosen match
      deaths = processor.getDeaths("",currentMatchNo-1);
      //Update summary data for specific match summary
      vs.updateMatchStatistics(currentMatchNo-1);
      UI.drawVisualizationStats(vs);
      //Update player selection options
      UI.updatePlayerDropDown(matchNumber-1);
    }
    createBarGraph();
  }
}

//Update procedure when a different player is selected
public void updateVisualisationPlayer(String playerName){

  //When the nodegraph is selected
  if(drawNodeGraph){
    //drawMatchTimeline(currentMatchNo, playerName);
  }
  //When the bargraph is selected
  else if(drawBarGraph){
    //If no player is selected
    if(playerName.equals("")){
      deaths = processor.getDeaths("",currentMatchNo-1); 
    }
    //If a specific player is selected
    else if(!playerName.equals("")){
        deaths = processor.getDeaths(playerName,currentMatchNo-1); 
    }
    createBarGraph();
  }
}

public void createBarGraph(){
    //Remove old slider control
    barControl.remove("BarSlider");
    //Create new bar graph
    graph = new BarGraph(deaths,graphArea,10,barControl);
    //Create summary info box
    vs = new VisualizationStats(reader.getMatches(),processor,statsArea);
}


public void BarSlider(float shift) {
  graph.UpdateShift(shift);
}

public void NodeSlider(float shift){
  nGraph.UpdateShift(shift);
}




class Area {
  
  public int aWidth;
  public int aHeight;
  public int x;
  public int y;
  
  public Area(int aWidth, int aHeight, int x, int y){
    this.aWidth = aWidth;
    this.aHeight = aHeight;
    this.x=x;
    this.y=y;
  }
  
  public int getWidth(){
    return aWidth;
  }
  public int getHeight(){
    return aHeight; 
  }
  public int getX(){
    return x;
  }
  public int getY(){
    return y; 
  }
}




class BarGraph{
  
  //Table of deaths and causes
  Hashtable<String,DeathCount> deaths;
  //Distance between adjacent bars
  int seperation;
  //Posiion and size of the graph
  Area graphArea;
  //Highest # of kills (used for scaling the bars)
  int maxKills=0;
  //Whether or not to always draw crit kills
  boolean showCrits=false;
  
  //Display stuff
  PFont arial;
  ControlP5 barControl;
  Slider barSlider;
  //Width of the killicon image
  int barWidth=128;
  int iconHeight=32;
  //Whether the graph fits in its allocated area or not
  boolean graphFits =true;
  //Shift value of horizontal slider
  float xShift=0;
  //Height of horizontal slider
  int sliderHeight;
  //Space for stats
  int statsSpace = 50;
  
  IconHandler icons;
  
  public BarGraph(Hashtable<String,DeathCount> deaths, Area barArea, int seperation, ControlP5 control){
    this.deaths = deaths;
    this.graphArea = barArea;
    this.seperation = seperation;
    this.barControl = control;
    
    //Format interface
    barControl.setColorForeground(0xffaa0000);
    barControl.setColorBackground(0xff385C78);
    barControl.setColorLabel(0xffdddddd);
    barControl.setColorValue(0xff342F2C);
    barControl.setColorActive(0xff9D302F);

    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    
    
    
    //Work out the highest kill value
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      if(death.getCount()>maxKills){
        maxKills = death.getCount();
      }
    }
    
    //Total width of graph
    int graphWidth = (deaths.size()*barWidth)+((deaths.size()-1)*seperation);
    
    //If graph is wider than its allocated area, add a horizontal scrollbar
    if(graphWidth>graphArea.getWidth())
    {
      sliderHeight = 20;
      //Add a slider for horizontal scrolling
      barSlider = barControl.addSlider("BarSlider",0,graphWidth-width,0,0,graphArea.getY()+graphArea.getHeight()-sliderHeight,width,sliderHeight);
      
      graphFits = false;
    }
    else{
      sliderHeight = 0;
    }
    
    //Set up font
    arial = createFont("Arial",12,true);

    //Set up icons
    icons = new IconHandler("killicons_final.png");
  }

  public void draw(){
    int h = 0;
    int x = 0;

    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      //Scale bar heights so that the highest is as tall as the graph
      h =  (int) map(death.getCount(), 0, maxKills, 0, graphArea.getHeight()-iconHeight-sliderHeight-statsSpace); 
      
      float xpos=x+graphArea.getX()-xShift;
      //Calculate y position of rectangle
      float ypos= graphArea.getHeight() + graphArea.getY() - h - sliderHeight;
      
      //Draw icon
      icons.Draw(death.getCause(), xpos, ypos-iconHeight);
      
      //Set bar colour and draw bars
      fill(52,47,44);
      rect(xpos,ypos,barWidth,h);
      
      //Draw crit kills and tooltip if mouse is over the bar
      if((mouseX>xpos && mouseX<=xpos+barWidth)&&(mouseY > height -  (h + iconHeight/2) && mouseY < height - sliderHeight )){
        //Draw bar on top showing crit kills
        fill(255,40,40);
        h = (int) map(death.getCritCount(),0,maxKills,0,graphArea.getHeight()-iconHeight-sliderHeight);
        ypos=graphArea.getHeight() + graphArea.getY() - h - sliderHeight;
        
        //Draw tooltip over highlighted bar
        ToolTip tip = new ToolTip("Weapon: "+death.getCause() +"\n" + "Kills: " + death.getCount() + "\n" + "Crits: " + death.getCritCount(), color(248,185,138), arial);
        tip.draw();
      }
      
      //Move to next bar position
      x+=(seperation+barWidth);
    }
  }
  
  public void UpdateShift(float shift){
    xShift=shift;
  }
}


class CaptureEvent extends Event{
  
  String[] capturingPlayers;
  String capturedObject;
  int eventValue = 5;
  
  public CaptureEvent(Time time, String[] capturingPlayers, String capturedObject){
    super(EventTypes.CAPTURE, time);
    this.capturingPlayers = capturingPlayers;
    this.capturedObject = capturedObject;
  }
  
  public String[] getCapturingPlayers(){
    return capturingPlayers;
  }
  
  public String getCapturedObject(){
    return capturedObject;
  }
  
  public int getValue(){
    return eventValue;
  }
  
}
class Circle {
  float x;
  float y;
  float r;
  String label;
 
  Circle(float x, float y, float r, String label){
    this.x = x;
    this.y = y;
    this.r = r;
    this.label = label;
  }
 
 
 /*
  float distance(float x1, float y1, float x2, float y2){
    return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  }
 
  float getOffset(float x, float y){
    return distance(this.x, this.y, x, y);
  }
 
  boolean contains(float x, float y){
    return distance(this.x, this.y, x, y) <= this.r;
  }
 
  boolean intersect(Circle circle){
    float d = distance(this.x, this.y, circle.x, circle.y);
    return d <= (this.r + circle.r);
  }*/
  
  public void draw()
  {
    ellipse(x, y, r*2, r*2);
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public float getRadius(){
    return r;
  }
  public void setX(float x){
    this.x = x;
  }
  public void setY(float y){
    this.y = y;
  }
}




class CircleGraph {

  float graphWidth, graphHeight, circleSpacing, xCentre, yCentre;
  Hashtable<String,DeathCount> deaths;
  ArrayList<Circle> circles;
  float damping;
  int totalIterations, remainingIterations;
  int circleScale;

  CircleGraph(float width, float height, Hashtable<String,DeathCount> deaths, float spacing, int iterations)
  {
    this.graphWidth = width;
    this.graphHeight = height;
    this.xCentre = width/2;
    this.yCentre = height/2;
    this.deaths = deaths;
    this.circleSpacing = spacing;
    
    //Might take these out?
    damping = 0.01f;
    this.totalIterations = iterations;
    remainingIterations = totalIterations;
    
    //Used to scale circle radius with kills
    this.circleScale = 5;
    createCircles();
  }

  public float distanceSquared(float x1, float y1, float x2, float y2)
  {
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
  }
  
  //Take data in hashtable of deaths, convert to arraylist
  public void createCircles(){
    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    Random rand = new Random();
    
    //Initialise circle arraylist
    circles = new ArrayList<Circle>(deaths.size());
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      circles.add(new Circle(xCentre + 2*(rand.nextFloat() -0.5f),yCentre + 2*(rand.nextFloat() -0.5f), death.getCount()*circleScale, key));
    }
  }


  public void packCircles()
  {
    for (int i = 0; i < circles.size(); i++)
    {
      Circle c1 = (Circle) circles.get(i);

      for (int j = i+1; j < circles.size(); j++)
      {
        Circle c2 = (Circle) circles.get(j);

        float squareDistance = distanceSquared(c1.getX(), c1.getY(), c2.getX(), c2.getY());
        float r = c1.getRadius() + c2.getRadius() + circleSpacing;

        //If circles are closer than they should be
        if (squareDistance < (r*r))
        {
          //Calculate x, y and total seperations
          float dx = c2.getX() - c1.getX();
          float dy = c2.getY() - c1.getY();
          float totalDistance = sqrt(squareDistance);

          //Distance squared from the centre of the graph
          float cd1 = distanceSquared(c1.getX(), c1.getY(), xCentre, yCentre);
          float cd2 = distanceSquared(c2.getX(), c2.getY(), xCentre, yCentre);
          
          //think this is unused
         // float total = dx + dy;

          //Increment to apply to each circle
          float vx = (dx/totalDistance) * (r-totalDistance);
          float vy = (dy/totalDistance) * (r-totalDistance);

          //Alter circle positions based on increments
          c1.x -= vx * cd1/(cd1+cd2);
          c1.y -= vy * cd1/(cd1+cd2);
          c2.x += vx * cd2/(cd1+cd2);
          c2.y += vy * cd2/(cd1+cd2);
        }    
      }
    }
    
    
    //Circles move to centre by default
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c = (Circle) circles.get(i);
      float vx = (c.x - xCentre) * damping;
      float vy = (c.y - yCentre)  *damping;
      c.x -= vx;
      c.y -= vy;
    }
    
  }
/*
  void update() {
    for (int w=0; w<iterations; w++)
    {
      this.pack();
    }
  }*/
  
  public void draw()
  {
    /**
    if(remainingIterations > 0){
      packCircles();
      System.out.println("pack iteration " + remainingIterations);
      remainingIterations -= 1;
    }
    */
    packCircles();
    System.out.println( frameRate);
    
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c = (Circle) circles.get(i);
      if (c.r < 1)
      {
        circles.remove(c);
      } else
      {
        c.draw();
      }
    }
  }
}






class DataProcessor {

  ArrayList<Match> matches;
  Hashtable<String, DeathCount> deaths;

  public DataProcessor(ArrayList<Match> matches) {
    synchronized(matches){
    this.matches = new ArrayList(matches);
    }
  }

  //Returns deaths of one player in a match, or deaths of one player in all matches if match = -1
  public Hashtable<String, DeathCount> getDeaths(String playerName , int match){
    Match currentMatch;
    ArrayList<Event> currentEvents;
    Event currentEvent;

    deaths = new Hashtable<String, DeathCount>();
    
    //If no match is selected (by passing match=-1), return deaths from all matches
    if(match == -1){
      synchronized(matches){
        //Iterate through all matches
        for (int i = 0; i < matches.size(); i++) {
          currentMatch = matches.get(i);
          currentEvents = currentMatch.getEvents();
          //Iterate through all events in current match
          for (int j = 0; j < currentMatch.getEvents().size(); j++) {
            currentEvent = currentEvents.get(j);
            //Event is only relevent if it is a kill
            if (currentEvent.getEventType().equals(EventTypes.KILL)) {
              KillEvent kill = (KillEvent) currentEvent;
              
              //If no player is selected, return all deaths
              if(playerName.equals("")){
                //If the weapon involved has already been added, just increment kill/crit counter
                if (deaths.containsKey(kill.getWeapon())) {
                  DeathCount count = deaths.get(kill.getWeapon());
                  if (kill.getCrit()) {
                    count.addCrit();
                  } else {
                    count.addDeath();
                  }
                } 
                //Otherwise, add a new death to the hashtable
                else {
                  DeathCount count = new DeathCount(kill.getWeapon());
                  if (kill.getCrit()) {
                    count.addCrit();
                  } else {
                    count.addDeath();
                  }
                  deaths.put(kill.getWeapon(), count);
                }
                
              }
              //Otherwise, return deaths of chosen player
              else {
                //Kill is only relevent if the victim is the chosen player
                if (kill.getVictim().equalsIgnoreCase(playerName)) {
                  //If the weapon involved has already been added, just increment kill/crit counter
                  if (deaths.containsKey(kill.getWeapon())) {
                    DeathCount count = deaths.get(kill.getWeapon());
                    if (kill.getCrit()) {
                      count.addCrit();
                    } else {
                      count.addDeath();
                    }
                  } 
                  //Otherwise, add a new death to the hashtable
                  else {
                    DeathCount count = new DeathCount(kill.getWeapon());
                    if (kill.getCrit()) {
                      count.addCrit();
                    } else {
                      count.addDeath();
                    }
                    deaths.put(kill.getWeapon(), count);
                  }
                }
              }
            }
          }
        }
      }
    }
    //Otherwise, return deaths only from the chosen match
    else{
      currentMatch = matches.get(match);
      currentEvents = currentMatch.getEvents();
      //Iterate through all events in the chosen match
      for (int j = 0; j < currentMatch.getEvents().size(); j++) {
        currentEvent = currentEvents.get(j);
        //Event is only relevent if it is a kill
        if (currentEvent.getEventType().equals(EventTypes.KILL)) {
          KillEvent kill = (KillEvent) currentEvent;

          //If no player is selected, return all deaths from the chosen match
          if(playerName.equals("")){
            //If the weapon involved has already been added, just increment kill/crit counter
            if (deaths.containsKey(kill.getWeapon())) {
              DeathCount count = deaths.get(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
            } 
            //Otherwise, add a new death to the hashtable
            else {
              DeathCount count = new DeathCount(kill.getWeapon());
              if (kill.getCrit()) {
                count.addCrit();
              } else {
                count.addDeath();
              }
              deaths.put(kill.getWeapon(), count);
            }      
          }
          //Otherwise, return deaths of chosen player
          else{
            //Kill is only relevent if the victim is the chosen player
            if (kill.getVictim().equalsIgnoreCase(playerName)) {
              //If the weapon involved has already been added, just increment kill/crit counter
              if (deaths.containsKey(kill.getWeapon())) {
                DeathCount count = deaths.get(kill.getWeapon());
                if (kill.getCrit()) {
                  count.addCrit();
                } else {
                  count.addDeath();
                }
              } 
              //Otherwise, add a new death to the hashtable
              else {
                DeathCount count = new DeathCount(kill.getWeapon());
                if (kill.getCrit()) {
                  count.addCrit();
                } else {
                  count.addDeath();
                }
                  deaths.put(kill.getWeapon(), count);
              }
            }  
          }
        }
      }
    }
    return deaths;
  }
  
  
  //Returns all players in a given match
  public String[] getMatchPlayers(int match){  
    synchronized(matches){
      List<String> matchPlayers = new ArrayList<String>();
      ArrayList<Event> matchEvents = new ArrayList<Event>();
      
      //If a match is selected, get the events from it
      if(match !=-1){
        Match currentMatch = matches.get(match);
        matchEvents = currentMatch.getEvents();
      }
      //Otherwise, get events from all matches
      else{
        for(int i = 0 ; i< matches.size(); i++){
          Match currentMatch = matches.get(i);
          matchEvents.addAll(currentMatch.getEvents());
        } 
      }
      
      //Go through all events obtained, and obtain names of all players involved
      for(int i = 0; i< matchEvents.size(); i++){
        Event currentEvent = matchEvents.get(i);
        if (currentEvent.getEventType().equals(EventTypes.KILL)) {
          KillEvent kill = (KillEvent) currentEvent;
          String nameOne = kill.getKiller();
          String nameTwo = kill.getVictim();
          
          if(!matchPlayers.contains(nameOne)){
            matchPlayers.add(nameOne);
          }
          if(!matchPlayers.contains(nameTwo)){
            matchPlayers.add(nameTwo);
          }
        }
      }
      
      //Convert the list of players into an array
      Iterator<String> it = matchPlayers.iterator();
      String[] players = new String[matchPlayers.size()];
      int counter = 0;
      while(it.hasNext()){
        players[counter] = it.next();
        counter++;
      }
    
      return players;
    }
  }
}
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


class DefendEvent extends Event{
  
  String defender;
  String defendedObject;
  int eventValue = 5;
  
  
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
  public int getValue(){
    return eventValue;
  }
  

}



class Event{
  EventTypes eventType;
  Time eventTime;
  
  public Event(EventTypes eventType, Time eventTime){
    
    this.eventType = eventType;
    this.eventTime = eventTime;
  }
  
  public EventTypes getEventType(){
    return eventType;
  }
  
  public Time getEventTime(){
    return eventTime;
  }
  
  public int getEventValue(){
    return 0;
  
  }
}



class FileReader {
  
  String[] data;
  ArrayList<Match> matches;
  Match currentMatch;

  public FileReader(String fileName){
    
    data = loadStrings(fileName);
    matches = new ArrayList<Match>();
  }
  
  //Processes an array of strings that have been read in from a data file
     public boolean processFile(String[] data) {
        boolean matchCreated = false;
        for (int i = 0; i < data.length; i++) {
          synchronized(matches){
            //New match when a new map is detected
            if (data[i].startsWith("Map: ")) {
              String mapName = data[i].substring(5);
              currentMatch = new Match(mapName);
              matchCreated = true;
              matches.add(currentMatch);
            }

            //Detects if a data entry is a kill event
            if (data[i].contains(" killed ") && data[i].contains(" with ")) {
              //Get the time of the event
              int timePosition = data[i].indexOf(": ");
              int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
              int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
              int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
              Time time = new Time(hours,minutes,seconds);
                
              String eventDesc = data[i].substring(timePosition + 2);

              int killedPosition = eventDesc.indexOf(" killed ");
              int withPosition = eventDesc.indexOf(" with ");

              String killer = eventDesc.substring(0, killedPosition);
              String victim = eventDesc.substring(killedPosition + 8,withPosition);
              String weaponName;
              Boolean crit = false;

              if (eventDesc.endsWith("(crit)")) {
                crit = true;
                weaponName = eventDesc.substring(withPosition + 6,eventDesc.length() - 8);
              } else {
                weaponName = eventDesc.substring(withPosition + 6,eventDesc.length()-1);
              }

              KillEvent currentEvent = new KillEvent(time, killer, victim,weaponName, crit);
              currentMatch.addEvent(currentEvent);
            }
            //Detects if a data entry is a defence event
            else if (data[i].contains(" defended ") && data[i].contains(" for team ")) {
                //Get the time of the event
                int timePosition = data[i].indexOf(": ");
                int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
                int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
                int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
                Time time = new Time(hours,minutes,seconds);
                
                String eventDesc = data[i].substring(timePosition + 2);
            
                int defendedPosition = eventDesc.indexOf(" defended ");

            
                String defender = eventDesc.substring(0, defendedPosition);
                String defendedObject = eventDesc.substring(defendedPosition);
              
                DefendEvent currentEvent = new DefendEvent(time,defender,defendedObject);
                currentMatch.addEvent(currentEvent);
            }else if(data[i].contains(" captured ")){
              
              //Mr.Sacha[FR], thetitle13, McKlon_347Rs captured the Rocket, Final Cap for team #3
              int timePosition = data[i].indexOf(": ");
                int hours = Integer.valueOf(data[i].substring(timePosition - 8, timePosition - 6));
                int minutes = Integer.valueOf(data[i].substring(timePosition - 5,timePosition - 3));
                int seconds = Integer.valueOf(data[i].substring(timePosition - 2, timePosition));
                Time time = new Time(hours,minutes,seconds);
                
                String eventDesc = data[i].substring(timePosition + 2);
                int capturedPosition = data[i].indexOf(" captured ");
                System.out.println(capturedPosition);
                
                String capturingPlayers = data[i].substring(timePosition+2, capturedPosition);
                String description = data[i].substring(capturedPosition + 10);
                
                String[] capturingPlayersArray = capturingPlayers.split(",");
                
                CaptureEvent currentEvent = new CaptureEvent(time,capturingPlayersArray,description);
                currentMatch.addEvent(currentEvent);
              
            }
          }
        }
        return false;
      }
      
  public String[] getData() {
    String[] newArray = new String[data.length];
    for(int i = 0; i< data.length; i++){
       newArray[i] = data[i]; 
    }
    return newArray ;
  }
  
  public ArrayList<Match> getMatches(){
    return new ArrayList<Match>(matches);
  }
}

class IconHandler{
  PImage icons;
  int xPos;
  int yPos;
  float scale=1.0f;
  float xOffset = 0;
  float yOffset = 0;

  JSONObject iconData;
  
  public IconHandler(String fileName){
    icons = loadImage(fileName);
    iconData=loadJSONObject("kill_icons.JSON");
  }
  
  public void Draw(String weapon, float x, float y){
    PVector position; 
    int u=0,v=0,section=0,width=0,height=0; 
    JSONObject icon;    
    
    //Look for the cause of death in the icon data
    try{
      icon = iconData.getJSONObject(weapon);
      section = icon.getInt("section");
      u = icon.getInt("x");
      v = icon.getInt("y");
      width = icon.getInt("width");
      height = icon.getInt("height");
      //Draw the icon
      image(icons, x + (xOffset*width*scale), y + (yOffset*height*scale), width*scale, height*scale, u+(section*512), v, u+width+(section*512),v+height);
    } catch(Exception e){
      //Handle the exception and print an error if icon not found
      System.err.println("Exception: " + e.getMessage());
    }
  }
  
  public Area getIconSize(String weapon){
    JSONObject icon;    
    Area size = new Area(0,0,0,0);
    //Look for the icon of death in the icon data
    try{
      icon = iconData.getJSONObject(weapon);
      size = new Area(icon.getInt("width"), icon.getInt("height"), icon.getInt("x"), icon.getInt("y"));
    } catch(Exception e){
      //Handle the exception and print an error if icon not found
      System.err.println("Exception: " + e.getMessage());
    }
    return size;
  }
  
  //Set scaling of icons to be drawn
  public void setScale(float scale){
    this.scale = scale;
  }
  
  //Set percentage offset of icons from right-hand corner
  public void setOffset(float xPercent, float yPercent){
    xOffset = xPercent;
    yOffset = yPercent;
    
  }
  
  
}



class KillEvent extends Event{
  
  String killer;
  String victim;
  String weapon;
  boolean crit;
  int standardValue = 15;
  int critValue = 10;
  
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
  public int getValue(){
    int value= standardValue;
    if(crit){
      value = critValue;
    }
    return value;
  }
  
}


class Match {
  
  String mapName;
  ArrayList<Event> events;
  
  public Match(String mapName){
    
    this.mapName = mapName;
    events = new ArrayList<Event>();
  }
  
  public String getMapName(){
    return mapName;
  }
  
  public ArrayList<Event> getEvents(){
    return events;
  }
  
  public void setEvents(ArrayList<Event> events)
  {
    this.events = events;
  }
  
  public void addEvent(Event e){
    events.add(e);
  }
}

class Node{
  
  private float x;
  private float y;
  private ToolTip tip;
  
 public Node(float x, float y, ToolTip tip ){
   this.x = x;
   this.y = y;
   this.tip = tip;
  
 } 
 
 public float  getX(){
   return x;
 }
 
 public float getY(){
   return y; 
 }
 
 public ToolTip getTooltip(){
  return tip; 
 }
  
}
//.//import controlP5.*;



class NodeGraph {
  
  ArrayList<Event> events;
  ArrayList<Node> nodes;
  int initialTime = 0;
  int timeStep;
  int separation;
  Area graphArea;
  ControlP5 nodeControl;
  String playerName;
  final int INITIALSEPARATION = 40;
  Slider nodeSlider;
  int sliderHeight;
  boolean graphFits =true;
  ArrayList<Event> playerEvents;
  PFont arial;
  //Shift value of horizontal slider
  float xShift=0;
  int offset = 30;
  int graphWidth;
  int graphHeight;
  int playerScore = 0;
  int padding = 30;
  NodeGraphRenderer render;
  boolean rendered = false;
  
  IconHandler icons;
  int minSeperation = 10;
  
  //Get system independent new line character
  String newLineCharacter = System.getProperty("line.separator");
 
 public NodeGraph(Area graphArea, ControlP5 nodeControl) {
   this.graphArea = graphArea;
   this.nodeControl = nodeControl;

   arial = createFont("Arial",12,true);
   
   //Apply custom colour scheme to all ControlP5 objects
   nodeControl.setColorForeground(0xffaa0000);
   nodeControl.setColorBackground(0xff385C78);
   nodeControl.setColorLabel(0xffdddddd);
    nodeControl.setColorValue(0xff342F2C);
    nodeControl.setColorActive(0xff9D302F);
    
    //Set the height of the graph
    graphHeight = graphArea.getHeight();
    
    //Initialise array of nodes
    nodes = new ArrayList<Node>();

 }
 
 public void dataSelection(ArrayList<Event> events, String playerName){
   this.events = events;
   this.playerName = playerName;
   
    //Get length of match to determine size of graph
    Event finalEvent = events.get(events.size()-1);
    Time finalTime = finalEvent.getEventTime();
    Event firstEvent = events.get(0);
    Time initialTime = firstEvent.getEventTime();
    int timeDifference = (int) getDateDiff(initialTime,finalTime);
    
     //Get all events related to the chosen player
    playerEvents = getPlayerEvents(playerName,events);
   
    int numberOfNodes = playerEvents.size();
    //Width of graph is the length of time plus half a node each direction
    graphWidth = timeDifference + 10 + offset;
    
    //Add a slider to the graph to control position
    if(graphWidth>graphArea.getWidth())
    {
      sliderHeight = 20;
      //Add a slider for horizontal scrolling
      nodeSlider = nodeControl.addSlider("NodeSlider",0,graphWidth-width,0,0,graphArea.getY()+graphArea.getHeight()-sliderHeight,width,sliderHeight);
      
      graphFits = false;
    }
    else{
      sliderHeight = 0;
    }
    //Set up icons
    icons = new IconHandler("killicons_final.png");
    
    processEvents();
    render = new NodeGraphRenderer(nodes);

   
 }
 
 public void draw(){
   
   textFont(arial);       
   fill(0);
   colorMode(RGB,255);
   stroke(0);
   rectMode(CORNER);
   
   //Only draw nodes if the users game has been processed.
    if(nodes.size() > 0){
      render.processGraph();
    }

   
 }
 
 

public long getDateDiff(Time time1, Time time2) {
    long diffInMillies = time2.getTime() - time1.getTime();
    return TimeUnit.SECONDS.convert(diffInMillies,TimeUnit.MILLISECONDS);
}

public ArrayList<Event> getPlayerEvents(String playerName, ArrayList<Event> events){
  ArrayList<Event> playerEvents = new ArrayList<Event>();
  //Get all events that are performed by, or on a specific player.
   for(int i =0; i< events.size(); i++){
    Event currentEvent = events.get(i);
    if(currentEvent.getEventType() == EventTypes.KILL){
      KillEvent kill = (KillEvent) currentEvent;  
      //Determine if the desired player killed or was a victim.
      if(kill.getKiller().equalsIgnoreCase(playerName) || kill.getVictim().equalsIgnoreCase(playerName)){
        playerEvents.add(currentEvent);
      }
    }else if(currentEvent.getEventType() == EventTypes.DEFEND){
       DefendEvent defend = (DefendEvent) currentEvent;
       if(defend.getDefender().equalsIgnoreCase(playerName)){
         playerEvents.add(currentEvent);
       }  
    }else if (currentEvent.getEventType() == EventTypes.CAPTURE){
      CaptureEvent capture = (CaptureEvent) currentEvent;
      String[] capturingPlayers = capture.getCapturingPlayers();
      for(int j = 0; j < capturingPlayers.length; j++){
        if(capturingPlayers[j].trim().equalsIgnoreCase(playerName)){
          playerEvents.add(currentEvent);
        
        }
      }
   }
   } 
   return playerEvents;
}

public void UpdateShift(float shift){
    xShift=shift;
}

public void processEvents(){
  
   Time firstEventTime = playerEvents.get(0).getEventTime();
   Event currentEvent = playerEvents.get(0); 
   
   float y =0;
   float x =0;
   float previousX = 0;
   boolean crit = false;
   
   String toolTipText = "";
   
   EventTypes eType=null;
   playerScore = 0;

   nodes.clear();

 for(int i =0; i< playerEvents.size(); i ++){
     currentEvent = playerEvents.get(i);
     crit = false;
     eType = currentEvent.getEventType();
     //Get the y position dependent on the type of event
     if(eType == EventTypes.KILL){
       KillEvent kill = (KillEvent) currentEvent;
       crit = kill.getCrit();
       //Determine if the chosen player is the killer or victim
       if(kill.getKiller().equalsIgnoreCase(playerName)){
         playerScore += kill.getValue();
         toolTipText = "Event Type: Kill" + newLineCharacter +  "Weapon: " + kill.getWeapon() + newLineCharacter + "Victim: " + kill.getVictim();
       }else if(kill.getVictim().equalsIgnoreCase(playerName)){
         playerScore -= kill.getValue();
         toolTipText = "Event Type: Death" + newLineCharacter + "Weapon: " + kill.getWeapon() + newLineCharacter + "Killer: " + kill.getKiller();
       }  
     }else if(eType == EventTypes.DEFEND){
       DefendEvent defend = (DefendEvent) currentEvent;
       playerScore += defend.getValue();
       toolTipText = "Event Type: Defence" + newLineCharacter + "Defended Object: " + defend.getDefendedObject();
     }else if (eType == EventTypes.CAPTURE){
       CaptureEvent capture = (CaptureEvent) currentEvent;
       playerScore += capture.getValue();
       toolTipText = "Event Type: Defence" + newLineCharacter + "Capture Description: " + capture.getCapturedObject();
     }

     //Get the difference between the initial time and the current event to calculate X position.
     int timeDifference = (int) getDateDiff(firstEventTime, currentEvent.getEventTime()) + offset;
     
     //Add a separation to reduce overlapped points
     float pointDifference = timeDifference - previousX;
     x =  (pointDifference +5);
     
     int roundedX = (int) Math.floor((x - xShift) +0.5f) ;
     System.out.println("player score: " + playerScore);
     
     y = playerScore;
   
     //Create a node with player score, event time and a tooltip.
     Node n = new Node((float) roundedX,y,new ToolTip(toolTipText, color(248,185,138), arial));
     nodes.add(n);
     previousX = x;
     
   }
}

}
  
   
  
  


class NodeGraphRenderer {
  
    ArrayList<Node> nodes;
    ArrayList<Node> displayedNodes;
    float screenPosX;
    float screenPosY;
    int currentNode = 0;
    int padding = 30;
    boolean renderingActive = false;
    
    
    public NodeGraphRenderer(ArrayList<Node> nodes) {
      this.nodes = nodes;
      displayedNodes = new ArrayList<Node>();
      
    
    }
    
    public void setNodes(ArrayList<Node> nodes){
       this.nodes = nodes; 
    }

    public ArrayList<Node> getDisplayedNodes(){
      return displayedNodes;

    }

    public void setRendering(boolean active){
      renderingActive = active;
    }
    
    
    public void processGraph() {
    
        while(currentNode < nodes.size()-1){
            Node n = nodes.get(currentNode);
            Node nextNode = nodes.get(currentNode +1);
            float waitTime = (nextNode.getX() - n.getX())*10000000;
            beginShape();
            fill(255);
            stroke(1);
            float yPos = height -n.getX() -padding;
            ellipse(n.getX(),yPos,10,10);
            endShape();
  
            System.out.println("Node X: " + n.getX() + " Node Y: " + n.getY());
            System.out.println("CALLED");
            currentNode++;
            displayedNodes.add(new Node(n.getX(),yPos,n.getTooltip()));
        }
      
        System.out.println(currentNode);
        for(int i =0; i < displayedNodes.size()-1; i++){
          System.out.println("POST PRINT");
          Node n = displayedNodes.get(i);
          beginShape();
          fill(255);
          stroke(1);
          ellipse(n.getX(),n.getY(),10,10);
          endShape();
        }
     
    }  
}
class Player {
  String name;
  ArrayList<Event> events;
  String[] deaths;
  String[] kills;
  int NoOfDefences;
  int NoOfCaptures;
  String team;
  
  Player(String name, String team){
    
    this.name = name;
    events = new ArrayList<Event>();
    this.team = team; 
  }
  
  public void addEvent(Event event){
    events.add(event);
  }
}
class ToolTip{
  //Area taken up by tooltip text
  Area tipArea;
  //Tip text (each element is a new line)
  String[] tipText;
  //Fill colour for tooltip box
  int tipColour;
  PFont font;
  //For when a tooltip containing a weapon icon is required
  Area iconArea = new Area(0,0,0,0);
  
  //Pixels added between text and edge of tooltip box
  int padding = 2;
  //Used to flip the tooltip if its too close to an edge
  float uOffset =0;
  float vOffset =0;
  
  public ToolTip(String text, int colour, PFont font){
    this.tipText = text.split("\n");
    this.tipColour = colour;
    this.font = font;
    textFont(font);
    
    //Calculate the area of the tooltip
    int width = 0;
    
    //Find widest line
    for(int i=0;i<tipText.length;i++){
      int l =(int)textWidth(tipText[i]);
      if(width < l){
        width = l;
      }
    }

    int height = ((int)textAscent()+(int)textDescent())*tipText.length;
    tipArea = new Area(width,height, mouseX-width, mouseY-height);
  }
  
  public ToolTip(String text, int colour, PFont font, Area iconArea){
    this.tipText = text.split("\n");
    this.tipColour = colour;
    this.font = font;
    textFont(font);
    
    //Calculate the area of the tooltip
    int width = 0;
    
    //Find widest line
    for(int i=0;i<tipText.length;i++){
      int l =(int)textWidth(tipText[i]);
      if(width < l){
        width = l;
      }
    }
    
    //If the icon is wider than the text, widen the box to accomodate it
    if(iconArea.getWidth()>width){
      width=iconArea.getWidth(); 
    }
    
    int height = ((int)textAscent()+(int)textDescent())*tipText.length;
    tipArea = new Area(width,height, mouseX-width, mouseY-height);
    this.iconArea=iconArea;
  }
  
  public PVector getIconPosition(){
    return new PVector(tipArea.getX() - padding + uOffset,
                       tipArea.getY() - padding + vOffset + tipArea.getHeight() - iconArea.getHeight()); 
  }
  
  public void draw(){
    //Draw a box for the tooltip
    fill(tipColour);
    
    float u=tipArea.getX()-(2*padding);
    float v= tipArea.getY()-(2*padding) -iconArea.getHeight();
    float w=tipArea.getWidth() + (2*padding);
    float h=tipArea.getHeight()+ (2*padding) + iconArea.getHeight();

    //Handle the tooltip being too close to the screen edge
    if(mouseX<w){
      uOffset = w;
    }
    if(mouseY<v){
      vOffset = h;
    }
    
    rect(u+uOffset,v+vOffset,w,h);
    
    //Draw the tooltip text
    textFont(font);       
    fill(0);
    
    textAlign(LEFT,TOP);
    for(int i=0;i<tipText.length;i++){
      text(tipText[i], tipArea.getX()-padding + uOffset, 
                       tipArea.getY()-padding + vOffset + ((tipArea.getHeight()/tipText.length)*i -  iconArea.getHeight()));
    }
    
    
    textAlign(LEFT,BASELINE);
  }
}




 
 
 
class TreeGraph{
	HashMap<String,Integer> classKills;
	Hashtable<String,DeathCount> data;
	Treemap map;
 
 	TreeGraph(Hashtable<String, DeathCount> data){
 		classKills = new HashMap<String,Integer>();
 		this.data = data;
    processData();
    processTreeGraph();


 	}
 
 	public void processData(){
 		Iterator it = data.entrySet().iterator();
    	while (it.hasNext()) {
        	Map.Entry pair = (Map.Entry)it.next();
        	DeathCount count = (DeathCount) pair.getValue();

        	classKills.put(pair.getKey().toString(),count.getCount());

        	it.remove(); // avoids a ConcurrentModificationException
    	}

 	}

 	public void processTreeGraph(){
 		ClassKillsMap mapData = new ClassKillsMap(classKills);

 		

 		map = new Treemap(mapData,0,0,width,height);

 	}

 	public void draw(){
 		if(map!= null){
 			map.draw();
      System.out.println("Tree Draw");
 		}
 		
 	}

  
}

class ClassKillsMap extends SimpleMapModel{
	HashMap classKills;
  ArrayList<KillsItem> killsArray;

	ClassKillsMap(){

	}

	ClassKillsMap(HashMap<String,Integer> classKills){
		this.classKills = classKills;
		Iterator it = classKills.entrySet().iterator();
    killsArray = new ArrayList<KillsItem>();
    	while (it.hasNext()) {
        	Map.Entry pair = (Map.Entry)it.next();
        	int value = (Integer) pair.getValue();

      			KillsItem item = new KillsItem(pair.getKey().toString());
        		for(int i = 0; i< value; i++){
        			item.incrementSize();
        		}
            killsArray.add(item);
    		

		}
    finishAdd();
	}

	public void finishAdd(){
		 items = killsArray.toArray(new KillsItem[killsArray.size()]);
		 
	}

}

class KillsItem extends SimpleMapItem {
  String word;

  KillsItem(String word) {
    this.word = word;
  }

  public void draw() {
    fill(10,12,14);
    rect(x, y, w, h);

    fill(0);
    if (w > textWidth(word) + 6) {
      if (h > textAscent() + 6) {
        textAlign(CENTER, CENTER);
        text(word, x + w/2, y + h/2);
      }
    }
  }
}






class UserInterface {
  ControlP5 cP5;
  DropdownList dropdown,playersDropDown,matchList,temp;
  ListBox l,playerList;
  Textarea myTextarea;
  boolean fileLoaded = false;
  int colour = 0;
  VisualizationStats vs;
  
  //Whether or not to draw a statistics box
  boolean vst = false;
  boolean notificationDisplayed = false;
  
  public UserInterface(ControlP5 cp5){
    
    this.cP5 = cp5;
    cP5.setColorForeground(0xffaa0000);
    cP5.setColorBackground(0xff385C78);
    cP5.setColorLabel(0xffdddddd);
    cP5.setColorValue(0xff342F2C);
    cP5.setColorActive(0xff9D302F);

    setupGUI();
  }
  
  //Create initial UI on startup
  public void setupGUI() {
    cP5.addButton("Load File",1,0,0,70,30);
  }
  
  
  public void UIDraw(){
    //Notification message on successful file load
    if(notificationDisplayed){
      if(colour < 128){
        colour = colour +1;
        myTextarea.setColor(colour);
      }else if(colour == 128){
        myTextarea.setText("");
        myTextarea.update();
      }
    }
    if(vst){
      vs.draw();
    }
  }
  
  //This creates the next section of the UI once a file has been loaded
  public void fileLoadedUI(){
    colour = 0;
    //Create a drop down box for visualization selection.

    dropdown = cP5.addDropdownList("VisualizationChoice").setPosition(80,15).setWidth(120).setHeight(40);
    
    dropdown.addItem("Cause Of Death Chart",0);
    dropdown.addItem("Circle Map",1);
    dropdown.addItem("Tree Map",2);
    dropdown.setBarHeight(15);
    dropdown.captionLabel().style().marginTop = 3;
    dropdown.captionLabel().style().marginLeft = 3;
    dropdown.valueLabel().style().marginTop = 4;

    
    
    
    //Create a notification to state file has loaded correctly.
    myTextarea = cP5.addTextarea("LoadSuccesful").setPosition(0,35).setFont(createFont("arial",16));
    myTextarea.setText("File Loaded Succesfully !");
    notificationDisplayed = true;
    fileLoaded = true;
  }
  
  //Start drawing statistics box
  public void drawVisualizationStats(VisualizationStats vs){
    this.vs = vs;
    vst = true;
  }
  
  public void removeVisualizationStats(){
     vst = false; 
  }
  
  public void removeOptions(){
    playersDropDown.hide();
    dropdown.hide();
    matchList.hide();
  }
  
  
  //Create the rest of the UI once a type of graph has been chosen
  public void addVisualizationOptions(String[] Players, ArrayList<Match> matches,boolean node) {
    //Create a drop down list of available players.
    playersDropDown = cP5.addDropdownList("PlayerChoice").setPosition(320,15).setSize(120,70);
    matchList = cP5.addDropdownList("MatchChoice").setPosition(200,15).setSize(120,70);
    if(!node){
      matchList.addItem("All Matches",0);
      playersDropDown.addItem("All Players",0);
    }
    customizeDropDownList(playersDropDown);
    customizeDropDownList(matchList);
    int adjustment = 0;
    if(node){
      adjustment = 0;
    }else{
       adjustment = 1; 
    }
    
    //Add all players to the drop-down list
    for(int i = 0 ; i < Players.length; i ++){
      try{
        //Must convert the string to bytes to handle unsupported characters.
        byte[] playerBytes = Players[i].getBytes("WINDOWS-1256");
        String playerName = new String(playerBytes);
        playersDropDown.addItem(playerName,i+adjustment);
      }catch(Exception e){
        System.out.println("Player Name Not Supported");
        playersDropDown.addItem("Unsupported Player Name " + i, i+adjustment);
      }
    }
    
    //Add all matches to the drop-down list
    for(int i =0 ; i< matches.size(); i++){
       Match currentMatch = matches.get(i);
       matchList.addItem(currentMatch.getMapName(),i+adjustment); 
    }
  }
  

  
  //Changes the formatting of a drop-down list to match our chosen scheme
  public void customizeDropDownList(DropdownList ddl) {
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(25);
    ddl.setBarHeight(15);
    ddl.captionLabel().style().marginTop = 3;
    ddl.captionLabel().style().marginLeft = 3;
    ddl.valueLabel().style().marginTop = 3;
  }
  
  public String getPlayer(int playerMenuIndex){
    return playersDropDown.getItem(playerMenuIndex).getText();
  }
  
  //Update the player sekection based on what match has been chosen
  public void updatePlayerDropDown(int match){
    String[] players = null;
    if(match != -1){
      players = processor.getMatchPlayers(match);
    }else{
      players = processor.getMatchPlayers(match);
    }
    playersDropDown = cP5.addDropdownList("PlayerChoice").setPosition(320,15).setSize(120,70);
    playersDropDown.addItem("All Players",0);
    customizeDropDownList(playersDropDown);
      
    int counter = 0;
    for(int i = 0 ; i < players.length; i ++){
      try{
        //Must convert the string to bytes to handle unsupported characters.
        byte[] playerBytes = players[i].getBytes("WINDOWS-1256");
        String playerName = new String(playerBytes);
        playersDropDown.addItem(playerName,i+1);
      }catch(Exception e){
        System.out.println("Player Name Not Supported");
        playersDropDown.addItem("Unsupported Player Name " + i, i+1);
      }
    }
  } 
}
class VisualizationStats {
  
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
  
  public VisualizationStats(ArrayList<Match> matches,DataProcessor reader, Area statsArea){
    this.matches = matches;
    this.deaths = reader.getDeaths("",-1);
    this.reader = reader;
    this.statsArea = statsArea;
    arial = createFont("Arial",11,true);
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
    fill(0,128,0,0);
    rect(statsArea.getX(), statsArea.getY(), statsArea.getWidth(), statsArea.getHeight(), 7);
    //textSize(32);
    textFont(arial);       
    fill(0);
    textAlign(CENTER);
    text("Match Statistics", statsArea.getX()+100, statsArea.getY()+20);
    text("Most Effective Weapon: "+ System.getProperty("line.separator")  + mostPopularWeapon, statsArea.getX()+100, statsArea.getY()+40); 
    text("Percentage of Crit Kills: " + percentCrits, statsArea.getX()+100, statsArea.getY()+75); 
    text("Most Kills: " + mostKills , statsArea.getX()+100, statsArea.getY()+95); 
    text("Most Deaths: " + mostDeaths , statsArea.getX()+100, statsArea.getY()+115); 
    
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
class WeaponToClassMap{
	
	JSONObject gameData;

	public WeaponToClassMap(){
		gameData=loadJSONObject("kill_icons.JSON");

	}


	/**
	* Method for getting the class that uses a weapon: weaponName
	*/
	public String getPlayerClass(String weaponName){
		String playerClass = "unknown";
		JSONObject weapon;
		try{
			weapon = gameData.getJSONObject(weaponName);
			playerClass = weapon.getString("class");
  		} catch(Exception e){
      		//Handle the exception and print an error if icon not found
     	 	System.err.println("Exception: " + e.getMessage());
  		}

  		return playerClass;

	}

	/**
	*Method for getting the colour representing a class.
	*/
	public int getClassColour(String playerClass){
		int red = 0;
		int green = 0;
		int blue = 0;

			if(playerClass.equals("pyro")){
				red = 255;
				green = 0;
				blue = 0;
			}else if(playerClass.equals("soldier")){
				red = 0;
			    green = 0;
				blue = 255;
			}else if(playerClass.equals("scout")){
				red = 255;
				green = 0;
				blue = 255;

			}else if(playerClass.equals("demoman")){
				red = 0;
				green = 255;
				blue = 255;
			}else if(playerClass.equals("engineer")){
				red = 255;
				green = 255;
				blue = 0;
			}else if(playerClass.equals("sniper")){
				red = 100;
				green = 100;
				blue = 50;
			}else if(playerClass.equals("medic")){
				red = 255;
				green = 45;
				blue = 110;

			}else if(playerClass.equals("heavy")){
				red = 0;
				green = 10;
				blue = 45;

			}else if(playerClass.equals("environment")){
				red = 10;
				green = 50;
				blue = 25;
			}else if(playerClass.equals("suicide")){
					red = 255;
					green = 0;
					blue = 24;
			}else{
				red = 255;
			    green = 255;
			    blue = 255;

			}
			
		return color(red,green,blue);

	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TF2Analyser" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
