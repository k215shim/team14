// Haguruma.java

/**
 * Haguruma（歯車）クラスは Enemy を継承し、
 * - 一方向に進み続ける
 * - 接触したらプレイヤーにダメージを与える
 * - 描画サイズは 48x48
 * - 画像2枚で回転アニメーションを実装
 */
class Haguruma extends Enemy {
  int dir;

  /**
   * @param hitbox   初期位置とサイズ（幅・高さともに48）
   * @param img1     歯車画像1（例: "haguruma0.png"）
   * @param img2     歯車画像2（例: "haguruma1.png"）
   * @param target   追跡対象の Player
   * @param collider 衝突判定用
   * @param colHand  衝突処理用
   * @param dir      移動方向（-1: 左, 1: 右）
   * @param hp       ヒットポイント
   * @param armor    アーマー値
   */
  Haguruma(Hitbox hitbox,
           PImage img1, PImage img2,
           Player target,
           CollisionChecker collider,
           CollisionHandler colHand,
           int dir,
           int hp, int armor) {
    super(
      hitbox,
      // 静止・瞬き用は同じ画像を左右両方に指定
      img1, img1,  
      img1, img1,  
      // 回転アニメーション用フレーム (左右同じ)
      new PImage[]{ img1, img2 }, 
      new PImage[]{ img1, img2 },
      target,
      0.5f,           // 移動速度
      collider, colHand,
      hp, armor       // HP とアーマーを追加
    );
    this.dir = dir;
    this.drawW = 60;
    this.drawH = 60;
        this.drawOffsetX = (hitbox.getW() - drawW) / 2;  

// 垂直方向は hitbox の底＝スプライトの底 になるように調整
// hitbox の高さは 40px、drawH は 80px なので 40 - 80 = -40
this.drawOffsetY = hitbox.getH() - drawH+20;
    this.animationSpeed = 6; // 回転（歩行）アニメ速度
  }

  @Override
  void update() {
    if (!isAlive) return;

    // ノックバック中はそのままＸ移動継続
    if (isKnockback) {
      knockbackTimer--;
      if (knockbackTimer <= 0) {
        isKnockback = false;
        hitbox.setVX(0);
      }
    } 
    else {
      // 指定方向へ移動
      hitbox.setVX(speed * dir);
      faceLeft = dir < 0;
    }

    // 重力適用・衝突判定・アニメ更新
    updatePosition();

    // プレイヤーとの当たり判定 (AABB)
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();

    if (x1 < x2 + w2 && x1 + w1 > x2 &&
        y1 < y2 + h2 && y1 + h1 > y2) {
      // 接触時の処理：ダメージ or リスポーン
      target.takeDamage();
      // もし respawn したいなら以下を代わりに呼ぶ:
      // target.respawn();
    }
  }
}
