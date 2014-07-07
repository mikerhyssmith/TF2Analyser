class IconHandler{
  PImage icons;
  int xPos;
  int yPos;
  int iconWidth;
  int iconHeight;
  
  
  public IconHandler(String fileName, int iconWidth, int iconHeight){
    icons = loadImage(fileName);
    this.iconWidth = iconWidth;
    this.iconHeight = iconHeight;
  }
  
  public void Draw(String weapon){
    KillType kill = KillType.valueOf(weapon.toUpperCase());
    
    imageMode(CORNER);

    switch(kill){
      case TF_PROJECTILE_ROCKET:  image(icons, 10, 10, iconWidth, iconHeight);
                                  println("rocket");
           break;
      default: println("UNKNOWN KILL");
                break;
    }
  }
}

