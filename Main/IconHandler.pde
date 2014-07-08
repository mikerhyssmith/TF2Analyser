class IconHandler{
  PImage icons;
  int xPos;
  int yPos;
  int iconWidth;
  int iconHeight;
  
  Hashtable<String, PVector> iconLocations;
  Boolean locationsLoaded;
  
  public IconHandler(String fileName, int iconWidth, int iconHeight){
    icons = loadImage(fileName);
    this.iconWidth = iconWidth;
    this.iconHeight = iconHeight;
    
    //Try to load icon positions from text file
    locationsLoaded = SetupIconTable("killicons.txt");
    //If loading fails, print an error
    if(!locationsLoaded){
      System.out.println("Icon location file format error.");
    }
  }
  
  public void Draw(String weapon, float x, float y){
    PVector position; 
    int u=0,v=0; 
    
    //If icon positions were loaded
    if(locationsLoaded){
      //Look for the kill icon in the hashtable
      position = iconLocations.get(weapon);
      if(position!=null){
        //If the icon was found, draw it
        u=(int)position.x;
        v=(int)position.y;
        
        image(icons,x, y, (float)iconWidth, (float)iconHeight, u*iconWidth, v*iconHeight, (u+1)*iconWidth, (v+1)*iconHeight);
      }
      else{
        //System.out.println("Icon location not found for "+ weapon);
      }
    }
    else{
      System.out.println("No icons loaded!");
    }

  }


  Boolean  SetupIconTable(String fileName)
  {
    iconLocations = new Hashtable<String, PVector>();
    String[] data = loadStrings(fileName);

    String weapon;
    PVector location;
    int dividerPos;
    
    for(int i =0; i<data.length;i++){
      //Look for a weapon name
      if(data[i].substring(0,6).equals("name: ")){
        //Store weapon name
        weapon=data[i].substring(6);
        //Move to next line and read in position
        i++;
        dividerPos = data[i].indexOf(",");
        //Check that there is a divider
        if(dividerPos!=-1){
          //Save the weapon to the hashtable
          location = new PVector(Float.parseFloat(data[i].substring(0,dividerPos)), Float.parseFloat(data[i].substring(dividerPos+1)));
          iconLocations.put(weapon,location);
        }
        else{
          //If line is not formatted correctly, return an error
          System.out.println("Invalid file format at line: " +i);
          return false;
        }
      }
      else{
        //If line is not formatted correctly, return an error
        System.out.println("Invalid file format at line: " +i);
        return false;
      }
    }
    return true;
  }
}

