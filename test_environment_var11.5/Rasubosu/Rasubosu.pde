// Rasubosu.java

/**
 * Rasubosu は最終局面で出現する空中浮揚型ボス。
 * - 高速にプレイヤーへ近づきつつ、わずかなランダム揺らぎも加える
 * - 一定間隔で炎（FireballEffect）を吐く
 * - プレイヤーと炎に当たると即死
 */
class Rasubosu extends Enemy {
  // 炎吐き用クールダウン
  private float fireCooldown = 0;
  private static final float FIRE_INTERVAL = 120;  // フレーム間隔（例：2秒ごと）
  
  // 炎のアニメーションフレーム
  private PImage fireImg1, fireImg2;
  
  // ランダム揺らぎの強さ
  private float jitter = 1.5f;

  /**
   * @param hitbox    初期位置とサイズ
   * @param img1      浮遊アニメ 1 フレーム目
   * @param img2      浮遊アニメ 2 フレーム目
   * @param fireImg1  吐く炎アニメ 1 フレーム目
   * @param fireImg2  吐く炎アニメ 2 フレーム目
   * @param target    追跡対象の Player
   * @param collider  衝突判定用 CollisionChecker
   * @param colHand   衝突処理用 CollisionHandler
   * @param speed     浮遊速度（px/frame）
   * @param hp        HP（ダメージを受けたら死ぬまでの回数）
   * @param armor     防御値（不要なら 0）
   */
  Rasubosu(Hitbox hitbox,
           PImage img1, PImage img2,
           PImage fireImg1, PImage fireImg2,
           Player target,
           CollisionChecker collider,
           CollisionHandler colHand,
           float speed,
           int hp, int armor) {
    // 通常立ち絵・点滅絵は img1、浮遊フレームは img1→img2
    super(
      hitbox,
      img1, img1,               // normalLeft, normalRight
      img1, img1,               // blinkLeft, blinkRight
      new PImage[]{ img1, img2 }, // walkLeftFrames
      new PImage[]{ img1, img2 }, // walkRightFrames
      target,
      speed,
      collider, colHand,
      hp, armor
    );
    // 描画サイズをボス向けに拡大
    this.drawW = 120;
    this.drawH = 120;
    // アニメ速度
    this.animationSpeed = 6;
    // 炎アニメ
    this.fireImg1 = fireImg1;
    this.fireImg2 = fireImg2;
  }

  @Override
  void update() {
    if (!isAlive) return;

    // 1) プレイヤーへのベクトルを計算＋少しランダム揺らぎを追加
    float dx = target.hitbox.getX() - hitbox.getX();
    float dy = target.hitbox.getY() - hitbox.getY();
    float dist = sqrt(dx*dx + dy*dy);
    if (dist > 0.1f) {
      float vx = speed * (dx / dist) + random(-jitter, jitter);
      float vy = speed * (dy / dist) + random(-jitter, jitter);
      hitbox.setVX(vx);
      hitbox.setVY(vy);
      faceLeft = vx < 0;
    }

    // 2) 移動（重力は無視）
    hitbox.move();

    // 3) 浮遊アニメーション
    super.updateAnimation();

    // 4) 定期的に炎を吐く
    if (fireCooldown <= 0) {
      // 吐く炎のヒットボックスをボスの左右から生成
      float fx = hitbox.getX() + (faceLeft ? -20 : hitbox.getW() + 0);
      float fy = hitbox.getY() + hitbox.getH() / 2;
      Hitbox fireBox = new Hitbox(fx, fy, 20, 20);

      // FireballEffect はスケッチ側で管理している fireballs リストに追加する想定
      FireballEffect flame = new FireballEffect(
        fireBox,
        new PImage[]{ fireImg1, fireImg2 },
        target,
        collider, colHand,
        8f,   // 炎の速度
        1,    // HP（不要なら 0）
        0     // armor
      );
      // グローバルなエフェクト管理リストに追加
      // (スケッチの ArrayList<FireballEffect> fireballs を参照)
      fireballs.add(flame);

      fireCooldown = FIRE_INTERVAL;
    } else {
      fireCooldown--;
    }

    // 5) 直接接触判定（当たったら即死）
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();
    if (x1 < x2 + w2 && x1 + w1 > x2
     && y1 < y2 + h2 && y1 + h1 > y2) {
      isDamaged = true;
      target.takeDamage();
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
