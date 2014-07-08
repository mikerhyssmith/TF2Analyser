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
        drawBarChart();
      }else{
      
      }
    
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
   Hashtable<String, DeathCount> deaths;
   deaths = processor.getAllDeaths();
   graph = new BarGraph(deaths,graphArea,10,barControl);
   graphDrawn = true;
   drawVisualizationStats();
}

void drawVisualizationStats(){
  vs = new VisualizationStats(reader.getMatches(),processor.getAllDeaths());
  
}


void drawMatchTimeline(){
  
}

void BarSlider(float shift) {
  graph.UpdateShift(shift);
  System.out.println("Shifting graph by: "+shift);
}




