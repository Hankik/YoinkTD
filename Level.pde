class Level implements Updates, Displays {
  
  PlayerController controller = new PlayerController();
  Timer test = new Timer(1);

  Level(){
    
    test.autoRestart = true;
  }
  
  void update(){
    controller.update();
    controller.player.update();
    test.update();
  }
  
  void display(){
  
    controller.player.display();
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
}
