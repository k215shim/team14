class Player extends Character {
  int startX, startY;
  
  PImage jumpImgLeft, jumpImgRight;
  
  int groundY;
  
  int lastActionTime = 0;
  int sleapFlag = 30000;
  
  PImage sleepImgLeft, sleepImgRight;
  PImage[] sleepyFramesLeft, sleepyFramesRight;
  int[] sleepyDurations;
  
  int sleepyFrame = 0;
  int sleepyCounter = 0;
 
  boolean isSleepy = false;
  boolean isAsleep = false;
  
   boolean isBlinking = false;
  int blinkTimer = 0;
  int blinkDuration = 4;
  int blinkCooldown = 150;
  
  float cameraOffsetX = 0;
  
  JumpController jumCon;

  Player(Hitbox hitbox,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft, PImage blinkImgRight,
    PImage sleepImgLeft, PImage sleepImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames,
    PImage[] sleepyFramesLeft, PImage[] sleepyFramesRight,
    int[] sleepyDurations,
     PImage jumpImgLeft, PImage jumpImgRight,
     CollisionChecker collider, CollisionHandler colHand,
     int startX, int startY
     ) {

    super(hitbox,
      normalImgLeft, normalImgRight,
      blinkImgLeft, blinkImgRight,
      walkLeftFrames, walkRightFrames
      );
    this. sleepyFramesLeft = sleepyFramesLeft;
    this.sleepyFramesRight = sleepyFramesRight;
    this.sleepyDurations = sleepyDurations;
    this.sleepImgLeft = sleepImgLeft;
    this.sleepImgRight = sleepImgRight;
    this.jumpImgLeft = jumpImgLeft;
    this.jumpImgRight = jumpImgRight;
    this.startX = startX;
    this.startY = startY;
    this.collider = collider;
    this.colHand = colHand;
    this.jumCon = new JumpController(jumpImgLeft, jumpImgRight);
    lastActionTime = millis();
    blinkTimer = blinkCooldown;
  }
  
  void update() {
    int now = millis();
    int elapsed = now - lastActionTime;
    
    updatePosition();
    
    isSleepy = (elapsed > sleapFlag - 5000 && elapsed <= sleapFlag);
    isAsleep = (elapsed > sleapFlag);

     //瞬き処理
     if (!isBlinking) {
      blinkTimer--;
      if (blinkTimer <= 0) {
        isBlinking = true;
        blinkTimer = blinkDuration;
      }
    } 
    else {
      blinkTimer--;
      if (blinkTimer <= 0) {
        isBlinking = false;
        blinkTimer = blinkCooldown;
    }
  }
  
    if (jumCon.isJumping()) {
    jumCon.update(this);
    }
     
     if (isOnGround) {
       if (lastGroundType.equals("map")) {
         drawOffsetY = 7;  // 地面のときは浮かせる
       } else if (lastGroundType.equals("obj")) {
         drawOffsetY = 0;   // オブジェクトのときはズラさない
       }
     }
    
    if ( hitbox.getY() > height + 420) {
      respawn();
    }
    
    float centerX = hitbox.getX() + hitbox.getW() / 2.0;
    cameraOffsetX = centerX - width / 2.0;
    int maxOffset = max(0, map[0].length * tileSize - width);
    cameraOffsetX = constrain(cameraOffsetX, 0, maxOffset);
  }
  
  void display() {
    float drawX = hitbox.getX() + drawOffsetX;
    float drawY = hitbox.getY() + drawOffsetY;
    
    pushMatrix();
    translate(-cameraOffsetX, 0);
    
    PImage img;
    
    if (isAsleep) {
      img = faceLeft ? sleepImgLeft : sleepImgRight;
    }
    else if (isSleepy) {
      PImage[] frames = faceLeft ? sleepyFramesLeft : sleepyFramesRight;
      sleepyCounter++;
      if (sleepyCounter >= sleepyDurations[sleepyFrame]) {
        sleepyFrame = (sleepyFrame + 1) % frames.length;
        sleepyCounter = 0;
      }
      img = frames[sleepyFrame];
    }
    else if (jumCon.isJumping()) {
      println(jumpImgLeft);
      img = jumCon.getJumpImage(faceLeft);
    }
    else {
      if (hitbox.getVX() != 0) {
         PImage[] frames = faceLeft ? walkLeftFrames : walkRightFrames;
         img = frames[currentFrame];
       } else {
         img = isBlinking ? (faceLeft ? blinkImgLeft : blinkImgRight)
                          : (faceLeft ? normalImgLeft : normalImgRight);
       }
     }
     
    image(img, drawX, drawY, drawW, drawH);
    popMatrix();
  }
  
  void move(int dir) {
    super.move(dir); // hitbox.vxセット & faceLeft更新
    notifyAction();
  }
  
  void jump() {
    if ( jumCon.canJumpNow(this)) {
      jumCon.startJump(this);
      notifyAction();
    }
     else {
     println("ジャンプできません: isOnGround=" + isOnGround + ", jumping=" + jumCon.isJumping);
    }
  }
  
  void notifyAction() {
    lastActionTime = millis();
    isSleepy = false;
    isAsleep = false;
  }
  
  float getCameraOffsetX() {
    return cameraOffsetX;
  }
  
  void respawn() {
    hitbox.setPos(startX, startY);
    hitbox.stopX();
    hitbox.stopY();
    isOnGround = false;
    isAsleep = false;
    isSleepy = false;
    notifyAction();
  }
}
