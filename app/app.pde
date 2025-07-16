PImage[] tileset = new PImage[7]; // 0=空, 1=地面, 2=切り株, 3=ブロック, 4=井戸, 5=木, 6=草
int tileSize = 95;
int mapCols = 1600 / tileSize;
int mapRows = 650 / tileSize;

int[][] map = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 5, 0, 2, 5, 0, 2, 0, 0, 0, 4, 0, 0, 0}, // ← 木を (3,4) と (6,4) に配置
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

void setup() {
  size(1600, 650);
  loadTiles();
}

void draw() {
  background(135, 206, 235);
  drawMap();
  drawGrass();
}

void loadTiles() {
  tileset[0] = null;
  tileset[1] = loadImage("maptile_jimen_sogen_01_center.png");
  tileset[2] = loadImage("kirikabu_02.png");
  tileset[3] = loadImage("block_renga_gray.png");
  tileset[4] = loadImage("ido_brown.png");
  tileset[5] = loadImage("ki_01_01.png");
  tileset[6] = loadImage("grass1.png");
}

void drawMap() {
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map[0].length; x++) {
      int tileID = map[y][x];
      if (tileID == 0) continue;

      if (tileID == 5) {
        // 木の描画（座標ごとに高さを変える）
        float scaleH = 1.0;
        if (x == 3 && y == 4) {
          scaleH = 1.8;  // ← この木だけ引き延ばす
        }

        float drawX = x * tileSize;
        float drawY = (y + 1) * tileSize - tileSize * scaleH;
        image(tileset[5], drawX, drawY, tileSize, tileSize * scaleH);
      } else {
        image(tileset[tileID], x * tileSize, y * tileSize, tileSize, tileSize);
      }
    }
  }
}

void drawGrass() {
  for (int y = 1; y < map.length; y++) {
    for (int x = 0; x < map[0].length; x++) {
      if (map[y][x] == 1 && map[y - 1][x] == 0) {
        float drawX = x * tileSize;
        float drawY = (y - 1) * tileSize + (tileSize - tileset[6].height);
        image(tileset[6], drawX, drawY);
      }
    }
  }
}
