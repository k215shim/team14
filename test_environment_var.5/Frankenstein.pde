class Frankenstein extends Enemy {

  Frankenstein(int x, int y, int w, int h, PImage frankensteinImg) {
    super(x, y, w, h, frankensteinImg, frankensteinImg);
  }


int direction = 1;
float speed = 2.5;

  void move(int dir) {
    vx = speed * dir;
    faceLeft = dir < 0;
  }
  void checkPlayerCollision(Player player) {
    if (!isAlive) return;

    // 矩形衝突判定
    int margin = 10; 
    if (player.x + player.w - margin > this.x + margin &&
    player.x + margin < this.x + this.w - margin &&
    player.y + player.h - margin > this.y + margin &&
    player.y + margin < this.y + this.h - margin) {
      player.respawn();  // die() はプレイヤークラスに追加が必要
      // 上から踏まれた場合（プレイヤーが上から落下している）
      if (player.vy > 0 && player.y + player.h - player.vy <= this.y) {
        isAlive = false;
        player.vy = -10; // 踏んだ反動で跳ねる
      }
      
    }
  }
}
