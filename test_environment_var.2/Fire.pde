class Fire extends Item {
  float vx;
  float lifetime = 120; // 2秒 (60fps前提)
  float age = 0;

  Fire(float x, float y, float w, float h, PImage img, float direction) {
    super(x, y, w, h, img);
    this.vx = direction * 6.0; // 右向き: +6, 左向き: -6
  }

  void update() {
    if (!isActive) return;

    x += vx;
    age++;
    if (x < 0 || x > width || age > lifetime) {
      isActive = false;
    }
  }

  // 敵との衝突判定（Spiderなどに使用される）
  boolean hits(Enemy enemy) {
    if (!isActive || !enemy.isAlive) return false;

    return (x + w > enemy.x && x < enemy.x + enemy.w &&
            y + h > enemy.y && y < enemy.y + enemy.h);
  }
}
