import processing.core.PApplet;

class Circle {
  float x;
  float y;
  float r;
  String label;
  PApplet processing;
 
  Circle(PApplet p,float x, float y, float r, String label){
    this.x = x;
    this.y = y;
    this.r = r;
    this.label = label;
    processing = p;
  }
  
  boolean containsPoint(float x, float y){
    float dist = ((this.x - x)*(this.x-x)) + ((this.y - y)*(this.y - y));
    
    if(dist < (r*r)){
      return true;
    }else{
      return false;
    }
  }
  
  void draw()
  {
    processing.ellipse(x, y, r*2, r*2);
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public float getRadius(){
    return r;
  }
  public String getLabel(){
    return label;
  }
  public void setX(float x){
    this.x = x;
  }
  public void setY(float y){
    this.y = y;
  }
}

