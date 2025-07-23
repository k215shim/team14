int tileSize = 22;
int objTileSize = 22;
int[] solidTiles = {1, 3, 4, 5, 6};
int currentStage = 1;

float cameraOffsetX = 0;
float cameraOffsetY = 0;
boolean isShaking = false;
int shakePhase = 0;
float shakeStrength = 8;

final int state_start = 0;
final int state_play  = 1;
final int state_pause = 2;  // オプション
final int state_gameOver = 3;
int gameState = state_start;
int stringBlinkCounter = 0;
int stringBlinkInterval = 30;

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

int CHARGE_1 = 30;
int CHARGE_2 = 60;
int animationFrame = 0;

PImage[] chargeLoop0 = new PImage[3];
PImage[] chargeTo1st = new PImage[2];
PImage[] chargeLoop1 = new PImage[3];
PImage[] chargeToMax = new PImage[3];
PImage[] chargeMaxLoop = new PImage[3];
PImage[] chargeEffect01 = new PImage[4];
PImage[] chargeEffect12 = new PImage[9];
PImage[] attackFrames = new PImage[3];
PImage[] fireballFrames = new PImage[2];
PImage[] fireArrowFrames = new PImage[2];
PImage[] infernoFrames = new PImage[3];
PImage[] inpactFrames = new PImage[5];
ArrayList<FireballEffect> fireballs = new ArrayList<FireballEffect>();
ArrayList<FireArrowEffect> fireArrows = new ArrayList<FireArrowEffect>();
ArrayList<InfernoEffect> infernos = new ArrayList<InfernoEffect>();
ArrayList<Inpact> inpacts = new ArrayList<Inpact>();

PImage manaIcon;
PImage fireRoseIcon;
PImage[] fireroseFrames = new PImage[3];
PImage[] manaOrbFrames = new PImage[3];


PImage[] chargeLeftLoop0 = new PImage[3];   // 0→1段階チャージループ
PImage[] chargeLeftTo1st = new PImage[2];   // 0→1段階移行
PImage[] chargeLeftLoop1 = new PImage[3];   // 1→MAX段階ループ
PImage[] chargeLeftToMax = new PImage[3];   // 1→MAX段階移行
PImage[] chargeLeftMaxLoop = new PImage[3]; // MAXチャージループ
PImage[] attackLeftFrames = new PImage[3];
PImage[] fireArrowLeftFrames = new PImage[2];
PImage[] infernoLeftFrames = new PImage[3];
PImage[] inpactLeftFrames = new PImage[5]; 

int[] sleepyDurations = {75, 10};
ArrayList<Enemy> enemies;

Player player;
CollisionChecker collisionChecker;
CollisionHandler collisionHandler;
TileBufferManager bufferManager;
ItemManager itemManager;

int[][] map = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0, 0, 0, 0 ,0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   {3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   {3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}
};
  
int[][] objMap = {
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  };
  
  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean upPressed = false;      
  boolean upKeyHandled = false;
  boolean aKeyHandled = false;
  boolean isDamaged = false;
  
