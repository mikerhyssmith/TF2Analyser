
class IconHandler{
  PImage icons;
  int xPos;
  int yPos;

  JSONObject iconData;
  
  public IconHandler(String fileName){
    icons = loadImage(fileName);
    iconData=loadJSONObject("kill_icons.JSON");
  }
  
  public void Draw(String weapon, float x, float y){
    PVector position; 
    int u=0,v=0,section=0,width=0,height=0; 
    JSONObject icon;    
    
    //Look for the cause of death in the icon data
    try{
      icon = iconData.getJSONObject(weapon);
      section = icon.getInt("section");
      u = icon.getInt("x");
      v = icon.getInt("y");
      width = icon.getInt("width");
      height = icon.getInt("height");
      //Draw the icon
      image(icons,x, y, width, height, u+(section*512), v, u+width+(section*512),v+height);
    } catch(Exception e){
      //Handle the exception and print an error if icon not found
      System.err.println("Exception: " + e.getMessage());
    }
  }
}

