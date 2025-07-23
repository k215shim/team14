class FireArrowEffect {
  float x, y;
  float vx;
  boolean active = true;
  PImage[] frames;
  int currentFrame = 0;
  int frameCounter = 0;
  int frameSpeed = 4;
  int width = 120;
  int height = 92;
  
  Hitbox fireArrowHB;

 FireArrowEffect(float x, float y, float vx, PImage[] frames) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.frames = frames;
    fireArrowHB = new Hitbox(x, y, 100, 55);
  }

  void update() {
    if (!active) return;

    x += vx;
    fireArrowHB.x = x;
    fireArrowHB.y = y;
    
     // 壁衝突で消滅（任意）
    fireArrowHB.setVX(vx);
    if (collisionHandler.willCollideX(fireArrowHB)) {
      active = false;
      return;
    }
    fireArrowHB.setVY(0);
    if (collisionHandler.willCollideY(fireArrowHB)) {
      active = false;
      return;
    }
    
    frameCounter++;
    if (x < cameraOffsetX - 100 || x > cameraOffsetX + width + 1000) {
      active = false;
      return;
    }
    
    if (frameCounter >= frameSpeed) {
      frameCounter = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }

   
  }

  void display() {
      if (active) {
        image(frames[currentFrame], x, y, width, height);
      }
  }

  boolean isActive() {
    return active;
  }
}
