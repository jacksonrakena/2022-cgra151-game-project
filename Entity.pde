interface GameObject {
  void step();
  float getX();
  float getY();
}


interface CircleCollider extends GameObject {
  float getRadius();
  boolean colliding(CircleCollider other);
  void changeX(float differential);
  void changeY(float differential);
  boolean isMovable();
  float getVx();
  float getVy();
  void setVx(float newVy);
  void setVy(float newVy);
}

interface Drawable extends GameObject {
  void draw();
}

class Entity implements GameObject, Drawable, CircleCollider {
  float x;
  float y;
  float vx = 0;
  float vy = 0;
  float momentumCoefficient = 0.99;
  float maximumVelocity = 5;
  float acceleration = 0.05;
  float width;
  EntityTexture texture;
  
  Entity(float x, float y, float width, EntityTexture texture) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.texture = texture;
  }
  
  boolean isMovable() { return true; }
  
  float getRadius() { return this.width/2; }
  
  float getVx() { return vx; }
  float getVy() { return vy; }
  
  
  void setVx(float newVx) { this.vx = newVx; }
  void setVy(float newVy) { this.vy = newVy; }
  
  boolean colliding(CircleCollider other) {
    return Math.hypot(abs(this.getX()-other.getX()), abs(this.getY()-other.getY())) <= (this.getRadius()+other.getRadius());
  }
  
  void changeX(float differential) {
    this.vx = max(0-maximumVelocity, min(maximumVelocity, this.vx+differential));
  }
  
  void changeY(float differential) {
    this.vy = max(0-maximumVelocity, min(maximumVelocity, this.vy+differential));
  }
  
  void step() {
    this.x += vx;
    this.y += vy;
    
    if (!DEBUG_disableAccelerationRampAndMomentum) this.vx *= momentumCoefficient;
    else this.vx = 0;
    
    if (abs(this.vx) < 0.05) this.vx = 0;
    
    if (!DEBUG_disableAccelerationRampAndMomentum) this.vy *= momentumCoefficient;
    else this.vy = 0;
    
    if (abs(this.vy) < 0.05) this.vy = 0;
  }
  
  void draw() {
    float nw = 30;
    float nh = 1.2*nw;
    
    float halfw = nw/2;
    float halfh = nh/2;
    
    stroke(255);
    //stroke(color(random(0,360),80,100));
    line(x, y-halfh, x-halfw, y+halfh);
    line(x-halfw, y+halfh, x, (y+(halfh/2)));
    line(x, (y+(halfh/2)), x+halfw, y+halfh);
    line(x+halfw, y+halfh, x, y-halfh);
    
    //texture.draw(x, y, this.width, this.width);
    //image(playerimg, x, y);
  }
  
  float getX() { return x; }
  float getY() { return y; }
}

class PlayableEntity extends Entity {
  ControlScheme control;
  
  PVector velocity = new PVector(0,0);
  float angle = 0;
  PVector direction = new PVector(0,-10);
  
  int acceleratingStatus = 0;
  
  color col;
  PlayableEntity(float x, float y, ControlScheme control, color c) {
    super(x,y, 25, new ColoredPlayerTexture());
    this.x = x;
    this.y = y;
    this.col = c;
    this.control = control;
  }
  void step() {
    x += velocity.x;
    y += velocity.y;
    
    float localAcceleration = DEBUG_disableAccelerationRampAndMomentum ? 1 : acceleration;
    
    if (control.right()) angle=((angle+5)%360);
    if (control.left()) angle=(angle-5)%360;
    
    float rad = radians(angle+180);
    
    acceleratingStatus = 0;
    if (control.y()) {
      // Calculate the forward vector (in the direction the ship is facing)
      PVector forward = new PVector((float)(-1 * Math.sin(rad)), (float)(Math.cos(rad)));
      
      // Set the acceleration of this vector
      forward.setMag((control.down() ? -1 : 1)*(localAcceleration*maximumVelocity));
      
      // Add the forward vector to the ship's trajectory
      velocity.add(forward);
      
      // Normalize the vector to a length of maximumVelocity if it's too fast
      if (velocity.mag() >= maximumVelocity) velocity.setMag(maximumVelocity);
      
      float vPct = velocity.mag()/maximumVelocity;
      acceleratingStatus = vPct > 0.3 ? vPct > 0.6 ? 3 : 2 : 1;
    }
    
    // Apply momentum
    velocity = velocity.mult(momentumCoefficient);
  }
  
  void changeV(float differential) {
    velocity.setMag(differential*velocity.mag());
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    stroke(this.col);
    strokeWeight(6);
    //stroke(color(random(0,360),80,100));
    float nw = 30;
    float nh = 1.2*nw;
    
    float halfw = nw/2;
    float halfh = nh/2;
    line(0, 0-halfh, 0-halfw, 0+halfh);
    line(0-halfw, 0+halfh, 0, (0+(halfh/2)));
    line(0, (0+(halfh/2)), 0+halfw, 0+halfh);
    line(0+halfw, 0+halfh, 0, 0-halfh);
    strokeWeight(0);
    if (acceleratingStatus != 0) {
      for (int i = 0; i < acceleratingStatus; i++) {
        fill(color(i == 0 ? 55 : i == 1 ? 46 : 0 , 100, 100));
        circle(0, 0+(nh-10)+(i*15), 10);
      }
    }
    strokeWeight(0);
    popMatrix();
  }
  
}

