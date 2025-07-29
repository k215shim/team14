class Enemy extends Character {
  Player target;    // 追跡対象
  float speed;      // 移動速度
  float startX,startY;
  boolean isAlive = true;
  int hp = 3;
  int armor = 1;
  boolean isKnockback = false;
  int knockbackTimer = 0;
  final int MaxKnockbackFrames = 15;
  AttackInfo atk;
  
  
  Enemy(
    Hitbox hitbox,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft,  PImage blinkImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames,
    Player target, float speed,
    CollisionChecker collider, CollisionHandler colHand,
    int hp, int armor
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
    this.hp = hp;
    this.armor = armor;
  }

  /** 毎フレーム呼ぶ */
  void update() {
    
    if (!isAlive) return;
    
    if (isKnockback) {
      println(hitbox.getVX());
      knockbackTimer--;
      if (knockbackTimer <= 0) {
        isKnockback = false;
        hitbox.setVX(0);
      }
    }
    else {
      // 1) プレイヤーのX位置に向かって移動
      float tx = target.hitbox.getX();
      float x  = hitbox.getX();
      if (Math.abs(tx - x) > 1) {  // ある程度近づいたら止める
        move(tx < x ? -1 : 1);
      } else {
        stop();
      }
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
  
  @Override
  void updatePosition() {
    hitbox.applyGravity(gravity);
    hitbox.move();
  
    if (!isKnockback) {
      colHand.checkX(hitbox, this);
    }

    colHand.checkY(hitbox, this);
    updateAnimation();
}
  
  void takeDamage(AttackInfo atk) {
    int actualDamage = atk.ignoreArmor ? atk.damage : max(0, atk.damage - armor);
    hp -= actualDamage;
    
    if (atk.knockbackX != 0 || atk.knockbackY != 0) {
      println(hp);
      float dirX = (target.hitbox.getX() < hitbox.getX()) ? 1 : -1;
      hitbox.setVX(atk.knockbackX * dirX);
      hitbox.setVY(atk.knockbackY);
      isKnockback = true;
      knockbackTimer = MaxKnockbackFrames;
      println("knockX = " + atk.knockbackX * dirX);
    }
    if (hp <= 0) {
      isAlive = false;
    }
  }
}
