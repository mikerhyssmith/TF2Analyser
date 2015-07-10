import java.util.Enumeration;
import java.util.Hashtable;

import processing.core.PApplet;
import processing.core.PFont;

public class BarGraph{
  
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
  int sliderHeight;
  //Space for stats
  int statsSpace = 50;
  
  PApplet processing;
  
  IconHandler icons;
  
  public BarGraph(PApplet p,Hashtable<String,DeathCount> deaths, Area barArea, int seperation, ControlP5 control){
    this.deaths = deaths;
    this.graphArea = barArea;
    this.seperation = seperation;
    this.barControl = control;
    processing = p;
    
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
      sliderHeight = 20;
      //Add a slider for horizontal scrolling
      barSlider = barControl.addSlider("BarSlider",0,graphWidth-width,0,0,graphArea.getY()+graphArea.getHeight()-sliderHeight,width,sliderHeight);
      
      graphFits = false;
    }
    else{
      sliderHeight = 0;
    }
    
    //Set up font
    arial = processing.createFont("Arial",12,true);

    //Set up icons
    icons = new IconHandler(processing,"killicons_final.png");
  }

  public void draw(){
    int h = 0;
    int x = 0;

    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      //Scale bar heights so that the highest is as tall as the graph
      h =  (int) processing.map(death.getCount(), 0, maxKills, 0, graphArea.getHeight()-iconHeight-sliderHeight-statsSpace); 
      
      float xpos=x+graphArea.getX()-xShift;
      //Calculate y position of rectangle
      float ypos= graphArea.getHeight() + graphArea.getY() - h - sliderHeight;
      
      //Draw icon
      icons.Draw(death.getCause(), xpos, ypos-iconHeight);
      
      //Set bar colour and draw bars
      processing.fill(52,47,44);
      processing.rect(xpos,ypos,barWidth,h);
      
      //Draw crit kills and tooltip if mouse is over the bar
      if((processing.mouseX>xpos && processing.mouseX<=xpos+barWidth)&&(processing.mouseY > processing.height -  (h + iconHeight/2) && processing.mouseY < processing.height - sliderHeight )){
        //Draw bar on top showing crit kills
        processing.fill(255,40,40);
        h = (int) processing.map(death.getCritCount(),0,maxKills,0,graphArea.getHeight()-iconHeight-sliderHeight);
        ypos=graphArea.getHeight() + graphArea.getY() - h - sliderHeight;
        
        //Draw tooltip over highlighted bar
        ToolTip tip = new ToolTip("Weapon: "+death.getCause() +"\n" + "Kills: " + death.getCount() + "\n" + "Crits: " + death.getCritCount(), color(248,185,138), arial);
        tip.draw();
      }
      
      //Move to next bar position
      x+=(seperation+barWidth);
    }
  }
  
  public void UpdateShift(float shift){
    xShift=shift;
  }
}
