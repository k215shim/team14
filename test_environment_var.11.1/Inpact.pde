class Inpact {
  PImage[] frames;
  int currentFrame = 0;
  int frameCounter = 0;
  int frameSpeed = 3;
  float x, y;
  float vx;
  boolean active = true;
  int screenBuffer = 100;

  Inpact(float x, float y, float vx, PImage[] frames) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.frames = frames;
  }

  void update() {
    if (!active) return;
    
    x += vx;
    frameCounter++;
    if (frameCounter >= frameSpeed) {
      frameCounter = 0;
      currentFrame++;
      if (currentFrame >= frames.length) {
        active = false;  // 1回再生で終了
      }
    }
  }

  void display() {
    if (active) {
      image(frames[currentFrame], x, y, 175, 100);
    }
  }

  boolean isActive() {
    return active;
  }
}
