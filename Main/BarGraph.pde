import java.util.Enumeration;
import java.util.Hashtable;
import controlP5.*;

class BarGraph{
  //Table of deaths and causes
  Hashtable<String,DeathCount> deaths;
  //Distance between adjacent bars
  int seperation;
  //Posiion and size of the graph
  Area graphArea;
  //Highest # of kills (used for scaling the bars)
  int maxKills=0;
  //Whether or not to always draw crit kills
  boolean showCrits=false;
  
  //Display stuff
  PFont arial;
  ControlP5 barControl;

  
  Slider barSlider;
  //Width of the killicon image
  int barWidth=128;
  //Whether the graph fits in its allocated area or not
  boolean graphFits =true;
  float xShift;
  
  
  public BarGraph(Hashtable<String,DeathCount> deaths, Area barArea, int seperation, ControlP5 control){
    this.deaths = deaths;
    this.graphArea = barArea;
    this.seperation = seperation;
    this.barControl = control;
    
    barControl.setColorForeground(0xffaa0000);
    barControl.setColorBackground(0xff385C78);
    barControl.setColorLabel(0xffdddddd);
    barControl.setColorValue(0xff342F2C);
    barControl.setColorActive(0xff9D302F);

    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    //Work out the highest kill value
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      if(death.getCount()>maxKills){
        maxKills = death.getCount();
      }
    }
    
    int graphWidth = (deaths.size()*barWidth)+((deaths.size()-1)*seperation);
    
    if(graphWidth>graphArea.getWidth())
    {
      //Add a slider for horizontal scrolling
      // parameters  : name, minimum, maximum, default value (float), x, y, width, height
      barSlider = barControl.addSlider("BarSlider",0,graphWidth-width,0,0,80,width,10);
      
      graphFits = false;
    }
    
    //Set up font
    arial = createFont("Arial",12,true);
    textAlign(CENTER);
    
    println("graph position: ("+graphArea.getX()+","+graphArea.getY());
  }

  public void draw(){
    int h=0;
    int x = 0;
    //Need to put checks in to make sure bars arent too narrow
    //int barWidth = (graphArea.getWidth() - ((deaths.size()-1)*seperation)) / deaths.size();
    
    //float xShift=0;
    //if(!graphFits){
    //  xShift = barSlider.getValue();
    //}
    
    
    //Just one colour for now
    fill(50);
    
    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      //Scale bar heights so that the highest is as tall as the graph
      h =  (int) map(death.getCount(),0,maxKills,0,graphArea.getHeight()); 
      
      //Set bar colour and draw bars
      fill(100);
      rect(x+graphArea.getX()-xShift,graphArea.getHeight()+graphArea.getY()-h,barWidth,h);
      
      //Label each bar
      textFont(arial);       
      fill(0);
      text(death.getCause(),x+barWidth/2-xShift,graphArea.getHeight()/2); 
      
      //Draw crit kills if mouse is over the bar
      if((mouseX>x && mouseX<=x+barWidth)&&(mouseY>graphArea.getHeight()+graphArea.getY()-h)){
        fill(255,40,40);
        h = (int) map(death.getCritCount(),0,maxKills,0,graphArea.getHeight());
        rect(x+graphArea.getX()-xShift,graphArea.getHeight()+graphArea.getY()-h,barWidth,h);
      }
      
      //Move to next bar position
      x+=(seperation+barWidth);
    }
  }
  
  public void UpdateShift(float shift){
    xShift=shift;
  }
}
