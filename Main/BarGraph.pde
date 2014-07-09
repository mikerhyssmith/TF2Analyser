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
  int iconHeight=32;
  //Whether the graph fits in its allocated area or not
  boolean graphFits =true;
  //Shift value of horizontal slider
  float xShift=0;
  //Height of horizontal slider
  int sliderHeight = 20;
  
  IconHandler icons;
  
  public BarGraph(Hashtable<String,DeathCount> deaths, Area barArea, int seperation, ControlP5 control){
    this.deaths = deaths;
    this.graphArea = barArea;
    this.seperation = seperation;
    this.barControl = control;
    
    //Format interface
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
    
    //Total width of graph
    int graphWidth = (deaths.size()*barWidth)+((deaths.size()-1)*seperation);
    
    //If graph is wider than its allocated area, add a horizontal scrollbar
    if(graphWidth>graphArea.getWidth())
    {
      //Add a slider for horizontal scrolling
      barSlider = barControl.addSlider("BarSlider",0,graphWidth-width,0,0,graphArea.getY()+graphArea.getHeight()-sliderHeight,width,sliderHeight);
      
      graphFits = false;
    }
    
    //Set up font
    arial = createFont("Arial",12,true);
    textAlign(CENTER);
    
    icons = new IconHandler("killicons_final.png");
  }

  public void draw(){
    int h=0;
    int x = 0;

    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      //Scale bar heights so that the highest is as tall as the graph
      h =  (int) map(death.getCount(),0,maxKills,0,graphArea.getHeight()-iconHeight-sliderHeight); 
      
      float xpos=x+graphArea.getX()-xShift;
      //Calculate y position of rectangle
      float ypos=graphArea.getHeight()+graphArea.getY()-h-sliderHeight;
      
      //Draw icon
      icons.Draw(death.getCause(), xpos, ypos-iconHeight);
      
      //Set bar colour and draw bars
      fill(52,47,44);
      rect(xpos,ypos,barWidth,h);
      
      //Label each bar
      textFont(arial);       
      fill(0);
      text(death.getCause(),x+barWidth/2-xShift,graphArea.getHeight()/2); 
      
      //Draw crit kills if mouse is over the bar
      if((mouseX>xpos && mouseX<=xpos+barWidth)&&(mouseY>graphArea.getHeight()+graphArea.getY()-h)){
        fill(255,40,40);
        h = (int) map(death.getCritCount(),0,maxKills,0,graphArea.getHeight());
        ypos=graphArea.getHeight()+graphArea.getY()-h-sliderHeight;
        rect(xpos,ypos,barWidth,h);
      }
      
      //Move to next bar position
      x+=(seperation+barWidth);
    }
  }
  
  public void UpdateShift(float shift){
    xShift=shift;
  }
}
