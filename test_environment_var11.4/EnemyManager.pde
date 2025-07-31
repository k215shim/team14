class EnemyManager {
  HashMap<Integer, ArrayList<EnemyData>> stageEnemyData = new HashMap<>();
  ArrayList<Enemy> enemies;
  CollisionChecker collider;
  CollisionHandler colHand;
  Player player;
  Hitbox hb;


  EnemyManager(CollisionChecker collider, CollisionHandler colHand, Player player){
    this.collider = collider;
    this.colHand = colHand;
    this.player = player;
    enemies = new ArrayList<Enemy>();
    stageEnemyData = new HashMap<Integer, ArrayList<EnemyData>>();
    
  }
  
  void registerEnemy() {
    ArrayList<EnemyData> enemy1 = new ArrayList<EnemyData>();
 // 底面（地面）の Y 座標
  float groundY = height - 156;
  // Haguruma 用に地面から 48px 上
  float hagurumaY = groundY - 48;
  // Frankenstein 用に地面から 64px 上
  float frkY      = groundY - 64;

  // ── 序盤：弱めのフライミーラ ×2 ──
   enemy1.add(new EnemyData(
    400, hagurumaY,
    "ookami",
    -1, 0.4f,
    3, 1));

  enemy1.add(new EnemyData(
    550, groundY - 36,
    "flymiira",
    1, 0.5f,
    2, 0));

  // ── 序盤：カラクリ車 ×1 ──
  enemy1.add(new EnemyData(
    600, hagurumaY,
    "haguruma",
    -1, 0.2f,
    4, 0));

  // ── 中盤：オオカミ（巡回） ×2 ──
  enemy1.add(new EnemyData(
    800, hagurumaY,
    "ookami",
    -1, 0.4f,
    3, 1));

  enemy1.add(new EnemyData(
    1000, hagurumaY,
    "ookami",
    -1, 0.4f,
    3, 1));

  // ── 中盤：フランケンシュタイン（遅いが固い） ×1 ──
  enemy1.add(new EnemyData(
    1200, frkY,
    "frankenstein",
    -1, 0.08f,
    6, 2));

  // ── 終盤：カラクリ車＋フライミーラの混成編隊 ──
  enemy1.add(new EnemyData( 1400, hagurumaY,   "haguruma",      1, 0.0f,  5, 0));
  enemy1.add(new EnemyData( 1550, groundY-36,  "flymiira",     -1, 0.7f,  3, 0));
  enemy1.add(new EnemyData( 1700, hagurumaY,   "haguruma",     -1, 0.2f,  5, 1));
  enemy1.add(new EnemyData( 1850, frkY,        "frankenstein",  -1, 0.2f,  7, 2));
  enemy1.add(new EnemyData( 2000, groundY-36, "ookami",       -1, 0.5f,  4, 1));

  // ── ゴール直前：ラスト警戒編隊 ──
  enemy1.add(new EnemyData( 2200, hagurumaY,   "haguruma",      1, 0.0f,  6, 1));
  enemy1.add(new EnemyData( 2350, frkY,        "frankenstein", -1, 0.12f, 8, 2));
  enemy1.add(new EnemyData( 2500, groundY-36, "flymiira",      1, 0.8f,  4, 0));
  enemy1.add(new EnemyData( 2650, groundY-36, "ookami",        1, 0.6f,  5, 1));
  
  enemy1.add(new EnemyData(2300, groundY-36, "ookami",       -1, 0.5f, 4, 1));
  enemy1.add(new EnemyData(2500, groundY-36, "ookami",        1, 0.5f, 4, 1));
  enemy1.add(new EnemyData(2900, groundY-36, "ookami",       -1, 0.5f, 4, 1));

  // 終わり際にフライミーラも追加
  enemy1.add(new EnemyData(2750, groundY-36, "flymiira",     -1, 0.7f, 3, 0));
  enemy1.add(new EnemyData(2900, groundY-36, "flymiira",      1, 0.7f, 3, 0));

  stageEnemyData.put(1, enemy1);
      
  }

 void setupEnemies(int stageNum) {
  // 自分自身のクリアメソッドを呼ぶ
  clear();

  ArrayList<EnemyData> list = stageEnemyData.get(stageNum);
  if (list == null) return;

  for (EnemyData data : list) {
    // Ookami
    if (data.type.equals("ookami")) {
      Hitbox hb = new Hitbox(data.x, data.y, 40, 40);
     add(new Ookami(
  hb,
  ookamiImgL,   ookamiBlinkL,
  ookamiImgR,   ookamiBlinkR,
  player,
  collider,     colHand,
  data.dir,
  data.hp,      data.armor
));
    }
    // Flymiira
    else if (data.type.equals("flymiira")) {
      Hitbox hb = new Hitbox(data.x, data.y, 30, 30);
      add(new Flymiira(
        hb,
        f1, f2,
        player,
        collider, colHand,
        data.speed,
        data.hp, data.armor
      ));
    }
    // Haguruma
    else if (data.type.equals("haguruma")) {
      Hitbox hb = new Hitbox(data.x, data.y, 48, 48);
      add(new Haguruma(
        hb,
        hagurumaImg0, hagurumaImg1,
        player,
        collider, colHand,
        data.dir,
        data.hp, data.armor
      ));
    }
    // Frankenstein
    else if (data.type.equals("frankenstein")) {
      Hitbox hb = new Hitbox(data.x, data.y, 64, 64);
      add(new Frankenstein(
        hb,
        frankensteinNormalLeft,   frankensteinNormalRight,
        frankensteinBlinkLeft,  frankensteinBlinkRight,
        frankensteinWalkLeft,   frankensteinWalkRight,
        player,
        collider, colHand,
        data.hp, data.armor
      ));
    }
  }
}

  
  void startStage(int stageNum) {
    currentStage = stageNum;
    setupEnemies(currentStage);
    player.resetPosition();
  }
  
   void add(Enemy enemy) {
    enemies.add(enemy);
  }

  void update() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      if (!e.isAlive) {
        enemies.remove(i);
      }
      else {
        e.update();
      }
    }
  }

  void display(float cameraOffsetX) {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      if (!e.isAlive) {
        enemies.remove(i);
      }
      else {
        e.display(cameraOffsetX);
      }
    }
  }
  
  void clear() {
    enemies.clear();
  }
  
  ArrayList<Enemy> getEnemies() {
    return enemies;
  }
}
