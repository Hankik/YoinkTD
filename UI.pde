Level createUI(LEVEL_TYPE type) {

  Level level = new Level(type);

  switch (type) {
    // add specific actors for each menu

  case PAUSE_MENU:
    break;

  case MAIN_MENU:
    break;

  case HUD:
    level.addActor("Cursor");

    break;
  case LEVEL:
    println("LMAO. This is for making UI not levels. Use Level constructor");
    break;
  }

  return level;
}
