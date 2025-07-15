// =======================
// TileMap.pde（マップのみ表示・ピクセル指定対応）
// =======================
PImage[] tileset = new PImage[6]; // tileID: 0=空, 1=地面, 2=切り株, 3=ブロック, 4=井戸, 5=木
int tileSize = 95;
int mapCols = 1600 / tileSize; // 16
int mapRows = 650 / tileSize;  // 6

int[][] map = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 5, 0, 2, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

void setup() {
  size(1600, 650);
  loadTiles();
}

void draw() {
  background(135, 206, 235);
  drawMap();
}

void loadTiles() {
  tileset[0] = null; // 空
  tileset[1] = loadImage("maptile_jimen_sogen_01_center.png");
  tileset[2] = loadImage("kirikabu_02.png");
  tileset[3] = loadImage("block_renga_gray.png");
  tileset[4] = loadImage("ido_brown.png");
  tileset[5] = loadImage("ki_01_01.png");
}

void drawMap() {
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map[0].length; x++) {
      int tileID = map[y][x];
      if (tileID == 0) continue;

      if (tileID == 5) { // 木（背景用）
        float drawX = x * tileSize;
        float drawY = (y + 1) * tileSize - tileSize * 1.5;
        image(tileset[5], drawX, drawY, tileSize * 1.5, tileSize * 1.5);
      } else {
        image(tileset[tileID], x * tileSize, y * tileSize, tileSize, tileSize);
      }
    }
  }
}
