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

void debug_printInputs() {
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
