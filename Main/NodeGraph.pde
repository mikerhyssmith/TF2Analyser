import controlP5.*;
import java.sql.Time;
import java.util.concurrent.TimeUnit;

class NodeGraph {
  
  ArrayList<Event> events;
  int initialTime = 0;
  int timeStep;
  int separation;
  Area graphArea;
  ControlP5 nodeControl;
  String playerName;
  final int INITIALSEPARATION = 40;
  float killNodeYPosition ;
  float defendCaptureNodeYPosition;
  float deathNodeYPosition;
  Slider nodeSlider;
  int sliderHeight;
  boolean graphFits =true;
  ArrayList<Event> playerEvents;
  PFont arial;
  //Shift value of horizontal slider
  float xShift=0;
  int offset = 30;
  int graphWidth;
  
  IconHandler icons;
  int minSeperation = 10;
  
  //Get system independent new line character
  String newLineCharacter = System.getProperty("line.separator");
 
 public NodeGraph(ArrayList<Event> events, Area graphArea, ControlP5 nodeControl, String playerName) {
   this.events = events;
   this.graphArea = graphArea;
   this.nodeControl = nodeControl;
   this.playerName = playerName;
   
   arial = createFont("Arial",12,true);
   
   //Apply custom colour scheme to all ControlP5 objects
    nodeControl.setColorForeground(0xffaa0000);
    nodeControl.setColorBackground(0xff385C78);
    nodeControl.setColorLabel(0xffdddddd);
    nodeControl.setColorValue(0xff342F2C);
    nodeControl.setColorActive(0xff9D302F);
    
    //Get length of match to determine size of graph
    Event finalEvent = events.get(events.size()-1);
    Time finalTime = finalEvent.getEventTime();
    Event firstEvent = events.get(0);
    Time initialTime = firstEvent.getEventTime();
    int timeDifference = (int) getDateDiff(initialTime,finalTime);
    
    //Calculate Y position of each node type
    deathNodeYPosition =  height - ( 0.125*graphArea.getHeight());
    killNodeYPosition =  height - (0.875 * graphArea.getHeight());
    defendCaptureNodeYPosition =  height - ( 0.5*graphArea.getHeight());
    
    
    
    //Get all events related to the chosen player
    playerEvents = getPlayerEvents(playerName);
    
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
   // icons.setScale(0.5);
   // icons.setOffset(-0.5, -1.25);
 }
 
 void draw(){
   
   textFont(arial);       
   fill(0);
   text("Kills",5 - xShift,killNodeYPosition);
   text("Match Events", 5- xShift , defendCaptureNodeYPosition );
   text("Deaths" , 5 - xShift, deathNodeYPosition); 
   rectMode(CENTER);
   stroke(128);
   
   if(graphWidth > width){
     fill(20,158,40,40);
     rect(graphWidth/2, killNodeYPosition + 30, graphWidth, 100);
     fill(80,15,60,40);
     rect(graphWidth/2, defendCaptureNodeYPosition + 30, graphWidth, 100);
     fill(80,15,170,40);
     rect(graphWidth/2, deathNodeYPosition + 30 , graphWidth, 100);
   }else{
     fill(20,158,40,40);
     rect(width/2, killNodeYPosition + 30, width, 100);
     fill(80,15,60,40);
     rect(width/2, defendCaptureNodeYPosition + 30, width, 100);
     fill(80,15,170,40);
     rect(width/2, deathNodeYPosition + 30 , width, 100);
     
   }
   stroke(0);
   rectMode(CORNER);
    
   Time firstEventTime = playerEvents.get(0).getEventTime();
   Event currentEvent = playerEvents.get(0); 
   
   float y =0;
   float x =0;
   float previousX = 0;
   float previousY = 0;
   
   String toolTipText = "";
   
   EventTypes eType=null;
   EventTypes previousType=null;
   
   
   for(int i =0; i< playerEvents.size(); i ++){
     currentEvent = playerEvents.get(i);
     
     String weapon=null;
     eType = currentEvent.getEventType();
     
     //Get the y position dependent on the type of event
     if(eType == EventTypes.KILL){
       KillEvent kill = (KillEvent) currentEvent;
       weapon = kill.getWeapon();
       //Determine if the chosen player is the killer or victim
       if(kill.getKiller().equalsIgnoreCase(playerName)){
         y = killNodeYPosition;
         toolTipText = "Event Type: Kill" + newLineCharacter +  "Weapon: " + kill.getWeapon() + newLineCharacter + "Victim: " + kill.getVictim();
       }else if(kill.getVictim().equalsIgnoreCase(playerName)){
         y = deathNodeYPosition;
         toolTipText = "Event Type: Death" + newLineCharacter + "Weapon: " + kill.getWeapon() + newLineCharacter + "Killer: " + kill.getKiller();
         eType = EventTypes.DEATH;
       }  
     }else if(eType == EventTypes.DEFEND){
       DefendEvent defend = (DefendEvent) currentEvent;
       y = defendCaptureNodeYPosition;
       toolTipText = "Event Type: Defence" + newLineCharacter + "Defended Object: " + defend.getDefendedObject();
     }

     //Get the difference between the initial time and the current event to calculate X position.
     int timeDifference = (int) getDateDiff(firstEventTime, currentEvent.getEventTime()) + offset;
     
     //Add a separation to reduce overlapped points
     float pointDifference = timeDifference - previousX;
     //System.out.println("Time DIfference" + timeDifference + " previousX " + previousX + "pointDifference " + pointDifference);
     x =  (timeDifference +5);
     
     //Define the point to be drawn
     int ellipseSize = 10;
     fill(255);
     int roundedX = (int) Math.floor((x - xShift) +0.5) ;
     int adaptedY =0;
     
     if(roundedX < previousX - xShift + minSeperation && previousY < y + 60){
       
       if(eType==previousType){
         y = previousY+12;
       } 
     }

     previousY = y;
     ellipse(roundedX + offset , y, ellipseSize, ellipseSize);
     previousX = x;
     
     /**
     //Draw icon for kills
     if(weapon!=null){
       icons.Draw(weapon, (float)(roundedX + offset) , y);
     }
     */
     
     //Defines the behaviour when the mouse is over each node.
     float r = (float)Math.sqrt( (mouseX-(roundedX + offset))*(mouseX-(roundedX + offset)) + (mouseY-y)*(mouseY-y));
     
     if(r<ellipseSize/2){
       if(weapon!=null){
         ToolTip tip = new ToolTip(toolTipText, color(248,185,138), arial, icons.getIconSize(weapon));
         tip.draw();
         PVector iconPos=tip.getIconPosition();
         icons.Draw(weapon, iconPos.x, iconPos.y);
       }
       else{
         ToolTip tip = new ToolTip(toolTipText, color(248,185,138), arial);
         tip.draw();
       }
     }
     
     previousType = eType;
   }
 }
 
 

public long getDateDiff(Time time1, Time time2) {
    long diffInMillies = time2.getTime() - time1.getTime();
    return TimeUnit.SECONDS.convert(diffInMillies,TimeUnit.MILLISECONDS);
}

public ArrayList<Event> getPlayerEvents(String playerName){
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
    }
   } 
   return playerEvents;
}

public void UpdateShift(float shift){
    xShift=shift;
}
  
   
  
  
}
