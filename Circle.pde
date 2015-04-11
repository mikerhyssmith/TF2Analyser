class Circle {
  float x;
  float y;
  float r;
  String label;
 
  Circle(float x, float y, float r, String label){
    this.x = x;
    this.y = y;
    this.r = r;
    this.label = label;
  }
 
 
 /*
  float distance(float x1, float y1, float x2, float y2){
    return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  }
 
  float getOffset(float x, float y){
    return distance(this.x, this.y, x, y);
  }
 
  boolean contains(float x, float y){
    return distance(this.x, this.y, x, y) <= this.r;
  }
 
  boolean intersect(Circle circle){
    float d = distance(this.x, this.y, circle.x, circle.y);
    return d <= (this.r + circle.r);
  }*/
  
  void draw()
  {
    ellipse(x, y, r*2, r*2);
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
  public void setX(float x){
    this.x = x;
  }
  public void setY(float y){
    this.y = y;
  }
}

