boolean DEBUG_disableAccelerationRampAndMomentum = false;
int windowSize = 16;
float tileSize = 800/20;
GameState state;
int bgHue;
int lastPlayer1ColorChangeFrame = 0;
int lastPlayer2ColorChangeFrame = 0;
void setup() {
  size(800,800);
  noStroke();
  smooth();
  frameRate(60);
  colorMode(HSB, 360, 100, 100);
  
  Globals.colors = new ArrayList<>(Arrays.asList(
    color(130,65,73),
    color(346, 69, 42),
    color(44,98,72),
    color(181,93,72)
  ));;
  
  state = new GameState();
  state.player1 = new PlayerState(new ControlScheme('A', 'D', 'W', 'S'), Globals.colors.get((int) random(0, Globals.colors.size())));
  state.player2 = new PlayerState(new ControlScheme(LEFT, RIGHT, UP, DOWN), Globals.colors.get((int) random(0, Globals.colors.size())));
  
  bgHue = (int) random(0,360);
  state.timeStart = System.currentTimeMillis();
}

void draw() {
  clear();
  
  long frameStart = System.currentTimeMillis();
  state.frame++;
  
  drawBackground();
  
  if (Globals.debugMode) {
    debug_printInputs();
  }
  
  switch (state.stage) {
    case CharacterSelect:
      drawCharacterSelect();
      break;
    case Load:
      state.objects = new ArrayList<Drawable2D>();
      state.objects.add(new CircleEntity2D(new PVector(width/2, width/2), 40, new PuckEntityTexture()));
      state.objects.add(new Wall(tileSize*2, tileSize*4, tileSize*2, tileSize*2, new DefaultWallTexture()));
      state.objects.add(new Wall(450, 450, 100, 200, new DefaultWallTexture()));
      state.objects.add(new PlayerEntity(new PVector(150,150), state.player1.controlScheme, state.player1.chosenColor));
      state.objects.add(new PlayerEntity(new PVector(300,300), state.player2.controlScheme, state.player2.chosenColor));
      state.stage = Stage.Play;
      break;
    case Play:
      drawGame();
      break;
    default:
      break;
  }
  
  long frameEnd = System.currentTimeMillis();
  fill(color(360,0,100));
  
  textAlign(LEFT);
  text("f="+state.frame + " msec="+(System.currentTimeMillis()-state.timeStart) + 
  " rate="+((System.currentTimeMillis()-state.timeStart)/state.frame) + 
  " frame_time=" + (frameEnd-frameStart) + " stage="+state.stage, 0, 40);
  
}

void drawCharacterSelect() {
  textSize(20);
  
  float sectionStart = 0.1*width;
  float sectionWidth = width-(sectionStart*2);
  float sectionSeparator = 0.2*sectionWidth;
  float selectSize = (sectionWidth-sectionSeparator)/2;
  
  textAlign(CENTER);
  
  rect(sectionStart, 0.2*width, selectSize, selectSize);
  text("PLAYER 1", sectionStart+(selectSize/2), (0.2*width)+selectSize+25);
  text("Use A and D to change", sectionStart+(selectSize/2), (0.2*width)+selectSize+50);
  playerTriangle((0.2*width)+(selectSize/4), (0.2*width)+(selectSize/2), 80, state.player1.chosenColor, state.frame%360, 0);
  
  rect(sectionStart+selectSize+sectionSeparator, 0.2*width, selectSize, selectSize);
  text("PLAYER 2", (sectionStart+selectSize+sectionSeparator)+(selectSize/2), (0.2*width)+selectSize+25);
  text("Use left and right arrow to change", (sectionStart+selectSize+sectionSeparator)+(selectSize/2), (0.2*width)+selectSize+50);
  playerTriangle((0.2*width)+(sectionSeparator)+(selectSize)+(selectSize/4), (0.2*width)+(selectSize/2), 80, state.player2.chosenColor, state.frame%360, 0);
  
  text("ENTER TO START", (width/2), 0.8*height);
  
  if (getInput(ENTER)) {
    state.stage = Stage.Load;
  }
  if (state.player1.controlScheme.left()) {
    state.player1.previousColor();
  }
  if (state.player1.controlScheme.right()) {
    state.player1.nextColor();
  }
  
  if (state.player2.controlScheme.left()) {
    state.player2.previousColor();
  }
  if (state.player2.controlScheme.right()) {
    state.player2.nextColor();
  }
}

void drawGame() {
  
  // Draw begins
  //drawBackground();
  textSize(20);
  
  if (getInput(BACKSPACE) || getInput(DELETE)) {
    state.stage = Stage.CharacterSelect;
    return;
  }
  
  // Simulation stage
  ArrayList<GameObject2D> colliders = new ArrayList<GameObject2D>();
  for (Drawable2D obj : state.objects) {
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
      
      for (Drawable2D obj2 : state.objects) {
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
  for (Drawable2D obj : state.objects) {
    obj.draw();
  }
}
