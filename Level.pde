enum LEVEL_TYPE {
  LEVEL,
  PAUSE_MENU,
  MAIN_MENU,
  HUD,
}

class Level implements Updates, Displays {

  ArrayList<Object> actors = new ArrayList(); // do not add non-actor types
  ArrayList<Command> commands = new ArrayList();
  LEVEL_TYPE type = LEVEL_TYPE.LEVEL;

  Level(LEVEL_TYPE type) {
    this.type = type;
    if (type != LEVEL_TYPE.LEVEL) { println("Created ui scene " + cleanName(this.toString())); return; }

    Tile t = (Tile) addActor("Tile");
    //addActor("Tile");
    Player player = (Player) addActor("Player");
    t.heldItem = new WeakReference(player);
  }

  void update() {
    update(actors);
    handleCommands();
  }
  
  void handleCommands(){
    for (int i = commands.size() - 1; i >= 0; i--) {
      commands.get(i).call();
      commands.remove(i);
    }
  }

  void display() {
    display(actors);
  }

  void keyPressed() {
    //controller.keyPressed();
  }

  void keyReleased() {
    //controller.keyReleased();
  }

  void mousePressed() {
   // controller.mousePressed();
  }

  void mouseReleased() {
    //controller.mouseReleased();
  }

  Actor addActor(Actor actor){
    if (actor != null)  {
    
      actors.add(actor);
      println(actor.getClass().getSimpleName() + " actor added to " + cleanName(this.toString()) + "... ");
    }
    return actor;
  }

  Actor addActor(String name) {
    Actor actor = createActor(name);
    if (actor != null) {
      actors.add(actor);
      println(name + " actor added to " + cleanName(this.toString()));
    }
    return actor;
  }
}
