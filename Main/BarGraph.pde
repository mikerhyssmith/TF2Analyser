class BarGraph{
  DeathCount[] deaths;
  int width;
  int height;
  int seperation;
  
  int maxKills=0;
  
  public BarGraph(DeathCount[] deaths, int width, int height, int seperation){
    this.deaths = deaths;
    this.width = width;
    this.height = height;
    this.seperation = seperation;
    
    //Get the range of kill values
    for(int i=0; i<deaths.length;i++){
      if(deaths[i].getCount()>maxKills){
        maxKills = deaths[i].getCount();
      }
    }
  }
  
  public void draw(){
    int h=0;
    int x = 0;
    //Need to put checks in to make sure bars arent too narrow
    int barWidth = (width - ((deaths.length-1)*seperation)) / deaths.length;
    
    //Just one colour for now
    fill(50);
    
    for(int i = 0; i<deaths.length; i++)
    {
      //Scale bar heights so that the highest is as tall as the graph
      h = (int) map(deaths[i].getCount(),0,maxKills,0,height);
      
      rect(x,height-h,barWidth,h);
      
      x+=seperation;
    }
  }
}
