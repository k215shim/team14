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
   * @param hitbox         初期位置とサイズ（幅・高さともに64）
   * @param normalLeft     通常画像（左）
   * @param normalRight    通常画像（右）
   * @param blinkLeft      瞬き画像（左）
   * @param blinkRight     瞬き画像（右）
   * @param walkLeftFrames 左向き歩行アニメ画像（配列）
   * @param walkRightFrames右向き歩行アニメ画像（配列）
   * @param target         プレイヤー
   * @param collider       衝突判定
   * @param colHand        衝突処理
   * @param hp             ヒットポイント
   * @param armor          アーマー値
   */
  Frankenstein(Hitbox hitbox,
               PImage normalLeft, PImage normalRight,
               PImage blinkLeft,  PImage blinkRight,
               PImage[] walkLeftFrames, PImage[] walkRightFrames,
               Player target,
               CollisionChecker collider,
               CollisionHandler colHand,
               int hp, int armor) {
    super(
      hitbox,
      normalLeft, normalRight,
      blinkLeft,  blinkRight,
      walkLeftFrames, walkRightFrames,
      target,
      0.6f,        // ゆっくり目の追跡速度
      collider, colHand,
      hp, armor    // HP とアーマーを渡す
    );
    this.drawW = 64;
    this.drawH = 64;
    this.animationSpeed = 6;
  }

  @Override
  void update() {
    if (!isAlive) return;

    // ノックバック処理
    if (isKnockback) {
      knockbackTimer--;
      if (knockbackTimer <= 0) {
        isKnockback = false;
        hitbox.setVX(0);
      }
    } 
    else {
      // プレイヤーに向かって移動
      float tx = target.hitbox.getX();
      float x  = hitbox.getX();
      if (Math.abs(tx - x) > 1) {
        move(tx < x ? -1 : 1);
      } else {
        stop();
      }
    }

    // 重力適用・衝突判定・アニメーション更新
    updatePosition();

    // プレイヤーとの当たり判定（AABB）
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();

    if (x1 < x2 + w2 && x1 + w1 > x2
     && y1 < y2 + h2 && y1 + h1 > y2) {
      // 接触時はプレイヤーにダメージ
      target.takeDamage();
    }
  }

  @Override
  void move(int dir) {
    hitbox.setVX(speed * dir);
    faceLeft = dir < 0;
  }
}
