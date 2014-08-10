import controlP5.*;

ControlP5 cP5;
ControlP5 barControl;
ControlP5 nodeControl;

DropdownList d1, d2;
BarGraph graph;
NodeGraph nGraph;
int col;
String filename;
boolean graphDrawn = false;
Area graphArea;
Area statsArea;
UserInterface UI;
FileReader reader;
DataProcessor processor;
boolean fileLoaded;
boolean dataProcessed;
String[] players;
ArrayList<Match> matches;
VisualizationStats vs;
Hashtable<String, DeathCount> deaths;
int m_number = -1;
boolean nodeDrawn = false;

//TF2 Analyser logo file
PImage logo;
static final int WINDOWWIDTH=1000;
static final int WINDOWHEIGHT=600;

void setup() {
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
  statsArea = new Area(150,200,width-10,height-10);

}

void draw(){
  background(128);
  
  if(!graphDrawn&&!nodeDrawn){
    image(logo, WINDOWWIDTH/2 - logo.width/2, WINDOWHEIGHT/2-logo.height/2, logo.width, logo.height);
  }
  
  if(fileLoaded){
    UI.fileLoadedUI();
    fileLoaded = false;
  }

  if(graphDrawn){
    graph.draw();
  }
  if(nodeDrawn){
    nGraph.draw();
  }
  UI.UIDraw();
}

void controlEvent(ControlEvent theEvent) {

  if(theEvent.isController()) { 

    if(theEvent.controller().name()=="Load File") {
         selectInput("Select a file to process:", "fileSelected");
    }
    
  }else if (theEvent.isGroup()) {
    // if the name of the event is equal to ImageSelect (aka the name of our dropdownlist)
    if (theEvent.group().name() == "VisualizationChoice") {
      if(theEvent.group().value() == 0){
        deaths = processor.getDeaths("",-1);
        UI.addVisualizationOptions(players,matches);
        drawBarChart();
        UI.drawVisualizationStats(vs);
        vs.getInitialStats();
      }else{
        //Draw match timeline    
        drawMatchTimeline();
      }
    }
    if(theEvent.group().name() == "MatchChoice"){
      int matchNumber = (int)theEvent.group().value();
      m_number = matchNumber -1;
      System.out.println("Match Number: " + m_number);
      
      updateVisualisationMatch(matchNumber);
    }
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

void fileSelected(File selection) {
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

void drawBarChart(){
   nodeDrawn = false;
   graphDrawn = false;
   barControl.remove("BarSlider");
   graph = new BarGraph(deaths,graphArea,10,barControl);
   graphDrawn = true;
   drawVisualizationStats();
}



void drawVisualizationStats(){
  vs = new VisualizationStats(reader.getMatches(),processor);
  
}


void drawMatchTimeline(){
 UI.removeVisualizationStats();
 graphDrawn = false;
 nodeDrawn = false;
 nGraph = new NodeGraph(matches.get(0).getEvents(), graphArea, nodeControl, "captain morgan");
 nodeDrawn = true;
  
}

void updateVisualisationMatch(int matchNumber){
  
  if(matchNumber == 0){
    deaths = processor.getDeaths("",-1);
    vs.updateMatchStatistics(-1);
    UI.drawVisualizationStats(vs);
    UI.updatePlayerDropDown(-1);

  }else{
    deaths = processor.getDeaths("",matchNumber-1);
    vs.updateMatchStatistics(matchNumber-1);
    UI.drawVisualizationStats(vs);
    UI.updatePlayerDropDown(matchNumber-1);

  }
  drawBarChart();
}
void updateVisualisationPlayer(String playerName){
  System.out.println(playerName);
  
  if(playerName.equals("")){
    if(m_number != -1){
      deaths = processor.getDeaths("",m_number); 
    }else{
      deaths = processor.getDeaths("",-1);
    }
  }else if(!playerName.equals("")){
      deaths = processor.getDeaths(playerName,m_number); 
  }
  drawBarChart();
}


void BarSlider(float shift) {
  graph.UpdateShift(shift);
}

void NodeSlider(float shift){
  nGraph.UpdateShift(shift);
}




