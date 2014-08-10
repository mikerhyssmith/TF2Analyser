class ToolTip{
  //Area taken up by tooltip text
  Area tipArea;
  //Tip text (each element is a new line)
  String[] tipText;
  //Fill colour for tooltip box
  color tipColour;
  PFont font;
  //For when a tooltip containing a weapon icon is required
  Area iconArea = new Area(0,0,0,0);
  
  //Pixels added between text and edge of tooltip box
  int padding = 2;
  //Used to flip the tooltip if its too close to an edge
  float uOffset =0;
  float vOffset =0;
  
  public ToolTip(String text, color colour, PFont font){
    this.tipText = text.split("\n");
    this.tipColour = colour;
    this.font = font;
    textFont(font);
    
    //Calculate the area of the tooltip
    int width = 0;
    
    //Find widest line
    for(int i=0;i<tipText.length;i++){
      int l =(int)textWidth(tipText[i]);
      if(width < l){
        width = l;
      }
    }

    int height = ((int)textAscent()+(int)textDescent())*tipText.length;
    tipArea = new Area(width,height, mouseX-width, mouseY-height);
  }
  
  public ToolTip(String text, color colour, PFont font, Area iconArea){
    this.tipText = text.split("\n");
    this.tipColour = colour;
    this.font = font;
    textFont(font);
    
    //Calculate the area of the tooltip
    int width = 0;
    
    //Find widest line
    for(int i=0;i<tipText.length;i++){
      int l =(int)textWidth(tipText[i]);
      if(width < l){
        width = l;
      }
    }
    
    //If the icon is wider than the text, widen the box to accomodate it
    if(iconArea.getWidth()>width){
      width=iconArea.getWidth(); 
    }
    
    int height = ((int)textAscent()+(int)textDescent())*tipText.length;
    tipArea = new Area(width,height, mouseX-width, mouseY-height);
    this.iconArea=iconArea;
  }
  
  public PVector getIconPosition(){
    return new PVector(tipArea.getX() - padding + uOffset,
                       tipArea.getY() - padding + vOffset + tipArea.getHeight() - iconArea.getHeight()); 
  }
  
  public void draw(){
    //Draw a box for the tooltip
    fill(tipColour);
    
    float u=tipArea.getX()-(2*padding);
    float v= tipArea.getY()-(2*padding) -iconArea.getHeight();
    float w=tipArea.getWidth() + (2*padding);
    float h=tipArea.getHeight()+ (2*padding) + iconArea.getHeight();

    float uOffset =0;
    float vOffset =0;
    
    //Handle the tooltip being too close to the screen edge
    if(mouseX<w){
      uOffset = w;
    }
    if(mouseY<v){
      vOffset = h;
    }
    
    rect(u+uOffset,v+vOffset,w,h);
    
    //Draw the tooltip text
    textFont(font);       
    fill(0);
    
    textAlign(LEFT,TOP);
    for(int i=0;i<tipText.length;i++){
      text(tipText[i], tipArea.getX()-padding + uOffset, 
                       tipArea.getY()-padding + vOffset + ((tipArea.getHeight()/tipText.length)*i -  iconArea.getHeight()));
    }
    
    
    textAlign(LEFT,BASELINE);
  }
}
