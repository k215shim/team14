// Ookami.java

/** 
 * Ookami は Enemy を継承し、
 * - Player にゆっくり向かって歩き、
 * - 当たると Player を即死（respawn）させる
 * - 描画サイズを 40x40 に設定
 * - 画像は ookami.png １枚のみを使う
 */
class Ookami extends Enemy {
  
  /**
   * @param hitbox   初期位置とサイズ (幅・高さとも 40)
   * @param img      loadImage("ookami.png") で読み込んだ PImage
   * @param target   追跡対象の Player インスタンス
   * @param collider 衝突判定用 CollisionChecker
   * @param colHand  衝突処理用 CollisionHandler
   */
  Ookami(Hitbox hitbox,
         PImage img,
         Player target,
         CollisionChecker collider,
         CollisionHandler colHand) {
    // super:
    // normalImgLeft, normalImgRight, blinkImgLeft, blinkImgRight はすべて同じ画像
    // walkLeftFrames, walkRightFrames を長さ 1 の配列で指定
    // 速度は 0.5f で「ゆっくり」
    super(
      hitbox,
      img, img,
      img, img,
      new PImage[]{ img },    // 歩行フレーム：単一画像
      new PImage[]{ img },
      target,
      0.5f,                   // 移動速度（ゆっくり）
      collider, colHand
    );
    
    // 描画サイズを 40x40 にオーバーライド
    this.drawW = 40;
    this.drawH = 40;
  }
}
