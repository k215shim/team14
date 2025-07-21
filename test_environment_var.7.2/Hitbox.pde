class Hitbox {
  float x, y;
  int w, h;
  float vx = 0;
  float vy = 0;

  Hitbox(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void setPos(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void move() {
    x += vx;
    y += vy;
  }

  void applyGravity(float gravity) {
    vy += gravity;
  }

  void stopX() { vx = 0; }
  void stopY() { vy = 0; }
  void setVX(float vx) { this.vx = vx; }
  void setVY(float vy) { this.vy = vy; }
  
  float getX() { return x; }
  float getY() { return y; }
  int getW() { return w; }
  int getH() { return h; }
  float getVX() { return vx; }
  float getVY() { return vy; }
}
