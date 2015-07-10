import java.util.ArrayList;

import processing.core.PApplet;

public class NodeGraphRenderer {
	PApplet processing;
	
    ArrayList<Node> nodes;
    ArrayList<Node> displayedNodes;
    float screenPosX;
    float screenPosY;
    int currentNode = 0;
    int padding = 30;
    boolean renderingActive = false;
    
    public NodeGraphRenderer(PApplet p, ArrayList<Node> nodes) {
      this.nodes = nodes;
      this.processing = p;
      
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
            processing.beginShape();
            processing.fill(255);
            processing.stroke(1);
            float yPos = processing.height -n.getX() -padding;
            processing.ellipse(n.getX(),yPos,10,10);
            processing.endShape();
  
            System.out.println("Node X: " + n.getX() + " Node Y: " + n.getY());
            System.out.println("CALLED");
            currentNode++;
            displayedNodes.add(new Node(n.getX(),yPos,n.getTooltip()));
        }
      
        System.out.println(currentNode);
        for(int i =0; i < displayedNodes.size()-1; i++){
          System.out.println("POST PRINT");
          Node n = displayedNodes.get(i);
          processing.beginShape();
          processing.fill(255);
          processing.stroke(1);
          processing.ellipse(n.getX(),n.getY(),10,10);
          processing.endShape();
        }
    }  
}
