import java.util.Map;

boolean[] inputs = new boolean[400];

void keyPressed() {
  if (keyCode < inputs.length) inputs[keyCode] = true;
}

void keyReleased() {
  if (keyCode < inputs.length) inputs[keyCode] = false;
}

boolean getInput(int keyCode) {
  return keyCode < inputs.length && inputs[keyCode];
}

class ControlScheme {
  int moveLeft;
  int moveRight;
  int moveUp;
  int moveDown;
  ControlScheme(int moveLeft, int moveRight, int moveUp, int moveDown) {
    this.moveLeft = moveLeft;
    this.moveRight = moveRight;
    this.moveUp = moveUp;
    this.moveDown = moveDown;
  }
  boolean x() { return left() || right(); }
  boolean y() { return up() || down(); }
  boolean left() { return getInput(this.moveLeft); }
  boolean right() { return getInput(this.moveRight); }
  boolean up() { return getInput(this.moveUp); }
  boolean down() { return getInput(this.moveDown); } 
}
