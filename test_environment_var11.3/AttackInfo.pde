class AttackInfo {
  int damage;
  String type; // 例: "fire", "ice", "physical", "holy" など
  boolean ignoreArmor;
  boolean pierce;
  int maxHits;
  float knockbackX;
  float knockbackY;
  // 必要なら状態異常やノックバックも追加
  // boolean causesBurn;
  // float knockbackX, knockbackY;

  AttackInfo(int damage, String type) {
    this.damage = damage;
    this.type = type;
    this.ignoreArmor = false;
    this.pierce = false;
    this.maxHits = 1;
    this.knockbackX = 0;
    this.knockbackY = 0;
  }

  AttackInfo(int damage, String type, boolean ignoreArmor, boolean pierce, int maxHits, float knockbackX, float knockbackY) {
    this.damage = damage;
    this.type = type;
    this.ignoreArmor = ignoreArmor;
    this.pierce = pierce;
    this.maxHits = maxHits;
    this.knockbackX = knockbackX;
    this.knockbackY = knockbackY;
  }
}
