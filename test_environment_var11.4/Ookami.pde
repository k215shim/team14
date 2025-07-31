// Ookami.java

/** 
 * Ookami は Enemy を継承し、
 * - Player にゆっくり向かって歩き、
 * - 当たると Player を即死（respawn）させる
 * - 描画サイズを 40x40 に設定
 * - 画像は ookami.png １枚のみを使う
 */
class Ookami extends Enemy {
  int dir;
  /**
   * @param hitbox   初期位置とサイズ (幅・高さとも 40)
   * @param img      loadImage("ookami.png") で読み込んだ PImage
   * @param target   追跡対象の Player インスタンス
   * @param collider 衝突判定用 CollisionChecker
   * @param colHand  衝突処理用 CollisionHandler
   */
  Ookami(Hitbox hitbox,
         PImage normalL,PImage blinkL,
         PImage normalR,PImage blinkR,
         Player target,
         CollisionChecker collider,
         CollisionHandler colHand,
         int dir, int hp, int armor) {
    // super:
    // normalImgLeft, normalImgRight, blinkImgLeft, blinkImgRight はすべて同じ画像
    // walkLeftFrames, walkRightFrames を長さ 1 の配列で指定
    // 速度は 0.5f で「ゆっくり」
    super(
      hitbox,
      normalL, normalR,
      blinkL, blinkR,
      new PImage[]{ normalL,blinkL },    // 歩行フレーム：単一画像
      new PImage[]{ normalR,blinkR },
      target,
      0.8f,                   // 移動速度（ゆっくり）
      collider, colHand,
      hp, armor
    );
    
   this.dir = dir;
    // 描画サイズを 40x40 にオーバーライド
    this.drawW = 60;
    this.drawH = 60;
    
    this.animationSpeed = 10;  

  }


void update() {
    // ── 毎フレーム、同じ方向にだけ進む ──
    if (!isAlive) return;
    // ── 前方に足場がなければ方向転換 ──
  {
    // Hitbox の前端座標を計算
    float frontX = hitbox.getX() + (dir > 0 ? hitbox.getW() : 0);
    // Hitbox の足下少し下を調べる
    float footY  = hitbox.getY() + hitbox.getH() + 1;
    // タイル座標に変換
    int tileX = (int)floor(frontX / tileSize);
    int tileY = (int)floor(footY  / tileSize);
    // collisionChecker に足場判定用のメソッドがあれば使う
    boolean hasGround = collider.isTileSolidMap(tileX, tileY)|| collider.isTileSolidObj(tileX, tileY);
    // もし無ければ向きを反転
    if (!hasGround) {
      dir *= -1;
    }
  }
  
   // ── 前方・後方に壁があれば方向転換 ──
  {
    float y    = hitbox.getY();
    int w    = hitbox.getW();
    int h    = hitbox.getH();
    // 今向いている方向（前方）にほんの少し移動
    float frontX = hitbox.getX() + dir * 1;
    // 逆向き（後方）にもほんの少し移動
    float backX  = hitbox.getX() - dir * 1;

    boolean frontHit = collider.isWallCollision(frontX, y, w, h);
    boolean backHit  = collider.isWallCollision(backX,  y, w, h);

    if (frontHit || backHit) {
      dir *= -1;
    }
  }


  // ── ダメージ中のノックバック処理 ──
    
    
    if (isKnockback) {
      knockbackTimer--;
      if (knockbackTimer <= 0) {
        isKnockback = false;
        hitbox.setVX(0);
      }
    }
    else {
      hitbox.setVX(speed * dir * 0.5f);
      faceLeft = dir < 0;
    }

    // 重力適用／衝突判定／アニメーション更新
    updatePosition();

    // プレイヤーとの当たり判定（AABB）
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();
    if (x1 < x2 + w2 && x1 + w1 > x2
     && y1 < y2 + h2 && y1 + h1 > y2) {
      // 接触したら即死（respawn）
      isDamaged = true;
      target.takeDamage();
    }
   }
 
 }
 
