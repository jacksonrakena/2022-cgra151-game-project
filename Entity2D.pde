interface Drawable {
  void draw();
  void step();
  boolean enabled();
}

interface PhysicsObject extends Drawable {
  PVector getVelocity();
  PVector getPosition();
  void setVelocity(PVector n);
  void setPosition(PVector n);
  long getLifetime();
}
abstract class Entity2D implements PhysicsObject {
   PVector velocity = new PVector(0,0);
   PVector position = new PVector(0,0);
   PVector dimensions;
   EntityTexture texture;
   long lifetime = 0;
   long lastOperationFrame = 0;
   Entity2D(PVector startingPosition, PVector dimensions, EntityTexture texture) {
     this.position = startingPosition;
     this.dimensions = dimensions;
     this.texture = texture;
   }
   
   void setVelocity(PVector n) {
      this.velocity = n;
   }
   
   public void setPosition(PVector n) {
      this.position = n;
   }
   
   PVector getVelocity() { return this.velocity; }
   PVector getPosition() { return this.position; }
   
   void step() {
     this.lifetime++;
   }
   long getLifetime() { return this.lifetime; }
   void draw() {
     this.texture.draw(this.position, this.dimensions);
   }
}

class TriangleEntity extends Entity2D implements BoxCollider {
  float momentumCoefficient = 0.97;
  int acceleratingStatus = 0;
  float angle = 0;
  
  TriangleEntity(PVector startingPosition, PVector dimensions, EntityTexture texture) {
    super(startingPosition, dimensions, texture);
  }
  
  void step() {
    super.step();
    this.position.add(this.velocity);
    
    // Apply momentum
    velocity = velocity.mult(momentumCoefficient);
  }
  
  LineSegment[] getCollidableSegments() {
    return createPlayerTriangle(this.position.x, this.position.y, this.dimensions.x, this.angle);
  }
  
  boolean enabled() { return true; }
  
  void draw() {
    super.draw();
  }
}

abstract class CircleEntity2D extends Entity2D implements CircleCollider2D {
  float momentumCoefficient = 0.98;
  float maximumVelocity = 5;
  float acceleration = 0.05;
  float width;
  EntityTexture texture;
  boolean disabled = false;
  
  CircleEntity2D(PVector startingPosition, float width, EntityTexture texture) {
    super(startingPosition, new PVector(width, width), texture);

    this.width = width;
    this.texture = texture;
  }
  
  boolean isMovable() { return true; }
  
  float getRadius() { return this.width/2; }
  
  void setMomentum(float m) {
    this.momentumCoefficient = m;
  }
  
    
  void addVelocity(PVector difference) {
    this.velocity.x = max(0-maximumVelocity, min(maximumVelocity, this.velocity.x+difference.x));
    this.velocity.y = max(0-maximumVelocity, min(maximumVelocity, this.velocity.y+difference.y));
  }
  
  boolean colliding(CircleCollider2D other) {
    if (disabled || (other instanceof CircleEntity2D && ((CircleEntity2D) other).disabled)) return false;
    return Math.hypot(abs(this.position.x-other.getPosition().x), abs(this.position.y-other.getPosition().y)) <= (this.getRadius()+other.getRadius());
  }
  
  void step() {
    if (disabled) return;
    this.position.add(this.velocity);
    
    if (!DEBUG_disableAccelerationRampAndMomentum) this.velocity.x *= momentumCoefficient;
    else this.velocity.x = 0;
    
    if (abs(this.velocity.x) < 0.05) this.velocity.x = 0;
    
    if (!DEBUG_disableAccelerationRampAndMomentum) this.velocity.y *= momentumCoefficient;
    else this.velocity.y = 0;
    
    if (abs(this.velocity.y) < 0.05) this.velocity.y = 0;
  }
  
  void draw() {
    if (disabled) return;
    super.draw();
  }
}
