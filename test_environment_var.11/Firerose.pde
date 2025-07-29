class FireRose extends Item {
  FireRose(float x, float y, PImage[] frames, int drawW, int drawH) {
    super(x, y, frames, drawW, drawH);
  }

  void onCollect() {
    player.gainFirePower();
  }
}
