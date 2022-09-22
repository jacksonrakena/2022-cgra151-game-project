final int distanceBetweenShots = 50;

class FaceOffGame extends Game {
  GameMap foMap;
  ArrayList<PlayerProjectileController> controllers;
  
  String getName() { return "1v1"; }
  String getDescription() { return "Fight against your opponent with a variety of weapons."; }
  
  void init() {
    println("Initialising face-off.");
    this.foMap = readMap("map_faceoff.csv");
    controllers = new ArrayList<PlayerProjectileController>();
    controllers.add(new PlayerProjectileController(state.player1()));
    controllers.add(new PlayerProjectileController(state.player2()));
    for (Wall w : this.foMap.walls) {
      state.objects.add(w);
    }
    state.player1().entity.setPosition(new PVector(100,100));
    state.player2().entity.setPosition(new PVector(400,400));
    state.objects.add(state.player1().entity);
    state.objects.add(state.player2().entity);
  }
  void draw() {
    for (PlayerProjectileController controller : controllers) {
      controller.step();
    }
  }
}

class PlayerProjectileController {
  PlayerState player;
  long lastFrameFired = 0;
  ArrayList<CircleEntity2D> projectiles = new ArrayList<CircleEntity2D>();
  public PlayerProjectileController(PlayerState player) {
    this.player = player;
  }
  void step() {
    if (this.player.controlScheme.fire()) {
      if (lastFrameFired == 0 || state.frame > lastFrameFired + distanceBetweenShots) {
        lastFrameFired = state.frame; 
        fire();
      }
    }
    for (CircleEntity2D projectile : projectiles) {
      for (PlayerState p : state.allPlayers) {
        if (p != this.player && projectile.colliding(p.entity)) {
         println("collision"); 
         projectile.disabled = true;
         state.objects.remove(projectile);
        }
      }
    }
  }
  
  void fire() {
    CircleEntity2D projectile = new CircleEntity2D(this.player.entity.getPosition().copy().add(
        this.player.entity.calculateForwardVector().normalize().mult(50)
      ), 20, new PuckEntityTexture(this.player.chosenColor));
    projectile.setMomentum(1);
    projectile.addVelocity(this.player.entity.calculateForwardVector().mult(200));
    projectiles.add(projectile);
    state.objects.add(projectile);
  }
}
