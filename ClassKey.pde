class ClassKey{
	Area keyArea;
	WeaponToClassMap dataMap = new WeaponToClassMap();
	PFont arial;

	public ClassKey(Area keyArea){
		this.keyArea = keyArea;
		arial = createFont("Arial",11,true);
	}


	void draw(){

	fill(200);
    rect(keyArea.getX(), keyArea.getY(), keyArea.getWidth(), keyArea.getHeight(), 7);
    textFont(arial);       
    
    textAlign(LEFT);
    ellipseMode(CORNER);

    fill(0);    
    text("Scout", keyArea.getX()+10, keyArea.getY()+20);
    text("Soldier", keyArea.getX()+100, keyArea.getY()+20); 
    text("Pyro", keyArea.getX()+190, keyArea.getY()+20);
    text("Demo", keyArea.getX()+10, keyArea.getY()+40);
    text("Heavy", keyArea.getX()+100, keyArea.getY()+40);
    text("Engi", keyArea.getX()+190, keyArea.getY()+40);
    text("Medic", keyArea.getX()+10, keyArea.getY()+60);
    text("Sniper", keyArea.getX()+100, keyArea.getY()+60);
    text("Spy", keyArea.getX()+190, keyArea.getY()+60);
    text("Environment", keyArea.getX()+50, keyArea.getY()+80);
    text("Suicide", keyArea.getX()+170, keyArea.getY()+80);

    fill(dataMap.getClassColour("scout"));
    ellipse(keyArea.getX() + 45, keyArea.getY() + 10,10,10);

    
    fill(dataMap.getClassColour("soldier"));
    ellipse(keyArea.getX() + 145, keyArea.getY() + 10,10,10);

    
    fill(dataMap.getClassColour("pyro"));
    ellipse(keyArea.getX() + 220, keyArea.getY() + 10,10,10);

    
    fill(dataMap.getClassColour("demoman"));
    ellipse(keyArea.getX() + 45, keyArea.getY() + 30,10,10);

    
    fill(dataMap.getClassColour("heavy"));
    ellipse(keyArea.getX() + 145, keyArea.getY() + 30,10,10);

    
    fill(dataMap.getClassColour("engineer"));
    ellipse(keyArea.getX() + 220, keyArea.getY() + 30,10,10);

    
    fill(dataMap.getClassColour("medic"));
    ellipse(keyArea.getX() + 45, keyArea.getY() + 50,10,10);

    
    fill(dataMap.getClassColour("sniper"));
    ellipse(keyArea.getX() + 145, keyArea.getY() + 50,10,10);

    
    fill(dataMap.getClassColour("spy"));
    ellipse(keyArea.getX() + 220, keyArea.getY() + 50,10,10);

    
    fill(dataMap.getClassColour("environment"));
    ellipse(keyArea.getX() + 120, keyArea.getY() + 70,10,10);

    
    fill(dataMap.getClassColour("suicide"));
    ellipse(keyArea.getX() + 210, keyArea.getY() + 70,10,10);
	}



}