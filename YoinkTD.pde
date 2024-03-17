import java.lang.reflect.*;
import java.util.*;
import java.util.HashSet;
import java.util.Set;
import java.lang.ref.WeakReference;

// TIMESTEP //
float dt, prevTime = 0.0;
float elapsed = 0.0;
// TIMESTEP

// Tile Globals //
final float TILE_SIZE = 32;

YoinkTD applet = this; // I need this for Constructor class method newInstance(applet, ... (other parameters);

boolean paused = false;

Level test;

void setup() {
  surface.setTitle("YoinkTD");
  surface.setResizable(false);
  size(1280, 720);
  frameRate(60);

  test = new Level();

  JSONSerializer serializer = new JSONSerializer();
  JSONObject json = serializer.getContents(test);
  saveJSONObject(json, "data/save.json");
}

void draw() {
  background(0);
  
 // calculate delta time
  float currTime = millis();
  dt = (currTime - prevTime) / 1000;
  prevTime = currTime;
  
  elapsed += dt;
  if (!paused) test.update();
  
  test.display();
}

void mousePressed(){
  test.mousePressed();
}

void mouseReleased(){
  test.mouseReleased();
}

void keyPressed(){
  Keyboard.handleKeyDown(keyCode);
  test.keyPressed();
}


void keyReleased(){
  Keyboard.handleKeyUp(keyCode);
  test.keyReleased();
  if (key == 'p') paused = !paused;
}

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
                //if (field.getName().equals("components")) continue;
                ArrayList<?> arrayList = (ArrayList<?>) field.get(o);
                JSONArray arrayContents = new JSONArray();
                if (arrayList != null) {
                    for (Object element : arrayList) {
                        JSONObject subobject = serializeObject(element);
                        arrayContents.append(subobject);
                    }
                }
                contents.setJSONArray(field.getName(), arrayContents);
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

  private boolean isUserDefinedClass(Class<?> type) {
    // Exclude primitive types and common Java types
    return !type.isPrimitive() && !type.getName().startsWith("java");
  }
  
  String cleanName(String name) {
  
    if (name.startsWith("processing.core.")) return name.substring(16);
    if (name.startsWith("YoinkTD$")) return name.substring(8);
    return name;
  }
}

//Level loadLevelFromJSON(JSONObject json) {

//  Level level = new Level();
//}
