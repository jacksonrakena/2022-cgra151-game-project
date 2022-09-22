import java.util.Arrays;
import java.util.Stack;

class GameState {
  Stage stage;
  Stack<Game> history = new Stack<Game>();
  long introStartTime = 0;
  ArrayList<Drawable> objects = new ArrayList<Drawable>();
  ArrayList<Integer> colors = new ArrayList<Integer>();
  long frame;
  long timeStart;
  Game game;
  
  ArrayList<PlayerState> allPlayers = new ArrayList<PlayerState>();
  
  PlayerState player1() { return allPlayers.get(0); }
  PlayerState player2() { return allPlayers.get(1); }
}

void switchGame(Game g) {
  if (state.game.getName() == null) state.history.push(state.game);
  switchGameNoSave(g);
}

void switchGameNoSave(Game g) {
  state.game = g;
  state.stage = Stage.Load;
}

enum Stage {
  Load,
  Paused,
  Play
}


static class Globals {
  static final float playerMaximumVelocity = 5;
  static final float playerAccelerationSpeed = 0.05;
  static final int backgroundCycleLength = 400;
  static final boolean debugMode = true;
  static ArrayList<Integer> colors;
  static long getTotalGameTimeMillis(GameState st) {
    return System.currentTimeMillis() - st.timeStart;
  }
  static int clickX;
  static int clickY;
}

class PlayerState {
  ControlScheme controlScheme;
  color chosenColor;
  long lastFrameChanged = 0;
  int requiredChangeGap = 10;
  PlayerEntity entity;
  
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
