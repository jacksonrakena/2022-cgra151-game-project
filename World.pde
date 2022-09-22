class BgStar {
  int x;
  int y;
  float w;
  float h;
  long duration;
  long currentFrame;
  boolean destroyed;
  void cp_star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle/2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  void stepAndDraw() {
    currentFrame++;
    if (currentFrame > duration) {
      this.destroyed = true;
    }
    
    if (!this.destroyed) {
      fill(0,0,100,75);
      double pg = (currentFrame == 0 ? 1 : currentFrame)/(float)this.duration;
      float width = (float)(this.w*(sin((float)((Math.PI)*pg))));
      float height = (float)(this.h*(sin((float)((Math.PI)*pg))));
      cp_star(this.x, this.y, (width+height)/2, 0.4*((width+height)/2), 5);

    }
  }
  
  public BgStar(int x, int y, float w, float h, long duration, long durationOffset) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.duration = duration;
    this.currentFrame = durationOffset;
  }
}
ArrayList<BgStar> stars;

float rand(float min, float max) {
  return (float) ((Math.random()*(max-min))+min);
}
int randInt(int min, int max) {
  return (int) Math.floor((Math.random()*(max-min))+min);
}
void drawBackground() {
  float starWmin = 5;
  float starWmax = 12;
  float starHmin = 5;
  float starHmax = 12;
  
  float progressionPct = (state.frame%Globals.backgroundCycleLength)/(float)Globals.backgroundCycleLength;
  if (stars == null) {
    stars = new ArrayList<BgStar>();
    for (int i = 0; i < 20; i++) {
      stars.add(new BgStar((int) Math.floor(Math.random()*width), (int) Math.floor(Math.random()*height), rand(starWmin, starWmax), rand(starHmin, starHmax), Globals.backgroundCycleLength, (long)(Math.random()*Globals.backgroundCycleLength)));
    }
  }
  ArrayList<BgStar> newStars = new ArrayList<BgStar>();
  for (BgStar s : stars) {
    s.stepAndDraw();
    if (s.destroyed) {
      newStars.add(new BgStar((int) Math.floor(Math.random()*width), (int) Math.floor(Math.random()*height), rand(starWmin, starWmax), rand(starHmin, starHmax), Globals.backgroundCycleLength, 0));
    } else newStars.add(s);
  }
  stars = newStars;
}

class Wall implements Drawable {
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

void button(float x, float y, float w, float h, String label, Game action) {
  fill(0,0,100);
  rect(x, y, w, h);
  fill(0,0,0);
  text(label, x, y, w, h);
  if (regionClicked(x,y,w,h)) {
    if (action == null) {
      exit();
    }
    switchGame(action);
  }
}
