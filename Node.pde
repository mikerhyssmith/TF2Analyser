class Node{
  
  private int x;
  private int y;
  private Tooltip tip;
  
 public Node(int x, int y, Tooltip tip){
   this.x = x;
   this.y = y;
   this.tip = tip;
  
 } 
 
 public int  getX(){
   return x;
 }
 
 public int getY(){
   return y; 
 }
 
 public Tooltip getTooltip(){
  return tip; 
 }
  
}
