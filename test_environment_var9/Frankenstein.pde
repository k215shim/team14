// Frankenstein.java

/**
 * Frankenstein クラスは Enemy を継承し、
 * - プレイヤーに向かって常に左右移動
 * - 接触時にダメージを与える
 * - 描画サイズは 64x64
 * - 左右アニメーション画像に対応
 */
class Frankenstein extends Enemy {
  /**
   * @param hitbox   初期位置とサイズ（幅・高さともに64）
   * @param walkLeftFrames  左向き歩行アニメ画像（配列）
   * @param walkRightFrames 右向き歩行アニメ画像（配列）
   * @param normalLeft 通常画像（左）
   * @param normalRight 通常画像（右）
   * @param target   プレイヤー
   * @param collider 衝突判定
   * @param colHand  衝突処理
   */
  Frankenstein(Hitbox hitbox,
               PImage normalLeft, PImage normalRight,
               PImage blinkLeft, PImage blinkRight,
               PImage[] walkLeftFrames, PImage[] walkRightFrames,
               Player target,
               CollisionChecker collider,
               CollisionHandler colHand) {
    super(
      hitbox,
      normalLeft, normalRight,
      blinkLeft, blinkRight,
      walkLeftFrames, walkRightFrames,
      target,
      0.6f, // ゆっくり目に追跡
      collider, colHand
    );

    this.drawW = 80;
    this.drawH = 80;
    this.animationSpeed = 6;
  }

  void update() {
    // プレイヤーに向かって左右移動
    float tx = target.hitbox.getX();
    float x  = hitbox.getX();

    if (Math.abs(tx - x) > 1) {
      move(tx < x ? -1 : 1);
    } else {
      stop();
    }

    updatePosition(); // 重力＋移動＋アニメーション更新

    // プレイヤーとの衝突判定（AABB）
    float x1 = hitbox.getX(), y1 = hitbox.getY();
    float w1 = hitbox.getW(), h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();

    boolean isCollision =
      x1 < x2 + w2 && x1 + w1 > x2 &&
      y1 < y2 + h2 && y1 + h1 > y2;

    if (isCollision) {
      target.takeDamage();
    }
  }
    void move(int dir) {
    hitbox.setVX(dir*speed);
    faceLeft = dir == -1;
  }
}
