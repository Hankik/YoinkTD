enum LEVEL_TYPE {
  LEVEL,
  PAUSE_MENU,
  MAIN_MENU,
  HUD,
}

class Level implements Updates, Displays, Listens {

  ArrayList<Object> actors = new ArrayList(); // do not add non-actor types
  ArrayList<Command> commands = new ArrayList();
  LEVEL_TYPE type = LEVEL_TYPE.LEVEL;

  Level(LEVEL_TYPE type) {
    this.type = type;
    if (type != LEVEL_TYPE.LEVEL) { println("Created ui scene " + cleanName(this.toString())); return; }
    else println("Created level " + cleanName(this.toString()));

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
    for (Object a : actors) if (a instanceof Listens) ((Listens)a).keyPressed();
  }

  void keyReleased() {
    for (Object a : actors) if (a instanceof Listens) ((Listens)a).keyReleased();
  }

  void mousePressed() {
   for (Object a : actors) if (a instanceof Listens) ((Listens)a).mousePressed();
  }

  void mouseReleased() {
    for (Object a : actors) if (a instanceof Listens) ((Listens)a).mouseReleased();
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
