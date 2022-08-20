interface CircleCollider2D extends GameObject2D {
  float getRadius();
  void addVelocity(PVector difference);
  boolean isMovable();
}


/**
  This method calculates and determines collision between the current ball and an arbitrary object,
  described as an entity with an (x,y) coordinate, a width and a height.
  
  Returns a 2D force vector representing the new velocity of the ball.
*/
PVector collideRectangleAndBall(PVector objectPos, 
PVector objectDimensions, 
PVector ballPos, float ballWidth,
PVector ballVelocity) {
  
  float ballRadius = ballWidth/2.0;
  
  // Calculate the half-width and half-height of the object.
  float objectHalfWidth = objectDimensions.x/2.0;
  float objectHalfHeight = objectDimensions.y/2.0;
  
  float ballX = ballPos.x;
  float ballY = ballPos.y;
  float ballVx = ballVelocity.x;
  float ballVy = ballVelocity.y;
  float objectX = objectPos.x;
  float objectY = objectPos.y;
  
  // Collision zone 1 (top)
  if ((ballX - ballRadius) > (objectX - objectHalfWidth) && (ballX + ballRadius) < (objectX + objectHalfWidth)
  && (ballY + ballRadius) > (objectY - objectHalfHeight) && (ballY + ballRadius < objectY)) {
    return new PVector(ballVx, -1 * Math.abs(ballVy));
  }
  
  // Collision zone 5 (bottom)
  else if ((ballX - ballRadius) > (objectX - objectHalfWidth)
    && (ballX + ballRadius < objectX + objectHalfWidth)
    && (ballY - ballRadius) < (objectY + objectHalfHeight)
    && (ballY - ballRadius) > (objectY)) {
      return new PVector(ballVx, Math.abs(ballVy));
  }
  
  // Collision zone 3 (right)
  else if (
    (ballX - ballRadius) < objectX + objectHalfWidth &&
    (ballX - ballRadius) > objectX &&
    (ballY > objectY - objectHalfHeight) &&
    (ballY < objectY + objectHalfHeight)
  ) {
    return new PVector(Math.abs(ballVx), ballVy);
  }
  
  // Collision zone 7 (left)
  else if (
    (ballX + ballRadius) > objectX - objectHalfWidth &&
    (ballX + ballRadius) < objectX &&
    (ballY) > objectY - objectHalfHeight &&
    (ballY) < objectY + objectHalfHeight
  ) {
    println("l");
     return new PVector(-1 * Math.abs(ballVx), ballVy);
  }
  
  // Collision zone 8 (corner in top-left)
  else if ((ballX + ballRadius) > (objectX - objectHalfWidth)
      && (ballX + ballRadius) < (objectX)
      && (ballY + ballRadius) > (objectY - objectHalfHeight)
      && (ballY + ballRadius) < objectY
  ) {
    return new PVector(-1 * Math.abs(ballVx), -1 * Math.abs(ballVy));
  }
  
  // Collision zone 2 (corner in top-right)
  else if (
    (ballX - ballRadius) < (objectX + objectHalfWidth)
    && (ballX - ballRadius) > objectX
    && (ballY + ballRadius) > (objectY - objectHalfHeight)
    && (ballY + ballRadius) < objectY
  ) {
    return new PVector(Math.abs(ballVx), -1 * Math.abs(ballVy));
  }
  
  // Collision zone 6 (corner in bottom-left)
  else if (
    (ballX + ballRadius) > (objectX - objectHalfWidth)
    && (ballX + ballRadius) < objectX
    && (ballY - ballRadius) < (objectY + objectHalfHeight)
    && (ballY - ballRadius) > objectY
  ) {
    return new PVector(-1 * Math.abs(ballVx), Math.abs(ballVy));
  }
  
  // Collision zone 4 (corner in bottom-right)
  else if (
    (ballX -ballRadius) < objectX + objectHalfWidth
    && (ballX-ballRadius) > objectX
    && (ballY-ballRadius) < objectY + objectHalfHeight
    && (ballY-ballRadius) > objectY
  ) {
    return new PVector(Math.abs(ballVx), Math.abs(ballVy));
  }
  
  return new PVector(ballVx, ballVy);
}
