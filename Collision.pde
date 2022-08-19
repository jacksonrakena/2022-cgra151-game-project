class BallObjectCollisionResult {
  float newVx;
  float newVy;
  BallObjectCollisionResult(float newVx, float newVy) {
    this.newVx = newVx;
    this.newVy = newVy;
  }
}

/**
  This method calculates and determines collision between the current ball and an arbitrary object,
  described as an entity with an (x,y) coordinate, a width and a height.
*/
BallObjectCollisionResult handleCollisionBetweenObjectAndBall(float objectX, float objectY, 
float objectWidth, float objectHeight, 
float ballX, float ballY, float ballWidth,
float ballVx, float ballVy) {
  float ballRadius = ballWidth/2.0;
  
  // Calculate the half-width and half-height of the object.
  float objectHalfWidth = objectWidth/2.0;
  float objectHalfHeight = objectHeight/2.0;
  
  
  // Collision zone 1 (top)
  if ((ballX - ballRadius) > (objectX - objectHalfWidth) && (ballX + ballRadius) < (objectX + objectHalfWidth)
  && (ballY + ballRadius) > (objectY - objectHalfHeight) && (ballY + ballRadius < objectY)) {
     return new BallObjectCollisionResult(0, -1 * Math.abs(ballVy));
  }
  
  // Collision zone 5 (bottom)
  else if ((ballX - ballRadius) > (objectX - objectHalfWidth)
    && (ballX + ballRadius < objectX + objectHalfWidth)
    && (ballY - ballRadius) < (objectY + objectHalfHeight)
    && (ballY - ballRadius) > (objectY)) {
     return new BallObjectCollisionResult(ballVx, Math.abs(ballVy));
  }
  
  // Collision zone 3 (right)
  else if (
    (ballX - ballRadius) < objectX + objectHalfWidth &&
    (ballX - ballRadius) > objectX &&
    (ballY > objectY - objectHalfHeight) &&
    (ballY < objectY + objectHalfHeight)
  ) {
      return new BallObjectCollisionResult(Math.abs(ballVx), ballVy);
  }
  
  // Collision zone 7 (left)
  else if (
    (ballX + ballRadius) > objectX - objectHalfWidth &&
    (ballX + ballRadius) < objectX &&
    (ballY) > objectY - objectHalfHeight &&
    (ballY) < objectY + objectHalfHeight
  ) {
     return new BallObjectCollisionResult(-1 * Math.abs(ballVx), ballVy);
  }
  
  // Collision zone 8 (corner in top-left)
  else if ((ballX + ballRadius) > (objectX - objectHalfWidth)
      && (ballX + ballRadius) < (objectX)
      && (ballY + ballRadius) > (objectY - objectHalfHeight)
      && (ballY + ballRadius) < objectY
  ) {
    return new BallObjectCollisionResult(-1 * Math.abs(ballVx), -1 * Math.abs(ballVy));
  }
  
  // Collision zone 2 (corner in top-right)
  else if (
    (ballX - ballRadius) < (objectX + objectHalfWidth)
    && (ballX - ballRadius) > objectX
    && (ballY + ballRadius) > (objectY - objectHalfHeight)
    && (ballY + ballRadius) < objectY
  ) {
    return new BallObjectCollisionResult(Math.abs(ballVx), -1 * Math.abs(ballVy));
  }
  
  // Collision zone 6 (corner in bottom-left)
  else if (
    (ballX + ballRadius) > (objectX - objectHalfWidth)
    && (ballX + ballRadius) < objectX
    && (ballY - ballRadius) < (objectY + objectHalfHeight)
    && (ballY - ballRadius) > objectY
  ) {
    return new BallObjectCollisionResult(-1 * Math.abs(ballVx), Math.abs(ballVy));
  }
  
  // Collision zone 4 (corner in bottom-right)
  else if (
    (ballX -ballRadius) < objectX + objectHalfWidth
    && (ballX-ballRadius) > objectX
    && (ballY-ballRadius) < objectY + objectHalfHeight
    && (ballY-ballRadius) > objectY
  ) {
    return new BallObjectCollisionResult(Math.abs(ballVx), Math.abs(ballVy));
  }
  
  return new BallObjectCollisionResult(ballVx, ballVy);
}
