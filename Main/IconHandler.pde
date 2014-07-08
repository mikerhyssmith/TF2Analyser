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
  
  public void Draw(String weapon, float x, float y){
    int u=0,v=0; 
    
    KillType kill = KillType.valueOf(weapon.toUpperCase());
    
    switch(kill){
      case TF_PROJECTILE_ROCKET:  u=0;
                                  v=3;
           break;
      case DUMPSTER_DEVICE:       u=5;
                                  v=3;
           break;
      case TF_PROJECTILE_PIPE:    u=0;
                                  v=11;
           break;
      case OBJ_SENTRYGUN:         u=5;
                                  v=17;
           break;
      case BLEED_KILL:            u=0;
                                  v=30;
           break;
      case BACKBURNER:            u=1;
                                  v=6;
           break;
     // default: println("UNKNOWN KILL");
              //  break;
    }
    
    image(icons,x, y, (float)iconWidth, (float)iconHeight, u*iconWidth, v*iconHeight, (u+1)*iconWidth, (v+1)*iconHeight);
  }
}

