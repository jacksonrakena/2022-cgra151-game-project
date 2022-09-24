interface EntityTexture {
  void draw(PVector position, PVector dimensions);
}

LineSegment[] createPlayerTriangle(float x, float y, float width, float angleDegrees) {
  float nw = width;
  float nh = 1.2*nw;
  
  float halfw = nw/2;
  float halfh = nh/2;
  PVector position = new PVector(x,y);
  float rads = radians(angleDegrees);
  LineSegment[] result = new LineSegment[4];
  PVector v0 = new PVector(0, 0-halfh).rotate(rads).add(position);
  PVector v1 = new PVector(0-halfw, 0+halfh).rotate(rads).add(position);
  PVector v2 = new PVector(0, halfh/2).rotate(rads).add(position);
  PVector v3 = new PVector(0+halfw, 0+halfh).rotate(rads).add(position);
  result[0] = new LineSegment(v0, v1);
  result[1] = new LineSegment(v1, v2);
  result[2] = new LineSegment(v2, v3);
  result[3] = new LineSegment(v3, v0);
  return result;
}

color changeBrightness(color in, float factor) {
  float r = min(255, red(in)*factor);
  float g = min(255, green(in)*factor);
  float b = min(255, blue(in)*factor);
  return color(r,g,b);
}

class ColoredPlayerTexture implements EntityTexture {
  PlayerState player;
  ColoredPlayerTexture(PlayerState p) {
    this.player = p;
  }
  
  void draw(PVector position, PVector dimensions) {
    if (this.player.entity == null) return;
    LineSegment[] textures = createPlayerTriangle(this.player.entity.position.x, this.player.entity.position.y, Globals.playerWidth, this.player.entity.angle);
    
    stroke(this.player.chosenColor);
    strokeWeight(0.25*Globals.playerWidth);

    for (LineSegment l : textures) {
      line(l.origin.x, l.origin.y, l.destination.x, l.destination.y);
    }
  }
}

class PuckEntityTexture implements EntityTexture {
  int baseColor;
  PuckEntityTexture(int base) {
    this.baseColor = base;
  }
  void draw(PVector position, PVector dimensions) {
    noStroke();
    color black = color(0,0,0);
    
    fill(baseColor);
    circle(position.x,position.y,dimensions.x);
    
    fill(black);
    circle(position.x,position.y,dimensions.x*(2.0/3));
    
    fill(baseColor);
    circle(position.x,position.y,dimensions.x*(1.0/3));
  }
}

class DefaultWallTexture implements EntityTexture {
  void draw(PVector position, PVector dimensions) {
    fill(color(0,0,100));
    noStroke();
    rect(position.x, position.y, dimensions.x, dimensions.y);
  }
}
