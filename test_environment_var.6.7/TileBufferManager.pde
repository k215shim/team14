class TileBufferManager {
  PGraphics stageBuffer;
  PGraphics objTileBuffer;
  PGraphics bgBuffer;

  int tileSize, objTileSize;
  int[][] map, objMap;
  PImage bgImg, blockImg;
  PImage grassGroundImg, grassImg, soilImg, cliff_left, cliff_right,imgKareki,imgMidoriKi,imgRenga;

  TileBufferManager(
    int tileSize, int objTileSize,
    int[][] map, int[][] objMap,
    PImage bgImg, PImage blockImg,
    PImage grassGroundImg, PImage grassImg, PImage soilImg, PImage cliff_left, PImage cliff_right ,PImage imgKareki,PImage imgMidoriKi,PImage imgRenga
  ) {
    this.tileSize = tileSize;
    this.objTileSize = objTileSize;
    this.map = map;
    this.objMap = objMap;
    this.bgImg = bgImg;
    this.blockImg = blockImg;
    this.grassGroundImg = grassGroundImg;
    this.grassImg = grassImg;
    this.soilImg = soilImg;
    this.cliff_left = cliff_left;
    this.cliff_right = cliff_right;
     this.imgKareki=imgKareki;
    this.imgMidoriKi=imgMidoriKi;
    this.imgRenga=imgRenga;


    createStageBuffer();
    createObjectBuffer();
    createBackgroundBuffer();
  }

  void createStageBuffer() {
    stageBuffer = createGraphics(tileSize * map[0].length, tileSize * map.length);
    stageBuffer.beginDraw();
    for (int row = 0; row < map.length; row++) {
      for (int col = 0; col < map[row].length; col++) {
        int tile = map[row][col];
        PImage tileImg = null;

        if (tile == 1) tileImg = grassGroundImg;
        else if (tile == 2) tileImg = grassImg;
        else if (tile == 3) tileImg = soilImg;
        else if (tile == 4) tileImg = cliff_left;
        else if (tile == 5) tileImg = cliff_right;
         else if(tile==7) tileImg = imgKareki;
        else if(tile==8) tileImg=imgMidoriKi;
        else if(tile==9) tileImg=imgRenga; 

        if (tileImg != null) {
          stageBuffer.image(tileImg, col * tileSize, row * tileSize, tileSize, tileSize);
        }
      }
    }
    stageBuffer.endDraw();
  }

  void createObjectBuffer() {
    objTileBuffer = createGraphics(objTileSize * objMap[0].length, objTileSize * objMap.length);
    objTileBuffer.beginDraw();
    for (int row = 0; row < objMap.length; row++) {
      for (int col = 0; col < objMap[row].length; col++) {
        int tile = objMap[row][col];
        if (tile == 6) {
          objTileBuffer.image(blockImg, col * objTileSize, row * objTileSize, objTileSize, objTileSize);
        }
      }
    }
    objTileBuffer.endDraw();
  }

  void createBackgroundBuffer() {
    bgBuffer = createGraphics(tileSize * map[0].length, tileSize * map.length);
    bgBuffer.beginDraw();
    int tilesX = ceil((float)bgBuffer.width / bgImg.width);
    int tilesY = ceil((float)bgBuffer.height / bgImg.height);

    for (int y = 0; y < tilesY; y++) {
      for (int x = 0; x < tilesX; x++) {
        bgBuffer.image(bgImg, x * bgImg.width, y * bgImg.height);
      }
    }
    bgBuffer.endDraw();
  }

  void drawAll(float offsetX, float offsetY) {
    image(bgBuffer, -offsetX, offsetY);
    image(objTileBuffer, -offsetX, offsetY);
    image(stageBuffer, -offsetX, offsetY);
  }

  PGraphics getStageBuffer() {
    return stageBuffer;
  }

  PGraphics getObjTileBuffer() {
    return objTileBuffer;
  }

  PGraphics getBgBuffer() {
    return bgBuffer;
  }
}
