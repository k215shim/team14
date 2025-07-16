class PoisonApple extends Item {

  PoisonApple(float x, float y, float w, float h, PImage img) {
    super(x, y, w, h, img);
  }

  @Override
  void onCollision(Player player) {
    if (!isActive) return;

    // 即死効果を発動
    player.die();

    // このアイテムは無効化
    isActive = false;
  }
}
