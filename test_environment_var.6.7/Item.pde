abstract class Item {
  float x, y;
  int drawW = 20;
  int drawH = 20;
  PImage[] frames;
  int currentFrame = 0;
  int frameCounter = 0;
  int frameSpeed = 10;
  boolean collected = false;
  boolean isHoverable = false;
  float hoverOffset = 0;
  float hoverAngle = 0;
  float hoverSpeed = 0.1;
  float hoverRange = 5;
  Hitbox hitbox;

  Item(float x, float y, PImage[] frames, int drawW, int drawH) {
    this.x = x;
    this.y = y;
    this.frames = frames;
    this.drawW = drawW;
    this.drawH = drawH;
    this.hitbox = new Hitbox(x, y, 20, 20); // サイズは必要に応じて調整
  }

  void update() {
    if (collected) return;
    
    if (isHoverable) {
       hoverAngle += hoverSpeed;
       hoverOffset = sin(hoverAngle) * hoverRange;
    }
    frameCounter++;
    if (frameCounter >= frameSpeed) {
      frameCounter = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }

    // プレイヤーと接触したら取得処理
    if (checkCollisionWithPlayer()) {
      onCollect();
      collected = true;
    }
  }

  void display() {
    if (!collected) {
      image(frames[currentFrame], x, y + hoverOffset, drawW, drawH);
    }
  }

  abstract void onCollect(); // 各アイテムごとの取得時の挙動

  boolean checkCollisionWithPlayer() {
    return hitbox.intersects(player.hitbox);
  }

  boolean isCollected() {
    return collected;
  }
}
