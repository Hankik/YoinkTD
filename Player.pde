class Player extends Actor {
  
  Movement m_Movement;
  Rect m_Rect;
  
  Player(){ 
    name = "player";
    
    location = new PVector(0,0);
    m_Movement = (Movement) addComponent("Movement");
    m_Rect = (Rect) addComponent("Rect");
    
  }
  
  void update(){
  
    m_Rect.update();
    update(components);
    
    
  }
  void display(){
  
    m_Rect.setPosition(location);
    m_Rect.display();
  }
} 


class PlayerController {

  Player player = new Player();
  PlayerController(){}
  
  void update(){
  
    if (Keyboard.isDown(Keyboard.LEFT) && !Keyboard.isDown(Keyboard.RIGHT))
      player.m_Movement.move( new PVector(-TILE_SIZE, 0)  ); 
    if (!Keyboard.isDown(Keyboard.LEFT) && Keyboard.isDown(Keyboard.RIGHT))
      player.m_Movement.move( new PVector(TILE_SIZE, 0) ); 
    if (Keyboard.isDown(Keyboard.UP) && !Keyboard.isDown(Keyboard.DOWN))
      player.m_Movement.move( new PVector(0, -TILE_SIZE) );
    if (!Keyboard.isDown(Keyboard.UP) && Keyboard.isDown(Keyboard.DOWN))
      player.m_Movement.move( new PVector(0, TILE_SIZE) ); 
      
  }
  
  void keyPressed(){
      
  }
  
  void keyReleased(){}
  
  void mousePressed(){}
  
  void mouseReleased(){}
}
