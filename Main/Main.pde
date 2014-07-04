import controlP5.*;

ControlP5 cp5;

DropdownList d1, d2;
BarGraph graph;

void setup() {
  
  size(800,600,P2D);
  smooth();
  cp5 = new ControlP5(this);
  String fileName = "C://Program Files (x86)//Steam//SteamApps//common//Team Fortress 2//tf//new4.txt";
  FileReader reader = new FileReader(fileName);
  reader.processFile(reader.getData());
  Hashtable<String, DeathCount> deaths;
  DataProcessor processor = new DataProcessor(reader.getMatches());
  deaths = processor.getDeaths("Mr.Sacha[FR]");
  graph = new BarGraph(deaths,400,400,20);
          
  
}

void draw(){
  
  graph.draw();
}
