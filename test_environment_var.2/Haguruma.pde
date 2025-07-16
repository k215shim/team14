class Haguruma extends Enemy {
  int direction = 1;
  float speed = 3.0;

  Haguruma(int x, int y, int w, int h, PImage img) {
    super(x, y, w, h, img, img);  // 左右共通画像使用
  }

  void update() {
    if (!isAlive) return;

    applyGravity();
    move(direction);
    updatePosition();
    checkCollision(map, tileSize);

    // 画面端で反転（または壁判定に変更してもOK）
    if (x <= 0 || x + w >= width) {
      direction *= -1;
    }
  }

  void move(int dir) {
    vx = speed * dir;
    faceLeft = dir < 0;
  }

  void checkPlayerCollision(Player player) {
    if (!isAlive) return;

    // シンプルな矩形衝突判定
    if (player.x + player.w > this.x && player.x < this.x + this.w &&
        player.y + player.h > this.y && player.y < this.y + this.h) {
      player.takeDamage(1); // 無敵なので常にダメージ
    }
  }

  // 踏んでも無敵なので、何も起きない
}
