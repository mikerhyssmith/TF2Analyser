import processing.core.PApplet;
import processing.data.JSONObject;

class WeaponToClassMap{
	
	PApplet processing;
	
	JSONObject gameData;

	public WeaponToClassMap(PApplet p){
		this.processing = p;
		gameData=processing.loadJSONObject("kill_icons.JSON");

	}


	/**
	* Method for getting the class that uses a weapon: weaponName
	*/
	public String getPlayerClass(String weaponName){
		String playerClass = "unknown";
		JSONObject weapon;
		try{
			weapon = gameData.getJSONObject(weaponName);
			playerClass = weapon.getString("class");
  		} catch(Exception e){
      		//Handle the exception and print an error if icon not found
     	 	System.err.println("Exception: " + e.getMessage());
  		}

  		return playerClass;

	}

	/**
	*Method for getting the colour representing a class.
	*/
	public int getClassColour(String playerClass){
		int red = 0;
		int green = 0;
		int blue = 0;

			if(playerClass.equals("pyro")){
				red = 47;
				green = 79;
				blue = 79;
			}else if(playerClass.equals("soldier")){
				red = 27;
			    green = 37;
				blue = 48;
			}else if(playerClass.equals("scout")){
				red = 37;
				green = 109;
				blue = 141;

			}else if(playerClass.equals("demoman")){
				red = 128;
				green = 128;
				blue = 0;
			}else if(playerClass.equals("engineer")){
				red = 0;
				green = 111;
				blue = 112;
			}else if(playerClass.equals("heavy")){
				red = 112;
				green = 176;
				blue = 74;
			}else if(playerClass.equals("medic")){
				red = 157;
				green = 49;
				blue = 47;

			}else if(playerClass.equals("sniper")){
				red = 163;
				green = 97;
				blue = 16;

			}else if(playerClass.equals("spy")){
				red = 128;
				green = 42;
				blue = 32;

			}else if(playerClass.equals("environment")){
				red = 255;
				green = 215;
				blue = 0;
			}else if(playerClass.equals("suicide")){
					red = 255;
					green = 0;
					blue = 0;
			}else{
				red = 165;
			    green = 15;
			    blue = 121;

			}
			
		return processing.color(red,green,blue);

	}

	public String getPrettyPrintWeaponName(String weaponName){
		String prettyPrintName = "unknown";
		JSONObject weapon;
		try{
			weapon = gameData.getJSONObject(weaponName);
			prettyPrintName = weapon.getString("pretty-print");
  		} catch(Exception e){
      		//Handle the exception and print an error if icon not found
     	 	System.err.println("Exception: " + e.getMessage());
  		}

  		return prettyPrintName;


	}
}
