class Player extends Actor implements Listens { // this will not be in the end product
  
  Movement movement;
  Rect rect;
  
  Player(){ 
    
    PVector startPosition = getGridLocation( new PVector(GRID_X_OFFSET, 0) );
    location = new PVector(startPosition.x, startPosition.y);
    movement = (Movement) addComponent("Movement");
    rect = (Rect) addComponent("Rect");
    rect.fillOpacity = 0;
    rect.stroke = WHITE;
    rect.strokeOpacity = 1;
    
  }
  
  void update(){
  
    rect.update();
    update(components);
    
    if (Keyboard.isDown(Keyboard.LEFT) && !Keyboard.isDown(Keyboard.RIGHT))
      movement.move( new PVector(-TILE_SIZE, 0)  ); 
    if (!Keyboard.isDown(Keyboard.LEFT) && Keyboard.isDown(Keyboard.RIGHT))
      movement.move( new PVector(TILE_SIZE, 0) ); 
    if (Keyboard.isDown(Keyboard.UP) && !Keyboard.isDown(Keyboard.DOWN))
      movement.move( new PVector(0, -TILE_SIZE) );
    if (!Keyboard.isDown(Keyboard.UP) && Keyboard.isDown(Keyboard.DOWN))
      movement.move( new PVector(0, TILE_SIZE) ); 
    
    
  }
  void display(){
  
    display(components);
  }
  
  void keyPressed(){}
  
  void keyReleased(){}
  
  void mousePressed(){}
  
  void mouseReleased(){}
} 


class PlayerController { // maybe make a global thing

  PlayerController(){}
  
  void update(){
  }
  
  void keyPressed(){}
  
  void keyReleased(){}
  
  void mousePressed(){}
  
  void mouseReleased(){}
}
