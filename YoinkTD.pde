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
final int UI_SCENE_AMOUNT = 1;
Level[] uiScenes = new Level[UI_SCENE_AMOUNT];
Level hud;
// LEVEL GLOBALS //

// FONT GLOBALS //
PFont maiandra;

YoinkTD applet = this; // I need this for the Constructor class method newInstance(applet, ... (other parameters);

boolean paused = false;

void setup() {
  
  maiandra = createFont("Maiandra GD", 48);
  
  surface.setTitle("YoinkTD");
  surface.setResizable(false);
  size(1280, 720);
  frameRate(60);
  
  for (int i = 0; i < LEVEL_AMOUNT; i++)  levels[i] = new Level(LEVEL_TYPE.LEVEL);
  hud = createUI(LEVEL_TYPE.HUD);

  JSONSerializer serializer = new JSONSerializer();
  JSONObject json = serializer.getContents(levels[0]);
  saveJSONObject(json, "data/save.json");
  Level deserializable = createLevel(json);
  JSONObject json2 = serializer.getContents(deserializable);
  saveJSONObject(json2, "data/save2.json");
  
  for (Level level : levels) level.handleCommands(); // handle any important commands gathered in deserialization
}

void draw() {
  background(0);
  
 // calculate delta time
  float currTime = millis();
  dt = (currTime - prevTime) / 1000;
  prevTime = currTime;
  
  elapsed += dt;
  hud.update();
  if (!paused) levels[currentLevel].update();
  
  levels[currentLevel].display();
  hud.display();
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
