class Coin extends Item {

  Coin(float x, float y, float w, float h, PImage img) {
    super(x, y, w, h, img);
  }

  @Override
  void onCollision(Player player) {
    if (!isActive) return;

    player.collectCoin();
    isActive = false;
  }
}
