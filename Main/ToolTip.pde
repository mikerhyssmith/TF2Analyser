class ToolTip{
  Area tipArea;
  String[] tipText;
  color tipColour;
  PFont font;
  
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
  
  public void draw(){
    //Draw a box for the tooltip
    fill(tipColour);
    rect(tipArea.getX()-2, tipArea.getY()-2, tipArea.getWidth()+2,tipArea.getHeight()+2);
    
    //Draw the tooltip text
    textFont(font);       
    fill(0);
    
    textAlign(LEFT,TOP);
    for(int i=0;i<tipText.length;i++){
      text(tipText[i],tipArea.getX()-1 , tipArea.getY()-1 + ((tipArea.getHeight()/tipText.length)*i));
    }
  }
}
