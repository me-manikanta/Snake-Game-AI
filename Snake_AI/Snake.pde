class Snake {

  int len=1; //Length of the snake
  PVector pos; //Head of the snake
  ArrayList<PVector> tailPositions; // All the positions of the snake
  PVector vel; //Direction of the snake
  Food food; //The food that this snake needs to eat
  int leftToLive; //To avoid infinite Loops
  boolean alive;
  int growCount;

  //Constructor
  Snake() {

    pos = new PVector(startX, startY);
    vel = new PVector(10, 0);
    tailPositions = new ArrayList<PVector>();
    for (int i=30; i>=10; i-=10) {
      tailPositions.add(new PVector(startX-i, startY));
    }
    len+=3;
    food = new Food();


    //Other variables
    leftToLive=200;
    alive=true;
    growCount=0;
  }

  void setVelocity() {

    //Decision should be generated automatically from neural net but for now generating it Randomly
    int decision = floor(random(0, 8));
    print(decision);
    if (decision == 0) { //Go left
      vel.x=-10;
      vel.y=0;
    } else if (decision==1) { //Go down
      vel.x=0;
      vel.y=-10;
    } else if (decision==2) { //Go right
      vel.x=10;
      vel.y=0;
    } else { //Go Up
      vel.x=0;
      vel.y=10;
    }
  }

  void move() {
    leftToLive--;
    //Snake is going in a infinite loop for a long time then it is dead
    if (leftToLive<0) {
      alive=false;
      return;
    }

    //If snake hits a wall or snake hits itself then it is dead
    if (checkDeath(pos.x+vel.x, pos.y+vel.y)) {
      alive=false;
      return;
    }

    if (pos.x + vel.x == food.pos.x && pos.y + vel.y == food.pos.y) {
      eatFood();
    }

    if (growCount>0) {
      growCount--;
      grow();
    } else {//Move the snake tail one step forward
      for (int i=0; i<tailPositions.size()-1; i++) {
        tailPositions.set(i, new PVector(tailPositions.get(i+1).x, tailPositions.get(i+1).y));
      }
      tailPositions.set(len-2, new PVector(pos.x, pos.y));
    }

    //Move the head of the snake
    pos.add(vel);
  }

  //Grow the snake by one square
  void grow() {
    len++;
    tailPositions.add(new PVector(pos.x, pos.y));
  }

  void eatFood() {
    food = new Food();
    //Time teaking process but didnt find another way
    //Food should not overlap with the body of the snake
    while (tailPositions.contains(food.pos)) food = new Food();
    leftToLive += 100;

    if (len>=10) growCount+=4;
    else growCount++;
  }

  boolean checkDeath(float x, float y) {

    //Check whether snake hits wall
    if (x<displaySize || y<0 || x>=(displaySize+gameSize) || y>=400) return true;

    //Check whether snake hits itself
    PVector temp= new PVector(x, y);
    return tailPositions.contains(temp);
  }

  void show() {
    fill(255);
    stroke(0);

    //Show the Snake
    //Head
    rect(pos.x, pos.y, 10, 10);
    //Tail
    for (int i = 0; i< tailPositions.size(); i++) {
      rect(tailPositions.get(i).x, tailPositions.get(i).y, 10, 10);
    }

    //Show food
    food.show();
  }
}
