class BossPanda extends Enemy {
  int direction = 1; // 1: 右, -1: 左
  float speed = 7.0;

  BossPanda(int x, int y, int w, int h, PImage pandaImg) {
    super(x, y, w, h, pandaImg, pandaImg);  // 左右共通の画像
  }

  void update() {
    if (!isAlive) return;

    applyGravity();
    move(direction);
    updatePosition();
    checkCollision(map, tileSize);

    // 画面端で反転（簡易パトロール）
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

    if (player.x + player.w > this.x && player.x < this.x + this.w &&
        player.y + player.h > this.y && player.y < this.y + this.h) {
      // プレイヤー即死
      player.die();  // die() はプレイヤークラスに追加が必要
    }
  }

  void display() {
    if (!isAlive) return;
    image(normalImgRight, x, y, w, h);
  }
}
