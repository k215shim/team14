class EnemyData {
  float x, y;
  String type;
  int dir;
  float speed;
  int hp;
  int armor;
  

  EnemyData(float x, float y, String type, int dir, float speed, int hp, int armor) {
    this.x = x;
    this.y = y;
    this.type = type; // "ookami" などの名前
    this.dir = dir;   // 移動方向（-1:左、1:右）
    this.speed = speed;
    this.hp = hp;
    this.armor = armor;
  }
}
