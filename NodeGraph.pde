//.//import controlP5.*;
import java.sql.Time;
import java.util.concurrent.TimeUnit;

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
  Thread renderThread;
  
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
 
 void dataSelection(ArrayList<Event> events, String playerName){
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
    renderThread = new Thread(render);

   
 }
 
 void draw(){
   
   textFont(arial);       
   fill(0);
   colorMode(RGB,255);
   stroke(0);
   rectMode(CORNER);
   
   //Only draw nodes if the users game has been processed.
    if(nodes.size() > 0 && !rendered){
      render.setRendering(true);
      renderThread.start();
      rendered = true;
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
     
     int roundedX = (int) Math.floor((x - xShift) +0.5) ;
     System.out.println("player score: " + playerScore);
     
     y = playerScore;
   
     //Create a node with player score, event time and a tooltip.
     Node n = new Node((float) roundedX,y,new ToolTip(toolTipText, color(248,185,138), arial));
     nodes.add(n);
     previousX = x;
     
   }
}

}
  
   
  
  

