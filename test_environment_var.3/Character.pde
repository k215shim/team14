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
  int animationSpeed = 5;

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
  
  void checkCollision(int tileSize) {
    int margin = 14;
    //足元の当たり判定
    int footX = (x + w / 2) / tileSize;
    int footY = (y + h - margin) / tileSize;
    if (isSolidTile(footX, footY)) {
      y = footY * tileSize - h + margin;
      vy = 0;
      isOnGround = true;
    }
    else {
      isOnGround = false;
    }
    
    //左側の壁との判定
    int leftX = (x + 4) / tileSize;
    int bodyY = (y + h / 2) / tileSize;
    if ( vx < 0 && isSolidTile(leftX, bodyY)) {
      x = (leftX + 1) * tileSize - 4; // めり込み調整
      vx = 0;
    }
    
     // 右側の壁との判定
  int rightX = (x + w - 4) / tileSize;
  if (vx > 0 && isSolidTile(rightX, bodyY)) {
    x = rightX * tileSize - w + 4;
    vx = 0;
  }

  // 天井との当たり判定（ジャンプ中）
  int headX = (x + w / 2) / tileSize;
  int headY = y / tileSize;
  if (vy < 0 && isSolidTile(headX, headY)) {
    vy = 0;
  }
  }
  
  void updateAnimation() {
    x += vx;
    
     if (vx != 0) {
      frameCounter++;
      int len = faceLeft ? walkLeftFrames.length : walkRightFrames.length;
      if (frameCounter % animationSpeed == 0) {
        currentFrame = (currentFrame + 1) % len;
      }
    } 
    else {
      currentFrame = 0;
    }
  }

  void move(int dir) {
    vx = 3.8 * dir;
    faceLeft = dir < 0;
  }

  void stop() {
    vx = 0;
  }
}
