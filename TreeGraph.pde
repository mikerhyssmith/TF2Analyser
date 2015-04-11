import java.util.Hashtable;
import java.util.HashMap;
import java.util.*;
import treemap.*;
 
 
 
class TreeGraph{
	HashMap<String,Integer> classKills;
	Hashtable<String,DeathCount> data;
	Treemap map;
 
 	TreeGraph(Hashtable<String, DeathCount> data){
 		classKills = new HashMap<String,Integer>();
 		this.data = data;

 	}
 
 	public void processData(){
 		Iterator it = data.entrySet().iterator();
    	while (it.hasNext()) {
        	Map.Entry pair = (Map.Entry)it.next();
        	DeathCount count = (DeathCount) pair.getValue();

        	classKills.put(pair.getKey().toString(),count.getCount());

        	it.remove(); // avoids a ConcurrentModificationException
    	}

 	}

 	public void processTreeGraph(){
 		ClassKillsMap mapData = new ClassKillsMap();

 		mapData.finishAdd();

 		map = new Treemap(mapData,0,0,width,height);

 	}

 	void draw(){
 		if(map!= null){
 			map.draw();
 		}
 		
 	}

  
}

class ClassKillsMap extends SimpleMapModel{
	HashMap classKills;

	ClassKillsMap(){

	}

	ClassKillsMap(HashMap<String,Integer> classKills){
		this.classKills = classKills;
		Iterator it = classKills.entrySet().iterator();
    	while (it.hasNext()) {
        	Map.Entry pair = (Map.Entry)it.next();
        	int value = (Integer) pair.getValue();

        	KillsItem item = (KillsItem) pair.getValue();
    		if (item == null) {
      			item = new KillsItem(pair.getValue().toString());
        		for(int i = 0; i< value; i++){
        			item.incrementSize();
        		}
    		}

		}
	}

	void finishAdd(){
		items = new KillsItem[classKills.size()];
		classKills.values().toArray(items);
	}

}

class KillsItem extends SimpleMapItem {
  String word;

  KillsItem(String word) {
    this.word = word;
  }

  void draw() {
    fill(255);
    rect(x, y, w, h);

    fill(0);
    if (w > textWidth(word) + 6) {
      if (h > textAscent() + 6) {
        textAlign(CENTER, CENTER);
        text(word, x + w/2, y + h/2);
      }
    }
  }
}



