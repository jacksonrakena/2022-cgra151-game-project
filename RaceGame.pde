class RaceMarker extends GameObject {
  float x, y, w, h;
  RaceMarker(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

class RaceGame extends Game {
  GameMap raceMap;
  String getName() { return "Maze Race"; }
  String getDescription() { return "Race against your opponent through a randomly-generated map."; }
  RaceMarker goal;
  void draw() {
    
  }
  
  void init() {
    println("Initialising race.");
    this.raceMap = readMap("map_race.csv");
    state.player1().entity.position = new PVector(20, 20);
    
    for (Wall w : this.raceMap.walls) {
      state.objects.add(w);
    }
    
    for (MapMarker marker : this.raceMap.markers) {
      switch (marker.type) {
        case "start0":
          state.player1().entity.position = new PVector(marker.x, marker.y);
          state.player1().entity.angle = 180;
          state.objects.add(state.player1().entity);
          break;
        case "start1":
          state.player2().entity.position = new PVector(marker.x, marker.y);
          state.player2().entity.angle = 180;
          state.objects.add(state.player2().entity);
          break;
        case "goal":
          goal = new RaceMarker(marker.x, marker.y, marker.width, marker.height);
          break;
        default:
          println("Unknown marker type " + marker.type);
          break;
      }
    }
    state.objects.add(goal);
  }
}
