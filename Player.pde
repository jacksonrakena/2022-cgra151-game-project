class PlayerEntity extends TriangleEntity  {
  PlayerState state;
  
  
  void addVelocity(PVector difference) {
    this.velocity.x = max(0-Globals.playerMaximumVelocity, min(Globals.playerMaximumVelocity, this.velocity.x+difference.x));
    this.velocity.y = max(0-Globals.playerMaximumVelocity, min(Globals.playerMaximumVelocity, this.velocity.y+difference.y));
  }
  
  PlayerEntity(PlayerState state, PVector startingPosition) {
    super(startingPosition, new PVector(Globals.playerWidth, 0), new ColoredPlayerTexture(state));
    this.state = state;
  }
  
  PVector calculateForwardVector() {
    return new PVector((float)(-1 * Math.sin(radians(angle+180))), (float)(Math.cos(radians(angle+180))));
  }
  
  void step() {
    super.step();
    float localAcceleration = DEBUG_disableAccelerationRampAndMomentum ? 1 : Globals.playerAccelerationSpeed;
    
    if (this.state.controlScheme.right()) angle=((angle+5)%360);
    if (this.state.controlScheme.left()) angle=(angle-5)%360;
    
    float rad = radians(angle+180);
    
    acceleratingStatus = 0;
    if (this.state.controlScheme.y()) {
      // Calculate the forward vector (in the direction the ship is facing)
      PVector forward = new PVector((float)(-1 * Math.sin(rad)), (float)(Math.cos(rad)));
      
      // Set the acceleration of this vector
      forward.setMag((this.state.controlScheme.down() ? -1 : 1)*(localAcceleration*Globals.playerMaximumVelocity));
      
      // Add the forward vector to the ship's trajectory
      velocity.add(forward);
      
      // Normalize the vector to a length of maximumVelocity if it's too fast
      if (velocity.mag() >= Globals.playerMaximumVelocity) velocity.setMag(Globals.playerMaximumVelocity);
      
      float vPct = velocity.mag()/Globals.playerMaximumVelocity;
      acceleratingStatus = vPct > 0.3 ? vPct > 0.6 ? 3 : 2 : 1;
    }
  }
  
  void draw() {
    super.draw();
  }
}
