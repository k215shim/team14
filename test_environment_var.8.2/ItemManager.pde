class ItemManager {
  ArrayList<Item> items;
  HashMap<Integer, ArrayList<ItemData>> stageItemData;

  ItemManager() {
    items = new ArrayList<Item>();
    stageItemData = new HashMap<Integer, ArrayList<ItemData>>();
  }
  
  void registerItems() {
    ArrayList<ItemData> items1 = new ArrayList<ItemData>();
    items1.add(new ItemData(200, 240, "rose"));
    items1.add(new ItemData(100, 240, "mana"));
    items1.add(new ItemData(130, 240, "mana"));
    stageItemData.put(1, items1);
  }
  
  void loadItemsFromData(int stageNum) {
    itemManager.clear();
    
    ArrayList<ItemData> items = stageItemData.get(stageNum);
    if (items == null) return;

    for (ItemData data : items) {
      if (data.type.equals("mana")) {
        itemManager.add(new ManaOrb(data.x, data.y, manaOrbFrames, 20, 20));
      } 
      else if (data.type.equals("rose")) {
        itemManager.add(new FireRose(data.x, data.y, fireroseFrames, 40, 40));
      }
    }
  }
  
  void startStage(int stageNum) {
    currentStage = stageNum;
    loadItemsFromData(currentStage);
    player.resetPosition();
  }
  
  void add(Item item) {
    items.add(item);
  }

  void update() {
    for (Item item : items) {
      item.update();
    }
  }

  void display() {
    for (Item item : items) {
      item.display();
    }
  }

  void reset() {
    for (Item item : items) {
      item.collected = false;
    }
  }

  void clear() {
    items.clear();
  }
}
