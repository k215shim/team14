class CollisionChecker {
  int tileSize;
  int objTileSize;
  int[][] map;
  int[][] objMap;
  int[] solidTiles;

  CollisionChecker(int tileSize, int objTileSize, int[][] map, int[][] objMap, int[] solidTiles) {
    this.tileSize = tileSize;
    this.objTileSize = objTileSize;
    this.map = map;
    this.objMap = objMap;
    this.solidTiles = solidTiles;
  }
  
  boolean isCollidingWithTileRect(float cx, float cy, int cw, int ch, int tileX, int tileY, int tileSize) {
  float tileLeft = tileX * tileSize;
  float tileTop = tileY * tileSize;
  float tileRight = tileLeft + tileSize;
  float tileBottom = tileTop + tileSize;

  float entityLeft = cx;
  float entityTop = cy;
  float entityRight = cx + cw;
  float entityBottom = cy + ch;

  return !(entityRight <= tileLeft ||
           entityLeft >= tileRight ||
           entityBottom <= tileTop ||
           entityTop >= tileBottom);
}

  boolean isTileSolidMap(int tileX, int tileY) {
    if (tileY < 0 || tileY >= map.length || tileX < 0 || tileX >= map[0].length) return false;
    int tile = map[tileY][tileX];
    for (int solid : solidTiles) {
      if (tile == solid) return true;
    }
    return false;
  }

  boolean isTileSolidObj(int tileX, int tileY) {
    if (tileY < 0 || tileY >= objMap.length || tileX < 0 || tileX >= objMap[0].length) return false;
    int tile = objMap[tileY][tileX];
    for (int solid : solidTiles) {
      if (tile == solid) return true;
    }
    return false;
  }

  boolean isSolidAtWorld(float x, float y) {
    int objX = int(x / objTileSize);
    int objY = int(y / objTileSize);
    if (isTileSolidObj(objX, objY)) return true;
    
    int mapX = int(x / tileSize);
    int mapY = int(y / tileSize);
    return isTileSolidMap(mapX, mapY);
  }
}
