import java.util.Arrays;
import java.util.Stack;

static class Globals {
  static final float playerMaximumVelocity = 5;
  static final float playerWidth = 20;
  static final float playerAccelerationSpeed = 0.05;
  static final int backgroundCycleLength = 400;
  
  // TURN OFF BEFORE SUBMITTING
  static final boolean debugMode = true;
  static ArrayList<Integer> colors;
  static long getTotalGameTimeMillis(GameState st) {
    return System.currentTimeMillis() - st.timeStart;
  }
  static int clickX;
  static int clickY;
}

class GameState {
  Stage stage;
  Stack<Game> navigationTreeHistory = new Stack<Game>();
  ArrayList<GameObject> objects = new ArrayList<GameObject>();
  ArrayList<Integer> colors = new ArrayList<Integer>();
  long frame;
  long timeStart;
  Game game;
  
  ArrayList<PlayerState> allPlayers = new ArrayList<PlayerState>();
  
  PlayerState player1() { return allPlayers.get(0); }
  PlayerState player2() { return allPlayers.get(1); }
}

GameState state;
PFont spaceFont;

void setup() {
  size(800,800);
  spaceFont = createFont("space-font.otf", 14);
  textFont(spaceFont, 128);
  noStroke();
  smooth(8);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER, CENTER);
  
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
  state.objects = new ArrayList<GameObject>();
  state.objects.add(new World()); 
  for (int i = 0; i < state.allPlayers.size(); i++) {
    PlayerState p = state.allPlayers.get(i);
    p.entity = new PlayerEntity(p, new PVector(i*150, 150));
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
      load();
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

void handleCollisionBetweenBoxColliders(BoxCollider first, BoxCollider second) {
  LineSegment[] firstBox = ((BoxCollider) first).getCollidableSegments();
  LineSegment[] secondBox = ((BoxCollider) second).getCollidableSegments();
  
  for (LineSegment firstLine : firstBox) {
    for (LineSegment secondLine : secondBox) {
      if (firstLine == null || secondLine == null) continue;
      LineSegmentCollisionResult result = firstLine.intercepting(secondLine);
      if (result.colliding) {
        // Collision between two box colliders
        if (Globals.debugMode) {
          stroke(66,91,47);
          point(result.pointOfCollision.x, result.pointOfCollision.y); 
        }
        
        Entity target = null;
        if (first instanceof Entity) target = ((Entity) first);
        else if (second instanceof Entity) target = ((Entity) second);
        if (target == null) continue;
        if (target.lastOperationFrame < state.frame) {
          println("Pushing back on " + target);
          PVector t = target.velocity;
          target.velocity = new PVector(t.x*-0.7,t.y*-0.7);
          target.lastOperationFrame = state.frame + 10;
        }
      }
    }
  }
}


void drawGame() {
  // Draw begins
  textSize(20);
  
  if (getInputDebounced(BACKSPACE) || getInputDebounced(DELETE)) {
    if (!state.navigationTreeHistory.empty()) { 
      switchGameNoSave(state.navigationTreeHistory.pop()); 
      return; 
    }
  }
    // Draw stage
  for (GameObject obj : state.objects) {
    obj.draw();
  }
  
  // Simulate physics for all objects loaded by the current game
  ArrayList<Entity> colliders = new ArrayList<Entity>();
  
  // Collisions
  for (GameObject first : state.objects) {
    if (!first.isEnabled()) continue;
    
    // Check this object against all other objects in the scene
    for (GameObject second : state.objects) {
      if (!second.isEnabled()) continue;
      
      // Do not collide an object against itself
      if (first == second) continue;
      
      // Handle two box colliders (triangles, rectangles, boxes) hitting each other
      if (first instanceof BoxCollider && second instanceof BoxCollider) {
        
        // If both box colliders aren't movable (i.e. two walls), don't simulate
        if (!(first instanceof Entity) && !(second instanceof Entity)) continue;
        
        // Check each line against each other line
        handleCollisionBetweenBoxColliders((BoxCollider) first, (BoxCollider) second);
      }
      
      // Handle a circle collider intersecting with a box collider
      if (first instanceof BoxCollider && second instanceof CircleCollider2D) {
        BoxCollider box = ((BoxCollider) first);
        CircleCollider2D circle = ((CircleCollider2D) second);
        if (isPointInsideTriangle(circle.position, box.getCollidableSegments()[0].origin, box.getCollidableSegments()[1].origin, box.getCollidableSegments()[2].origin)) {
          println("Point collision between " + box + " and " + circle + " at " + System.currentTimeMillis());
          circle.onCollide((GameObject) box);
        }
      }
      
      
      /**
       A more ideal solution would have the circle entities colliding with the World box collider.
      */
      if (first instanceof CircleEntity2D) {
        CircleEntity2D c = ((CircleEntity2D) first);
        if (c.position.x+c.getRadius() > width || c.position.y+c.getRadius() > height || c.position.x-c.getRadius() < 0 || c.position.y-c.getRadius() < 0) {
          c.disabled = true; 
        }
      }
    }
    
    // Legacy circle code
    // TODO remove
    if (first instanceof CircleCollider2D) {
      if (!first.isEnabled()) continue;
      CircleCollider2D collider = (CircleCollider2D) first;
      PVector pos = collider.position;
      PVector vel = collider.velocity;
      
      // Bounce off the left and right of the screen.
      if ((pos.x - collider.getRadius()) < 0 || (pos.x + collider.getRadius())  > width) {
        collider.velocity = new PVector(vel.x * -1,vel.y);
        
      }
     
      // Bounce off the top and bottom of the screen.
      if ((pos.y + collider.getRadius()) > height || (pos.y - collider.getRadius()) < 0) {
        collider.velocity = new PVector(vel.x,vel.y*-1);
      }
      
      for (GameObject obj2 : state.objects) {
        if (!obj2.isEnabled()) continue;
        if (obj2 instanceof Wall) {
          Wall wall = (Wall) obj2;
          float wallCenterX = wall.position.x + (wall.dimensions.x/2);
          float wallCenterY = wall.position.y + (wall.dimensions.y/2);
          double wallHalfHeight = wall.dimensions.y/2;
          double wallHalfWidth = wall.dimensions.x/2;
          double distanceBetweenColliders = Math.hypot(collider.position.x - wallCenterX, collider.position.y - wallCenterY);
          
          float testX = collider.position.x;
          float testY = collider.position.y;
          
          if (collider.position.x < wall.position.x) testX = wall.position.x;
          else if (collider.position.x > wall.position.x+wall.dimensions.x) testX = wall.position.x + wall.dimensions.x;
          
          if (collider.position.y < wall.position.y) testY = wall.position.y;
          else if (collider.position.y > wall.position.y + wall.dimensions.y) testY = wall.position.y + wall.dimensions.y;
          
          float distX = collider.position.x - testX;
          float distY = collider.position.y - testY;
          double distance = Math.hypot(distX, distY);
          if (distance <= collider.getRadius()) {
            PVector result = collideRectangleAndBall(
              new PVector(wallCenterX, wallCenterY), new PVector(wall.dimensions.x, wall.dimensions.y),
              collider.position, collider.getRadius()*2, collider.velocity
            );
            result.mult(0.9);
            collider.velocity = result;
          }
        }
        
        if (obj2 instanceof CircleCollider2D && obj2 != first) {
          CircleCollider2D obj2c = (CircleCollider2D) obj2;
          boolean colliding = Math.hypot(abs(obj2c.position.x-collider.position.x), abs(obj2c.position.y-collider.position.y)) <= (obj2c.getRadius()+collider.getRadius());
          if (colliding && !colliders.contains(collider)) {
            colliders.add(collider);
            // Collision
            
            double angleOfCollision = Math.atan2(collider.position.y - obj2c.position.y, collider.position.x - obj2c.position.x);
            
            double distanceBetweenColliders = Math.hypot(collider.position.x - obj2c.position.x, collider.position.y - obj2c.position.y);
            
            double distanceToMove = (obj2c.getRadius()+collider.getRadius()) - distanceBetweenColliders;

            CircleCollider2D target = collider.isMovable() ? collider : obj2c;
            
            target.addVelocity(new PVector((float)(Math.cos(angleOfCollision) * distanceToMove), (float)(Math.sin(angleOfCollision) * distanceToMove)));
          }
        }
      }
    }
    first.step();
  }
  
  //// Draw stage
  //for (Drawable obj : state.objects) {
  //  obj.draw();
  //}
  if (state.game != null) state.game.draw();
}

boolean DEBUG_disableAccelerationRampAndMomentum = false;

void DEBUG_printFrameData(long frameStart, long frameEnd) {
  fill(color(360,0,100));
  textSize(16);
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
  
  textAlign(LEFT);
  text("f="+state.frame + " count=" + state.objects.size() + " msec="+(System.currentTimeMillis()-state.timeStart) + 
  " rate="+((System.currentTimeMillis()-state.timeStart)/state.frame) + 
  " frame_time=" + (frameEnd-frameStart) + " stage="+state.stage + " game="+state.game, 0, 40);
}
