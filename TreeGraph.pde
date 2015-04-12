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
 
 	TreeGraph(Hashtable<String, DeathCount> data, Area graphArea, Area statsArea){
 		classKills = new HashMap<String,Integer>();
 		this.data = data;
    processClassData();
    processTreeGraph();


 	}
 
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

 	public void processTreeGraph(){
 		ClassKillsMap mapData = new ClassKillsMap(classKills,classObject);

 		

 		map = new Treemap(mapData,0,height-graphArea.getHeight(),graphArea.getWidth(),graphArea.getHeight());

 	}

 	void draw(){
 		if(map!= null){
 			map.draw();

 		}
 		
 	}

  
}

class ClassKillsMap extends SimpleMapModel{
	HashMap classKills;
  ArrayList<KillsItem> killsArray;

	ClassKillsMap(){

	}

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



