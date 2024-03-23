class Button extends Actor {

  String text = "";
  Rect hitbox;
  ButtonState state = ButtonState.IDLE;
  Command purpose;
  
  Button(){
  
    hitbox.setPosition(new PVector(width/2, height/2));
    hitbox.setSize(TILE_SIZE, TILE_SIZE);
  }

  Button(PVector location, PVector size, String text, Command purpose) {

    hitbox = new Rect(location.x, location.y, size.x, size.y);
    this.purpose = purpose;
    this.text = text;
  }

  void update() {
    hitbox.update();

    switch (state) {

    case IDLE:
      if (mouseX < hitbox.x - hitbox.halfW) break;
      if (mouseX > hitbox.x + hitbox.halfW) break;
      if (mouseY < hitbox.y - hitbox.halfH) break;
      if (mouseY > hitbox.y + hitbox.halfH) break;
      state = ButtonState.HOVERED;
      break;
    case HOVERED:
      if (mouseX < hitbox.x - hitbox.halfW) {
        state = ButtonState.IDLE;
        break;
      }
      if (mouseX > hitbox.x + hitbox.halfW) {
        state = ButtonState.IDLE;
        break;
      }
      if (mouseY < hitbox.y - hitbox.halfH) {
        state = ButtonState.IDLE;
        break;
      }
      if (mouseY > hitbox.y + hitbox.halfH) {
        state = ButtonState.IDLE;
        break;
      }
      break;
    case PRESSED:
      if (mouseX < hitbox.x - hitbox.halfW) {
        state = ButtonState.IDLE;
        break;
      }
      if (mouseX > hitbox.x + hitbox.halfW) {
        state = ButtonState.IDLE;
        break;
      }
      if (mouseY < hitbox.y - hitbox.halfH) {
        state = ButtonState.IDLE;
        break;
      }
      if (mouseY > hitbox.y + hitbox.halfH) {
        state = ButtonState.IDLE;
        break;
      }
      break;
    case RELEASED:
      purpose.call();
      state = ButtonState.IDLE;
      break;
    }
  }

  void display() {
    
    switch (state) {
    
      case IDLE:
      fill(LIGHTBLUE);
      break;
      case HOVERED:
      fill(BLUE);
      break;
      case PRESSED:
      fill(BLACK);
      break;
      case RELEASED:
      fill(BLACK);
      break;
    }
    stroke(0);
    textFont(maiandra);
    strokeWeight(1);
    rect( hitbox.x - hitbox.halfW, hitbox.y - hitbox.halfH, hitbox.w, hitbox.h, 8);
    fill(0);
    textAlign(CENTER);
    textSize(16);
    text(text, hitbox.x, hitbox.y + 7);
  }

  void mousePressed() {

    if (state == ButtonState.HOVERED) {

      state = ButtonState.PRESSED;
    }
  }

  void mouseReleased() {

    if (state == ButtonState.PRESSED) {

      state = ButtonState.RELEASED;
    }
  }
}

enum ButtonState {

  IDLE,
    HOVERED,
    PRESSED,
    RELEASED,
}
