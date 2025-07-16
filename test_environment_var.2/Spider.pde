class Spider extends Enemy {
  float baseY;       // 初期Y位置（吊るされる基準）
  float amplitude = 40; // 上下に動く幅
  float speed = 0.05;   // 揺れ速度
  float angle = 0;

  Spider(int x, int y, int w, int h, PImage img) {
    super(x, y, w, h, img, img);
    baseY = y;
  }

  void update() {
    if (!isAlive) return;

    // 上下にゆっくり揺れる
    angle += speed;
    y = baseY + sin(angle) * amplitude;

    // 重力や横移動は不要（宙吊りのため）
  }

  void display() {
    if (!isAlive) return;

    // 糸を描く（画面上部から現在の中心まで）
    stroke(150);
    line(x + w / 2, 0, x + w / 2, y);

    // 本体描画
    image(normalImgRight, x, y, w, h);
  }

  void checkPlayerCollision(Player player) {
    if (!isAlive) return;

    if (player.x + player.w > this.x && player.x < this.x + this.w &&
        player.y + player.h > this.y && player.y < this.y + this.h) {
      player.takeDamage(1);
    }
  }

  void checkFireCollision(Fire fire) {
    // Fireクラスの x,y,w,h を想定
    if (!isAlive) return;

    if (fire.x + fire.w > this.x && fire.x < this.x + this.w &&
        fire.y + fire.h > this.y && fire.y < this.y + this.h) {
      isAlive = false;
    }
  }
}
