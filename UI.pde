Level createUI(LEVEL_TYPE type) {

  Level level = new Level(type);

  switch (type) {
    // add specific actors for each menu

  case PAUSE_MENU:
    break;

  case MAIN_MENU:
    break;

  case HUD:
    level.addActor("Cursor");
    level.addActor("HUDOverlay");
    Button addNewButtonButton = (Button) level.addActor("Button");
    addNewButtonButton.purpose = () -> { 
      println();
      Button newButton = (Button) createActor("Button");
      newButton.location = getGridLocation(new PVector(
                                              random(GRID_X_OFFSET, width - GRID_X_OFFSET), 
                                              random(0, height)));
      newButton.purpose = () -> { newButton.actorState = ACTOR_STATE.DEAD;  return true; };
      // adding actors during update requires using this command
      // otherwise, you can add actors while game is paused
      AddActorCommand addActorCommand = new AddActorCommand();
      addActorCommand.actorToAdd = newButton;
      addActorCommand.actorLevel = level;
      level.commands.add( addActorCommand ); 
      return true;
    };        
    Button hidePlayerButton = (Button) level.addActor("Button");
    hidePlayerButton.location = getGridLocation( new PVector( width/2, height/2 + TILE_SIZE) );
    hidePlayerButton.purpose = () -> { 
      for (Object a : levels[currentLevel].actors) 
        if (a instanceof Player) {
          Player p = (Player) a;
          p.actorState = (p.actorState.equals(ACTOR_STATE.AWAKE) ? ACTOR_STATE.ASLEEP : ACTOR_STATE.AWAKE);
          println("\ntoggling player awake");
        } 
      return true; };

    break;
  case LEVEL:
    println("LMAO. This is for making UI not levels. Go use Level constructor.");
    break;
  }

  return level;
}

class HUDOverlay extends Actor {
  
  color fill = PINK;

  void update(){}
  
  void display(){
    rectMode(CORNER);
    fill(fill);
    noStroke();
    rect(0, 0, GRID_X_OFFSET, height); 
    rect(width - GRID_X_OFFSET, 0, GRID_X_OFFSET, height);
    
    fill(WHITE);
    textAlign(RIGHT);
    text((paused ? "paused" : ""), width - GRID_X_OFFSET - TILE_SIZE, height - TILE_SIZE);
  }
}
