class Player {

  int x, y, w, h;
  color r, g, b;
  boolean up, down;
  int speed = 3;

  public Player(int w, int h, color r, color g, color b) { 
    this.w = w;
    this.h = h;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void display(int x, int y) {
    this.x = x;
    this.y = y;
    fill(r, g, b);
    rect(x, y, w, h);
  }

}
