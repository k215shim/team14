class Enemy extends Character {
  boolean isAlive = true;
  PImage imgLeft, imgRight;

  Enemy(int x, int y, int w, int h, PImage imgLeft, PImage imgRight) {
    super(x, y, w, h, imgLeft, imgRight, null, null, null, null);
    this.imgLeft = imgLeft;
    this.imgRight = imgRight;
  }

  void update(int[][] map, int tileSize) {
    if (!isAlive) return;

    applyGravity();
    updatePosition();
    checkCollision(map, tileSize);
  }

  void display() {
    if (!isAlive) return;

    if (faceLeft) {
      image(imgLeft, x, y, w, h);
    } else {
      image(imgRight, x, y, w, h);
    }
  }

  void die() {
    isAlive = false;
  }
}
