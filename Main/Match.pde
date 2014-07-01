class Match {
  
  String mapName;
  GameModes gameMode;
  
  
  public Match(String mapName, GameModes gameMode){
    
    this.mapName = mapName;
    this.gameMode = gameMode;
    
  }
  
  public GameModes getGameMode(){
    return gameMode;
  }
  
  public String getMapName(){
    return mapName;
  }
