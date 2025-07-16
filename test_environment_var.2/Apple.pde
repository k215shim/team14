class Apple extends Item {

  Apple(float x, float y, float w, float h, PImage img) {
    super(x, y, w, h, img);
  }

  @Override
  void onCollision(Player player) {
    if (!isActive) return;

    // プレイヤーを成長させる
    player.grow();  // ※Playerクラスにgrow()を追加する必要あり

    // このアイテムを無効化（非表示＋再判定不可）
    isActive = false;
  }
}
