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
  final int INITIALSEPARATION = 10;
  int killNodeYPosition ;
  int defendCaptureNodeYPosition;
  int deathNodeYPosition;
  Slider nodeSlider;
 
 public NodeGraph(ArrayList<Event> events, Area graphArea, ControlP5 nodeControl, String playerName) {
   this.events = events;
   this.graphArea = graphArea;
   this.nodeControl = nodeControl;
   this.playerName = playerName;
   
   //Apply custom colour scheme to all ControlP5 objects
    nodeControl.setColorForeground(0xffaa0000);
    nodeControl.setColorBackground(0xff385C78);
    nodeControl.setColorLabel(0xffdddddd);
    nodeControl.setColorValue(0xff342F2C);
    nodeControl.setColorActive(0xff9D302F);
    
    //Get length of match to determine size of graph
    Event finalEvent = events.get(events.size());
    Time finalTime = finalEvent.getEventTime();
    Event firstEvent = events.get(0);
    Time initialTime = firstEvent.getEventTime();
    int timeDifference = (int) getDateDiff(initialTime,finalTime);
    
    //Calculate Y position of each node type
    deathNodeYPosition = 0.125*graphArea.getHeight();
    killNodeYPosition = 0.875 * graphArea.getHeight();
    defendCaptureNodeYPositon = 0.5*graphArea.getHeight();
    
    //Get all events related to the chosen player
    ArrayList<Event> playerEvents = getPlayerEvents(playerName);
    
    int numberOfNodes = playerEvents.size();
    int graphWidth = (numberOfNodes * INITIALSEPARATION) + (timeDifference * 2);
    
    //Add a slider to the graph to control position
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
      if(kill.getKiller().equals(playerName) || kill.getVictim().equals(playerName)){
        playerEvents.add(currentEvent);
      }
    }else if(currentEvent.getEventType() == EventTypes.DEFEND){
       DefendEvent defend = (DefendEvent) currentEvent;
       if(defend.getDefender().equals(playerName)){
         playerEvents.add(currentEvent);
       }  
    }
   } 
}
  
   
  
  
}
