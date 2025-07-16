abstract class Item {
  float x, y;
  float w, h;
  PImage img;
  boolean isActive = true;

  Item(float x, float y, float w, float h, PImage img) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
  }

  // 描画
  void display() {
    if (!isActive) return;
    image(img, x, y, w, h);
  }

  // プレイヤーとの当たり判定（衝突時に個別に効果を発揮）
  void checkPlayerCollision(Player player) {
    if (!isActive) return;

    if (player.x + player.w > x && player.x < x + w &&
        player.y + player.h > y && player.y < y + h) {
      onCollision(player);
    }
  }

  // 衝突時の個別挙動（継承クラスでオーバーライド）
  abstract void onCollision(Player player);
}
