public class JSONSerializer {

  private Set<Object> visitedObjects = new HashSet<>();

  // This function ignores the type of o (only serializing its contents)
  JSONObject getContents(Object o) {
    visitedObjects.clear(); // Clear the set before each serialization
    return serializeObject(o);
  }

  private JSONObject serializeObject(Object o) {
    JSONObject object = new JSONObject();
    JSONObject contents = new JSONObject();
    if (o == null) return contents;
    if (visitedObjects.contains(o)) {
      // Object already visited, return an empty JSON object or handle as needed
      return contents;
    }

    visitedObjects.add(o);

    Field[] fields = o.getClass().getDeclaredFields();
    List<Field> extFields = new ArrayList<>(Arrays.asList(fields));
    List<Field> superFields = Arrays.asList(o.getClass().getSuperclass().getDeclaredFields()); 
    extFields.addAll( superFields );

    for (Field field : extFields) {
      try {
        field.setAccessible(true);
        Class<?> fieldType = field.getType();
        
        if (field.isSynthetic()) continue; // this skips over java created fields
        
        Object fieldValue = field.get(o);
        
        if (isUserDefinedClass(fieldType)) {
          
          if (Component.class.isAssignableFrom(fieldType) && field.get(o) != null) {
            println("replacing component with id");
            contents.setString(field.getName(), ((Component) field.get(o)).id);
            continue;
          }
          
          if (field.getName().contains("Callback")) continue;
          
          JSONObject subobject = serializeObject(fieldValue);
          contents.setJSONObject(field.getName(), subobject);
          
        } else {
          switch (fieldType.getName()) {
            case "boolean":
              contents.setBoolean(field.getName(), field.getBoolean(o));
            break;
          case "int":
            contents.setInt(field.getName(), field.getInt(o));
            break;
          case "float":
            contents.setFloat(field.getName(), field.getFloat(o));
            break;
          case "double":
            contents.setDouble(field.getName(), field.getDouble(o));
            break;
          case "long":
            contents.setLong(field.getName(), field.getLong(o));
            break;
          default:
            if (field.isEnumConstant()) contents.setString(field.getName(), (String) field.get(o));
            
            // Add additional handling for other types if needed
            String javaObjectType = fieldType.getName().substring(fieldType.getName().lastIndexOf('.') + 1);
            switch (javaObjectType) {
            
              case "String":
                contents.setString(field.getName(), (String) field.get(o));
              break;
              
              case "ArrayList":
              
                ArrayList<?> arrayList = (ArrayList<?>) field.get(o);
                if (arrayList != null) {
                    JSONObject listObject = new JSONObject();
                    for (Object element : arrayList) {
                        JSONObject subobject = serializeObject(element);
                        String elementType = cleanName(element.getClass().getName());
                        listObject.setJSONObject(elementType, (JSONObject) subobject.get(elementType));
                    }
                    contents.setJSONObject(field.getName(), listObject);
                }
                break;
              case "WeakReference": // im going to assume its an actor
                WeakReference weakRef = (WeakReference) field.get(o);
                Actor actor = null;
                if (weakRef != null) actor = (Actor) weakRef.get();
                if (actor != null) contents.setString(field.getName(), actor.id );
                break;
            }
            break;
          }
        }
      }
      catch (Exception e) {
        e.printStackTrace(); // Handle exceptions appropriately
      }
    }
    object.setJSONObject(cleanName(o.getClass().getName()), contents);
    return object;
  }
  
  String cleanName(String name) {
  
    if (name.startsWith("processing.core.")) return name.substring(16);
    if (name.startsWith("YoinkTD$")) return name.substring(8);
    return name;
  }
}


Level createLevel(JSONObject json) {
   
  Level level = new Level();
  JSONObject levelFields = (JSONObject) json.get("Level");
  
  for (Object key : levelFields.keys()) {
    // Get value based on key
    Object value = (JSONObject) levelFields.get((String) key);
    //println(key);
    
      
    Class type = null;
    try { type = Class.forName("YoinkTD$" + key); } 
    catch(Exception e) { println(e); }
    if (type != null) {
      if (Actor.class.isAssignableFrom(type)) {
        Actor actor = createActor((String) key);
        populateActorFields(actor, (JSONObject) value);
      }
    }
  }
  
  return level;
}

