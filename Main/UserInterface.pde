class UserInterface {
  ControlP5 cP5;
  
  public UserInterface(ControlP5 cp5){
    
    this.cP5 = cp5;
    cP5.setColorForeground(0xffaa0000);
    cP5.setColorBackground(0xff660000);
    cP5.setColorLabel(0xffdddddd);
    cP5.setColorValue(0xffff88ff);
    cP5.setColorActive(0xffff0000);
    
    
    setupGUI();
    
    
  }
  
  
  void setupGUI() {
  
  cP5.addButton("Load File",1,0,0,70,30);
  
  }
  
 

  
}
