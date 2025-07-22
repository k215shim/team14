// Flymiira.java

/**
 * Flymiira は空中を飛び回りながら Player に向かって近づいてくる敵。
 * 当たると Player を即死（respawn）させる。
 * 画像は ookami 同様２フレームで足（羽）を羽ばたかせるイメージ。
 */
class Flymiira extends Enemy {
  float speed;   // 飛行速度（px/frame）

  /**
   * @param hitbox   初期位置とサイズ
   * @param img1     １フレーム目の PImage
   * @param img2     ２フレーム目の PImage
   * @param target   追跡対象の Player
   * @param collider 衝突判定用 CollisionChecker （地面判定は無視しても OK）
   * @param colHand  衝突処理用 CollisionHandler
   * @param speed    飛行速度
   */
  Flymiira(
    Hitbox hitbox,
    PImage img1, PImage img2,
    Player target,
    CollisionChecker collider,
    CollisionHandler colHand,
    float speed
  ) {
    // super の第７・８引数に歩行(飛行)フレームを渡す
    super(
      hitbox,
      img1, img1,               // 通常立ち絵は img1
      img1, img1,               // 瞬き絵も img1
      new PImage[]{ img1, img2 },  // 左向き・羽ばたきフレーム
      new PImage[]{ img1, img2 },  // 右向き・羽ばたきフレーム
      target,
      speed,
      collider, colHand
    );
    this.speed = speed;
    // 大きさやアニメ速度はお好みで
    this.drawW = 40;
    this.drawH = 40;
    this.animationSpeed = 8;  // フレーム切替の速さ調整
  }

  @Override
  void update() {
    // 1) プレイヤーへの方向ベクトルを計算
    float dx = target.hitbox.getX() - hitbox.getX();
    float dy = target.hitbox.getY() - hitbox.getY();
    float dist = sqrt(dx*dx + dy*dy);
    if (dist > 0) {
      hitbox.setVX(speed * dx / dist);
      hitbox.setVY(speed * dy / dist);
      faceLeft = (dx < 0);
    }

    // 2) 移動（Gravity は無視）
    hitbox.move();

    // 3) フレームアニメーション
    if (dist > 1) {
      frameCounter++;
      if (frameCounter % animationSpeed == 0) {
        currentFrame = (currentFrame + 1) % walkLeftFrames.length;
      }
    } else {
      currentFrame = 0;
    }

    // 4) プレイヤーとの当たり判定で即死
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();
    if (x1 < x2 + w2 && x1 + w1 > x2
     && y1 < y2 + h2 && y1 + h1 > y2) {
      target.respawn();
    }
  }

  @Override
  void display(float cameraOffsetX) {
    float drawX = hitbox.getX() + drawOffsetX;
    float drawY = hitbox.getY() + drawOffsetY;

    pushMatrix();
    translate(-cameraOffsetX, 0);
    PImage img = faceLeft
      ? walkLeftFrames[currentFrame]
      : walkRightFrames[currentFrame];
    image(img, drawX, drawY, drawW, drawH);
    popMatrix();
  }
}