void setup() {
  size(700, 370);
  background(216, 151, 71);
  
  bgImg = loadImage("background.png");
  
  
  PImage ookamiImg = loadImage("ookami0.png");
  PImage ookamiImg2 = loadImage("ookami1.png");
  PImage f1 = loadImage("fly.png");
  PImage f2 = loadImage("fly2.png");
  
  
  
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
  
  fireballFrames[0] = loadImage("fire0.png");
  fireballFrames[1] = loadImage("fire1.png");
  fireArrowFrames[0] = loadImage("firearrow0.png");
  fireArrowFrames[1] = loadImage("firearrow1.png");
  
  
  for (int i = 0; i < 5; i++) inpactFrames[i] = loadImage("effect" + (i + 9) + ".png");
  for (int i = 0; i < 3; i++) infernoFrames[i] = loadImage("inferno" + i + ".png");
  
  for (int i = 0; i < 8; i++) walkRightFrames[i] = loadImage("player" + (i + 4) + ".png");
  for (int i = 0; i < 8; i++) walkLeftFrames[i] = loadImage("player" + (i + 16) + ".png");
  for (int i = 0; i < 3; i++) chargeLoop0[i] = loadImage("player" + (i + 26) + ".png");
  for (int i = 0; i < 2; i++) chargeTo1st[i] = loadImage("player" + (i + 29) + ".png");
  for (int i = 0; i < 3; i++) chargeLoop1[i] = loadImage("player" + (i + 31) + ".png");
  for (int i = 0; i < 3; i++) chargeToMax[i] = loadImage("player" + (i + 34) + ".png");
  for (int i = 0; i < 3; i++) chargeMaxLoop[i] = loadImage("player" + (i + 37) + ".png");
  
  for (int i = 0; i < 4; i++) chargeEffect01[i] = loadImage("effect" + i + ".png");
  for (int i = 0; i < 9; i++) chargeEffect12[i] = loadImage("effect" + i + ".png");
  for (int i = 0; i < 3; i++) attackFrames[i] = loadImage("player" + (i + 40) + ".png");
  
  for (int i = 0; i < 3; i++) chargeLeftLoop0[i] = loadImage("player" + (43 + i) + ".png"); // player43～45
  for (int i = 0; i < 2; i++) chargeLeftTo1st[i] = loadImage("player" + (46 + i) + ".png"); // player46～47
  for (int i = 0; i < 3; i++) chargeLeftLoop1[i] = loadImage("player" + (48 + i) + ".png"); // player48～50
  for (int i = 0; i < 3; i++) chargeLeftToMax[i] = loadImage("player" + (51 + i) + ".png"); // player51～53
  for (int i = 0; i < 3; i++) chargeLeftMaxLoop[i] = loadImage("player" + (54 + i) + ".png"); // player54～56
  for (int i = 0; i < 3; i++) attackLeftFrames[i] = loadImage("player" + (57 + i) + ".png"); // player57～59
  
  for (int i = 0; i < 2; i++) fireArrowLeftFrames[i] = loadImage("firearrow" + (i + 2) + ".png");
  for (int i = 0; i < 3; i++) infernoLeftFrames[i] = loadImage("inferno" + (i + 3) + ".png");
  for (int i = 0; i < 5; i++) inpactLeftFrames[i] = loadImage("effect" + (i + 14) + ".png");
  
  for (int i = 0; i < 3; i++) fireroseFrames[i] = loadImage("firerose" + i + ".png");
  for (int i = 0; i < 3; i++) manaOrbFrames[i] = loadImage("mana" + i + ".png");
  manaIcon = loadImage("mana0.png");
  fireRoseIcon = loadImage("firerose1.png");
  itemManager = new ItemManager();
  itemManager.registerItems();
  itemManager.loadItemsFromData(currentStage);
  
   collisionChecker = new CollisionChecker(tileSize, objTileSize, map, objMap, solidTiles);
   collisionHandler = new CollisionHandler(collisionChecker);
   Hitbox playerBox = new Hitbox(20, height - 156, 38, 80);
   
   
   Hitbox wolfBox = new Hitbox(500, height - 156, 40, 40);
   Hitbox flyBox = new Hitbox(350, -50, 30, 30);  // 画面外上部からスタート
   
   
   
   bufferManager = new TileBufferManager(
    tileSize, objTileSize, map, objMap,
    bgImg, blockImg,
    grassGroundImg, grassImg, soilImg, cliff_left, cliff_right
  );
  
  player = new FlamePlayer(
  playerBox, 
  normalImgLeft, normalImgRight, 
  blinkImgLeft, blinkImgRight, 
  sleepImgLeft, sleepImgRight, 
  walkLeftFrames, walkRightFrames, 
  sleepyFramesLeft, sleepyFramesRight, 
  sleepyDurations,
  jumpImgLeft, jumpImgRight,
  collisionChecker, collisionHandler,
  0, height - 156,
  chargeLoop0, chargeTo1st, chargeLoop1, chargeToMax, chargeMaxLoop,
  chargeEffect01, chargeEffect12,
  attackFrames,
  fireballFrames,
  fireArrowFrames,
  chargeLeftLoop0, chargeLeftTo1st, chargeLeftLoop1, chargeLeftToMax, chargeLeftMaxLoop,
  attackLeftFrames,
  fireArrowLeftFrames,
  infernoLeftFrames, inpactLeftFrames
  );
  player.groundY = height - 156;
  player.colHand = collisionHandler;
  
  
  
   wolf = new Ookami(
    wolfBox,
    ookamiImg,
    ookamiImg2,
    player,
    collisionChecker,
    collisionHandler,
    -1
  );
  
  fly = new Flymiira(
    flyBox,
    f1, f2,
    player,
    collisionChecker,
    collisionHandler,
    0.5f,    // 飛行速度
    1
  );
  enemies = new ArrayList<Enemy>();
  enemies.add(wolf);
  enemies.add(fly);
}

  void draw() {
    background(216, 151, 71);
    
    if (gameState == state_start) {
      displayStartScreen();
    }
    else if (gameState == state_play) {
      boolean attacking = false;   
      updateCameraShake();
      float centerX = player.hitbox.getX() + player.hitbox.getW() / 2.0;
      cameraOffsetX = centerX - width / 2.0;
      int maxOffset = max(0, map[0].length * tileSize - width);
      cameraOffsetX = constrain(cameraOffsetX, 0, maxOffset);
    
      bufferManager.drawAll(cameraOffsetX, cameraOffsetY);
      fill(255);
      textSize(16);
      textAlign(RIGHT, TOP);
      text("× " + player.manaCount, width - 20, 20);
      image(manaIcon, width - 62, 15, 24, 24);
      if (player.hasFirePower) {
        image(fireRoseIcon, width - 82, 16, 28, 28);
      }
      pushMatrix();
      translate(-cameraOffsetX, cameraOffsetY);
     
      itemManager.update();
      itemManager.display();
     
      for (int i = fireballs.size() - 1; i >= 0; i--) {
         FireballEffect f = fireballs.get(i);
         f.update();
         f.display();
         
          for (int j = enemies.size() - 1; j >= 0; j--) {
    Enemy e = enemies.get(j);
    if (!e.isAlive) continue;

    if (isHit(f.fireHB, e.hitbox)) {
      e.takeFireHit();     // 🔥 耐久を1減らす
      f.active = false;    // 🔥 Fireball消滅
      break;               // 1体のみにヒット（貫通しない）
    }
  }
         if (!f.isActive()){
           fireballs.remove(i);
         }
       }
    
       for (int i = fireArrows.size() - 1; i >= 0; i--) {
         FireArrowEffect arrow = fireArrows.get(i);
         arrow.update();
         arrow.display();
         if (!arrow.isActive()) {
           fireArrows.remove(i);
         }
       }
    
      for (int i = infernos.size() - 1; i >= 0; i--) {
        InfernoEffect inferno = infernos.get(i);
        inferno.update();
        inferno.display();
        if (!inferno.isActive()) {
          infernos.remove(i);
        }
      }
      for (int i = inpacts.size()-1; i >= 0; i--) {
        Inpact inp = inpacts.get(i);
        inp.update();
        inp.display();
        if (!inp.isActive()) inpacts.remove(i);
      }
 
      FlamePlayer flamePlayer = (FlamePlayer)player;
      if (player instanceof FlamePlayer) {
        attacking = ((FlamePlayer)player).getIsAttacking();
      }
      if (!attacking && !flamePlayer.isCharging){
      if (leftPressed) {
        player.move(-1);
      } 
      else if (rightPressed) {
        player.move(1);
      } 
      else {
        player.stop();
      }
  
      if (upPressed && !upKeyHandled) {
        // 横移動中なら連続ジャンプOK
        player.jump();
        upKeyHandled = true;
      }
     }
   
     player.update();
  
     if (player instanceof FlamePlayer) {
       if (flamePlayer.isCharging || flamePlayer.getIsAttacking()) {
         flamePlayer.updateFlameAnimation();
       } 
       else {
         player.display();
       }
     }  
     else {
       player.display();
     }
     popMatrix();
   
     wolf.update();
     wolf.display(cameraOffsetX);
     fly.update();
     fly.display(cameraOffsetX);
    }
    else if (gameState == state_pause) {
      bufferManager.drawAll(cameraOffsetX, cameraOffsetY);
      fill(0, 0, 0, 150);
      rect(0, 0, width, height);
      displayPauseScreen();
    }
    else if (gameState == state_gameOver) {
      bufferManager.drawAll(cameraOffsetX, cameraOffsetY);
      fill(0, 0, 0, 150); 
      rect(0, 0, width, height);
      displayGameOverScreen();
    }
 }


  void updateCameraShake() {
    if (!isShaking) return;
    
    if (shakePhase == 0) {
      // 上にガクッ
      cameraOffsetY = -shakeStrength;
      shakePhase = 1;
    } 
    else if (shakePhase == 1) {
      // 下にガクッ
      cameraOffsetY = shakeStrength;
      shakePhase = 2;
    }
    else if (shakePhase == 2) {
      // 元の位置に戻す
      cameraOffsetY = 0;
      isShaking = false;
      shakePhase = 0;
    }
  }
  
  void startVerticalShockShake(float strength) {
    isShaking = true;
    shakePhase = 0;
    shakeStrength = strength;
  }


  int resumeBtnX = 254, resumeBtnY = 220, btnW = 200, btnH = 50;
  int quitBtnX = 252, quitBtnY = 290;
  int retryBtnX = 254, retryBtnY = 220;
  
  void displayStartScreen() {
    image(bgImg, 0, 0, width, height);  // ダークブルー系
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(45);
    text("Twilight    Forest", width / 2 - 5, height / 2 - 60);
    if ((stringBlinkCounter / stringBlinkInterval) % 2 == 0) {
      textSize(20);
      text("Press to Start", width / 2, height / 2 + 70);
    }
    stringBlinkCounter++;
  }
  void displayPauseScreen() {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("PAUSE", width / 2, height / 2 - 40);
    
    fill(100, 200, 100);
    rect(resumeBtnX, resumeBtnY, btnW, btnH, 10);
    fill(255);
    textSize(20);
    text("▶ Restart", resumeBtnX + btnW / 2, resumeBtnY + btnH / 2);
    
    fill(200, 100, 100);
    rect(quitBtnX, quitBtnY, btnW, btnH, 10);
    fill(255);
    text("⏹ Escape", quitBtnX + btnW / 2, quitBtnY + btnH / 2);
  }
  void displayGameOverScreen() {
    textAlign(CENTER, CENTER);
    textSize(36);
    fill(255, 50, 50);
    text("GAME  OVER", width / 2, 180);
  
  // やり直しボタン
  fill(100, 200, 100);
  rect(retryBtnX, retryBtnY, btnW, btnH, 10);
  fill(255);
  textSize(20);
  text("Retry", retryBtnX + btnW / 2, retryBtnY + btnH / 2);
  
  // スタートに戻るボタン
  fill(200, 100, 100);
  rect(quitBtnX, quitBtnY, btnW, btnH, 10);
  fill(255);
  text("⏹ Escape", quitBtnX + btnW / 2, quitBtnY + btnH / 2);
}

