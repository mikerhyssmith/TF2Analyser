import processing.core.PApplet;
import processing.core.PFont;

class ClassKey {
	Area keyArea;
	WeaponToClassMap dataMap = new WeaponToClassMap();
	PFont arial;
	PApplet processing;

	public ClassKey(PApplet p, Area keyArea) {
		this.keyArea = keyArea;
		processing = p;
		arial = processing.createFont("Arial", 11, true);
	}

	void draw() {

		processing.fill(200);
		processing.rect(keyArea.getX(), keyArea.getY(), keyArea.getWidth(),
				keyArea.getHeight(), 7);
		processing.textFont(arial);

		processing.textAlign(processing.LEFT);
		processing.ellipseMode(processing.CORNER);

		processing.fill(0);
		processing.text("Scout", keyArea.getX() + 10, keyArea.getY() + 20);
		processing.text("Soldier", keyArea.getX() + 100, keyArea.getY() + 20);
		processing.text("Pyro", keyArea.getX() + 190, keyArea.getY() + 20);
		processing.text("Demo", keyArea.getX() + 10, keyArea.getY() + 40);
		processing.text("Heavy", keyArea.getX() + 100, keyArea.getY() + 40);
		processing.text("Engi", keyArea.getX() + 190, keyArea.getY() + 40);
		processing.text("Medic", keyArea.getX() + 10, keyArea.getY() + 60);
		processing.text("Sniper", keyArea.getX() + 100, keyArea.getY() + 60);
		processing.text("Spy", keyArea.getX() + 190, keyArea.getY() + 60);
		processing.text("Environment", keyArea.getX() + 50, keyArea.getY() + 80);
		processing.text("Suicide", keyArea.getX() + 170, keyArea.getY() + 80);

		fill(dataMap.getClassColour("scout"));
		processing.ellipse(keyArea.getX() + 45, keyArea.getY() + 10, 10, 10);

		fill(dataMap.getClassColour("soldier"));
		processing.ellipse(keyArea.getX() + 145, keyArea.getY() + 10, 10, 10);

		fill(dataMap.getClassColour("pyro"));
		processing.ellipse(keyArea.getX() + 220, keyArea.getY() + 10, 10, 10);

		fill(dataMap.getClassColour("demoman"));
		processing.ellipse(keyArea.getX() + 45, keyArea.getY() + 30, 10, 10);

		fill(dataMap.getClassColour("heavy"));
		processing.ellipse(keyArea.getX() + 145, keyArea.getY() + 30, 10, 10);

		fill(dataMap.getClassColour("engineer"));
		processing.ellipse(keyArea.getX() + 220, keyArea.getY() + 30, 10, 10);

		fill(dataMap.getClassColour("medic"));
		processing.ellipse(keyArea.getX() + 45, keyArea.getY() + 50, 10, 10);

		fill(dataMap.getClassColour("sniper"));
		processing.ellipse(keyArea.getX() + 145, keyArea.getY() + 50, 10, 10);

		fill(dataMap.getClassColour("spy"));
		processing.ellipse(keyArea.getX() + 220, keyArea.getY() + 50, 10, 10);

		fill(dataMap.getClassColour("environment"));
		processing.ellipse(keyArea.getX() + 120, keyArea.getY() + 70, 10, 10);

		fill(dataMap.getClassColour("suicide"));
		processing.ellipse(keyArea.getX() + 210, keyArea.getY() + 70, 10, 10);
	}

}