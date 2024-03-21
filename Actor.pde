abstract class Actor implements Updates, Displays { // abstract means you cannot make an instance of this (only child instances)

  String name = "actor";
  String id = UUID.randomUUID().toString();
  PVector location = new PVector(0, 0);
  ArrayList<Object> components = new ArrayList(); // do not add non-component types

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
        // ------------------------------- type.getBlahBlah( requires we pass in the parameter signature to find the constructor we want ).newInstance( pass in those arguments now );
        Component component = (Component) type.getDeclaredConstructor(parameterTypes).newInstance(applet, this); // all constructors have a hidden YoinkTD.class instance passed in

        // Add the component to the list
        components.add(component);

        println(name + " component added to " + this.name);
        return component;
      } else {
        println(name + " is not a component.");
      }
    }
    catch (ClassNotFoundException e) {
      println("Could not find component class: " + e);
    }
    catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
      println("Error instantiating component: " + e + "\nREQUIRED: Components need a constructor like this 'Constructor(Actor parent)'!");
    }

    return null;
  }

  Actor() {
  }

  abstract void update();

  abstract void display();
}

abstract class Component implements Updates, Displays {

  String name = "component";
  Actor parent = null;
  String id = UUID.randomUUID().toString();
  abstract void update();
  abstract void display();

  Component() {
  }
  Component(Actor parent) {
    this.parent = parent;
  }

  void setProperty(String name, Class<?> type, Object value) {

    try {
      Field field = getClass().getField(name);
      if (isUserDefinedClass(type)) {
        field.set(this, (Class<?>) value);
      } else {
        switch (type.getName()) {
        case "boolean":
            field.setBoolean(this, (boolean) value);
          break;
        case "int":
          field.setInt(this, (int) value);
          break;
        case "float":
          field.setFloat(this, (float) value);
          break;
        case "double":
          field.setDouble(this, (double) value);
          break;
        case "long":
          field.setLong(this, (long) value);
          break;
        default:
          if (field.isEnumConstant()) field.set(this, (Class<?>) value);
          // Add additional handling for other types if needed
          break;
        }
      }
    }
    catch(NoSuchFieldException | IllegalAccessException e) {
      println("Failed to add field " + name + ": " + e);
    }
  }
}

Actor createActor(String name) {

  try {
    // Load class
    Class type = Class.forName("YoinkTD$" + name);

    // Check if the class is a subclass of Component
    if (Actor.class.isAssignableFrom(type)) {


      // Get parameter types
      Class[]  parameterTypes = {YoinkTD.class};

      // ------------------------------- type.getBlahBlah( requires we pass in the parameter signature to find the constructor we want ).newInstance( pass in those arguments now );
      Actor actor = (Actor) type.getDeclaredConstructor(parameterTypes).newInstance(applet); // all constructors have a hidden YoinkTD.class instance passed in
      return actor;
    } else {
      println(name + " is not an actor.");
    }
  }
  catch (ClassNotFoundException e) {
    println("Could not find actor class: " + e);
  }
  catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
    println("Error instantiating actor: " + e);
  }
  
  return null;
}
