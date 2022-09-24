class CollectGame extends Game {
  GameMap foMap;
  ArrayList<PlayerProjectileController> controllers;
  
  String getName() { return "Capture The Flag"; }
  String getDescription() { return "Capture your opponent's flag before they get yours."; }
  
  void init() {
    println("Initialising ctf.");
    this.foMap = readMap("map_faceoff.csv");
    controllers = new ArrayList<PlayerProjectileController>();
    controllers.add(new PlayerProjectileController(state.player1()));
    controllers.add(new PlayerProjectileController(state.player2()));
    for (Wall w : this.foMap.walls) {
      state.objects.add(w);
    }
    state.player1().entity.position = new PVector(100,100);
    state.player2().entity.position = new PVector(400,400);
    state.objects.add(state.player1().entity);
    state.objects.add(state.player2().entity);
  }
  void draw() {
    for (PlayerProjectileController controller : controllers) {
      controller.step();
    }
  }
}
