class JumpController {
  boolean isJumping = false;
  boolean canJump = true;
  int jumpPhase = 0;
  int jumpPauseCounter = 0;
  int jumpPauseDuration = 12;

  float gravity = 1;
  float jumpPower = -22;

  PImage jumpImgLeft, jumpImgRight;

  JumpController(PImage jumpImgLeft, PImage jumpImgRight) {
    this.jumpImgLeft = jumpImgLeft;
    this.jumpImgRight = jumpImgRight;
  }

  void startJump(Player p) {
    isJumping = true;
    jumpPhase = 0;
    p.hitbox.setVY(jumpPower);
    println("ジャンプ開始！");
  }

  void update(Player p) {
    if (!isJumping) return;

    Hitbox hb = p.hitbox;
    
    switch (jumpPhase) {
      case 0: // 上昇フェーズ
       hb.y += hb.vy;
        if (hb.vy < -1) {
          hb.vy *= 0.7;
        } else {
          hb.vy = 0;
          jumpPauseCounter = 0;
          jumpPhase = 1;
        }
        break;

      case 1: // 停止フェーズ
        hb.vy = 0;
        jumpPauseCounter++;
        if (jumpPauseCounter >= jumpPauseDuration) {
          jumpPhase = 2;
        }
        break;

      case 2: // 落下フェーズ
        hb.vy += gravity / 2;
        hb.y += hb.vy;
        if (player.isOnGround) {
          hb.vy = 0;
          isJumping = false;
          jumpPhase = 0;
        }
        break;
    }
  }

  boolean isJumping() {
    return isJumping;
  }

  boolean canJumpNow(Player p) {
    return !isJumping && p.isOnGround;
  }

  // ジャンプ中に表示する画像を返す
  PImage getJumpImage(boolean faceLeft) {
    return faceLeft ? jumpImgLeft : jumpImgRight;
  }
}
