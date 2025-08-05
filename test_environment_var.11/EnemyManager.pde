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
    enemy1.add(new EnemyData(600, 240, "ookami", -1, 0, 12, 0));
    enemy1.add(new EnemyData(360, -50, "flymiira", -1, 0.5f, 7, 0));
    stageEnemyData.put(1, enemy1);
  }

  void setupEnemies(int stageNum) {
    enemyManager.clear();
    ArrayList<EnemyData> enemies = stageEnemyData.get(stageNum);
    if (enemies == null) return;

    for (EnemyData data : enemies) {
      if (data.type.equals("ookami")) {
        Hitbox ookamiHb = new Hitbox(data.x, data.y, 40, 40);
        enemyManager.add(new Ookami(ookamiHb, ookamiImg, ookamiImg2, player, collider, colHand, data.dir, data.hp, data.armor));
      }
      if (data.type.equals("flymiira")) {
        Hitbox flymiiraHb = new Hitbox(data.x, data.y, 30, 30);
        enemyManager.add(new Flymiira(flymiiraHb, f1, f2, player, collider, colHand, data.speed, data.hp, data.armor));
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
