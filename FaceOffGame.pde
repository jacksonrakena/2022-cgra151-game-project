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

PVector calculateForwardVector(float angle) {
  return new PVector((float)(-1 * Math.sin(radians(angle+180))), (float)(Math.cos(radians(angle+180))));
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
  }
  
  void fire() {
    CircleEntity2D projectile = new Projectile(this.player.entity.position.copy().add(
        calculateForwardVector(this.player.entity.angle).copy().normalize().mult(50)
      ), 20, new PuckEntityTexture(this.player.chosenColor));
    projectile.setMomentum(1);
    projectile.addVelocity(this.player.entity.calculateForwardVector().copy().normalize().mult(200));
    projectiles.add(projectile);
    state.objects.add(projectile);
  }
}

class Projectile extends CircleEntity2D {
  boolean enabled() { return !this.disabled; }
  Projectile(PVector startingPosition, float width, EntityTexture texture) {
    super(startingPosition, width, texture);
  }
  void onCollide(GameObject other) {
    this.disabled = true;
  }
}
