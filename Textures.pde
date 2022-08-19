interface EntityTexture {
  void draw(float x, float y, float width, float height);
}

color changeBrightness(color in, float factor) {
  float r = min(255, red(in)*factor);
  float g = min(255, green(in)*factor);
  float b = min(255, blue(in)*factor);
  return color(r,g,b);
}

class ColoredPlayerTexture implements EntityTexture {
  color c;
  ColoredPlayerTexture() {
    this.c = color(random(0,360),80,100);
  }
  
  void draw(float x, float y, float width, float height) {
    
  }
}

class PuckEntityTexture implements EntityTexture {
  void draw(float x, float y, float width, float height) {
    color inner = color(228, 48, 69);
    color outer = color(228, 74, 61);
    color black = color(0,0,0);
    
    fill(outer);
    circle(x,y,width);
    
    fill(black);
    circle(x,y,width*(2.0/3));
    
    fill(inner);
    circle(x,y,width*(1.0/3));
  }
}

class DefaultWallTexture implements EntityTexture {
  void draw(float x, float y, float width, float height) {
    fill(color(0,0,100));
    rect(x,y,width,height);
  }
}
