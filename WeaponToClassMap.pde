class WeaponToClassMap{
	
	JSONObject gameData;

	public WeaponToClassMap(){
		gameData=loadJSONObject("kill_icons.JSON");

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
	public color getClassColour(String playerClass){
		int red = 0;
		int green = 0;
		int blue = 0;

			if(playerClass.equals("pyro")){
				red = 255;
				green = 0;
				blue = 0;
			}else if(playerClass.equals("soldier")){
				red = 0;
			    green = 0;
				blue = 255;
			}else if(playerClass.equals("scout")){
				red = 255;
				green = 0;
				blue = 255;

			}else if(playerClass.equals("demoman")){
				red = 0;
				green = 255;
				blue = 255;
			}else if(playerClass.equals("engineer")){
				red = 255;
				green = 255;
				blue = 0;
			}else if(playerClass.equals("sniper")){
				red = 100;
				green = 100;
				blue = 50;
			}else if(playerClass.equals("medic")){
				red = 255;
				green = 45;
				blue = 110;

			}else if(playerClass.equals("heavy")){
				red = 0;
				green = 10;
				blue = 45;

			}else if(playerClass.equals("environment")){
				red = 10;
				green = 50;
				blue = 25;
			}else if(playerClass.equals("suicide")){
					red = 255;
					green = 0;
					blue = 24;
			}else{
				red = 255;
			    green = 255;
			    blue = 255;

			}
			
		return color(red,green,blue);

	}


}