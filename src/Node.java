class Node{
  
  private float x;
  private float y;
  private ToolTip tip;
  
 public Node(float x, float y, ToolTip tip ){
   this.x = x;
   this.y = y;
   this.tip = tip;
  
 } 
 
 public float  getX(){
   return x;
 }
 
 public float getY(){
   return y; 
 }
 
 public ToolTip getTooltip(){
  return tip; 
 }
  
}
