
class IconHandler{
  PImage icons;
  int xPos;
  int yPos;
  float scale=1.0;
  float xOffset = 0;
  float yOffset = 0;

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
      image(icons, x + (xOffset*width*scale), y + (yOffset*height*scale), width*scale, height*scale, u+(section*512), v, u+width+(section*512),v+height);
    } catch(Exception e){
      //Handle the exception and print an error if icon not found
      System.err.println("Exception: " + e.getMessage());
    }
  }
  
  public Area getIconSize(String weapon){
    JSONObject icon;    
    Area size = new Area(0,0,0,0);
    //Look for the icon of death in the icon data
    try{
      icon = iconData.getJSONObject(weapon);
      size = new Area(icon.getInt("width"), icon.getInt("height"), icon.getInt("x"), icon.getInt("y"));
    } catch(Exception e){
      //Handle the exception and print an error if icon not found
      System.err.println("Exception: " + e.getMessage());
    }
    return size;
  }
  
  //Set scaling of icons to be drawn
  public void setScale(float scale){
    this.scale = scale;
  }
  
  //Set percentage offset of icons from right-hand corner
  public void setOffset(float xPercent, float yPercent){
    xOffset = xPercent;
    yOffset = yPercent;
    
  }
  
  
}

