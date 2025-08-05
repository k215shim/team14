/**
 * Rasubosu (ラスボス) は、空中を自由に飛び回りながら不規則にプレイヤーを追跡する強力なボス敵です。
 * rasubosu.png を使った単一フレーム表示で、速度・HP・アーマーを Enemy より強化しています。
 */
class Rasubosu extends Enemy {
  PImage rasubosuImg;

  /**
   * @param hitbox   初期位置とサイズ
   * @param rasubosuImg  ボス画像 (rasubosu.png)
   * @param target   追跡対象の Player
   * @param collider 衝突判定用 CollisionChecker
   * @param colHand  衝突処理用 CollisionHandler
   * @param speed    飛行速度
   * @param hp       ヒットポイント
   * @param armor    アーマー値
   */
  Rasubosu(
    Hitbox hitbox,
    PImage rasubosuImg,
    Player target,
    CollisionChecker collider,
    CollisionHandler colHand,
    float speed,
    int hp,
    int armor
  ) {
    super(
      hitbox,
      rasubosuImg, rasubosuImg,
      rasubosuImg, rasubosuImg,
      new PImage[]{ rasubosuImg },
      new PImage[]{ rasubosuImg },
      target,
      speed,
      collider, colHand,
      hp, armor
    );
    this.rasubosuImg = rasubosuImg;
    this.drawW = 120;
    this.drawH = 120;
    this.animationSpeed = 6;
  }

  /**
   * 毎フレーム呼び出され、ランダムオフセット付きでプレイヤーを追跡し続けます。
   * 重力は無視し、常に空中を漂うように動きます。
   */
  @Override
  void update() {
    if (!isAlive) return;

    // (1) プレイヤーへのベクトルにランダムノイズを加える
    float dx = target.hitbox.getX() - hitbox.getX() + random(-1, 1);
    float dy = target.hitbox.getY() - hitbox.getY() + random(-1, 1);
    float dist = sqrt(dx*dx + dy*dy);
    if (dist > 0) {
      hitbox.setVX(speed * dx / dist);
      hitbox.setVY(speed * dy / dist);
      faceLeft = (dx < 0);
    }

    // (2) 移動 (重力適用なし)
    hitbox.move();

    // (3) プレイヤーとの当たり判定 (即死)
    float x1 = hitbox.getX(),      y1 = hitbox.getY();
    float w1 = hitbox.getW(),      h1 = hitbox.getH();
    float x2 = target.hitbox.getX(), y2 = target.hitbox.getY();
    float w2 = target.hitbox.getW(), h2 = target.hitbox.getH();
    if (x1 < x2 + w2 && x1 + w1 > x2
     && y1 < y2 + h2 && y1 + h1 > y2) {
      target.respawn();
    }
  }

  /**
   * 描画時はカメラオフセットを考慮し、rasubosu.png を表示します。
   */
  @Override
  void display(float cameraOffsetX) {
    pushMatrix();
    translate(-cameraOffsetX, 0);
    image(
      rasubosuImg,
      hitbox.getX() + drawOffsetX,
      hitbox.getY() + drawOffsetY,
      drawW,
      drawH
    );
    popMatrix();
  }
}
