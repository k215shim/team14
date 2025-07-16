class Character {
  int x, y;
  int w, h;
  float vx = 0;
  float vy = 0;
  float gravity = 1;
  
  boolean isOnGround = false;
  boolean faceLeft = false;

  PImage normalImgLeft, normalImgRight;
  PImage blinkImgLeft, blinkImgRight;
  PImage[] walkLeftFrames, walkRightFrames;
 

  int currentFrame = 0;
  int frameCounter = 0;
  int animationSpeed = 3;

 

  Character(int x, int y, int w, int h,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft, PImage blinkImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames
    ) {

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.normalImgLeft = normalImgLeft;
    this.normalImgRight = normalImgRight;
    this.blinkImgLeft = blinkImgLeft;
    this.blinkImgRight = blinkImgRight;
    this.walkLeftFrames = walkLeftFrames;
    this.walkRightFrames = walkRightFrames;
  }
  
  void applyGravity() {
    vy += gravity;
  }

  void updatePosition() {
    x += vx;
    y += vy;
  }
  
  void checkCollision(int[][] map, int tileSize) {
    int margin = 14;
    int footX = (x + w / 2) / tileSize;
    int footY = (y + h - margin) / tileSize;
    
    if (footY < map.length && footX < map[0].length && (map[footY][footX] == 1|| map[footY][footX] == 4 || map[footY][footX] == 5)) {  
      y = footY * tileSize - h + margin;
      vy = 0;
      isOnGround = true;    
  }
      else {  
        isOnGround = false;  
    }  
  }
  
  void updateAnimation() {
    x += vx;

    

   
  }

  void move(int dir) {
    vx = 4.5 * dir;
    faceLeft = dir < 0;
  }

  void stop() {
    vx = 0;
  }
}
