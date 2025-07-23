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
         PImage img,
         PImage img2,
         Player target,
         CollisionChecker collider,
         CollisionHandler colHand,
         int dir) {
    // super:
    // normalImgLeft, normalImgRight, blinkImgLeft, blinkImgRight はすべて同じ画像
    // walkLeftFrames, walkRightFrames を長さ 1 の配列で指定
    // 速度は 0.5f で「ゆっくり」
    super(
      hitbox,
      img, img,
      img, img,
      new PImage[]{ img,img2 },    // 歩行フレーム：単一画像
      new PImage[]{ img,img2 },
      target,
      0.8f,                   // 移動速度（ゆっくり）
      collider, colHand,
      1
    );
    
   this.dir = dir;
    // 描画サイズを 40x40 にオーバーライド
    this.drawW = 60;
    this.drawH = 60;
    
    this.animationSpeed = 10;  

  }


void update() {
  if(!isAlive) return;//倒されたら何もしない
  
  // ── 毎フレーム、同じ方向にだけ進む ──
    hitbox.setVX(speed * dir);
    faceLeft = dir < 0;

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
    @Override
  void display(float cameraOffsetX) {
    // 🔴 死んだら描画しない
    if (!isAlive) return;

    // 親の描画ロジックをそのまま利用
    super.display(cameraOffsetX);
  }
 }
