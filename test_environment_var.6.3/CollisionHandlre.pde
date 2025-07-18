class CollisionHandler {
  CollisionChecker checker;

  CollisionHandler(CollisionChecker checker) {
    this.checker = checker;
  }
  
   void checkX(Hitbox hb, Character c) {
     float nextX = hb.x + hb.vx;
     float top = hb.y;
     float bottom = hb.y + hb.h;
     
     int minTileY = int(top / checker.tileSize);
     int maxTileY = int((bottom -  3) / checker.tileSize);

     if (hb.vx > 0) { // 右
      int tx = int((nextX + hb.w - 1) / checker.tileSize);
      for (int ty = minTileY; ty <= maxTileY; ty++) {
        if (checker.isTileSolidMap(tx, ty)) {
          hb.x = tx * checker.tileSize - hb.w;
          hb.stopX();
          return;
        }
        if (checker.isTileSolidObj(tx, ty)) {
          hb.x = tx * checker.objTileSize - hb.w;
          hb.stopX();
          return;
        }
      }
    } else if (hb.vx < 0) { // 左
      int tx = int(nextX / checker.tileSize);
      for (int ty = minTileY; ty <= maxTileY; ty++) {
        if (checker.isTileSolidMap(tx, ty)) {
          hb.x = (tx + 1) * checker.tileSize;
          hb.stopX();
          return;
        }
        if (checker.isTileSolidObj(tx, ty)) {
          hb.x = (tx + 1) * checker.objTileSize;
          hb.stopX();
          return;
        }
      }
    }

    // 衝突なければ移動
    hb.x = nextX;
   }

  void checkY(Hitbox hb, Character c) {
    c.isOnGround = false;
    c.lastGroundType = "";
    
    float totalMoveY = hb.vy;
    float stepY = 1 * Math.signum(totalMoveY);  // 上昇なら-1、落下なら+1
    float movedY = 0;
    
    while (abs(movedY) < abs(totalMoveY)) {
     float dy = abs(totalMoveY - movedY) < abs(stepY) ? (totalMoveY - movedY) : stepY;
     float nextY = hb.y + dy;
    float left = hb.x;
    float right = hb.x + hb.w;

    int minTileX = int(left / checker.tileSize);
    int maxTileX = int((right - 1) / checker.tileSize);

    if (dy > 0) { // 落下
      int ty = int((nextY + hb.h - 1) / checker.tileSize);
      for (int tx = minTileX; tx <= maxTileX; tx++) {
        if (checker.isTileSolidMap(tx, ty)) {
          hb.y = ty * checker.tileSize - hb.h;
          hb.stopY();
          c.isOnGround = true;
          c.lastGroundType = "map";
          return;
        }
        if (checker.isTileSolidObj(tx, ty)) {
          hb.y = ty * checker.objTileSize - hb.h;
          hb.stopY();
          c.isOnGround = true;
          c.lastGroundType = "obj";
          return;
        }
      }
    } 
    else if (dy < 0) { // 上昇（天井）
      int ty = int(nextY / checker.tileSize);
      for (int tx = minTileX; tx <= maxTileX; tx++) {
        if (checker.isTileSolidMap(tx, ty)) {
          hb.y = (ty + 1) * checker.tileSize;
          hb.stopY();
          return;
        }
        if (checker.isTileSolidObj(tx, ty)) {
          hb.y = (ty + 1) * checker.objTileSize;
          hb.stopY();
          return;
        }
      }
    }
    // 衝突なし
    hb.y += dy;
    movedY += dy;
    }
  c.isOnGround = false;
  }
}
