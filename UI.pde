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
      Actor newButton = createActor("Button");
      newButton.location = getGridLocation(new PVector(
                                              random(GRID_X_OFFSET, width - GRID_X_OFFSET), 
                                              random(0, height)));
      // adding actors during update requires using this command
      // otherwise, you can add actors while game is paused
      AddActorCommand addActorCommand = new AddActorCommand();
      addActorCommand.actorToAdd = newButton;
      addActorCommand.actorLevel = level;
      level.commands.add( addActorCommand ); 
      return true;
    };        

    break;
  case LEVEL:
    println("LMAO. This is for making UI not levels. Go use Level constructor.");
    break;
  }

  return level;
}

class HUDOverlay extends Actor {

  void update(){}
  
  void display(){
    rectMode(CORNER);
    fill(GREEN);
    noStroke();
    rect(0, 0, GRID_X_OFFSET, height);
    rect(width - GRID_X_OFFSET, 0, GRID_X_OFFSET, height);
    textAlign(RIGHT);
    fill(WHITE);
    text("paused: " + paused, width - GRID_X_OFFSET - TILE_SIZE, height - TILE_SIZE);
  }
}
