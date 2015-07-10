import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import processing.core.PApplet;
import processing.core.PFont;
import treemap.OrderedTreemap;
import treemap.SimpleMapItem;
import treemap.SimpleMapModel;
import treemap.SquarifiedLayout;
import treemap.Treemap;
 
 
 
public class TreeGraph{
	
	PApplet processing;
	
	HashMap<String,Integer> classKills;
	Hashtable<String,DeathCount> data;
	Treemap map;
  WeaponToClassMap dataMap;
  boolean classObject = false;
  PFont arial;
  Area graphKeyArea;
  ClassKey key ;

 
 	public TreeGraph(PApplet p, Hashtable<String, DeathCount> data, Area graphArea, Area graphKeyArea){
 		dataMap = new WeaponToClassMap(p);
 		classKills = new HashMap<String,Integer>();
 		
 		this.processing=p;
 		this.data = data;
    arial = processing.createFont("Arial",11,true);
    this.graphKeyArea = graphKeyArea;

    key = new ClassKey(p,graphKeyArea);
    processWeaponsData();
    processTreeGraph();
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
 		map = new Treemap(mapData,0,processing.height- graphArea.getHeight(),graphArea.getWidth(),graphArea.getHeight());
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
 			map.draw();

 		}
    key.draw();
 		
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
	
	PApplet processing;
  String word;
  boolean classObject = false;
  WeaponToClassMap dataMap = new WeaponToClassMap();

  KillsItem(PApplet p, String word) {
	  this.processing = p;
    this.word = word;
  }

  public void setClassObject(boolean object){
    classObject = object;
  }

  public void draw() {
    String printWord =  word;

    if(classObject){

      fill(dataMap.getClassColour(word));
    }else{
      fill(dataMap.getClassColour(dataMap.getPlayerClass(word)));
      printWord = dataMap.getPrettyPrintWeaponName(word);
    }


     
    processing.rect(x, y, w, h);

    processing.fill(255);
    if (w > processing.textWidth(printWord) + 6) {
      if (h > processing.textAscent() + 6) {
    	  processing.textAlign(processing.CENTER, processing.CENTER);
        text(printWord, x + w/2, y + h/2);
      }
    }
  }
}



