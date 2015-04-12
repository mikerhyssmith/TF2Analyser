import java.util.Enumeration;
import java.util.Hashtable;

class CircleGraph {
  //Font and icons for tooltips
  PFont arial;
  IconHandler icons;
  
  Area graphArea;
  float xCentre, yCentre;
  
  Hashtable<String,DeathCount> deaths;
  
  ArrayList<Circle> circles;
  float circleSpacing;
  float damping;
  int circleScale;
  
  int totalIterations, remainingIterations;

  CircleGraph(Area area, Hashtable<String,DeathCount> deaths, float spacing, int iterations)
  {
    this.graphArea =area;
    this.xCentre = graphArea.getWidth()/2 + graphArea.getX();
    this.yCentre = graphArea.getHeight()/2 + graphArea.getY();
    this.deaths = deaths;
    this.circleSpacing = spacing;
    
    damping = 0.01;
    this.totalIterations = iterations;
    remainingIterations = totalIterations;
    
    //Used to scale circle radius with kills
    this.circleScale = 2;
    createCircles();
    
    //Set up font
    arial = createFont("Arial",12,true);
    //Set up icons
    icons = new IconHandler("killicons_final.png");
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
    
    //Sort according to size
    Collections.sort(circles, new Comparator<Circle>() {
      //Return a negative integer, zero, or a positive integer as the first argument is less than, equal to, or greater than the second.
        @Override
        public int compare(Circle c1, Circle c2)
        {
            if(c1.getRadius()<c2.getRadius()){
              return -1;
            }
            if(c1.getRadius()>c2.getRadius()){
              return 1;
            }
            return 0;
        }
    });
  }


  void packCircles()
  {
    
    for (int i = 0; i < circles.size(); i++)
    {
      Circle c1 = (Circle) circles.get(i);
      
      //First push circles in if they are outside the graph boundary
      float xShift = 0;
      float yShift = 0;
      System.out.println("Circle: "+ c1.getLabel());
      //Off the right of the screen
      if((c1.getX() + c1.getRadius()) > graphArea.getWidth() + graphArea.getX()){
        xShift = ((graphArea.getWidth() + graphArea.getX()) - (c1.getX() + c1.getRadius())) *10*damping;
        System.out.println("Right "+xShift);
      }
      //Off the left of the screen
      if((c1.getX() - c1.getRadius()) < graphArea.getX()){
        xShift = (graphArea.getX() - (c1.getX() - c1.getRadius())) * 10*damping;
                System.out.println("left "+xShift);
      }
      //Off the bottom of the screen
      if((c1.getY() + c1.getRadius()) > graphArea.getHeight() + graphArea.getY()){
        yShift = ((graphArea.getHeight() + graphArea.getY()) - (c1.getY() + c1.getRadius())) * 10* damping;
                System.out.println("bottom "+yShift);
      }
      //Off the top of the screen
      if((c1.getY() - c1.getRadius()) < graphArea.getY()){
        yShift = (graphArea.getY() - (c1.getY() - c1.getRadius())) *10* damping;
                System.out.println("top "+yShift);
      }
      //Apply the necessary shift

      c1.setX(c1.getX()+xShift);
      c1.setY(c1.getY()+yShift);
      
      //for (int j = i+1; j < circles.size(); j++)
      for(int j = circles.size()-1; j>i; j--)
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
/*
    //Circles move to centre by default
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c = (Circle) circles.get(i);
      float vx = (c.x - xCentre) *damping;
      float vy = (c.y - yCentre) *damping;
      c.x -= vx;
      c.y -= vy;
    }
    /*
    //Push in circles that are outside the graph area
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c = (Circle) circles.get(i);
      float vx = 0;
      float vy = 0;
      
      //Off the right of the screen
      if((c.getX() + c.getRadius()) > graphArea.getWidth() + graphArea.getX()){
        vx = ((graphArea.getWidth() + graphArea.getX()) - (c.getX() + c.getRadius())) * damping;
        System.out.println("Right "+vx);
      }
      //Off the left of the screen
      if((c.getX() - c.getRadius()) < graphArea.getX()){
        vx = (graphArea.getX() - (c.getX() - c.getRadius())) * damping;
                System.out.println("left "+vx);
      }
      //Off the bottom of the screen
      if((c.getY() + c.getRadius()) > graphArea.getHeight() + graphArea.getY()){
        vy = ((graphArea.getHeight() + graphArea.getY()) - (c.getY() + c.getRadius())) * damping;
                System.out.println("bottom "+vy);
      }
      //Off the top of the screen
      if((c.getY() - c.getRadius()) < graphArea.getY()){
        vy = (graphArea.getY() - (c.getY() - c.getRadius())) * damping;
                System.out.println("top "+vy);
      }

      c.setX(c.getX()+vx);
      c.setY(c.getY()+vy);
    }*/
    
  }
  
  void draw()
  {
    boolean circleSelected = false;
    String circleKey = "";
    DeathCount death;
    fill(150);
    stroke(0);
    /**
    if(remainingIterations > 0){
      packCircles();
      System.out.println("pack iteration " + remainingIterations);
      remainingIterations -= 1;
    }
    */
    packCircles();
    ellipseMode(CENTER);
    for (int i = 0; i < circles.size (); i++)
    {
      Circle c =  circles.get(i);
      c.draw();
      //Draw crit kills and tooltip if mouse is over the bar
      if(c.containsPoint(mouseX,mouseY)){
        circleSelected=true;
        circleKey = c.getLabel();
      }
    }
    //Draw tooltip over highlighted bar
    if(circleSelected){
      death = deaths.get(circleKey);
      ToolTip tip = new ToolTip("Weapon: "+death.getCause() +"\n" + "Kills: " + death.getCount() + "\n" + "Crits: " + death.getCritCount(), color(248,185,138), arial);
      tip.draw();
    }
  }
}

