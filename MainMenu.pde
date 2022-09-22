class MainMenu extends Game {
  String getName() { return null; }
  String getDescription() { return null; }
  void draw() {
    textSize(20);
    
    textAlign(CENTER);
    fill(0,0,100);
    textSize(40);
    text("COSMOS CONFLICT", 0.5*width, 0.1*height);
    
    float buttonStartingH = 0.3*height;
    float buttonW = 0.3*width;
    float buttonStartingWidth = (width-buttonW)/2;
    
    button(buttonStartingWidth, buttonStartingH, buttonW, 100, "PLAY", new GameSelect());
    button(buttonStartingWidth, buttonStartingH+150, buttonW, 100, "CONTROLS", new ControlsMenu());
    button(buttonStartingWidth, buttonStartingH+300, buttonW, 100, "QUIT", null);
  }
  
  void init() {}
}

class ControlsMenu extends Game {
  String getName() { return null; }
  String getDescription() { return null; }
  void draw() {
    textAlign(CENTER);
    fill(0,0,100);
    textSize(40);
    text("THE CONTROLS", 0.5*width, 0.1*height);
    
    textSize(25);
    String player1 = "Player 1 (the leftie), uses W-A-S-D, and the SPACE BAR to shoot.";
    String player2 = "Player 2 (the rightie) uses the arrow-keys to move, and the CONTROL key to shoot.";
    String shoot = "Shooting is only available in some games.";
    String separator = "\n\n";
    text(player1+separator+player2+separator+shoot+separator+separator+"Press backspace at any time to go back.", 0.1*width, 0.3*height, 0.8*width, 0.7*height);
  }
  
  void init() {}
}
