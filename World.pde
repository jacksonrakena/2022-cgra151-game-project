class World {
  int[][] map;
  
  World(int[][] map) {
    this.map = map;
  }
}

void drawBackground() {
  float tileFactor = tileSize/3;
  int horiz = (int)(width/(tileFactor));
  int vert = (int)(height/(tileFactor));
  for (int v = 0; v < vert+5; v++) {
    for (int h = 0; h < horiz+5; h++) {
      fill(color(bgHue,20+(((float)v/(vert+5))*80),20+(((float)h/(horiz+5))*100)));
      circle(v*tileFactor, h*tileFactor, 5);
    }
  }
}

class Wall implements Drawable {
  float x;
  float y;
  float width;
  float height;
  EntityTexture texture;
 
  Wall(float x, float y, float width, float height, EntityTexture texture) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.texture = texture;
  }
 
  float getX() { return x; }
  float getY() { return y; }
  
  void draw() {
    texture.draw(x,y,width,height);
  }
  
  void step() {
    
  }
}
