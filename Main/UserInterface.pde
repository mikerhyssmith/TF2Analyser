import controlP5.*;
import java.text.Normalizer;

class UserInterface {
  ControlP5 cP5;
  DropdownList dropdown,playersDropDown,matchList,temp;
  ListBox l,playerList;
  Textarea myTextarea;
  boolean fileLoaded = false;
  int colour = 0;
  VisualizationStats vs;
  
  //Whether or not to draw a statistics box
  boolean vst = false;
  boolean notificationDisplayed = false;
  
  public UserInterface(ControlP5 cp5){
    
    this.cP5 = cp5;
    cP5.setColorForeground(0xffaa0000);
    cP5.setColorBackground(0xff385C78);
    cP5.setColorLabel(0xffdddddd);
    cP5.setColorValue(0xff342F2C);
    cP5.setColorActive(0xff9D302F);

    setupGUI();
  }
  
  //Create initial UI on startup
  void setupGUI() {
    cP5.addButton("Load File",1,0,0,70,30);
  }
  
  
  void UIDraw(){
    //Notification message on successful file load
    if(notificationDisplayed){
      if(colour < 128){
        colour = colour +1;
        myTextarea.setColor(colour);
      }else if(colour == 128){
        myTextarea.setText("");
        myTextarea.update();
      }
    }
    if(vst){
      vs.draw();
    }
  }
  
  //This creates the next section of the UI once a file has been loaded
  void fileLoadedUI(){
    colour = 0;
    //Create a drop down box for visualization selection.

    dropdown = cP5.addDropdownList("VisualizationChoice").setPosition(80,15).setSize(120,70);
    dropdown.addItem("Cause Of Death Chart",0);
    dropdown.addItem("Match Timeline",1);
    dropdown.setItemHeight(25);
    dropdown.setBarHeight(15);
    dropdown.captionLabel().style().marginTop = 4;
    dropdown.captionLabel().style().marginLeft = 3;
    dropdown.valueLabel().style().marginTop = 3;
    
    
    
    //Create a notification to state file has loaded correctly.
    myTextarea = cP5.addTextarea("LoadSuccesful").setPosition(0,35);
    myTextarea.setText("File Loaded Succesfully !");
    notificationDisplayed = true;
    fileLoaded = true;
  }
  
  //Start drawing statistics box
  void drawVisualizationStats(VisualizationStats vs){
    this.vs = vs;
    vst = true;
  }
  
  void removeVisualizationStats(){
     vst = false; 
  }
  
  void removeOptions(){
    playersDropDown.hide();
    dropdown.hide();
    matchList.hide();
  }
  
  
  //Create the rest of the UI once a type of graph has been chosen
  void addVisualizationOptions(String[] Players, ArrayList<Match> matches,boolean node) {
    //Create a drop down list of available players.
    playersDropDown = cP5.addDropdownList("PlayerChoice").setPosition(320,15).setSize(120,70);
    matchList = cP5.addDropdownList("MatchChoice").setPosition(200,15).setSize(120,70);
    if(!node){
      matchList.addItem("All Matches",0);
      playersDropDown.addItem("All Players",0);
    }
    customizeDropDownList(playersDropDown);
    customizeDropDownList(matchList);
    int adjustment = 0;
    if(node){
      adjustment = 0;
    }else{
       adjustment = 1; 
    }
    
    //Add all players to the drop-down list
    for(int i = 0 ; i < Players.length; i ++){
      try{
        //Must convert the string to bytes to handle unsupported characters.
        byte[] playerBytes = Players[i].getBytes("WINDOWS-1256");
        String playerName = new String(playerBytes);
        playersDropDown.addItem(playerName,i+adjustment);
      }catch(Exception e){
        System.out.println("Player Name Not Supported");
        playersDropDown.addItem("Unsupported Player Name " + i, i+adjustment);
      }
    }
    
    //Add all matches to the drop-down list
    for(int i =0 ; i< matches.size(); i++){
       Match currentMatch = matches.get(i);
       matchList.addItem(currentMatch.getMapName(),i+adjustment); 
    }
  }
  

  
  //Changes the formatting of a drop-down list to match our chosen scheme
  void customizeDropDownList(DropdownList ddl) {
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(25);
    ddl.setBarHeight(15);
    ddl.captionLabel().style().marginTop = 3;
    ddl.captionLabel().style().marginLeft = 3;
    ddl.valueLabel().style().marginTop = 3;
  }
  
  public String getPlayer(int playerMenuIndex){
    return playersDropDown.getItem(playerMenuIndex).getText();
  }
  
  //Update the player sekection based on what match has been chosen
  public void updatePlayerDropDown(int match){
    String[] players = null;
    if(match != -1){
      players = processor.getMatchPlayers(match);
    }else{
      players = processor.getMatchPlayers(match);
    }
    playersDropDown = cP5.addDropdownList("PlayerChoice").setPosition(320,15).setSize(120,70);
    playersDropDown.addItem("All Players",0);
    customizeDropDownList(playersDropDown);
      
    int counter = 0;
    for(int i = 0 ; i < players.length; i ++){
      try{
        //Must convert the string to bytes to handle unsupported characters.
        byte[] playerBytes = players[i].getBytes("WINDOWS-1256");
        String playerName = new String(playerBytes);
        playersDropDown.addItem(playerName,i+1);
      }catch(Exception e){
        System.out.println("Player Name Not Supported");
        playersDropDown.addItem("Unsupported Player Name " + i, i+1);
      }
    }
  } 
}
