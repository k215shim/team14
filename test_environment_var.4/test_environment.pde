int tileSize = 64;
PImage grassGroundImg;
PImage grassImg;
PImage soilImg;
PImage cliff_left;
PImage cliff_right;
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
PImage BossPanda;
int[] sleepyDurations = {75, 10};
Player player;

int[][] map = {
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {2, 2, 2, 2, 2, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   {1, 1, 1, 1, 4, 0, 0, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {3, 3, 3, 3, 3, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}
  };

void setup() {
  size(600, 300);
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
  
  for (int i = 0; i < 8; i++) {
    walkRightFrames[i] = loadImage("player" + (i + 4) + ".png");
  }
  
  for (int i = 0; i < 8; i++) {
    walkLeftFrames[i] = loadImage("player" + (i + 16) + ".png");
  }
  
  player = new Player(0, height - 169, 75, 75, 
  normalImgLeft, normalImgRight, 
  blinkImgLeft, blinkImgRight, 
  sleepImgLeft, sleepImgRight, 
  walkLeftFrames, walkRightFrames, 
  sleepyFramesLeft, sleepyFramesRight, 
  sleepyDurations,
  jumpImgLeft, jumpImgRight
  );
  
  bossPanda = new BossPanda()
  
  player.groundY = height - 169;
}

void drawMap() {
  for (int row = 0; row < map.length; row++) {
    for (int col = 0; col < map[row].length; col++) {
      if (map[row][col] == 1){
        image(grassGroundImg, col * tileSize, row * tileSize, tileSize, tileSize);
      }
      else if (map[row][col] == 2){
        image(grassImg, col * tileSize, row * tileSize, tileSize, tileSize);
      }
       else if (map[row][col] == 3){
        image(soilImg, col * tileSize, row * tileSize, tileSize, tileSize);
      }
      else if (map[row][col] == 4){
        image(cliff_left, col * tileSize, row * tileSize, tileSize, tileSize);
      }
      else if (map[row][col] == 5){
        image(cliff_right, col * tileSize, row * tileSize, tileSize, tileSize);
      }
    }
  }
}

void draw() {
  background(0);
  pushMatrix();
  translate(-player.getCameraOffsetX(), 0);
  
  image(bgImg, 0, 0, 600, 300);
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
