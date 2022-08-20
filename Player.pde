class PlayerEntity extends TriangleEntity implements CircleCollider2D {
  color col;
  ControlScheme control;
  float angle = 0;
  
  float getRadius() {
    return 15;
  }
  
  boolean isMovable() { return true; }
  
  void addVelocity(PVector difference) {
    this.velocity.x = max(0-Globals.playerMaximumVelocity, min(Globals.playerMaximumVelocity, this.velocity.x+difference.x));
    this.velocity.y = max(0-Globals.playerMaximumVelocity, min(Globals.playerMaximumVelocity, this.velocity.y+difference.y));
  }
  
  PlayerEntity(PVector startingPosition, ControlScheme control, color c) {
    super(startingPosition);
    this.col = c;
    this.control = control;
  }
  
  void step() {
    super.step();
    float localAcceleration = DEBUG_disableAccelerationRampAndMomentum ? 1 : Globals.playerAccelerationSpeed;
    
    if (control.right()) angle=((angle+5)%360);
    if (control.left()) angle=(angle-5)%360;
    
    float rad = radians(angle+180);
    
    acceleratingStatus = 0;
    if (control.y()) {
      // Calculate the forward vector (in the direction the ship is facing)
      PVector forward = new PVector((float)(-1 * Math.sin(rad)), (float)(Math.cos(rad)));
      
      // Set the acceleration of this vector
      forward.setMag((control.down() ? -1 : 1)*(localAcceleration*Globals.playerMaximumVelocity));
      
      // Add the forward vector to the ship's trajectory
      velocity.add(forward);
      
      // Normalize the vector to a length of maximumVelocity if it's too fast
      if (velocity.mag() >= Globals.playerMaximumVelocity) velocity.setMag(Globals.playerMaximumVelocity);
      
      float vPct = velocity.mag()/Globals.playerMaximumVelocity;
      acceleratingStatus = vPct > 0.3 ? vPct > 0.6 ? 3 : 2 : 1;
    }
  }
  
  void draw() {
    playerTriangle(this.position.x, this.position.y, 30, this.col, angle, acceleratingStatus);
  }
}
