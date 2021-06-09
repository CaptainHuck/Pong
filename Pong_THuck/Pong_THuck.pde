GameMode game_mode;

void setup() {
  size(1000, 600, P2D);
  frameRate(120);
  game_mode = new GameMode();
}

void draw() {
  game_mode.draw();
}

void keyPressed() {
  game_mode.keyPressed();
}

void keyReleased() {
  game_mode.keyReleased();
}
