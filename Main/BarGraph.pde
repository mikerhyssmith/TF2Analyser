import java.util.Enumeration;
import java.util.Hashtable;

class BarGraph{
  Hashtable<String,DeathCount> deaths;
  int width;
  int height;
  int seperation;
  
  int maxKills=0;
  boolean showCrits=false;
  
  PFont arial;
  
  public BarGraph(Hashtable<String,DeathCount> deaths, int width, int height, int seperation){
    this.deaths = deaths;
    this.width = width;
    this.height = height;
    this.seperation = seperation;
    
    //Get the range of kill values
    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      if(death.getCount()>maxKills){
        maxKills = death.getCount();
      }
    }
    
    arial = createFont("Arial",12,true);
    textAlign(CENTER);
  }
  
  public void draw(){
    int h=0;
    int x = 0;
    //Need to put checks in to make sure bars arent too narrow
    System.out.println(deaths.size());
    int barWidth = (width - ((deaths.size()-1)*seperation)) / deaths.size();
    
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
      h =  (int) map(death.getCount(),0,maxKills,0,height);
      
      fill(100);
      rect(x,height-h,barWidth,h);
      
      textFont(arial);       
      fill(0);
      text(death.getCause(),x+barWidth/2,height/2); 
      
      if((mouseX>x && mouseX<=x+barWidth)){
        fill(255,40,40);
        h = (int) map(death.getCritCount(),0,maxKills,0,height);
        rect(x,height-h,barWidth,h);
      }
      x+=(seperation+barWidth);
    }
  }
}
