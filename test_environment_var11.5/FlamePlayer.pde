class FlamePlayer extends Player {
PImage[] chargeLoop0 = new PImage[3];
PImage[] chargeTo1st = new PImage[2];
PImage[] chargeLoop1 = new PImage[3];
PImage[] chargeToMax = new PImage[3];
PImage[] chargeMaxLoop = new PImage[3];
PImage[] chargeEffect01 = new PImage[4];
PImage[] chargeEffect12 = new PImage[9];
PImage[] attackFrames = new PImage[3];
PImage[] fireballFrames = new PImage[2];
PImage[] fireArrowFrames = new PImage[2];

PImage[] chargeLeftLoop0 = new PImage[3];   // 0→1段階チャージループ
PImage[] chargeLeftTo1st = new PImage[2];   // 0→1段階移行
PImage[] chargeLeftLoop1 = new PImage[3];   // 1→MAX段階ループ
PImage[] chargeLeftToMax = new PImage[3];   // 1→MAX段階移行
PImage[] chargeLeftMaxLoop = new PImage[3]; // MAXチャージループ
PImage[] attackLeftFrames = new PImage[3];
PImage[] fireArrowLeftFrames = new PImage[2];
PImage[] infernoLeftFrames = new PImage[3];
PImage[] inpactLeftFrames = new PImage[5];


int effectFrame = -1;
int effectStage = 0;
boolean isAttacking = false;
int attackFrame = 0;
int attackDuration = 0;
boolean isCharging = false;
int chargeFrame = 0;
int chargeLevel = 0;

EnemyManager enemies;
  
  FlamePlayer(
    Hitbox hitbox,
    PImage normalImgLeft, PImage normalImgRight,
    PImage blinkImgLeft, PImage blinkImgRight,
    PImage sleepImgLeft, PImage sleepImgRight,
    PImage[] walkLeftFrames, PImage[] walkRightFrames,
    PImage[] sleepyFramesLeft, PImage[] sleepyFramesRight,
    int[] sleepyDurations,
    PImage jumpImgLeft, PImage jumpImgRight,
    CollisionChecker collider, CollisionHandler colHand,
    int startX, int startY,
    PImage[] chargeLoop0, PImage[] chargeTo1st, PImage[] chargeLoop1, PImage[] chargeToMax, PImage[] chargeMaxLoop,
    PImage[] chargeEffect01,
    PImage[] chargeEffect12,
    PImage[] attackFrames,
    PImage[] fireballFrames, PImage[] fireArrowFrames,
    PImage[] chargeLeftLoop0, PImage[] chargeLeftTo1st, PImage[] chargeLeftLoop1, PImage[] chargeLeftToMax, PImage[] chargeLeftMaxLoop,
    PImage[] attackLeftFrames,
    PImage[] fireArrowLeftFrames,
    PImage[] infernoLeftFrames, PImage[] inpactLeftFrames,
    EnemyManager enemies
  ) {
    super(hitbox, normalImgLeft, normalImgRight,
          blinkImgLeft, blinkImgRight,
          sleepImgLeft, sleepImgRight,
          walkLeftFrames, walkRightFrames,
          sleepyFramesLeft, sleepyFramesRight,
          sleepyDurations,
          jumpImgLeft, jumpImgRight,
          collider, colHand,
          startX, startY);
          
           this.chargeLoop0 = chargeLoop0;
    this.chargeTo1st = chargeTo1st;
    this.chargeLoop1 = chargeLoop1;
    this.chargeToMax = chargeToMax;
    this.chargeMaxLoop = chargeMaxLoop;
    this.chargeEffect01 = chargeEffect01;
    this.chargeEffect12 = chargeEffect12;
    this.attackFrames = attackFrames;
    this.fireballFrames = fireballFrames;
    this.fireArrowFrames = fireArrowFrames;
    
    this.chargeLeftLoop0 = chargeLeftLoop0;
    this.chargeLeftTo1st = chargeLeftTo1st;
    this.chargeLeftLoop1 = chargeLeftLoop1;
    this.chargeLeftToMax = chargeLeftToMax;
    this.chargeLeftMaxLoop = chargeLeftMaxLoop;
    this.attackLeftFrames = attackLeftFrames;
    this.fireArrowLeftFrames = fireArrowLeftFrames;
    this.infernoLeftFrames = infernoLeftFrames;
    this.inpactLeftFrames = inpactLeftFrames;
    this.enemies = enemies;
  }
  
  void updateFlameAnimation() {
    float drawX = hitbox.getX() + drawOffsetX;
    float drawY = hitbox.getY() + drawOffsetY;
    
    
    
    if (isAttacking) {
        int idx = (attackFrame / 5) % attackFrames.length;
        if (faceLeft) image(attackLeftFrames[idx], drawX, drawY, drawW, drawH);
        else image(attackFrames[idx], drawX, drawY, drawW, drawH);
        
        if (attackDuration > 0) {
          attackFrame++;
          attackDuration--;
        }
        else {
          isAttacking = false;
          attackFrame = 0;
        }

        return;  // 他の状態と重ならないようにここで終了
      }
      

    if (isCharging) {
      chargeFrame++;

      // 段階更新
      if (chargeLevel == 0 && chargeFrame >= CHARGE_1) {
        chargeLevel = 1;
        animationFrame = 0;
        effectFrame = 0;
        effectStage = 1;
      } 
      else if (chargeLevel == 1 && chargeFrame >= CHARGE_2) {
        chargeLevel = 2;
        animationFrame = 0;
        effectFrame = 0;
        effectStage = 2;
      }

      PImage frame = null;
      
      PImage effect = null;
      if (effectFrame >= 0) {
        if (effectStage == 1) {
          int idx = effectFrame / 3;
          if (idx < chargeEffect01.length) {
            effect = chargeEffect01[idx];
          } else {
            effectFrame = -1;
            effectStage = 0;
          }
        } else if (effectStage == 2) {
          int idx = effectFrame / 3;
          if (idx < chargeEffect12.length) {
            effect = chargeEffect12[idx];
          } else {
            effectFrame = -1;
            effectStage = 0;
          }
        }
      }

      if (faceLeft) {
        if (chargeLevel == 0) {
          frame = chargeLeftLoop0[(animationFrame / 6) % chargeLeftLoop0.length];
        } 
        else if (chargeLevel == 1 && chargeFrame < CHARGE_2) {
          if (animationFrame / 3 < chargeLeftTo1st.length) {
            frame = chargeLeftTo1st[animationFrame / 3];
          } 
          else {
            frame = chargeLeftLoop1[(animationFrame / 5) % chargeLeftLoop1.length];
          }
        } 
        else if (chargeLevel == 2 && chargeFrame < CHARGE_2 + 50) {
          if (animationFrame / 3 < chargeLeftToMax.length) {
            frame = chargeLeftToMax[animationFrame / 3];
          } 
          else {
            frame = chargeLeftMaxLoop[(animationFrame / 5) % chargeLeftMaxLoop.length];
          }
        }
        else {
          frame = chargeLeftMaxLoop[(animationFrame / 5) % chargeLeftMaxLoop.length];
        }
      }
      else {
        if (chargeLevel == 0) {
          frame = chargeLoop0[(animationFrame / 6) % chargeLoop0.length];
        } 
        else if (chargeLevel == 1 && chargeFrame < CHARGE_2) {
          if (animationFrame / 3 < chargeTo1st.length) {
            frame = chargeTo1st[animationFrame / 3];
          } 
          else {
            frame = chargeLoop1[(animationFrame / 5) % chargeLoop1.length];
          }
        } 
        else if (chargeLevel == 2 && chargeFrame < CHARGE_2 + 50) {
          if (animationFrame / 3 < chargeToMax.length) {
            frame = chargeToMax[animationFrame / 3];
          } 
          else {
            frame = chargeMaxLoop[(animationFrame / 5) % chargeMaxLoop.length];
          }
        }
        else {
          frame = chargeMaxLoop[(animationFrame / 5) % chargeMaxLoop.length];
        }
      }
      image(frame, drawX, drawY, drawW, drawH);
      
      if (effect != null) {
          if (faceLeft) image(effect, drawX + 10, drawY -10, drawW, drawH);
          else image(effect, drawX - 10, drawY - 10, drawW, drawH);
          effectFrame++;
        }
        else {
          effectFrame = -1;
          effectStage = 0;
        }
        
       
       animationFrame++;
    }
  }
  
  boolean getIsAttacking() {
    return isAttacking;
  }
  
  void startCharging() {
    isCharging = true;
    chargeFrame = 0;
    chargeLevel = 0;
    animationFrame = 0;
    effectFrame = -1;
    effectStage = 0;
    hitbox.setVX(0);
  }
  
  void stopChargingAndAttack() {
    isCharging = false;
    isAttacking = true;
    attackFrame = 0;
    if (chargeLevel == 0) {
      attackDuration = 10;
      
      float fireballX = hitbox.getX() + (faceLeft ? -10 : +40);
      float fireballY = hitbox.getY() + 20;
      AttackInfo fireball = new AttackInfo(3, "fireball", false, false, 1, 0, 0);
      fireballs.add(new FireballEffect(
      fireballX, fireballY, faceLeft ? -6 : 6, -4, fireballFrames, enemies.getEnemies(), fireball));
    }
    else if (chargeLevel == 1) {
      attackDuration = 20;
      float spawnX = hitbox.getX() + (faceLeft ? -10 : 40);
      float spawnY = hitbox.getY() - 10;
      float speed = faceLeft ? -14 : 14;
      if (faceLeft) {
        AttackInfo fireArrow = new AttackInfo(7, "Inferno", false, true, 2, 3, 0);
        fireArrows.add(new FireArrowEffect(spawnX, spawnY, speed, fireArrowLeftFrames, enemies.getEnemies(), fireArrow));
      }
      else {
        AttackInfo fireArrow = new AttackInfo(7, "Inferno", false, true, 2, 3, 0);
        fireArrows.add(new FireArrowEffect(spawnX, spawnY, speed, fireArrowFrames, enemies.getEnemies(), fireArrow));
      }
    }
    else {
      attackDuration = 40;
      float fireX = hitbox.getX() + (player.faceLeft ? -5 : 20);
      float fireY = hitbox.getY() - 10;
      float infernoVX = player.faceLeft ? -18 : 18;
      float inpactVX = player.faceLeft ? -10 : 10;
      startVerticalShockShake(10);
      if (faceLeft){
        AttackInfo inferno = new AttackInfo(12, "Inferno", false, true, 100, 10, -5);
        infernos.add(new InfernoEffect(fireX, fireY, infernoVX, infernoLeftFrames, enemies.getEnemies(), inferno));
        inpacts.add(new Inpact(fireX, fireY - 10, inpactVX, inpactLeftFrames));
      }
      else {
        AttackInfo inferno = new AttackInfo(12, "Inferno", false, true, 100, 10, -5);
        infernos.add(new InfernoEffect(fireX, fireY, infernoVX, infernoFrames, enemies.getEnemies(), inferno));
        inpacts.add(new Inpact(fireX, fireY - 10, inpactVX, inpactFrames));
      }
    }
    chargeLevel = 0;
    chargeFrame = 0;
    animationFrame = 0;
  }
}
