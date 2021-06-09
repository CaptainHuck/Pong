class GameMode {

  Ball ball;
  float ballX = 0, ballY = 0;
  float vx = 0, vy = 0;
  boolean isBallInitialized = false;

  Player p1, p2;
  int h = 100;
  int w = 20;

  int speed = 3;
  boolean isSpeedDoubled = false;
  color r = 255, g = 255, b = 255;
  int numHits = 0;
  int scoreP1, scoreP2;

  boolean isGoal = false;
  PFont font;

  static final float MAXBOUNCEANGLE = (5 * PI) / 12;

  boolean up1, down1, up2, down2;

  int posX1 = 50;
  int posX2 = width-(50+w);
  int posY1 = ((height/2)-(h/2));
  int posY2 = ((height/2)-(h/2));

  float ballAngle;


  public GameMode() {
    
    // Initializes the ball
    ball = new Ball(ballX, ballY, vx, vy);
    calculateBallDropInAngle();
    initializeBall();

    // Initializes player paddles
    p1 = new Player(w, h, r, g, b);
    p2 = new Player(w, h, r, g, b);
    
    font = createFont("Lucida Console", 32);
    textAlign(CENTER);
    textFont(font, 28);
  }


  void draw() {
    background(0, 0, 0);

    // Draws the centre line of the game field
    for (int i=10; i<height-10; i+= 15) {
      rect((width/2)+1.5, i, 3, 8);
    }

    ball.update();
    calculateSpeed();
    p1.display(posX1, posY1);
    updateP1();
    p2.display(posX2, posY2);
    updateP2();
    checkPaddleBorders();

    detectBallBorderCollision();
    detectBallPaddleCollision();

    showScore();
  }


  // Initializes a new ball if none has been created yet
  void initializeBall() {
    if (isBallInitialized == false) {
      ball.pos.x = random((width/2)-60, (width/2)+60);
      ball.pos.y = 5;
      ball.velo.x = 2;
      ball.velo.y = 2;
      isBallInitialized = true;
    }
  }

  // Calculates a drop in angle for the ball between 30 and 60 degrees 
  // or 120 and 150 degrees accordingly
  // with almost equal distribution between the left and the right player field
  void calculateBallDropInAngle() {
    float randAngle = random(PI/6, PI/3) + (PI/2) * floor(random(0, 2));
    println("angle: " + degrees(randAngle));
    this.ballAngle = randAngle;
  }

  // Makes the ball move regarding its current direction angle and velocity
  void calculateSpeed() {
    ball.pos.x += cos(ballAngle) * ball.velo.x;
    ball.pos.y += sin(ballAngle) * ball.velo.y;
  }

  // Lets the players control their paddles if the up or down keys are pressed
  void updateP1() {
    if (up1) {
      posY1 -= speed;
    } else if (down1) {
      posY1 += speed;
    }
  }

  void updateP2() {
    if (up2) {
      posY2 -= speed;
    } else if (down2) {
      posY2 += speed;
    }
  }


  // Checks if the paddles stay within the upper and lower game field limit
  void checkPaddleBorders() {
    if (posY1 <= 0) {
      up1 = false;
    } 
    if (posY2 <= 0) {
      up2 = false;
    } 
    if ((posY1+h) >= height) {
      down1 = false;
    } 
    if ((posY2+h) >= height) {
      down2 = false;
    }
  }

  
  void keyPressed() {
    if (keyPressed) {
      if (keyCode == 'W') {
        if (posY1 > 0) {
          up1 = true;
        } else {
          up1 = false;
        }
      }
      if (keyCode == 'S') {
        if ((posY1+h) < height) {
          down1 = true;
        } else {
          down1 = false;
        }
      }
      if (keyCode == UP) {
        if (posY2 > 0) {
          up2 = true;
        } else {
          up2 = false;
        }
      }
      if (keyCode == DOWN) {
        if ((posY2+h) < height) {
          down2 = true;
        } else {
          down2 = false;
        }
      }
    }
  }

  void keyReleased() {
    if (keyCode == 'W') {
      up1 = false;
    }
    if (keyCode == 'S') {
      down1 = false;
    }
    if (keyCode == UP) {
      up2 = false;
    }
    if (keyCode == DOWN) {
      down2 = false;
    }
  }

  // Lets the ball bounce off the upper and lower game field border.
  // Checks if the ball has flown out to either the left or the right side,
  // calculates the new score and increases the game speed.
  void detectBallBorderCollision() {
    if (ball.pos.y <= 0 + ball.diam/2) {
      this.ball.velo.y *= -1;
    }
    if (ball.pos.y >= height - ball.diam/2) {
      this.ball.velo.y *= -1;
    }
    if (ball.pos.x <= 0) {
      if (isGoal == false) {
        println("1 Point for P2");
        isGoal = true;
      }
      ++scoreP2;
      isSpeedDoubled = false;
      isBallInitialized = false;
      calculateBallDropInAngle();
      initializeBall();
      increaseSpeed();
    }
    if (ball.pos.x >= width) {
      if (isGoal == false) {
        println("1 Point for P1");
        isGoal = true;
      }
      ++scoreP1;
      isSpeedDoubled = false;
      isBallInitialized = false;
      calculateBallDropInAngle();
      initializeBall();
      increaseSpeed();
    }
  }

  // Checks if the ball has hit the upper or lower half of the paddle
  // and, accordingly, calculates a bounce off angle.
  // The closer the ball is to the edge of the paddle, the obtuser the angle.
  void changeAngleP1() {
    float relativizedPaddleBallIntersect = (ball.pos.y - p1.y)/p1.h;
    float normalizedPaddleBallIntersect = (2 * relativizedPaddleBallIntersect) - 1 ;
    println(normalizedPaddleBallIntersect);
    ballAngle = abs(normalizedPaddleBallIntersect * MAXBOUNCEANGLE);
  }

  void changeAngleP2() {
    float relativizedPaddleBallIntersect = (ball.pos.y - p2.y)/p2.h;
    float normalizedPaddleBallIntersect = (2 * relativizedPaddleBallIntersect) - 1 ;
    println(normalizedPaddleBallIntersect);
    ballAngle = abs(normalizedPaddleBallIntersect * MAXBOUNCEANGLE);
  }

  // Calculates the collision between the ball and the paddle
  void detectBallPaddleCollision() {
    // Checks if the ball collides with the P1 paddle
    float velo = 2 * abs(ball.velo.x);

    if (ball.pos.x <= p1.x+w && ball.pos.x >= p1.x+(w-velo) && ball.pos.y >= p1.y && ball.pos.y < p1.y+h) {
      ++numHits;
      changeAngleP1();
      this.ball.velo.x *= -1;
      this.ball.pos.x += velo;
    }
    // Checks if the ball collides with the P2 paddle
    if (ball.pos.x >= p2.x && ball.pos.x <= p2.x+velo && ball.pos.y >= p2.y && ball.pos.y < p2.y+h) {
      ++numHits;
      changeAngleP2();
      this.ball.velo.x *= -1;
      this.ball.pos.x -= velo;
    }
  }

  // Prints the current score to the screen
  void showScore() {
    if (scoreP2 == 0) {
      text("P2 : 0", width*0.75, 50);
    } else {
      text("P2 : " + scoreP2, width*0.75, 50);
    }
    if (scoreP1 == 0) {
      text("P1 : 0", width*0.25, 50);
    } else {
      text("P1 : " + scoreP1, width*0.25, 50);
    }
  }


  // Increases the speed after either one player has achieved a few goals
  void increaseSpeed() {
    if (scoreP1 != 0 || scoreP2 != 0) {
      if (isSpeedDoubled == false) {
        if (scoreP1 >= 1 || scoreP2 >= 2) {
          this.ball.velo.x *= 1.5;
          this.ball.velo.y *= 1.5;
          this.speed += 1.0;
        } 
        if (scoreP1 >= 3 || scoreP2 >= 5) {
          this.ball.velo.x *= 1.5;
          this.ball.velo.y *= 1.5;
          this.speed += 0.75;
        } 
        if (scoreP1 >= 6 || scoreP2 >= 10) {
          this.ball.velo.x *= 1.5;
          this.ball.velo.y *= 1.5;
          this.speed += 0.75;
        } 
        isSpeedDoubled = true;
      }
    }
  }
  
}
