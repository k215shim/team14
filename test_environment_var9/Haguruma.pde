// Haguruma.java

/**
 * Haguruma（歯車）クラスは Enemy を継承し、
 * - プレイヤーに向かって近づき続ける
 * - 接触したらプレイヤーにダメージを与える
 * - 描画サイズは 48x48
 * - 画像2枚で回転アニメーションを実装
 */

class Haguruma extends Enemy {
  /**
   * @param hitbox   初期位置とサイズ（幅・高さともに48）
   * @param img1     歯車画像1（例えば「haguruma0.png」）
   * @param img2     歯車画像2（例えば「haguruma1.png」）
   * @param target   追跡対象の Player
   * @param collider 衝突判定用
   * @param colHand  衝突処理用
   */
 int dir;
  Haguruma(Hitbox hitbox,
           PImage img1, PImage img2,
           Player target,
           CollisionChecker collider,
           CollisionHandler colHand,
           int dir) {
    super(
      hitbox,
      img1, img1,  // 左右共通画像（静止時）
      img1, img1,  // 瞬きなし
      new PImage[]{img1, img2}, new PImage[]{img1, img2}, // 歩行アニメ2枚
      target,
      0.5f,  // スピードやや速め
      collider, colHand
    );
    this.dir = dir;
    this.drawW = 48;
    this.drawH = 48;
    this.animationSpeed = 6; // 回転速度に相当
  }

void update() {
  // 一方通行に移動（dir: -1なら左へ、1なら右へ）
  hitbox.setVX(speed * dir);
  faceLeft = dir < 0;

  // 重力適用・衝突判定・アニメーション更新
  updatePosition();

  // プレイヤーとの当たり判定（AABB方式）
  float x1 = hitbox.getX();
  float y1 = hitbox.getY();
  float w1 = hitbox.getW();
  float h1 = hitbox.getH();

  float x2 = target.hitbox.getX();
  float y2 = target.hitbox.getY();
  float w2 = target.hitbox.getW();
  float h2 = target.hitbox.getH();

  boolean isCollision =
    x1 < x2 + w2 && x1 + w1 > x2 &&
    y1 < y2 + h2 && y1 + h1 > y2;

  if (isCollision) {
    target.takeDamage();
  }
}
}
