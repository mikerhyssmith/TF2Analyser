import java.util.Enumeration;
import java.util.Hashtable;

class CircleGraph {

  float graphWidth, graphHeight, circleSpacing, xCentre, yCentre;
  Hashtable<String,DeathCount> deaths;
  ArrayList<Circle> circles;
  float damping;
  int totalIterations, remainingIterations;
  int circleScale;

  CircleGraph(float width, float height, Hashtable<String,DeathCount> deaths, float spacing, int iterations)
  {
    this.graphWidth = width;
    this.graphHeight = height;
    this.xCentre = width/2;
    this.yCentre = height/2;
    this.deaths = deaths;
    this.circleSpacing = spacing;
    
    //Might take these out?
    damping = 0.01;
    this.totalIterations = iterations;
    remainingIterations = totalIterations;
    
    //Used to scale circle radius with kills
    this.circleScale = 5;
    createCircles();
  }

  float distanceSquared(float x1, float y1, float x2, float y2)
  {
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
  }
  
  //Take data in hashtable of deaths, convert to arraylist
  void createCircles(){
    //Set up iterator for deaths
    Enumeration<String> enumDeath = deaths.keys();
    String key;
    DeathCount death;
    Random rand = new Random();
    
    //Initialise circle arraylist
    circles = new ArrayList<Circle>(deaths.size());
    
    while(enumDeath.hasMoreElements()){
      key = enumDeath.nextElement();
      death = deaths.get(key);
      
      circles.add(new Circle(xCentre + 2*(rand.nextFloat() -0.5),yCentre + 2*(rand.nextFloat() -0.5), death.getCount()*circleScale, key));
    }
  }


  void packCircles()
  {
    for (int i = 0; i < circles.size(); i++)
    {
      Circle c1 = (Circle) circles.get(i);

      for (int j = i+1; j < circles.size(); j++)
      {
        Circle c2 = (Circle) circles.get(j);

        float squareDistance = distanceSquared(c1.getX(), c1.getY(), c2.getX(), c2.getY());
        float r = c1.getRadius() + c2.getRadius() + circleSpacing;

        //If circles are closer than they should be
        if (squareDistance < (r*r))
        {
          //Calculate x, y and total seperations
          float dx = c2.getX() - c1.getX();
          float dy = c2.getY() - c1.getY();
          float totalDistance = sqrt(squareDistance);

          //Distance squared from the centre of the graph
          float cd1 = distanceSquared(c1.getX(), c1.getY(), xCentre, yCentre);
          float cd2 = distanceSquared(c2.getX(), c2.getY(), xCentre, yCentre);
          
          //think this is unused
         // float total = dx + dy;

          //Increment to apply to each circle
          float vx = (dx/totalDistance) * (r-totalDistance);
          float vy = (dy/totalDistance) * (r-totalDistance);

          //Alter circle positions based on increments
          c1.x -= vx * cd1/(cd1+cd2);
          c1.y -= vy * cd1/(cd1+cd2);
          c2.x += vx * cd2/(cd1+cd2);
          c2.y += vy * cd2/(cd1+cd2);
        }    
      }
    }
    
    
    //Circles move to centre by default
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c = (Circle) circles.get(i);
      float vx = (c.x - xCentre) * damping;
      float vy = (c.y - yCentre)  *damping;
      c.x -= vx;
      c.y -= vy;
    }
    
  }
/*
  void update() {
    for (int w=0; w<iterations; w++)
    {
      this.pack();
    }
  }*/
  
  void draw()
  {
    /**
    if(remainingIterations > 0){
      packCircles();
      System.out.println("pack iteration " + remainingIterations);
      remainingIterations -= 1;
    }
    */
    packCircles();
    System.out.println( frameRate);
    
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c = (Circle) circles.get(i);
      if (c.r < 1)
      {
        circles.remove(c);
      } else
      {
        c.draw();
      }
    }
  }
}

