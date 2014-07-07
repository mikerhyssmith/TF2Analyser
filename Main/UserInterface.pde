import controlP5.*;
import java.text.Normalizer;

class UserInterface {
  ControlP5 cP5;
  DropdownList dropdown,playersDropDown;
  ListBox l,playerList;
  Textarea myTextarea;
  boolean fileLoaded = false;
  int colour = 0;
  
  public UserInterface(ControlP5 cp5){
    
    this.cP5 = cp5;
    cP5.setColorForeground(0xffaa0000);
    cP5.setColorBackground(0xff385C78);
    cP5.setColorLabel(0xffdddddd);
    cP5.setColorValue(0xff342F2C);
    cP5.setColorActive(0xff9D302F);
    
    setupGUI();

  }
  
  
  void setupGUI() {
    cP5.addButton("Load File",1,0,0,70,30);
  }
  
  void UIDraw(){
    
    if(fileLoaded){
      
      if(colour < 128){
        colour = colour +1;
        myTextarea.setColor(colour);
      }else if(colour == 128){
        myTextarea.setText("");
        myTextarea.update();
        
      }
    }
  }
  
  void fileLoadedUI(){
    colour = 0;
    dropdown = cP5.addDropdownList("VisualizationChoice").setPosition(80,15).setSize(120,70);
    dropdown.addItem("Cause Of Death Chart",0);
    dropdown.addItem("Match Timeline",1);
    customizeDropDownList(dropdown);
    myTextarea = cP5.addTextarea("LoadSuccesful").setPosition(0,35);
    myTextarea.setText("File Loaded Succesfully !");
    fileLoaded = true;
    
  }
  
  void addVisualizationOptions(String[] Players) {
    playersDropDown = cP5.addDropdownList("PlayerChoice").setPosition(200,15).setSize(120,70);
    playersDropDown.addItem("All Players",0);
    customizeDropDownList(playersDropDown);
    int counter = 0;
    for(int i = 0 ; i < Players.length; i ++){
      try{
        byte[] playerBytes = Players[i].getBytes("WINDOWS-1256");
        String playerName = new String(playerBytes);
      playersDropDown.addItem(playerName,i);
      }catch(Exception e){
        System.out.println("Player Name Not Supported");
        playersDropDown.addItem("Unsupported Player Name " + i, i);
      }
    }
  }
  
  void customizeDropDownList(DropdownList ddl) {
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
}
  
 

  
}
