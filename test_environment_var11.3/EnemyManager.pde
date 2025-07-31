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
    enemy1.add(new EnemyData(600, 240, "ookami", -1, 0, 3, 0));
    enemy1.add(new EnemyData(360, -50, "flymiira", -1, 0.5f, 3, 0));
    enemy1.add(new EnemyData(370, -50, "flymiira", -1, 0.5f, 3, 0));
      float groundY = height - 156;      // 地面の Y 座標
      float spawnY  = groundY - 48;      // Haguruma の高さ分だけ上に
    enemy1.add(new EnemyData(500, spawnY, "haguruma", -1, 0.5f, 5, 0)); 
    
    float frkY    = groundY - 64;  // Frankenstein の身長分だけ上
    enemy1.add(new EnemyData(380,frkY,"frankenstein",-1,0.01f,7,2));
    
  enemy1.add(new EnemyData(1700, spawnY,         "haguruma",     -1, 0.f,  5, 0));
  enemy1.add(new EnemyData(1400, frkY,         "frankenstein", -1, 0.01f, 7, 1));
  enemy1.add(new EnemyData(1600, groundY-40,  "flymiira",    -1, 0.7f,  3, 0));
  enemy1.add(new EnemyData(1800, groundY-36,  "ookami",       -1, 0.2f,     3, 1));
  enemy1.add(new EnemyData(2000, groundY-36,  "ookami",       -1, 0.2f,     3, 1));
    
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
        ookamiImg, ookamiImg2,
        player,
        collider, colHand,
        data.dir,
        data.hp, data.armor
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
