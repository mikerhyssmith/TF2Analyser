import controlP5.*;

ControlP5 cP5;
ControlP5 barControl;

DropdownList d1, d2;
BarGraph graph;
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

void setup() {
  size(800,600);
  smooth();
  background(128);
  cP5 = new ControlP5(this);
  barControl = new ControlP5(this);
  
  UI = new UserInterface(cP5);
  
  //Define containing areas for various features
  graphArea = new Area(800,500,0,100);
  statsArea = new Area(150,200,width-10,height-10);

}

void draw(){
  background(128);
  if(fileLoaded){
    UI.fileLoadedUI();
    fileLoaded = false;
  }
  if(dataProcessed){
    UI.addVisualizationOptions(players,matches);
 
    dataProcessed = false;
  }
  if(graphDrawn){
    graph.draw();
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
        deaths = processor.getAllDeaths();
        drawBarChart();
        UI.drawVisualizationStats(vs);
        vs.getInitialStats();
      }else{
        //Draw match timeline
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
   barControl.remove("BarSlider");
   graph = new BarGraph(deaths,graphArea,10,barControl);
   graphDrawn = true;
   drawVisualizationStats();
}



void drawVisualizationStats(){
  vs = new VisualizationStats(reader.getMatches(),processor);
  
}


void drawMatchTimeline(){
  
}

void updateVisualisationMatch(int matchNumber){
  
  if(matchNumber == 0){
    deaths = processor.getAllDeaths();
    vs.updateMatchStatistics(-1);
    UI.drawVisualizationStats(vs);
    UI.updatePlayerDropDown(-1);

  }else{
    deaths = processor.getMatchDeaths(matchNumber-1);
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
      deaths = processor.getMatchDeaths(m_number); 
    }else{
      deaths = processor.getAllDeaths();
    }
  }else if(!playerName.equals("")){
      deaths = processor.getDeaths(playerName,m_number); 
  }
  drawBarChart();
}


void BarSlider(float shift) {
  graph.UpdateShift(shift);
}




