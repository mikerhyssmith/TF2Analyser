import controlP5.*;

class UserInterface {
  ControlP5 cP5;
  DropdownList dropdown,playersDropDown;
  ListBox l,playerList;
  
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
  
  void fileLoadedUI(){
    
    dropdown = cP5.addDropdownList("VisualizationChoice").setPosition(80,20).setSize(120,70);
    dropdown.addItem("Cause Of Death Chart",0);
    dropdown.addItem("Match Timeline",1);
    customizeDropDownList(dropdown);
    
  }
  
  void addVisualizationOptions(String[] Players) {
    playersDropDown = cP5.addDropdownList("PlayerChoice").setPosition(200,20).setSize(120,70);
    playersDropDown.addItem("All Players",0);
    for(int i = 0 ; i < Players.length; i ++){
      playersDropDown.addItem(Players[i],i+1);
    }
    customizeDropDownList(playersDropDown);
      
    
    
    
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
