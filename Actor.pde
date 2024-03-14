abstract class Actor implements Updates, Displays {

  String name = "actor";
  PVector location = new PVector(0,0,0);
  PVector rotation = new PVector(0,0,0);
  PVector scale = new PVector(1,1,1);
  ArrayList<Component> components = new ArrayList();

  Actor(){}
  
  abstract void update();
  
  abstract void display();
}

abstract class Component implements Updates, Displays {

  String name = "component";
  abstract void update();
  abstract void display();
}
