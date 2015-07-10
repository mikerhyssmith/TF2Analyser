import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PVector;

public class ToolTip{
	
	PApplet processing;
	
  //Area taken up by tooltip text
  Area tipArea;
  //Tip text (each element is a new line)
  String[] tipText;
  //Fill colour for tooltip box
  int tipColour;
  PFont font;
  //For when a tooltip containing a weapon icon is required
  Area iconArea = new Area(0,0,0,0);
  
  //Pixels added between text and edge of tooltip box
  int padding = 2;
  //Used to flip the tooltip if its too close to an edge
  float uOffset =0;
  float vOffset =0;
  
  public ToolTip(PApplet p, String text, int colour, PFont font){
	  this.processing = p;
    this.tipText = text.split("\n");
    this.tipColour = colour;
    this.font = font;
    processing.textFont(font);
    
    //Calculate the area of the tooltip
    int width = 0;
    
    //Find widest line
    for(int i=0;i<tipText.length;i++){
      int l =(int)processing.textWidth(tipText[i]);
      if(width < l){
        width = l;
      }
    }

    int height = ((int)processing.textAscent()+(int)processing.textDescent())*tipText.length;
    tipArea = new Area(width,height, processing.mouseX-width, processing.mouseY-height);
  }
  
  public ToolTip(PApplet p, String text, int colour, PFont font, Area iconArea){
	  this.processing = p;
    this.tipText = text.split("\n");
    this.tipColour = colour;
    this.font = font;
    processing.textFont(font);
    
    //Calculate the area of the tooltip
    int width = 0;
    
    //Find widest line
    for(int i=0;i<tipText.length;i++){
      int l =(int)processing.textWidth(tipText[i]);
      if(width < l){
        width = l;
      }
    }
    
    //If the icon is wider than the text, widen the box to accomodate it
    if(iconArea.getWidth()>width){
      width=iconArea.getWidth(); 
    }
    
    int height = ((int)processing.textAscent()+(int)processing.textDescent())*tipText.length;
    tipArea = new Area(width,height, processing.mouseX-width, processing.mouseY-height);
    this.iconArea=iconArea;
  }
  
  public PVector getIconPosition(){
    return new PVector(tipArea.getX() - padding + uOffset,
                       tipArea.getY() - padding + vOffset + tipArea.getHeight() - iconArea.getHeight()); 
  }
  
  public void draw(){
    //Draw a box for the tooltip
    processing.fill(tipColour);
    
    float u=tipArea.getX()-(2*padding);
    float v= tipArea.getY()-(2*padding) -iconArea.getHeight();
    float w=tipArea.getWidth() + (2*padding);
    float h=tipArea.getHeight()+ (2*padding) + iconArea.getHeight();

    //Handle the tooltip being too close to the screen edge
    if(processing.mouseX<w){
      uOffset = w;
    }
    if(processing.mouseY<v){
      vOffset = h;
    }
    
    processing.rect(u+uOffset,v+vOffset,w,h);
    
    //Draw the tooltip text
    processing.textFont(font);       
    processing.fill(0);
    
    processing.textAlign(processing.LEFT,processing.TOP);
    for(int i=0;i<tipText.length;i++){
    	processing.text(tipText[i], tipArea.getX()-padding + uOffset, 
                       tipArea.getY()-padding + vOffset + ((tipArea.getHeight()/tipText.length)*i -  iconArea.getHeight()));
    }
    
    
    processing.textAlign(processing.LEFT,processing.BASELINE);
  }
}
