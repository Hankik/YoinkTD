class Tile extends Actor {

  Rect rect;
  Tile[] neighbors = new Tile[4];
  // Weak references do not keep objects alive in memory when all normal (strong) references are gone
  // We use WeakReference<T> so we do not need to make sure every kill method communicates to associated tiles that they need to drop their references.
  WeakReference<TileHolds> heldItem = new WeakReference(null); 
  
  Tile(){
    
    PVector startPosition = getGridLocation( new PVector(GRID_X_OFFSET, 0) );
    location = new PVector(startPosition.x, startPosition.y); // many components require its parent have a location so make sure we instantiate location ahead of time
    rect = (Rect) addComponent("Rect");  // like rect ^^
  }
  
  void update(){
    update(components);
  }
  
  void display(){
    display(components);
  }
}

class TileMap extends Actor {
  
  
  final int MAP_WIDTH = 24;
  final int MAP_HEIGHT = 23;
  Tile[][] tiles = new Tile[MAP_WIDTH][MAP_HEIGHT];
  
  TileMap(){
    
    Rect rect = (Rect) addComponent("Rect");
    rect.setSize(TILE_SIZE * (MAP_WIDTH), TILE_SIZE * MAP_HEIGHT);
    location = PVector.sub(getGridLocation( new PVector(GRID_X_OFFSET + (MAP_WIDTH/2) * TILE_SIZE, (MAP_HEIGHT/2) * TILE_SIZE) ), new PVector(16, 0));
    rect.fill = BLACK;
    rect.opacity = .25;
    println( rect.fill);
  
    for (int x = 0; x < MAP_WIDTH; x++) {
      for (int y = 0; y < MAP_HEIGHT; y++) {
      
        tiles[x][y] = new Tile();
        Tile tile = tiles[x][y];
        tile.rect.fill = BLUE;
        tile.rect.opacity = .3;
        
        // populate neighbors
        if (x != 0) tile.neighbors[NEIGHBOR_LEFT] = tiles[x-1][y];
        if (y != 0) tile.neighbors[NEIGHBOR_TOP] = tiles[x][y-1];
        if (x != MAP_WIDTH-1) tile.neighbors[NEIGHBOR_RIGHT] = tiles[x+1][y];
        if (y != MAP_HEIGHT-1) tile.neighbors[NEIGHBOR_BOT] = tiles[x][y+1];
        
        tile.location =  getGridLocation( new PVector ( GRID_X_OFFSET + x * TILE_SIZE, y * TILE_SIZE) ) ;
      }
    }
  }

  void update(){
    update(components);
     for (int x = 0; x < MAP_WIDTH; x++) {
      for (int y = 0; y < MAP_HEIGHT; y++) {
      
        tiles[x][y].update();
      }
    }
  }
  
  void display(){
    
    display(components);
    for (int x = 0; x < MAP_WIDTH; x++) {
      for (int y = 0; y < MAP_HEIGHT; y++) {
      
        tiles[x][y].display();
      }
    }
    
  }
}

final int NEIGHBOR_LEFT = 0;
final int NEIGHBOR_TOP = 1;
final int NEIGHBOR_RIGHT = 2;
final int NEIGHBOR_BOT = 3;
