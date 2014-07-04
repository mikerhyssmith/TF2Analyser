import controlP5.*;

ControlP5 cP5;

DropdownList d1, d2;
BarGraph graph;
int col;
String filename;
boolean graphDrawn = false;
Area graphArea;
Area statsArea;

void setup() {
  
  size(800,600);
  smooth();
  cP5 = new ControlP5(this);
  UserInterface UI = new UserInterface(cP5);
  graphArea = new Area(800,400,0,100);
  statsArea = new Area(150,200,width-10,height-10);
  //String fileName = "C://Program Files (x86)//Steam//SteamApps//common//Team Fortress 2//tf//new4.txt";
 
          
  
}

void draw(){
  if(graphDrawn){
    graph.draw();
  }
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
    FileReader reader = new FileReader(filename);
    reader.processFile(reader.getData());
    Hashtable<String, DeathCount> deaths;
    DataProcessor processor = new DataProcessor(reader.getMatches());
    deaths = processor.getMatchDeaths(1);
    graph = new BarGraph(deaths,graphArea.getWidth(),graphArea.getHeight(),10);
    graphDrawn = true;
  }
}




