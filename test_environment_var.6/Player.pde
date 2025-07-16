class Player extends Character {
  int startX, startY;
  //ジャンプ
  PImage jumpImgLeft, jumpImgRight;
  float jumpPower = -5;
  boolean isJumping = false;
  boolean canJump = true;
  int groundY;
  int jumpPhase = 0;
  int jumpPauseDuration = 12;
  int jumpPauseCounter = 0;
  
  int lastActionTime = 0;
  int sleapFlag = 30000;
  
  PImage sleepImgLeft, sleepImgRight;
  PImage[] sleepyFramesLeft, sleepyFramesRight;
   
  int sleepyFrame = 0;
  int sleepyCounter = 0;
  int[] sleepyDurations;
  
  boolean isSleepy = false;
  boolean isAsleep = false;
  
   boolean isBlinking = false;
  int blinkTimer = 0;
  int blinkDuration = 4;
  int blinkCooldown = 150;
  
  float cameraOffsetX = 0;

  Player(int x, int y, int w, int h,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft, PImage blinkImgRight,
    PImage sleepImgLeft, PImage sleepImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames,
    PImage[] sleepyFramesLeft, PImage[] sleepyFramesRight,
    int[] sleepyDurations,
     PImage jumpImgLeft, PImage jumpImgRight,
     int startX, int startY
     ) {

    super(x, y, w, h,
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
    lastActionTime = millis();
    
    blinkTimer = blinkCooldown;
  }

  void update() {
    int now = millis();
    int elapsed = now - lastActionTime;

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
    
    applyGravity();
    updatePosition();
    
    cameraOffsetX = x - width / 2 + w / 2;
    int maxOffset = max(0, map[0].length * tileSize - width);
  cameraOffsetX = constrain(cameraOffsetX, 0, maxOffset);
    
    checkCollision(tileSize);
    updateAnimation();
    
    if (isOnGround) {
      isJumping = false;
    }
    
    //ジャンプ処理
    if (isJumping) {
      switch (jumpPhase) {
        case 0:
        y += vy;
        if (vy < -1) {
          vy *= 0.7;
        }
        else {
          vy = 0;
          jumpPauseCounter = 0;
          jumpPhase = 1;
        }
        break;
        
        case 1:
        jumpPauseCounter++;
        if (jumpPauseCounter >= jumpPauseDuration) {
          vy = 0;
          jumpPhase = 2;
        }
        break;
        
        case 2:
        vy += gravity;
        y += vy;
        if (y >= groundY) {
          y = groundY;
          vy = 0;
          isJumping = false;
          jumpPhase = 0;
        }
        break;
      }
    }
    
    if ( y > height + 420) {
      respawn();
    }
  }
  
  void display() {
    pushMatrix();
    translate(-cameraOffsetX, 0);
    
    if (isAsleep) {
      image(faceLeft ? sleepImgLeft : sleepImgRight, x, y, w, h);
    }
    else if (isSleepy) {
      PImage[] frames = faceLeft ? sleepyFramesLeft : sleepyFramesRight;
      sleepyCounter++;
      if (sleepyCounter >= sleepyDurations[sleepyFrame]) {
        sleepyFrame = (sleepyFrame + 1) % frames.length;
        sleepyCounter = 0;
      }
      image(frames[sleepyFrame], x, y, w, h);
    }
    else if (isJumping) {
      image(faceLeft ? jumpImgLeft : jumpImgRight, x, y, w, h);
    }
    else {
      PImage img;
    if (vx != 0) {
      PImage[] frames = faceLeft ? walkLeftFrames : walkRightFrames;
      img = frames[currentFrame];
    }
    else {
      img = isBlinking ? (faceLeft ? blinkImgLeft : blinkImgRight) 
      : (faceLeft ? normalImgLeft : normalImgRight);
    }
    image(img, x, y, w, h);
    }
    
    popMatrix();
  }
  
  void jump() {
    if ( canJump && vy == 0 && !isJumping && isOnGround) {
      isJumping = true;
      jumpPhase = 0;
      vy = -30;
      notifyAction();
      canJump = false;
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
    x = startX;
    y = startY;
    vx = 0;
    vy = 0;
    isJumping = false;
    jumpPhase = 0;
    isOnGround = false;
    isAsleep = false;
    isSleepy = false;
    notifyAction();
  }
}
