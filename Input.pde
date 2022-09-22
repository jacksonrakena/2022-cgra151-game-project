import java.util.Map;

boolean[] inputs = new boolean[400];
Map<Integer, Long> inputDebouncing = new HashMap<Integer,Long>();
long debouncingDelay = 10;

void keyPressed() {
  if (keyCode < inputs.length) inputs[keyCode] = true;
}

void keyReleased() {
  if (keyCode < inputs.length) inputs[keyCode] = false;
}

boolean getInput(int keyCode) {
  return keyCode < inputs.length && inputs[keyCode];
}

/**
  Returns true if the selected input is pressed,
  and it has also been [debouncingDelay] frames since the last press.
*/
boolean getInputDebounced(int keyCode) {
  if (!getInput(keyCode)) return false;
  if (inputDebouncing.containsKey(keyCode)) {
    if (state.frame > inputDebouncing.get(keyCode) + debouncingDelay) {
      inputDebouncing.put(keyCode,state.frame);
      return true;
    }
    return false;
  } else {
    inputDebouncing.put(keyCode, state.frame);
    return true;
  }
}

void mousePressed(MouseEvent event) {
  Globals.clickX = event.getX();
  Globals.clickY = event.getY();
}
void mouseReleased() {
  Globals.clickX = 0;
  Globals.clickY = 0;
}

boolean regionClicked(float x1, float y1, float w, float h) {
  return Globals.clickX > x1 && Globals.clickX < x1+w && Globals.clickY > y1 && Globals.clickY < y1+h;
}

class ControlScheme {
  int moveLeft;
  int moveRight;
  int moveUp;
  int moveDown;
  int fire;
  ControlScheme(int moveLeft, int moveRight, int moveUp, int moveDown, int fire) {
    this.moveLeft = moveLeft;
    this.moveRight = moveRight;
    this.moveUp = moveUp;
    this.moveDown = moveDown;
    this.fire = fire;
  }
  boolean x() { return left() || right(); }
  boolean y() { return up() || down(); }
  boolean left() { return getInput(this.moveLeft); }
  boolean right() { return getInput(this.moveRight); }
  boolean up() { return getInput(this.moveUp); }
  boolean down() { return getInput(this.moveDown); } 
  boolean fire() { return getInput(this.fire); }
}
