class ManaOrb extends Item {
  
  ManaOrb(float x, float y, PImage[] frames, int drawW, int drawH) {
    super(x, y, frames, drawW, drawH);
    this.hitbox = new Hitbox(x, y, 15, 15);
    this.isHoverable = true;
  }

  void onCollect() {
    player.manaCount++;
    if (player.manaCount % 20 == 0) {
      if (player.shieldCount >= 5){
        player.shieldCount = 5;
        return;
      }
      player.shieldCount++;
    }// 耐性を1回分追加
    if (player.manaCount >= 100) player.manaCount = 0;
  }
}
