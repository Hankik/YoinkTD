class Level implements Updates, Displays {
  
  PlayerController controller = new PlayerController();
  ArrayList<Object> actors = new ArrayList(); // do not add non-actor types

  Level(){
    
    addActor("Tile");
    
  }
  
  void update(){
    controller.update();
    controller.player.update();
    update(actors);
  }
  
  void display(){
  
    controller.player.display();
    display(actors);
  }
  
  void keyPressed(){
    controller.keyPressed();
  }
  
  void keyReleased(){
    controller.keyReleased();
  }
  
  void mousePressed(){
    controller.mousePressed();  
  }
  
  void mouseReleased(){
    controller.mouseReleased();
  }
  
  
  Actor addActor(String name) {
    try {
        // Load class
        Class type = Class.forName("YoinkTD$" + name);
        
        // Check if the class is a subclass of Component
        if (Actor.class.isAssignableFrom(type)) {
            
    
            // Get parameter types
            Class[]  parameterTypes = {YoinkTD.class};
            
            // ------------------------------- type.getBlahBlah( requires we pass in the parameter signature to find the constructor we want ).newInstance( pass in those arguments now );
            Actor actor = (Actor) type.getDeclaredConstructor(parameterTypes).newInstance(applet); // all constructors have a hidden YoinkTD.class instance passed in
            
            // Add the component to the list
            actors.add(actor);
            
            println(name + " actor added to a level.");
            return actor;
        } else {
            println(name + " is not an actor.");
        }
    } catch (ClassNotFoundException e) {
        println("Could not find actor class: " + e);
    } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
        println("Error instantiating actor: " + e);
    }
    
    return null;
  }
}
