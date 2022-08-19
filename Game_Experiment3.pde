ArrayList<GameObject> objects;
int frame;
long start;
boolean DEBUG_disableAccelerationRampAndMomentum = false;
int horizontalFactor = 16;
int verticalFactor = 9;
int windowSize = 16;
float tileSize = 800/20;
PImage playerimg;
GameState state;
int bgHue;
void setup() {
  size(800,800);
  noStroke();
  smooth();
  frameRate(60);
  colorMode(HSB, 360, 100, 100);
  state = new GameState();
  playerimg = loadImage("playerv1.png");
  bgHue = (int) random(0,360);
  start = System.currentTimeMillis();
  objects = new ArrayList<GameObject>();
  objects.add(new PlayableEntity(150, 150, new ControlScheme(LEFT, RIGHT, UP, DOWN), color(random(0,360),80,100)));
  objects.add(new PlayableEntity(300, 300, new ControlScheme('A', 'D', 'W', 'S'), color(random(0,360),80,100)));
  objects.add(new CircleEntity(width/2, width/2, 40, new PuckEntityTexture()));
  objects.add(new Wall(tileSize*2, tileSize*4, tileSize*2, tileSize*2, new DefaultWallTexture()));
  objects.add(new Wall(450, 450, 100, 200, new DefaultWallTexture()));
}

void draw() {
  clear();
  long frameStart = System.currentTimeMillis();
  frame++;
 
  switch (state.stage) {
    case CharacterSelect:
      drawCharacterSelect();
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
  text("f="+frame + " msec="+(System.currentTimeMillis()-start) + 
  " rate="+((System.currentTimeMillis()-start)/frame) + 
  " frame_time=" + (frameEnd-frameStart), 0, 40);
  
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
  
  rect(sectionStart+selectSize+sectionSeparator, 0.2*width, selectSize, selectSize);
  text("PLAYER 2", (sectionStart+selectSize+sectionSeparator)+(selectSize/2), (0.2*width)+selectSize+25);
  text("Use left and right arrow to change", (sectionStart+selectSize+sectionSeparator)+(selectSize/2), (0.2*width)+selectSize+50);
  
  text("ENTER TO START", (width/2), 0.8*height);
  
  if (getInput(ENTER)) {
    state.stage = Stage.Play;
  }
}

void drawGame() {
  
  // Draw begins
  //drawBackground();
  textSize(20);
  
  int pressed = 0;
  for (int i = 0; i < 400; i++) {
    if (getInput(i)) {
      String value = String.valueOf((char)i);
      if (i==RIGHT)value="R";
      if (i==LEFT)value="L";
      if (i==UP)value="U";
      if (i==DOWN)value="D";
      text(value, 20*pressed, 20);
      pressed++;
    }
  }
  // Simulation stage
  ArrayList<GameObject> colliders = new ArrayList<GameObject>();
  for (GameObject obj : objects) {
    if (obj instanceof PlayableEntity) {
      PlayableEntity ent = (PlayableEntity) obj;
      // Bounce off the left and right of the screen.
      if ((ent.getX() - ent.getRadius()) < 0 || (ent.getX() + ent.getRadius())  > width) {
        print("sides collision");
        if (ent.velocity.mag() != 0) ent.velocity.set(0,0);
      }
     
      // Bounce off the top and bottom of the screen.
      if ((ent.getY() + ent.getRadius()) > height || (ent.getY() - ent.getRadius()) < 0) {
        if (ent.velocity.mag() != 0) ent.velocity.set(0,0);
      }
      
    }
    if (obj instanceof CircleCollider) {
      CircleCollider collider = (CircleCollider) obj;
      
      // Bounce off the left and right of the screen.
      if ((collider.getX() - collider.getRadius()) < 0 || (collider.getX() + collider.getRadius())  > width) {
        collider.setVx(collider.getVx() * -1);
        if (collider.getVx() == 0) collider.setVx((collider.getX() - collider.getRadius()) < 0 ? 1 : -1);
      }
     
      // Bounce off the top and bottom of the screen.
      if ((collider.getY() + collider.getRadius()) > height || (collider.getY() - collider.getRadius()) < 0) {
        collider.setVy(collider.getVy() * -1);
        if (collider.getVy() == 0) collider.setVx((collider.getY() + collider.getRadius()) > height ? 1 : -1);
      }
      
      for (GameObject obj2 : objects) {
        if (obj2 instanceof Wall) {
          Wall wall = (Wall) obj2;
          float wallCenterX = wall.x + (wall.width/2);
          float wallCenterY = wall.y + (wall.height/2);
          double wallHalfHeight = wall.height/2;
          double wallHalfWidth = wall.width/2;
          double distanceBetweenColliders = Math.hypot(collider.getX() - wallCenterX, collider.getY() - wallCenterY);
          
          float testX = collider.getX();
          float testY = collider.getY();
          
          if (collider.getX() < wall.getX()) testX = wall.getX();
          else if (collider.getX() > wall.getX()+wall.width) testX = wall.getX() + wall.width;
          
          if (collider.getY() < wall.getY()) testY = wall.getY();
          else if (collider.getY() > wall.getY() + wall.height) testY = wall.getY() + wall.height;
          
          float distX = collider.getX() - testX;
          float distY = collider.getY() - testY;
          double distance = Math.hypot(distX, distY);
          if (distance <= collider.getRadius()) {
            //double angleOfCollision = Math.atan2(collider.getY() - wallCenterY, collider.getX() - wallCenterX);
            
            //double distanceToEdge = Math.hypot(wallHalfHeight, wallHalfWidth) + collider.getRadius();
            //double distanceToMove = distanceToEdge - distanceBetweenColliders;
            
            //collider.changeX((float)(Math.cos(angleOfCollision*distanceToMove)));
            //collider.changeY((float)(Math.sin(angleOfCollision*distanceToMove)));
            // println("wall collide " + System.currentTimeMillis() + " at " + angleOfCollision); 
            BallObjectCollisionResult result = handleCollisionBetweenObjectAndBall(
              wallCenterX, wallCenterY, wall.width, wall.height, collider.getX(), collider.getY(), collider.getRadius()*2, collider.getVx(),
              collider.getVy()
            );
            collider.setVx(result.newVx == collider.getVx() ? collider.getVx() : (result.newVx * 0.9));
            collider.setVy(result.newVy == collider.getVy() ? collider.getVy() : (result.newVy * 0.9));
          }
        }
        
        if (obj2 instanceof CircleCollider && obj2 != obj) {
          CircleCollider obj2c = (CircleCollider) obj2;
          if (obj2c.colliding(collider) && !colliders.contains(collider)) {
            colliders.add(collider);
            // Collision
            
            double angleOfCollision = Math.atan2(collider.getY() - obj2c.getY(), collider.getX() - obj2c.getX());
            
            double distanceBetweenColliders = Math.hypot(collider.getX() - obj2c.getX(), collider.getY() - obj2c.getY());
            
            double distanceToMove = (obj2c.getRadius()+collider.getRadius()) - distanceBetweenColliders;

            CircleCollider target = collider.isMovable() ? collider : obj2c;
            
            target.changeX((float)(Math.cos(angleOfCollision) * distanceToMove));
            target.changeY((float)(Math.sin(angleOfCollision) * distanceToMove));
          }
        }
      }
    }
    obj.step();
  }
  
  // Draw stage
  for (GameObject obj : objects) {
    if (obj instanceof Drawable) {
      ((Drawable) obj).draw();
    }
  }
}
