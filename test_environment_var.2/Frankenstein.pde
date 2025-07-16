class Frankenstein extends Enemy {

  Frankenstein(int x, int y, int w, int h, PImage frankensteinImg) {
    super(x, y, w, h, frankensteinImg, frankensteinImg);
  }

  void checkPlayerCollision(Player player) {
    if (!isAlive) return;

    // 矩形衝突判定
    if (player.x + player.w > this.x && player.x < this.x + this.w &&
        player.y + player.h > this.y && player.y < this.y + this.h) {

      // 上から踏まれた場合（プレイヤーが上から落下している）
      if (player.vy > 0 && player.y + player.h - player.vy <= this.y) {
        isAlive = false;
        player.vy = -10; // 踏んだ反動で跳ねる
      } else {
        player.takeDamage(1); // 側面衝突などで1ダメージ
      }
    }
  }
}