void populateActorFields(Actor actor, JSONObject json){
  
    Field[] fields = actor.getClass().getDeclaredFields();
    List<Field> extFields = new ArrayList<>(Arrays.asList(fields));
    List<Field> superFields = Arrays.asList(actor.getClass().getSuperclass().getDeclaredFields()); 
    extFields.addAll( superFields );
    
    for (Field field : extFields) {
      try {
        field.setAccessible(true);
        Class<?> fieldType = field.getType();
        
        if (field.isSynthetic()) continue; // this skips over java created fields
        
        if (isUserDefinedClass(fieldType)) {
          if (Component.class.isAssignableFrom(fieldType)) {
          
            Component component = actor.addComponent(fieldType.toString());
            // TODO: populate component
            continue;
          }
          
          if (Actor.class.isAssignableFrom(fieldType)) {
            Actor subActor = createActor( fieldType.toString() );
            populateActorFields(subActor, (JSONObject) json.get(fieldType.toString()));
          
            field.set( actor, subActor );
            continue;
          }
        
          
          // we have a userdefined field
          
        } else {
          switch (fieldType.getName()) {
            case "boolean":
              field.set(actor, (boolean) json.get(field.getName()));
            break;
          case "int":
            field.set(actor, (int) json.get(field.getName()));
            break;
          case "float":
            field.set(actor, (float) json.get(field.getName()));
            break;
          case "double":
            field.set(actor, (double) json.get(field.getName()));
            break;
          case "long":
            field.set(actor, (long) json.get(field.getName()));
            break;
          default:
            if (field.isEnumConstant()) {} // is enum
            
            // Add additional handling for other types if needed
            String javaObjectType = fieldType.getName().substring(fieldType.getName().lastIndexOf('.') + 1);
            //println(javaObjectType);
            switch (javaObjectType) {
            
              case "String":
                println(json.get(field.getName()).toString());
                String foundString = json.get(field.getName()).toString();
                
                // look to see if value is an id BUT I DONT WANT THE KEY TO BE AN ID
                if (!field.getName().equals("id") && foundString.matches("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")) { //uuid check
                  //for 
                
                  for (Level level : levels) {
                  
                    for (Object a : level.actors) { 
                      Actor levelActor = (Actor) a;
                      for (Object c : levelActor.components) if(((Component) c).id.equals(foundString)){
                        SetFieldReferenceCommand setReference = new SetFieldReferenceCommand();
                        setReference.referenceHolder = actor;
                        setReference.referenceField = field;
                        setReference.referencedObject = c;
                        level.commands.add( setReference );
                        return;
                      }
                      
                      if ( levelActor.id.equals(foundString) ) { // ugly as sin
                        SetFieldReferenceCommand setReference = new SetFieldReferenceCommand();
                        setReference.referenceHolder = actor;
                        setReference.referenceField = field;
                        setReference.referencedObject = levelActor;
                        level.commands.add( setReference );
                        return;
                      }
                    }
                  }
                  continue;
                }
                field.set(actor, json.get(field.getName()));
                break;
              
              case "ArrayList":
                ArrayList<?> arrayList = (ArrayList<?>) field.get(actor);
                if (arrayList == null) arrayList = new ArrayList();
                JSONArray value = (JSONArray) json.get(field.getName());
                
                
                break;
              case "WeakReference": // im going to assume its an actor
                break;
            }
            break;
          }
        }
      }
      catch (Exception e) {
        e.printStackTrace(); // Handle exceptions appropriately
      }
    }
  
}

void populateComponentFields(Component component, JSONObject json){
  
    Field[] fields = component.getClass().getDeclaredFields();
    List<Field> extFields = new ArrayList<>(Arrays.asList(fields));
    List<Field> superFields = Arrays.asList(component.getClass().getSuperclass().getDeclaredFields()); 
    extFields.addAll( superFields );
    
    for (Field field : extFields) {
      try {
        field.setAccessible(true);
        Class<?> fieldType = field.getType();
        
        if (field.isSynthetic()) continue; // this skips over java created fields
        
        if (isUserDefinedClass(fieldType)) {
          
          // we have a userdefined field
          if (Actor.class.isAssignableFrom(fieldType)) {
            Actor subActor = createActor( fieldType.toString() );
            populateActorFields(subActor, (JSONObject) json.get(fieldType.toString()));
          
            field.set( component, subActor );
            continue;
          }
        
          
          
          
        } else {
          switch (fieldType.getName()) {
            case "boolean":
              field.set(component, json.get(field.getName()));
            break;
          case "int":
            field.set(component, json.get(field.getName()));
            break;
          case "float":
            field.set(component, json.get(field.getName()));
            break;
          case "double":
            field.set(component, json.get(field.getName()));
            break;
          case "long":
            field.set(component, json.get(field.getName()));
            break;
          default:
            if (field.isEnumConstant()) {} // is enum
            
            // Add additional handling for other types if needed
            String javaObjectType = fieldType.getName().substring(fieldType.getName().lastIndexOf('.') + 1);
            switch (javaObjectType) {
            
              case "String":
                String foundString = json.get(field.getName()).toString();
                if (foundString.matches("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")) { //uuid check
                  for (Level level : levels) {
                  
                    for (Object a : level.actors) { 
                      Actor levelActor = (Actor) a;
                      
                      if ( levelActor.id.equals(foundString) ) { // ugly as sin
                        SetFieldReferenceCommand setReference = new SetFieldReferenceCommand();
                        setReference.referenceHolder = component;
                        setReference.referenceField = field;
                        setReference.referencedObject = levelActor;
                        level.commands.add( setReference );
                        return;
                      }
                    }
                  }
                  continue;
                }
                field.set(component, json.get(field.getName()));
                break;
              
              case "ArrayList":
                ArrayList<?> arrayList = (ArrayList<?>) field.get(component);
                if (arrayList == null) arrayList = new ArrayList();
                //for (Object jarrayElem : (JSONArray) json.get(
                break;
              case "WeakReference": // im going to assume its an actor
                break;
            }
            break;
          }
        }
      }
      catch (Exception e) {
        e.printStackTrace(); // Handle exceptions appropriately
      }
    }
  
}

boolean isUserDefinedClass(Class<?> type) {
  // Exclude primitive types and common Java types
  return !type.isPrimitive() && !type.getName().startsWith("java");
}
