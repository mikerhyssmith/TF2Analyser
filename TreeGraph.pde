import java.util.Hashtable;
import java.util.HashMap;
import java.util.*;
import treemap.*;
 
 
 
class TreeGraph{
	HashMap<String,Integer> classKills;
	Hashtable<String,DeathCount> data;
	Treemap map;
  WeaponToClassMap dataMap = new WeaponToClassMap();
  boolean classObject = false;
  PFont arial;
  Area statsArea;

 
 	TreeGraph(Hashtable<String, DeathCount> data, Area graphArea, Area statsArea){
 		classKills = new HashMap<String,Integer>();
 		this.data = data;
    arial = createFont("Arial",11,true);
    this.statsArea = statsArea;

    processWeaponsData();
    processTreeGraph();
 	}

/**
* Draws the key for the graph showing the class name next to the colour that represents it.
*/
  public void drawKey(){
    fill(200);
    rect(statsArea.getX(), statsArea.getY(), statsArea.getWidth(), statsArea.getHeight(), 7);
    textFont(arial);       
    
    textAlign(LEFT);
    ellipseMode(CORNER);

    fill(0);    
    text("Scout", statsArea.getX()+10, statsArea.getY()+20);
    text("Soldier", statsArea.getX()+100, statsArea.getY()+20); 
    text("Pyro", statsArea.getX()+190, statsArea.getY()+20);
    text("Demo", statsArea.getX()+10, statsArea.getY()+40);
    text("Heavy", statsArea.getX()+100, statsArea.getY()+40);
    text("Engi", statsArea.getX()+190, statsArea.getY()+40);
    text("Medic", statsArea.getX()+10, statsArea.getY()+60);
    text("Sniper", statsArea.getX()+100, statsArea.getY()+60);
    text("Spy", statsArea.getX()+190, statsArea.getY()+60);
    text("Environment", statsArea.getX()+50, statsArea.getY()+80);
    text("Suicide", statsArea.getX()+170, statsArea.getY()+80);

    fill(dataMap.getClassColour("scout"));
    ellipse(statsArea.getX() + 45, statsArea.getY() + 10,10,10);

    
    fill(dataMap.getClassColour("soldier"));
    ellipse(statsArea.getX() + 145, statsArea.getY() + 10,10,10);

    
    fill(dataMap.getClassColour("pyro"));
    ellipse(statsArea.getX() + 220, statsArea.getY() + 10,10,10);

    
    fill(dataMap.getClassColour("demoman"));
    ellipse(statsArea.getX() + 45, statsArea.getY() + 30,10,10);

    
    fill(dataMap.getClassColour("heavy"));
    ellipse(statsArea.getX() + 145, statsArea.getY() + 30,10,10);

    
    fill(dataMap.getClassColour("engineer"));
    ellipse(statsArea.getX() + 220, statsArea.getY() + 30,10,10);

    
    fill(dataMap.getClassColour("medic"));
    ellipse(statsArea.getX() + 45, statsArea.getY() + 50,10,10);

    
    fill(dataMap.getClassColour("sniper"));
    ellipse(statsArea.getX() + 145, statsArea.getY() + 50,10,10);

    
    fill(dataMap.getClassColour("spy"));
    ellipse(statsArea.getX() + 220, statsArea.getY() + 50,10,10);

    
    fill(dataMap.getClassColour("environment"));
    ellipse(statsArea.getX() + 120, statsArea.getY() + 70,10,10);

    
    fill(dataMap.getClassColour("suicide"));
    ellipse(statsArea.getX() + 210, statsArea.getY() + 70,10,10);

  }
 
 /**
 *Processes a tree map which shows the weapon statistics
 */
 	public void processWeaponsData(){
 		Iterator it = data.entrySet().iterator();
    	while (it.hasNext()) {
        	Map.Entry pair = (Map.Entry)it.next();
        	DeathCount count = (DeathCount) pair.getValue();

        	classKills.put(pair.getKey().toString(),count.getCount());

        	it.remove(); // avoids a ConcurrentModificationException

          classObject = false;
    	}

 	}

  /**
  * Processes the data which shows the class statistics
  */
  public void processClassData(){
    Iterator it = data.entrySet().iterator();
      while (it.hasNext()) {
          Map.Entry pair = (Map.Entry)it.next();
          DeathCount count = (DeathCount) pair.getValue();

          classKills.put(dataMap.getPlayerClass(pair.getKey().toString()),count.getCount());

          it.remove(); // avoids a ConcurrentModificationException

          classObject = true;
      }

  }

  /**
  *Produce the Tree Map
  */
 	public void processTreeGraph(){
 		ClassKillsMap mapData = new ClassKillsMap(classKills,classObject);
 		map = new Treemap(mapData,0,height-graphArea.getHeight(),graphArea.getWidth(),graphArea.getHeight());
    OrderedTreemap orderLayout = new OrderedTreemap();
    SquarifiedLayout layout = new SquarifiedLayout();
    map.setLayout(layout);
    map.updateLayout();


 	}

  /**
  *Draw the TreeMap
  */
 	void draw(){
 		if(map!= null){
      drawKey();
 			map.draw();

 		}
 		
 	}

}

class ClassKillsMap extends SimpleMapModel{
	HashMap classKills;
  ArrayList<KillsItem> killsArray;

	ClassKillsMap(){

	}

  /**
  * Overloaded constructor to allow us to process data.
  */
	ClassKillsMap(HashMap<String,Integer> classKills,boolean classObject){
		this.classKills = classKills;
		Iterator it = classKills.entrySet().iterator();
    killsArray = new ArrayList<KillsItem>();
    	while (it.hasNext()) {
        	Map.Entry pair = (Map.Entry)it.next();
        	int value = (Integer) pair.getValue();

      			KillsItem item = new KillsItem(pair.getKey().toString());
            item.setClassObject(classObject);
        		for(int i = 0; i< value; i++){
        			item.incrementSize();
        		}
            killsArray.add(item);
    		

		}
    finishAdd();
	}

  /**
  * Inherited method to be called to fill the items array in the super class.
  */
	void finishAdd(){
		 items = killsArray.toArray(new KillsItem[killsArray.size()]);
		 
	}

}

class KillsItem extends SimpleMapItem {
  String word;
  boolean classObject = false;
  WeaponToClassMap dataMap = new WeaponToClassMap();

  KillsItem(String word) {
    this.word = word;
  }

  void setClassObject(boolean object){
    classObject = object;
  }

  void draw() {
    String printWord =  word;

    if(classObject){

      fill(dataMap.getClassColour(word));
    }else{
      fill(dataMap.getClassColour(dataMap.getPlayerClass(word)));
      printWord = dataMap.getPrettyPrintWeaponName(word);
    }


     
    rect(x, y, w, h);

    fill(255);
    if (w > textWidth(printWord) + 6) {
      if (h > textAscent() + 6) {
        textAlign(CENTER, CENTER);
        text(printWord, x + w/2, y + h/2);
      }
    }
  }
}



