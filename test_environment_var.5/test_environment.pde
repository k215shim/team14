int tileSize = 50;
int[] solidTiles = {1, 3, 4, };
PImage grassGroundImg;
PImage grassImg;
PImage soilImg;
PImage cliff_left;
PImage cliff_right;
PImage blockImg;
PImage kirikabuImg;
PImage idoImg;
PImage kiImg;
PImage kusaImg;
PImage normalImgLeft;
PImage normalImgRight;
PImage blinkImgLeft;
PImage blinkImgRight;
PImage sleepImgLeft;
PImage sleepImgRight;
PImage[] walkRightFrames = new PImage[8];
PImage[] walkLeftFrames = new PImage[8];
PImage[] sleepyFramesLeft = new PImage[2];
PImage[] sleepyFramesRight = new PImage[2];
PImage jumpImgLeft;
PImage jumpImgRight;
PImage bgImg;
int[] sleepyDurations = {75, 10};
Player player;

int[][] map = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 2, 2, 5, 2, 2, 5, 0, 0, 0, 0, 0, 2, 0, 0, 4},
  {1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1}
};

void setup() {
  size(800, 300);
  background(216, 151, 71);

  bgImg = loadImage("background.png");

  normalImgLeft = loadImage("player12.png");
  normalImgRight = loadImage("player0.png");
  blinkImgLeft = loadImage("player13.png");
  blinkImgRight = loadImage("player1.png");
  sleepImgLeft = loadImage("player15.png");
  sleepImgRight = loadImage("player3.png");

  sleepyFramesLeft[0] = loadImage("player14.png");
  sleepyFramesLeft[1] = loadImage("player15.png");
  sleepyFramesRight[0] = loadImage("player2.png");
  sleepyFramesRight[1] = loadImage("player3.png");

  jumpImgLeft = loadImage("player25.png");
  jumpImgRight = loadImage("player24.png");

  grassGroundImg = loadImage("grass0.png");
  grassImg = loadImage("grass1.png");
  soilImg = loadImage("soil.png");
  cliff_left = loadImage("cliff_left.png");
  cliff_right = loadImage("cliff_right.png");
  blockImg = loadImage("block_renga_gray.png");
  kirikabuImg = loadImage("kirikabu_02.png");
  idoImg = loadImage("ido_brown.png");
  kiImg = loadImage("ki_01_01.png");

  for (int i = 0; i < 8; i++) {
    walkRightFrames[i] = loadImage("player" + (i + 4) + ".png");
  }

  for (int i = 0; i < 8; i++) {
    walkLeftFrames[i] = loadImage("player" + (i + 16) + ".png");
  }

  player = new Player(0, height - 164, 75, 75, 
    normalImgLeft, normalImgRight, 
    blinkImgLeft, blinkImgRight, 
    sleepImgLeft, sleepImgRight, 
    walkLeftFrames, walkRightFrames, 
    sleepyFramesLeft, sleepyFramesRight, 
    sleepyDurations,
    jumpImgLeft, jumpImgRight,
    0, height - 164
  );

  player.groundY = height - 164;
}

void drawMap() {
  for (int row = 0; row < map.length; row++) {
    for (int col = 0; col < map[row].length; col++) {
      int tile = map[row][col];
      float x = col * tileSize;
      float y = row * tileSize;

      if (tile == 1) image(grassGroundImg, x, y, tileSize, tileSize);
      else if (tile == 2) image(grassImg, x, y, tileSize, tileSize);
      else if (tile == 3) image(blockImg, x, y, tileSize, tileSize);
      else if (tile == 4) image(idoImg, x, y, tileSize, tileSize);
      else if (tile == 5) image(kiImg, x, y - tileSize * 0.8, tileSize, tileSize * 1.8);
    }
  }
}

boolean isSolidTile(int tileX, int tileY) {
  if (tileY < 0 || tileY >= map.length || tileX < 0 || tileX >= map[0].length) return false;
  int tile = map[tileY][tileX];
  for (int i = 0; i < solidTiles.length; i++) {
    if (tile == solidTiles[i]) return true;
  }
  return false;
}

void draw() {
  background(216, 151, 71);
  pushMatrix();
  translate(-player.getCameraOffsetX(), 0);
  drawMap();
  popMatrix();

  player.update();
  player.display();
}

void keyPressed() {
  player.notifyAction();

  if (keyCode == LEFT) {
    player.move(-1);
  }
  else if (keyCode == RIGHT) {
    player.move(1);
  }
  else if (key == ' ' || keyCode == UP) {
    player.jump();
  }
}

void keyReleased() {
  if (keyCode == LEFT || keyCode == RIGHT) {
    player.stop();
  }
}
