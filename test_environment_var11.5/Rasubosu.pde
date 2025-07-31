// Rasubosu.java

import java.util.ArrayList;
import processing.core.PImage;

/**
 * Rasubosu は最終フェーズ到達後にのみ出現する空中浮遊型ボス。
 * プレイヤー方向に素早く移動しつつ、炎弾を吐いて攻撃する。
 * プレイヤーに当たると即死（respawn）。
 */
public class Rasubosu extends Enemy {
  // ── フィールド ──
  private int shootCooldown = 0;                         // 炎弾発射のクールダウン
  private ArrayList<FireballEffect> fireballs;           // 発射した炎弾のリスト
  private PImage fireImg1, fireImg2;                     // 炎のアニメーション用フレーム
  private Player target;                                 // 攻撃対象（プレイヤー）
  private CollisionChecker collider;
  private CollisionHandler colHand;
  private boolean active = false;                        // 最終フェーズ到達フラグ

  /**
   * @param hitbox     初期位置とサイズ
   * @param normalL    通常立ち絵（左向き）
   * @param normalR    通常立ち絵（右向き）
   * @param blinkL     瞬き絵（左向き）
   * @param blinkR     瞬き絵（右向き）
   * @param walkL      歩行（浮遊）フレーム（左向き配列）
   * @param walkR      歩行（浮遊）フレーム（右向き配列）
   * @param target     プレイヤーインスタンス
   * @param speed      浮遊移動速度
   * @param fireImg1   炎エフェクト１枚目
   * @param fireImg2   炎エフェクト２枚目
   * @param collider   衝突判定用 CollisionChecker
   * @param colHand    衝突処理用 CollisionHandler
   * @param hp         HP
   * @param armor      防御力
   */
  public Rasubosu(
    Hitbox hitbox,
    PImage normalL, PImage normalR,
    PImage blinkL,  PImage blinkR,
    PImage[] walkL, PImage[] walkR,
    Player target,
    float speed,
    PImage fireImg1, PImage fireImg2,
    CollisionChecker collider,
    CollisionHandler colHand,
    int hp, int armor
  ) {
    super(
      hitbox,
      normalL, normalR,
      blinkL,  blinkR,
      walkL,   walkR,
      target,
      speed,
      collider, colHand,
      hp, armor
    );
    this.fireballs = new ArrayList<>();
    this.fireImg1   = fireImg1;
    this.fireImg2   = fireImg2;
    this.target     = target;
    this.collider   = collider;
    this.colHand    = colHand;

    // 見た目調整
    this.drawW = 120;
    this.drawH = 120;
    this.animationSpeed = 6;
  }

  /** 最終フェーズに到達したら呼び出してボスを起動 **/
  public void activate() {
    this.active = true;
  }

  @Override
  public void update() {
    if (!active) return;  // 非アクティブ時は何もしない

    // ── 1) 移動ロジック：Player にできるだけ近づくようランダム＋追跡 ──
    float dx = target.hitbox.getX() - hitbox.getX();
    float dy = target.hitbox.getY() - hitbox.getY();
    float dist = sqrt(dx*dx + dy*dy);
    if (dist > 0) {
      float vx = speed * dx / dist;
      float vy = speed * dy / dist;
      hitbox.setVX(vx);
      hitbox.setVY(vy);
      faceLeft = (vx < 0);
    }
    // 浮遊なので gravity なし、直接 move
    hitbox.move();
    updateAnimation();  // Enemy 側のアニメ更新（walkLeft/RightFrames を利用）

    // ── 2) 炎弾発射ロジック ──
    if (shootCooldown <= 0) {
      // 攻撃情報を作成
      AttackInfo atkInfo = new AttackInfo(1, 0);

      // 発射位置（口元あたりに調整）
      float startX = hitbox.getX() + drawOffsetX + drawW/2;
      float startY = hitbox.getY() + drawOffsetY + drawH/3;

      // 単位ベクトル計算
      float fx = target.hitbox.getX() - startX;
      float fy = target.hitbox.getY() - startY;
      float fDist = sqrt(fx*fx + fy*fy);
      float fSpeed = 8f;
      float vx = fSpeed * fx / fDist;
      float vy = fSpeed * fy / fDist;

      // フレーム配列
      PImage[] fireFrames = new PImage[]{ fireImg1, fireImg2 };

      // インスタンス生成
      FireballEffect flame = new FireballEffect(
        startX, startY,
        vx, vy,
        fireFrames,
        enemyManager.getEnemies(),
        atkInfo
      );
      fireballs.add(flame);
      shootCooldown = 120;  // 2秒ごとに1発
    } else {
      shootCooldown--;
    }

    // ── 3) 既存炎弾の更新＆消去 ──
    for (int i = fireballs.size() - 1; i >= 0; i--) {
      FireballEffect f = fireballs.get(i);
      f.update();
      if (!f.isActive()) {
        fireballs.remove(i);
      }
    }

    // ── 4) 自身の当たり判定・ダメージ処理 ──
    super.checkDamage();
  }

  @Override
  public void display(float cameraOffsetX) {
    if (!active) return;  // 非アクティブ時は表示しない

    // ボス本体の描画
    super.display(cameraOffsetX);

    // 炎弾を描画
    pushMatrix();
      translate(-cameraOffsetX, 0);
      for (FireballEffect f : fireballs) {
        f.display();
      }
    popMatrix();
  }
}
