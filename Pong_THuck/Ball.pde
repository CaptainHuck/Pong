class Ball {

  int diam = 10;
  PVector pos;
  PVector velo;


  public Ball(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    velo = new PVector(vx, vy);
  }

  void update() {
    fill(255, 255, 255);
    circle(pos.x, pos.y, diam);
  }
} 
