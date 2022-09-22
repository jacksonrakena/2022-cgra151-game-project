interface Drawable {
  void draw();
  void step();
}

interface PhysicsObject extends Drawable {
  PVector getVelocity();
  PVector getPosition();
  void setVelocity(PVector n);
  void setPosition(PVector n);
}

abstract class GameObject2D implements PhysicsObject {
  abstract PVector getVelocity();
  abstract PVector getPosition();
  abstract void setVelocity(PVector n);
  abstract void setPosition(PVector n);
}

class Entity2D extends GameObject2D {
   PVector velocity = new PVector(0,0);
   PVector position = new PVector(0,0);
   
   Entity2D(PVector startingPosition) {
     this.position = startingPosition;
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
     
   }
   
   void draw() {
     
   }
}

class TriangleEntity extends Entity2D {
  float momentumCoefficient = 0.99;
  int acceleratingStatus = 0;
  
  TriangleEntity(PVector startingPosition) {
    super(startingPosition);
  }
  
  void step() {
    super.step();
    this.position.add(this.velocity);
    
    // Apply momentum
    velocity = velocity.mult(momentumCoefficient);
  }
  
  void draw() {
    super.draw();
  }
}

class CircleEntity2D extends Entity2D implements CircleCollider2D {
  float momentumCoefficient = 0.98;
  float maximumVelocity = 5;
  float acceleration = 0.05;
  float width;
  EntityTexture texture;
  boolean disabled = false;
  
  CircleEntity2D(PVector startingPosition, float width, EntityTexture texture) {
    super(startingPosition);

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
    texture.draw(this.position.x, this.position.y, this.width, this.width);
  }
}
