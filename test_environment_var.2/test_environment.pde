PImage appleImg, poisonImg, coinImg, fireImg;
Apple apple;
PoisonApple poison;
Coin coin;
ArrayList<Fire> fires = new ArrayList<Fire>();
Player player;

void setup() {
  size(600, 300);
  appleImg = loadImage("apple.png");
  poisonImg = loadImage("poisonApple.png");
  coinImg = loadImage("coin.png");
  fireImg = loadImage("fire.png");

  apple = new Apple(100, 200, 32, 32, appleImg);
  poison = new PoisonApple(160, 200, 32, 32, poisonImg);
  coin = new Coin(220, 200, 24, 24, coinImg);

  player = new Player();
  player.x = 50;
  player.y = 200;
  player.w = 48;
  player.h = 48;
}

void draw() {
  background(255);
  apple.display();
  poison.display();
  coin.display();

  apple.checkPlayerCollision(player);
  poison.checkPlayerCollision(player);
  coin.checkPlayerCollision(player);

  for (int i = fires.size() - 1; i >= 0; i--) {
    Fire f = fires.get(i);
    f.update();
    f.display();
    if (!f.isActive) fires.remove(i);
  }

  // player.display(); // 必要に応じて表示
}

void keyPressed() {
  if (key == 'z') {
    float fx = player.x + player.w / 2;
    float fy = player.y + player.h / 2;
    float dir = player.faceLeft ? -1 : 1;
    fires.add(new Fire(fx, fy, 32, 16, fireImg, dir));
  }
}
