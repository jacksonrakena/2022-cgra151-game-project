void playerTriangle(float x, float y, float width, color c, float angleDegrees, int acceleratingStatus) {
  pushMatrix();
  translate(x, y);
  stroke(c);
  strokeWeight(8);
  rotate(radians(angleDegrees));
  float nw = width;
  float nh = 1.2*nw;
  
  float halfw = nw/2;
  float halfh = nh/2;
  line(0, 0-halfh, 0-halfw, 0+halfh);
  line(0-halfw, 0+halfh, 0, (0+(halfh/2)));
  line(0, (0+(halfh/2)), 0+halfw, 0+halfh);
  line(0+halfw, 0+halfh, 0, 0-halfh);
  strokeWeight(0);
  if (acceleratingStatus != 0) {
      for (int i = 0; i < acceleratingStatus; i++) {
        fill(color(i == 0 ? 55 : i == 1 ? 46 : 0 , 100, 100));
        circle(0, 0+(nh-10)+(i*15), 10);
      }
  }
  popMatrix();
}

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
  int baseColor;
  PuckEntityTexture(int base) {
    this.baseColor = base;
  }
  void draw(float x, float y, float width, float height) {
    color black = color(0,0,0);
    
    fill(baseColor);
    circle(x,y,width);
    
    fill(black);
    circle(x,y,width*(2.0/3));
    
    fill(baseColor);
    circle(x,y,width*(1.0/3));
  }
}

class DefaultWallTexture implements EntityTexture {
  void draw(float x, float y, float width, float height) {
    fill(color(0,0,100));
    rect(x,y,width,height);
  }
}
