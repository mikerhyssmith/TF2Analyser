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
    int graphWidth = timeDifference + (numberOfNodes*10);
    System.out.println(playerEvents.size());
    
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
 }
 
 void draw(){
   Time firstEventTime = playerEvents.get(0).getEventTime();
   Event currentEvent = playerEvents.get(0); 
   
   float y =0;
   float x =0;
   float previousX = 10;
   
   String toolTipText = "";
   
   for(int i =0; i< playerEvents.size(); i ++){
     currentEvent = playerEvents.get(i);
     //Get the y position dependent on the type of event
      if(currentEvent.getEventType() == EventTypes.KILL){
        KillEvent kill = (KillEvent) currentEvent;  
        //Determine if the chosen player is the killer or victim
        if(kill.getKiller().equalsIgnoreCase(playerName)){
          y = killNodeYPosition;
          toolTipText = "Event Type: Kill" + newLineCharacter +  "Weapon: " + kill.getWeapon() + newLineCharacter + "Victim: " + kill.getVictim();
          
        }else if(kill.getVictim().equalsIgnoreCase(playerName)){
           y = deathNodeYPosition;
           toolTipText = "Event Type: Death" + newLineCharacter + "Weapon: " + kill.getWeapon() + newLineCharacter + "Killer: " + kill.getKiller();
        }

      }else if(currentEvent.getEventType() == EventTypes.DEFEND){
         DefendEvent defend = (DefendEvent) currentEvent;
         y = defendCaptureNodeYPosition;
         toolTipText = "Event Type: Defence" + newLineCharacter + "Defended Object: " + defend.getDefendedObject();
      }

     //Get the difference between the initial time and the current event to calculate X position.
     int timeDifference = (int) getDateDiff(firstEventTime, currentEvent.getEventTime());
     
     //Add a separation to reduce overlapped points
     float pointDifference = timeDifference - previousX;
     //System.out.println("Time DIfference" + timeDifference + " previousX " + previousX + "pointDifference " + pointDifference);
     x =  previousX + timeDifference  -(previousX/2);
     
     //Define the point to be drawn
     int ellipseSize = 10;
     fill(255);
     int roundedX = (int) Math.floor((x - xShift) +0.5);
     ellipse(roundedX , y, ellipseSize, ellipseSize);
     previousX = x;
     
     //Defines the behaviour when the mouse is over each node.
     if((mouseX < roundedX + ellipseSize/2 && mouseX > roundedX - ellipseSize/2)&&(mouseY> y - ellipseSize/2 && mouseY < y+ellipseSize/2)){
       ToolTip tip = new ToolTip(toolTipText + newLineCharacter + roundedX, color(248,185,138), arial);
       tip.draw();
       
     }
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
