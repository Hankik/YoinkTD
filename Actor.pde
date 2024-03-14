abstract class Actor implements Updates, Displays {

  String name = "actor";
  PVector location = new PVector(0,0);
  ArrayList<Component> components = new ArrayList();
  
  Component addComponent(String name) {
    try {
        // Load class
        Class type = Class.forName("YoinkTD$" + name);
        
        // Check if the class is a subclass of Component
        if (Component.class.isAssignableFrom(type)) {
            
    
            // Get parameter types
            Class[]  parameterTypes = {YoinkTD.class, Actor.class };
            
            // SORRY THIS IS SOME ARCANE SHIT
            // Instantiate the class
            Component component = (Component) type.getDeclaredConstructor(parameterTypes).newInstance(applet, this);
            
            // Add the component to the list
            components.add(component);
            
            println(name + " component added to " + this.name);
            return component;
        } else {
            println(name + " is not a component.");
        }
    } catch (ClassNotFoundException e) {
        println("Could not find component class: " + e);
    } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
        println("Error instantiating component: " + e + "\nREQUIRED: Components need a constructor like this 'Constructor(Actor parent)'!");
    }
    
    return null;
  }

  Actor(){}
  
  abstract void update();
  
  abstract void display();
}

abstract class Component implements Updates, Displays {

  String name = "component";
  Actor parent = null;
  abstract void update();
  abstract void display();
  
  Component(){}
  Component(Actor parent) { this.parent = parent; }
}
