class Enemy extends Character {
  Player target;    // 追跡対象
  float speed;      // 移動速度

  Enemy(
    Hitbox hitbox,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft,  PImage blinkImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames,
    Player target, float speed,
    CollisionChecker collider, CollisionHandler colHand
  ) {
    super(hitbox,
      normalImgLeft, normalImgRight,
      blinkImgLeft,  blinkImgRight,
      walkLeftFrames, walkRightFrames
    );
    this.target   = target;
    this.speed    = speed;
    this.collider = collider;
    this.colHand  = colHand;
  }

  /** 毎フレーム呼ぶ */
  void update() {
    // 1) プレイヤーのX位置に向かって移動
    float tx = target.hitbox.getX();
    float x  = hitbox.getX();
    if (Math.abs(tx - x) > 1) {  // ある程度近づいたら止める
      move(tx < x ? -1 : 1);
    } else {
      stop();
    }

    // 2) 重力適用・衝突判定・アニメ更新
    updatePosition();

    // 3) プレイヤーとの当たり判定（AABB）
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();
    if (x1 < x2 + w2 && x1 + w1 > x2
     && y1 < y2 + h2 && y1 + h1 > y2) {
      // 衝突したらプレイヤーをリスポーン（即死処理）
      target.respawn();
    }
  }

  /** カメラオフセットを考慮して描画 */
  void display(float cameraOffsetX) {
    float drawX = hitbox.getX() + drawOffsetX;
    float drawY = hitbox.getY() + drawOffsetY;

    pushMatrix();
    translate(-cameraOffsetX, 0);

    PImage img;
    if (hitbox.getVX() != 0) {
      PImage[] frames = faceLeft ? walkLeftFrames : walkRightFrames;
      img = frames[currentFrame];
    } else {
      img = faceLeft ? normalImgLeft : normalImgRight;
    }

    image(img, drawX, drawY, drawW, drawH);
    popMatrix();
  }
}
