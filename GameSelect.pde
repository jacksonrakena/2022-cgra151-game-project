class GameSelect extends Game {
  String getName() { return null; }
  String getDescription() { return null; }
  void draw() {
    textSize(20);
    float sectionStart = 0.1*width;
    float sectionWidth = width-(sectionStart*2);
    float sectionSeparator = 0.2*sectionWidth;
    float vheight = 0.5*height;
    float selectSize = (sectionWidth-sectionSeparator)/2;
    
    textAlign(CENTER);
    fill(0,0,100);
    textSize(40);
    text("Choose your color", 0.5*width, 0.1*height);
    textSize(20);
    fill(0,0,100);
    PlayerState p1 = state.allPlayers.get(0);
    text("Player 1", sectionStart+(selectSize/2), (0.2*vheight)+selectSize+25);
    text("Use A and D to change", sectionStart+(selectSize/2), (0.2*vheight)+selectSize+50);
    playerTriangle((0.2*width)+(selectSize/4), (0.2*vheight)+(selectSize/2), 80, p1.chosenColor, state.frame%360, 0);
    PlayerState p2 = state.allPlayers.get(1);
    text("Player 2", (sectionStart+selectSize+sectionSeparator)+(selectSize/2), (0.2*vheight)+selectSize+25);
    text("Use left and right arrow to change", (sectionStart+selectSize+sectionSeparator)+(selectSize/2), (0.2*vheight)+selectSize+50);
    playerTriangle((0.2*width)+(sectionSeparator)+(selectSize)+(selectSize/4), (0.2*vheight)+(selectSize/2), 80, p2.chosenColor, state.frame%360, 0);
    
    for (PlayerState p : state.allPlayers) {
      if (p.controlScheme.left()) p.previousColor();
      if (p.controlScheme.right()) p.nextColor();
    }
    
    drawGameSelectSection();
  }
 
  
  void drawGameSelectSection() {
    fill(0,0,100);
    textSize(40);
    text("Choose your event", 0.5*width, 0.55*height);
    textSize(20);
    float gameSelectStartH = (0.6*height);
    float gameSelectSectionH = (height-gameSelectStartH);
    float gameSelectBoxHeight = 0.8*gameSelectSectionH;
    float gameSelectStartW = 0.1*width;
    float widthOfGSelectBox = (width-(gameSelectStartW*2))/(gameOptions.size());
    for (int i = 0; i < gameOptions.size(); i++) {
      Game g = gameOptions.get(i);
      
      float x = gameSelectStartW+(i*(widthOfGSelectBox));
      float y = gameSelectStartH;
      float w = widthOfGSelectBox-(20/(gameOptions.size()-1));
      float h = gameSelectBoxHeight;
      
      if (regionClicked(x,y,w,h)) {
        switchGame(g);
      }
      fill(0,0,100);
      rect(x, y, w, h);
      fill(color(0,0,0));
      
      float textPadding = 0.95;
      text("\"" + g.getName() + "\"", x+(w/2), y+(0.3*h));
      text(g.getDescription(), x+(((1-textPadding)/2)*w), y+(0.3*h)+10, textPadding*w, h/2);
    }
  }
  
  void init() {
    state.objects.clear();
  }
}
