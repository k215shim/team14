class Character {
  Hitbox hitbox;
  int drawW = 80;
  int drawH = 80;
  float drawOffsetX = -16;
  float drawOffsetY = 8;
  float gravity = 1;
  
  boolean isOnGround = false;
  boolean faceLeft = false;

  PImage normalImgLeft, normalImgRight;
  PImage blinkImgLeft, blinkImgRight;
  PImage[] walkLeftFrames, walkRightFrames;
 

  int currentFrame = 0;
  int frameCounter = 0;
  int animationSpeed = 5;
  
  CollisionChecker collider;
  CollisionHandler colHand;
  String lastGroundType = "";

  Character(Hitbox hitbox,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft, PImage blinkImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames
    ) {
    this.hitbox = hitbox;
    this.normalImgLeft = normalImgLeft;
    this.normalImgRight = normalImgRight;
    this.blinkImgLeft = blinkImgLeft;
    this.blinkImgRight = blinkImgRight;
    this.walkLeftFrames = walkLeftFrames;
    this.walkRightFrames = walkRightFrames;
  }

  void updatePosition() {
    hitbox.applyGravity(gravity);
    hitbox.move();
    colHand.checkX(hitbox, this); 
    colHand.checkY(hitbox, this); 
    updateAnimation();
  }
  

  
  void updateAnimation() {
     if (hitbox.getVX() != 0) {
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
    hitbox.setVX(2.5 * dir);
    faceLeft = dir < 0;
  }

  void stop() {
    hitbox.stopX();
  }
}
