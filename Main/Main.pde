import controlP5.*;

ControlP5 cP5;

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

void setup() {
  
  size(800,600);
  smooth();
  background(128);
  cP5 = new ControlP5(this);
  UI = new UserInterface(cP5);
  graphArea = new Area(800,400,0,100);
  statsArea = new Area(150,200,width-10,height-10);
}

void draw(){
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
    
  }  
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    filename = selection.getAbsolutePath();
    reader = new FileReader(filename);
    reader.processFile(reader.getData());
    UI.fileLoadedUI();
    processor = new DataProcessor(reader.getMatches());
    String [] players = processor.getMatchPlayers(0);
    UI.addVisualizationOptions(players);
   
  }
}

void drawBarChart(){
   Hashtable<String, DeathCount> deaths;
   deaths = processor.getMatchDeaths(1);
   graph = new BarGraph(deaths,graphArea.getWidth(),graphArea.getHeight(),10);
   graphDrawn = true;
}