// old circle code
class CircleEntity implements GameObject, Drawable, CircleCollider {
  float x;
  float y;
  float vx = 0;
  float vy = 0;
  float momentumCoefficient = 0.98;
  float maximumVelocity = 5;
  float acceleration = 0.05;
  float width;
  EntityTexture texture;
  
  CircleEntity(float x, float y, float width, EntityTexture texture) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.texture = texture;
  }
  
  boolean isMovable() { return true; }
  
  float getRadius() { return this.width/2; }
  
  float getVx() { return vx; }
  float getVy() { return vy; }
  
  void setVx(float newVx) { this.vx = newVx; }
  void setVy(float newVy) { this.vy = newVy; }
  
  boolean colliding(CircleCollider other) {
    return Math.hypot(abs(this.getX()-other.getX()), abs(this.getY()-other.getY())) <= (this.getRadius()+other.getRadius());
  }
  
  void changeX(float differential) {
    this.vx = max(0-maximumVelocity, min(maximumVelocity, this.vx+differential));
  }
  
  void changeY(float differential) {
    this.vy = max(0-maximumVelocity, min(maximumVelocity, this.vy+differential));
  }
  
  void step() {
    this.x += vx;
    this.y += vy;
    
    if (!DEBUG_disableAccelerationRampAndMomentum) this.vx *= momentumCoefficient;
    else this.vx = 0;
    
    if (abs(this.vx) < 0.05) this.vx = 0;
    
    if (!DEBUG_disableAccelerationRampAndMomentum) this.vy *= momentumCoefficient;
    else this.vy = 0;
    
    if (abs(this.vy) < 0.05) this.vy = 0;
  }
  
  void draw() {
    texture.draw(x, y, this.width, this.width);
  }
  
  float getX() { return x; }
  float getY() { return y; }
}

// old circle code
//class Entity implements GameObject, Drawable, CircleCollider {
//  float x;
//  float y;
//  float vx = 0;
//  float vy = 0;
//  float momentumCoefficient = 0.98;
//  float maximumVelocity = 5;
//  float acceleration = 0.05;
//  float width;
//  EntityTexture texture;
  
//  Entity(float x, float y, float width, EntityTexture texture) {
//    this.x = x;
//    this.y = y;
//    this.width = width;
//    this.texture = texture;
//  }
  
//  boolean isMovable() { return true; }
  
//  float getRadius() { return this.width/2; }
  
//  float getVx() { return vx; }
//  float getVy() { return vy; }
  
//  void setVx(float newVx) { this.vx = newVx; }
//  void setVy(float newVy) { this.vy = newVy; }
  
//  boolean colliding(CircleCollider other) {
//    return Math.hypot(abs(this.getX()-other.getX()), abs(this.getY()-other.getY())) <= (this.getRadius()+other.getRadius());
//  }
  
//  void changeX(float differential) {
//    this.vx = max(0-maximumVelocity, min(maximumVelocity, this.vx+differential));
//  }
  
//  void changeY(float differential) {
//    this.vy = max(0-maximumVelocity, min(maximumVelocity, this.vy+differential));
//  }
  
//  void step() {
//    this.x += vx;
//    this.y += vy;
    
//    if (!DEBUG_disableAccelerationRampAndMomentum) this.vx *= momentumCoefficient;
//    else this.vx = 0;
    
//    if (abs(this.vx) < 0.05) this.vx = 0;
    
//    if (!DEBUG_disableAccelerationRampAndMomentum) this.vy *= momentumCoefficient;
//    else this.vy = 0;
    
//    if (abs(this.vy) < 0.05) this.vy = 0;
//  }
  
//  void draw() {
//    texture.draw(x, y, this.width, this.width);
//  }
  
//  float getX() { return x; }
//  float getY() { return y; }
//}

//class PlayableEntity extends Entity {
//  ControlScheme control;
  
//  PlayableEntity(float x, float y, ControlScheme control) {
//    super(x,y, 25, new ColoredEntityTexture());
//    this.x = x;
//    this.y = y;
//    this.control = control;
//  }

//  void step() {
//    super.step();
//    float localAcceleration = DEBUG_disableAccelerationRampAndMomentum ? 1 : acceleration;
//    if (control.left()) changeX(0-(localAcceleration*maximumVelocity));
//    if (control.right()) changeX((localAcceleration*maximumVelocity));
//    if (control.up()) changeY(0-(localAcceleration*maximumVelocity));
//    if (control.down()) changeY((localAcceleration*maximumVelocity));
//  }
//}
