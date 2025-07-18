int tileSize = 27;
int objTileSize = 27;
int[] solidTiles = {1, 4, 5, 6};
PImage grassGroundImg;
PImage grassImg;
PImage soilImg;
PImage cliff_left;
PImage cliff_right;
PImage blockImg;
PImage bgImg;

PGraphics stageBuffer;
PGraphics objTileBuffer;
PGraphics bgBuffer;

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

Enemy enemy;
Ookami wolf;
Flymiira fly;

int[] sleepyDurations = {75, 10};

Player player;
CollisionChecker collisionChecker;
CollisionHandler collisionHandler;
TileBufferManager bufferManager;

int[][] map = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {2, 2, 2, 2, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 3, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}
  };
  
int[][] objMap = {
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  };
  
  boolean debugDraw = false;
  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean upPressed = false;      
  boolean upKeyHandled = false;
  
void setup() {
  size(700, 400);
  background(216, 151, 71);
  
  bgImg = loadImage("background.png");
  PImage ookamiImg = loadImage("ookami.png");
  PImage ookamiImg2 = loadImage("ookami2.png");
  
  normalImgLeft = loadImage("player12.png");  // スケッチと同じフォルダに配置
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
  blockImg = loadImage("renga.png");
  
  for (int i = 0; i < 8; i++) {
    walkRightFrames[i] = loadImage("player" + (i + 4) + ".png");
  }
  
  for (int i = 0; i < 8; i++) {
    walkLeftFrames[i] = loadImage("player" + (i + 16) + ".png");
  }
  
   collisionChecker = new CollisionChecker(tileSize, objTileSize, map, objMap, solidTiles);
   collisionHandler = new CollisionHandler(collisionChecker);
   Hitbox playerBox = new Hitbox(20, height - 156, 44, 80);
   Hitbox wolfBox = new Hitbox(500, height - 156, 40, 40);
   
   bufferManager = new TileBufferManager(
    tileSize, objTileSize, map, objMap,
    bgImg, blockImg,
    grassGroundImg, grassImg, soilImg, cliff_left, cliff_right
  );
  
  player = new Player(
  playerBox, 
  normalImgLeft, normalImgRight, 
  blinkImgLeft, blinkImgRight, 
  sleepImgLeft, sleepImgRight, 
  walkLeftFrames, walkRightFrames, 
  sleepyFramesLeft, sleepyFramesRight, 
  sleepyDurations,
  jumpImgLeft, jumpImgRight,
  collisionChecker, collisionHandler,
  0, height - 156
  );
  player.groundY = height - 156;
  player.colHand = collisionHandler;
    Hitbox eBox = new Hitbox(300, height - 156, 44, 80);

    wolf = new Ookami(
    wolfBox,
    ookamiImg,
    ookamiImg2,
    player,
    collisionChecker,
    collisionHandler,
    -1
  );
  
  PImage f1 = loadImage("fly.png");
  PImage f2 = loadImage("fly2.png");
  Hitbox flyBox = new Hitbox(350, -50, 40, 40);  // 画面外上部からスタート

  fly = new Flymiira(
    flyBox,
    f1, f2,
    player,
    collisionChecker,
    collisionHandler,
    0.5f    // 飛行速度
  );
  
}

void draw() {
  background(216, 151, 71);
  
 float offsetX = player.getCameraOffsetX();
 
bufferManager.drawAll(offsetX);
 
 if (leftPressed) {
    player.move(-1);
  } else if (rightPressed) {
    player.move(1);
  } else {
    player.stop();
  }
  
   if (upPressed && !upKeyHandled) {
      // 横移動中なら連続ジャンプOK
      player.jump();
      upKeyHandled = true;
    } 
 
  player.update();
  player.display();
  
    // 敵の更新・描画
  
  wolf.update();
  wolf.display(offsetX);
  
  fly.update();
  fly.display(player.getCameraOffsetX());
}

void keyPressed() {
  player.notifyAction();
  
  if (keyCode == LEFT) {
    leftPressed = true;
  }
  if (keyCode == RIGHT) {
    rightPressed = true;
  }
  if (key == ' ' || keyCode == UP) {
    upPressed = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    leftPressed = false;
  }
  if (keyCode == RIGHT) {
    rightPressed = false;
  }
  if (key == ' ' || keyCode == UP) {
    upPressed = false;
    upKeyHandled = false;
  }
}
