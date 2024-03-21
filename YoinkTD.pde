import java.lang.reflect.*;
import java.util.*;
import java.util.HashSet;
import java.util.Set;
import java.lang.ref.WeakReference;
import java.util.UUID;

// TIMESTEP //
float dt, prevTime = 0.0;
float elapsed = 0.0;
// TIMESTEP

// TILE GLOBALS //
final float TILE_SIZE = 32;
// TILE GLOBALS // 

// LEVEL GLOBALS //
final int LEVEL_AMOUNT = 1;
Level[] levels = new Level[LEVEL_AMOUNT];
int currentLevel = 0;
// LEVEL GLOBALS //

YoinkTD applet = this; // I need this for the Constructor class method newInstance(applet, ... (other parameters);

boolean paused = false;

void setup() {
  
  surface.setTitle("YoinkTD");
  surface.setResizable(false);
  size(1280, 720);
  frameRate(60);
  
  for (int i = 0; i < LEVEL_AMOUNT; i++){
    levels[i] = new Level();
  }

  JSONSerializer serializer = new JSONSerializer();
  JSONObject json = serializer.getContents(levels[0]);
  saveJSONObject(json, "data/save.json");
  Level deserializable = createLevel(json);
  JSONObject json2 = serializer.getContents(deserializable);
  saveJSONObject(json2, "data/save2.json");
}

void draw() {
  background(0);
  
 // calculate delta time
  float currTime = millis();
  dt = (currTime - prevTime) / 1000;
  prevTime = currTime;
  
  elapsed += dt;
  if (!paused) levels[currentLevel].update();
  
  levels[currentLevel].display();
}

void mousePressed(){
  levels[currentLevel].mousePressed();
}

void mouseReleased(){
  levels[currentLevel].mouseReleased();
}

void keyPressed(){
  Keyboard.handleKeyDown(keyCode);
  levels[currentLevel].keyPressed();
}


void keyReleased(){
  Keyboard.handleKeyUp(keyCode);
  levels[currentLevel].keyReleased();
  if (key == 'p') paused = !paused;
}
