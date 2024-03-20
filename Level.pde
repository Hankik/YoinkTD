class Level implements Updates, Displays {

  PlayerController controller = new PlayerController();
  ArrayList<Object> actors = new ArrayList(); // do not add non-actor types

  Level() {

    Tile t = (Tile) addActor("Tile");
    t.heldItem = new WeakReference(controller.player);
  }

  void update() {
    controller.update();
    controller.player.update();
    update(actors);
  }

  void display() {

    controller.player.display();
    display(actors);
  }

  void keyPressed() {
    controller.keyPressed();
  }

  void keyReleased() {
    controller.keyReleased();
  }

  void mousePressed() {
    controller.mousePressed();
  }

  void mouseReleased() {
    controller.mouseReleased();
  }


  Actor addActor(String name) {
    Actor actor = createActor(name);
    if (actor != null) {
      actors.add(actor);
      println(name + " actor added to a level.");
    }
    return actor;
  }
  
}
