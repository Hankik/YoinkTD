class Tile extends Actor {

  Rect hitbox;
  // Weak references do not keep objects alive in memory when all normal (strong) references are gone
  // We use WeakReference<T> so we do not to make sure every kill method communicates to associated tiles that they need to drop their references.
  WeakReference<TileHolds> heldItem = null; 
  
  Tile(){
    name = "tile";
  
    location = new PVector(0,0); // many components require its parent have a location so make sure we instantiate location ahead of time
    hitbox = (Rect) addComponent("Rect");  // like rect ^^
  }
  
  void update(){
    update(components);
  }
  
  void display(){
    display(components);
  }
}
