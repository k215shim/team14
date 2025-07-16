class Player extends Character {
  // 移動・ジャンプ
  PImage jumpImgLeft, jumpImgRight;
  float jumpPower = -5;
  boolean isJumping = false;
  int groundY;
  int jumpPhase = 0;
  int jumpPauseDuration = 4;
  int jumpPauseCounter = 0;

  float cameraOffsetX = 0;

  // スリープ関連
  int lastActionTime = 0;
  int sleapFlag = 30000;
  boolean isSleepy = false;
  boolean isAsleep = false;

  PImage sleepImgLeft, sleepImgRight;
  PImage[] sleepyFramesLeft, sleepyFramesRight;
  int sleepyFrame = 0;
  int sleepyCounter = 0;
  int[] sleepyDurations;

  // 瞬き
  boolean isBlinking = false;
  int blinkTimer = 0;
  int blinkDuration = 4;
  int blinkCooldown = 150;

  // ステータス関連
  int hp = 3;
  int level = 1;
  int coinCount = 0;
  boolean isDead = false;

  Player(int x, int y, int w, int h,
         PImage normalImgLeft, PImage normalImgRight,
         PImage blinkImgLeft, PImage blinkImgRight,
         PImage sleepImgLeft, PImage sleepImgRight,
         PImage[] walkLeftFrames, PImage[] walkRightFrames,
         PImage[] sleepyFramesLeft, PImage[] sleepyFramesRight,
         int[] sleepyDurations,
         PImage jumpImgLeft, PImage jumpImgRight) {

    super(x, y, w, h,
      normalImgLeft, normalImgRight,
      blinkImgLeft, blinkImgRight,
      walkLeftFrames, walkRightFrames);

    this.sleepyFramesLeft = sleepyFramesLeft;
    this.sleepyFramesRight = sleepyFramesRight;
    this.sleepyDurations = sleepyDurations;
    this.sleepImgLeft = sleepImgLeft;
    this.sleepImgRight = sleepImgRight;
    this.jumpImgLeft = jumpImgLeft;
    this.jumpImgRight = jumpImgRight;

    lastActionTime = millis();
    blinkTimer = blinkCooldown;
  }

  void update() {
    if (isDead) return;

    int now = millis();
    int elapsed = now - lastActionTime;

    isSleepy = (elapsed > sleapFlag - 5000 && elapsed <= sleapFlag);
    isAsleep = (elapsed > sleapFlag);

    // 瞬き処理
    if (!isBlinking) {
      blinkTimer--;
      if (blinkTimer <= 0) {
        isBlinking = true;
        blinkTimer = blinkDuration;
      }
    } else {
      blinkTimer--;
      if (blinkTimer <= 0) {
        isBlinking = false;
        blinkTimer = blinkCooldown;
      }
    }

    // 歩行アニメーション更新
    if (vx != 0) {
      frameCounter++;
      int len = faceLeft ? walkLeftFrames.length : walkRightFrames.length;
      if (frameCounter % animationSpeed == 0) {
        currentFrame = (currentFrame + 1) % len;
      }
    } else {
      currentFrame = 0;
    }

    applyGravity();
    updatePosition();

    cameraOffsetX = x - width / 2 + w / 2;
    int maxOffset = max(0, map[0].length * tileSize - width);
    cameraOffsetX = constrain(cameraOffsetX, 0, maxOffset);

    checkCollision(map, tileSize);
    updateAnimation();

    if (isOnGround) {
      isJumping = false;
    }

    // ジャンプフェーズ制御
    if (isJumping) {
      switch (jumpPhase) {
        case 0:
          y += vy;
          if (vy < -1) {
            vy *= 0.7;
          } else {
            vy = 0;
            jumpPauseCounter = 0;
            jumpPhase = 1;
          }
          break;

        case 1:
          jumpPauseCounter++;
          if (jumpPauseCounter >= jumpPauseDuration) {
            vy = 0.9;
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
  }

  void display() {
    pushMatrix();
    translate(-cameraOffsetX, 0);

    if (isDead) {
      tint(255, 100);  // 死亡時に半透明などで演出可
    }

    if (isAsleep) {
      image(faceLeft ? sleepImgLeft : sleepImgRight, x, y, w, h);
    } else if (isSleepy) {
      PImage[] frames = faceLeft ? sleepyFramesLeft : sleepyFramesRight;
      sleepyCounter++;
      if (sleepyCounter >= sleepyDurations[sleepyFrame]) {
        sleepyFrame = (sleepyFrame + 1) % frames.length;
        sleepyCounter = 0;
      }
      image(frames[sleepyFrame], x, y, w, h);
    } else if (isJumping) {
      image(faceLeft ? jumpImgLeft : jumpImgRight, x, y, w, h);
    } else {
      PImage img;
      if (vx != 0) {
        PImage[] frames = faceLeft ? walkLeftFrames : walkRightFrames;
        img = frames[currentFrame];
      } else {
        img = isBlinking ? (faceLeft ? blinkImgLeft : blinkImgRight)
                         : (faceLeft ? normalImgLeft : normalImgRight);
      }
      image(img, x, y, w, h);
    }

    popMatrix();
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      jumpPhase = 0;
      vy = -20;
      notifyAction();
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

  // 🛡️ ダメージ処理
  void takeDamage(int amount) {
    if (isDead) return;

    hp -= amount;
    println("Player took damage! HP: " + hp);

    if (hp <= 0) {
      die();
    }
  }

  // 💀 即死処理
  void die() {
    if (!isDead) {
      isDead = true;
      println("Game Over!");
      // TODO: 死亡演出・ゲームリセット処理を追加
    }
  }

  // 🍎 成長処理
  void grow() {
    level++;
    println("Level Up! Now Level: " + level);
    // ジャンプ力UPや速度UPのような強化も追加可能
  }

  // 🪙 コイン取得処理
  void collectCoin() {
    coinCount++;
    println("Coins: " + coinCount);

    if (coinCount >= 100) {
      grow();
      coinCount = 0;
    }
  }
}
