import java.io.*;
class NodeGraphRenderer {
  
    ArrayList<Node> nodes;
    ArrayList<Node> displayedNodes;
    float screenPosX;
    float screenPosY;
    int currentNode = 0;
    int padding = 30;
    boolean renderingActive = false;
    
    
    public NodeGraphRenderer(ArrayList<Node> nodes) {
      this.nodes = nodes;
      displayedNodes = new ArrayList<Node>();
      
    
    }
    
    public void setNodes(ArrayList<Node> nodes){
       this.nodes = nodes; 
    }

    public ArrayList<Node> getDisplayedNodes(){
      return displayedNodes;

    }

    public void setRendering(boolean active){
      renderingActive = active;
    }
    
    
    public void processGraph() {
    
        while(currentNode < nodes.size()-1){
            Node n = nodes.get(currentNode);
            Node nextNode = nodes.get(currentNode +1);
            float waitTime = (nextNode.getX() - n.getX())*10000000;
            beginShape();
            fill(255);
            stroke(1);
            float yPos = height -n.getX() -padding;
            ellipse(n.getX(),yPos,10,10);
            endShape();
  
            System.out.println("Node X: " + n.getX() + " Node Y: " + n.getY());
            System.out.println("CALLED");
            currentNode++;
            displayedNodes.add(new Node(n.getX(),yPos,n.getTooltip()));
        }
      
        System.out.println(currentNode);
        for(int i =0; i < displayedNodes.size()-1; i++){
          System.out.println("POST PRINT");
          Node n = displayedNodes.get(i);
          beginShape();
          fill(255);
          stroke(1);
          ellipse(n.getX(),n.getY(),10,10);
          endShape();
        }
     
    }  
}
