interface GameEvent {
  void draw();
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

class Wall implements Drawable2D {
  PVector dimensions;
  PVector position;
  EntityTexture texture;
 
  Wall(float x, float y, float width, float height, EntityTexture texture) {
    this.dimensions = new PVector(width, height);
    this.position = new PVector(x, y);
    this.texture = texture;
  }

  void step() {}
  void draw() {
    texture.draw(position.x,position.y,dimensions.x,dimensions.y);
  }
}
