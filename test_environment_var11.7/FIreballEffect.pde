class FireballEffect {
  PImage[] frames;
  int currentFrame = 0;
  int frameCounter = 0;
  int frameSpeed = 10;

  float x, y;
  float vx, vy;
  float gravity = 1;
  int bounceCount = 0;
  int maxBounces = 3;
  boolean active = true;
  int graceFrame = 3;
  int frameSinceSpawn = 0;
  
  int attackPower = 3;
  
  Hitbox fireHB;
  Enemy enemy;
  ArrayList<Enemy> enemies;
  ArrayList<Enemy> hitEnemies = new ArrayList<Enemy>();
  AttackInfo atkInfo;

  FireballEffect(float x, float y, float vx, float vy, PImage[] frames, ArrayList enemies, AttackInfo atkInfo) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.frames = frames;
    this.enemies = enemies;
    this.atkInfo = atkInfo;
    fireHB = new Hitbox(x, y, 30, 25);
  }

  void update() {
    if (!active) return;

    // 移動
    x += vx;
    y += vy;
    
    fireHB.x = x;
    fireHB.y = y;

    // 重力適用
    vy += gravity;

    //衝突処理
    if (frameSinceSpawn > graceFrame) {
       fireHB.setVX(vx);
       if (collisionHandler.willCollideX(fireHB)) {
         active = false;
         return;
      }
    }
    fireHB.setVY(vy);
    if (collisionHandler.willCollideY(fireHB)) {
      vy *= -0.7;
      bounceCount++;
      if (bounceCount > maxBounces) {
        active = false;
      }
    }
    for (Enemy enemy : enemies) {
      if (enemy.isAlive && fireHB.intersects(enemy.hitbox)) {
        enemy.takeDamage(atkInfo);
        active = false;
        break;
      }
    }
    frameSinceSpawn++;
    
    // アニメーション更新
    frameCounter++;
    if (frameCounter >= frameSpeed) {
      frameCounter = 0;
      currentFrame = (currentFrame + 1) % frames.length;
    }
  }

  void display() {
    if (active) {
      image(frames[currentFrame], x, y);
    }
  }

  boolean isActive() {
    return active;
  }
}
