class InfernoEffect {
  PImage[] frames;
  int currentFrame = 0;
  int frameCounter = 0;
  int frameSpeed = 2;

  float x, y;
  float vx;
  boolean active = true;

  int screenBuffer = 100;  // 画面外に出た判定用余裕
  Hitbox infernoHB;

  InfernoEffect(float x, float y, float vx, PImage[] frames) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.frames = frames;
    infernoHB = new Hitbox(x, y, 140, 80);
  }

  void update() {
    if (!active) return;

    x += vx;
    infernoHB.x = x;

    // アニメーション更新
    frameCounter++;
    if (frameCounter >= frameSpeed) {
      frameCounter = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }

    // 画面外に出たら消す
    if (x < cameraOffsetX - 100 || x > cameraOffsetX + width + 1000) {
      active = false;
      return;
    }
  }

  void display() {
    if (active) {
      image(frames[currentFrame], x, y, 161, 92);
    }
  }

  boolean isActive() {
    return active;
  }
}
