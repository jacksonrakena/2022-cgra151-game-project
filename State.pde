import java.util.Arrays;

class GameState {
  Stage stage = Stage.CharacterSelect;
  ArrayList<Drawable2D> objects = new ArrayList<>();
  ArrayList<Integer> colors = new ArrayList<>();
  int frame;
  long timeStart;
  
  PlayerState player1;
  PlayerState player2;
}

enum Stage {
  Play,
  Load,
  Pause,
  CharacterSelect
}

static class Globals {
  static final float playerMaximumVelocity = 5;
  static final float playerAccelerationSpeed = 0.05;
  static final boolean debugMode = true;
  static ArrayList<Integer> colors;
}

class PlayerState {
  ControlScheme controlScheme;
  color chosenColor;
  int lastFrameChanged = 0;
  int requiredChangeGap = 10;
  
  PlayerState(ControlScheme control, color c) {
    this.controlScheme = control;
    this.chosenColor = c;
  }
  
  void previousColor() {
    if ((state.frame - lastFrameChanged) > requiredChangeGap) {
      chosenColor = Globals.colors.get(Globals.colors.indexOf(chosenColor) == 0 ? Globals.colors.size()-1 : Globals.colors.indexOf(chosenColor)-1);
      lastFrameChanged = state.frame;
    }
  }
  
  void nextColor() {
    if ((state.frame - lastFrameChanged) > requiredChangeGap) {
      chosenColor = Globals.colors.get(Globals.colors.indexOf(chosenColor) == 0 ? Globals.colors.size()-1 : Globals.colors.indexOf(chosenColor)-1);
      lastFrameChanged = state.frame;
    }
  }
}
