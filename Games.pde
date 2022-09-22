abstract class Game {
  void draw() {
    
  }
  
  void init() {
    
  }
  
  abstract String getName();
  abstract String getDescription();
}

class RaceGame extends Game {
  GameMap raceMap;
  String getName() { return "Maze Race"; }
  String getDescription() { return "Race against your opponent through a randomly-generated map."; }
  void draw() {
    
  }
  
  void init() {
    println("Initialising race.");
    this.raceMap = readMap("map_race.csv");
    state.player1().entity.setPosition(new PVector(20, 20));
    
    for (Wall w : this.raceMap.walls) {
      state.objects.add(w);
    }
    
    for (MapMarker marker : this.raceMap.markers) {
      switch (marker.type) {
        case "start0":
          state.player1().entity.setPosition(new PVector(marker.x, marker.y));
          state.player1().entity.angle = 180;
          state.objects.add(state.player1().entity);
          break;
        case "start1":
          state.player2().entity.setPosition(new PVector(marker.x, marker.y));
          state.player2().entity.angle = 180;
          state.objects.add(state.player2().entity);
          break;
        default:
          println("Unknown marker type " + marker.type);
          break;
      }
    }
  }
}

enum GameName {
  Race,
  FaceOff
}

ArrayList<Game> gameOptions = new ArrayList<Game>();

void initGames() {
  gameOptions.add(new RaceGame());
  gameOptions.add(new FaceOffGame());
  gameOptions.add(new CollectGame());
}