void restartGame(boolean isRetry) {
  player.hasFirePower = false;
  player.resetPosition();

  if (isRetry) {
    gameState = state_play;
    // エフェクト・アイテムなどのリセット
    fireballs.clear();
    fireArrows.clear();
    infernos.clear();
    inpacts.clear();
    itemManager.reset();
    // 敵のリセット
    for (Enemy e : enemies) {
      e.resetForRetry();
    }
  } else {
    gameState = state_start;
    player.manaCount = 0;
    player.shieldCount = 0;
    itemManager.reset();
    for (Enemy e : enemies) {
      e.resetForRetry();
    }
  }
}

  
  
  void mousePressed() {
    if (gameState == state_start) {
      gameState = state_play;
       println(gameState);
    }
    else if (gameState == state_pause) {
      if (mouseX >= resumeBtnX && mouseX <= resumeBtnX + btnW && 
          mouseY >= resumeBtnY && mouseY <=resumeBtnY + btnH) {
            gameState = state_play;
          }
          else if (mouseX >= quitBtnX && mouseX <= quitBtnX + btnW &&
                   mouseY >= quitBtnY && mouseY <= quitBtnY + btnH) {
                     gameState = state_start;
                   }
    }
    else if (gameState == state_gameOver) {
      // 再試行
      if (mouseX >= retryBtnX && mouseX <= retryBtnX + btnW &&
          mouseY >= retryBtnY && mouseY <= retryBtnY + btnH) {
        restartGame(true);  // ← マナ保持ありで再スタート
      } 
      // スタートに戻る
      else if (mouseX >= quitBtnX && mouseX <= quitBtnX + btnW &&
               mouseY >= quitBtnY && mouseY <= quitBtnY + btnH) {
        restartGame(false);// ← 全リセット
      }
    }
  }
  
  void keyPressed() {
    player.notifyAction();
    
    if (gameState == state_start && key == ENTER) {
      gameState = state_play;
    }
    if (gameState == state_play && key == 'p') {
      gameState = state_pause;
    }
  
    if (keyCode == LEFT) leftPressed = true;
    if (keyCode == RIGHT) rightPressed = true;
    if (key == ' ' || keyCode == UP) upPressed = true;
    if ((key == 'a' || key == 'A') && player instanceof FlamePlayer && !aKeyHandled && player.hasFirePower) {
      FlamePlayer flamePlayer = (FlamePlayer)player;
      if (!flamePlayer.isCharging) {
        flamePlayer.startCharging();
        flamePlayer.isAttacking = false;  // フラグを内部に反映
        flamePlayer.attackFrame = 0;
        flamePlayer.chargeLevel = 0;
        flamePlayer.chargeFrame = 0;
        animationFrame = 0;
        aKeyHandled = true;
      }
      flamePlayer.chargeLevel = 0;
      flamePlayer.chargeFrame = 0;
      animationFrame = 0;
    }
  }

void keyReleased() {
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (key == ' ' || keyCode == UP) {
    upPressed = false;
    upKeyHandled = false;
  }
   if ((key == 'a' || key == 'A') && player instanceof FlamePlayer) {
     FlamePlayer flamePlayer = (FlamePlayer) player;
    if (flamePlayer.isCharging) {
      flamePlayer.stopChargingAndAttack();
      flamePlayer.isAttacking = true;
      flamePlayer.attackFrame = 0;
    }
      flamePlayer.chargeLevel = 0;
      flamePlayer.chargeFrame = 0;
      animationFrame = 0;
      aKeyHandled = false;
    // 魔法発動処理を書くならここ
  }}
  boolean isHit(Hitbox a, Hitbox b) {
  return a.getX() < b.getX() + b.getW() &&
         a.getX() + a.getW() > b.getX() &&
         a.getY() < b.getY() + b.getH() &&
         a.getY() + a.getH() > b.getY();
}
