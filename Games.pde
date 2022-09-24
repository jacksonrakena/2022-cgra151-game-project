abstract class Game {
  void draw() {
    
  }
  
  void init() {
    
  }
  
  abstract String getName();
  abstract String getDescription();
}

ArrayList<Game> gameOptions = new ArrayList<Game>();

void initGames() {
  gameOptions.add(new RaceGame());
  gameOptions.add(new FaceOffGame());
  gameOptions.add(new CollectGame());
}
