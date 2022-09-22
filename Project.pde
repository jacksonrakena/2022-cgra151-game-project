GameState state;
PFont spaceFont;
void setup() {
  size(800,800);
  spaceFont = createFont("space-font.otf", 14);
  textFont(spaceFont, 128);
  noStroke();
  smooth(8);
  colorMode(HSB, 360, 100, 100);
  
  Globals.colors = new ArrayList<Integer>(Arrays.asList(
    color(130,65,73),
    color(346, 69, 42),
    color(44,98,72),
    color(181,93,72)
  ));
  
  state = new GameState();
  state.allPlayers.add(new PlayerState(new ControlScheme('A', 'D', 'W', 'S', ' '), Globals.colors.get((int) random(0, Globals.colors.size()))));
  state.allPlayers.add(new PlayerState(new ControlScheme(LEFT, RIGHT, UP, DOWN, CONTROL), Globals.colors.get((int) random(0, Globals.colors.size()))));
  
  state.timeStart = System.currentTimeMillis();
  initGames();
  state.stage = Stage.Play;
  state.game = new MainMenu();
}

void load() {
  state.objects = new ArrayList<Drawable>();
  for (int i = 0; i < state.allPlayers.size(); i++) {
    PlayerState p = state.allPlayers.get(i);
    p.entity = new PlayerEntity(new PVector(i*150, 150), p.controlScheme, p.chosenColor);
  }
  state.stage = Stage.Play;
  state.game.init();
}

void draw() {
  clear();
  
  long frameStart = System.currentTimeMillis();
  state.frame++;
  
  drawBackground();
  
  switch (state.stage) {
    case Load:
      state.objects = new ArrayList<Drawable>();
      int i = 1;
      for (PlayerState player : state.allPlayers) {
        player.entity = new PlayerEntity(new PVector(i*150, 150), player.controlScheme, player.chosenColor);
        i++;
      }
      state.introStartTime = System.currentTimeMillis();
      state.stage = Stage.Play;
      state.game.init();
      break;
    case Play:
      drawGame();
      break;
    default:
      break;
  }
  if (Globals.debugMode) {
      DEBUG_printFrameData(frameStart, System.currentTimeMillis());
  }
}


void drawGame() {
  // Draw begins
  textSize(20);
  
  if (getInputDebounced(BACKSPACE) || getInputDebounced(DELETE)) {
    if (!state.history.empty()) { 
      switchGameNoSave(state.history.pop()); 
      return; 
    }
  }
  
  // Simulate physics for all objects loaded by the current game
  ArrayList<PhysicsObject> colliders = new ArrayList<PhysicsObject>();
  for (Drawable obj : state.objects) {
    if (obj instanceof CircleCollider2D) {
      CircleCollider2D collider = (CircleCollider2D) obj;
      PVector pos = collider.getPosition();
      PVector vel = collider.getVelocity();
      
      // Bounce off the left and right of the screen.
      if ((pos.x - collider.getRadius()) < 0 || (pos.x + collider.getRadius())  > width) {
        collider.setVelocity(new PVector(vel.x * -1,vel.y));
        
      }
     
      // Bounce off the top and bottom of the screen.
      if ((pos.y + collider.getRadius()) > height || (pos.y - collider.getRadius()) < 0) {
        collider.setVelocity(new PVector(vel.x,vel.y*-1));
      }
      
      for (Drawable obj2 : state.objects) {
        if (obj2 instanceof Wall) {
          Wall wall = (Wall) obj2;
          float wallCenterX = wall.position.x + (wall.dimensions.x/2);
          float wallCenterY = wall.position.y + (wall.dimensions.y/2);
          double wallHalfHeight = wall.dimensions.y/2;
          double wallHalfWidth = wall.dimensions.x/2;
          double distanceBetweenColliders = Math.hypot(collider.getPosition().x - wallCenterX, collider.getPosition().y - wallCenterY);
          
          float testX = collider.getPosition().x;
          float testY = collider.getPosition().y;
          
          if (collider.getPosition().x < wall.position.x) testX = wall.position.x;
          else if (collider.getPosition().x > wall.position.x+wall.dimensions.x) testX = wall.position.x + wall.dimensions.x;
          
          if (collider.getPosition().y < wall.position.y) testY = wall.position.y;
          else if (collider.getPosition().y > wall.position.y + wall.dimensions.y) testY = wall.position.y + wall.dimensions.y;
          
          float distX = collider.getPosition().x - testX;
          float distY = collider.getPosition().y - testY;
          double distance = Math.hypot(distX, distY);
          if (distance <= collider.getRadius()) {
            PVector result = collideRectangleAndBall(
              new PVector(wallCenterX, wallCenterY), new PVector(wall.dimensions.x, wall.dimensions.y),
              collider.getPosition(), collider.getRadius()*2, collider.getVelocity()
            );
            result.mult(0.9);
            collider.setVelocity(result);
          }
        }
        
        if (obj2 instanceof CircleCollider2D && obj2 != obj) {
          CircleCollider2D obj2c = (CircleCollider2D) obj2;
          boolean colliding = Math.hypot(abs(obj2c.getPosition().x-collider.getPosition().x), abs(obj2c.getPosition().y-collider.getPosition().y)) <= (obj2c.getRadius()+collider.getRadius());
          if (colliding && !colliders.contains(collider)) {
            colliders.add(collider);
            // Collision
            
            double angleOfCollision = Math.atan2(collider.getPosition().y - obj2c.getPosition().y, collider.getPosition().x - obj2c.getPosition().x);
            
            double distanceBetweenColliders = Math.hypot(collider.getPosition().x - obj2c.getPosition().x, collider.getPosition().y - obj2c.getPosition().y);
            
            double distanceToMove = (obj2c.getRadius()+collider.getRadius()) - distanceBetweenColliders;

            CircleCollider2D target = collider.isMovable() ? collider : obj2c;
            
            target.addVelocity(new PVector((float)(Math.cos(angleOfCollision) * distanceToMove), (float)(Math.sin(angleOfCollision) * distanceToMove)));
          }
        }
      }
    }
    obj.step();
  }
  
  // Draw stage
  for (Drawable obj : state.objects) {
    obj.draw();
  }
  if (state.game != null) state.game.draw();
}
