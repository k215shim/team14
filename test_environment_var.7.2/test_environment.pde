int tileSize = 27;
int objTileSize = 27;
int[] solidTiles = {1, 3, 4, 5, 6};

float cameraOffsetX = 0;
float cameraOffsetY = 0;
boolean isShaking = false;
int shakePhase = 0;
float shakeStrength = 8;

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

Player player;
CollisionChecker collisionChecker;
CollisionHandler collisionHandler;
TileBufferManager bufferManager;

int[][] map = {
  
  
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0, 0, 0, 0 ,0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
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
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  };
  
  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean upPressed = false;      
  boolean upKeyHandled = false;
  boolean aKeyHandled = false;
  
void setup() {
  size(700, 370);
  background(216, 151, 71);
  
  bgImg = loadImage("background.png");
  
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
  
   collisionChecker = new CollisionChecker(tileSize, objTileSize, map, objMap, solidTiles);
   collisionHandler = new CollisionHandler(collisionChecker);
   Hitbox playerBox = new Hitbox(20, height - 156, 38, 80);
   
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
}

  void draw() {
    background(216, 151, 71);
  
    boolean attacking = false;   
    updateCameraShake();
    float centerX = player.hitbox.getX() + player.hitbox.getW() / 2.0;
    cameraOffsetX = centerX - width / 2.0;
    int maxOffset = max(0, map[0].length * tileSize - width);
    cameraOffsetX = constrain(cameraOffsetX, 0, maxOffset);
    
    bufferManager.drawAll(cameraOffsetX, cameraOffsetY);
    pushMatrix();
    translate(-cameraOffsetX, cameraOffsetY);
    
    for (int i = fireballs.size() - 1; i >= 0; i--) {
       FireballEffect f = fireballs.get(i);
       f.update();
       f.display();
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


  void keyPressed() {
    player.notifyAction();
  
    if (keyCode == LEFT) leftPressed = true;
    if (keyCode == RIGHT) rightPressed = true;
    if (key == ' ' || keyCode == UP) upPressed = true;
    if ((key == 'a' || key == 'A') && player instanceof FlamePlayer && !aKeyHandled) {
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
  }
}
