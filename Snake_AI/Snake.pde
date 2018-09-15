class Snake {

  int len; //Length of the snake
  PVector pos; //Head of the snake
  ArrayList<PVector> tailPositions; // All the positions of the snake
  PVector vel; //Direction of the snake
  Food food; //The food that this snake needs to eat
  int leftToLive; //To avoid infinite Loops
  int lifeTime; //How much time the snake has lived
  boolean alive; //If the snake is dead or alive
  int growCount; //The amount snake still needs to grow

  //NeuralNetowrk variables
  long fitness;
  NeuralNetwork brain; //Brain of current snake
  float[] vision; //What snake can see currently
  float[] decision;


  //Constructor
  Snake() {

    pos = new PVector(startX, startY);
    vel = new PVector(10, 0);
    tailPositions = new ArrayList<PVector>();
    for (int i=30; i>=10; i-=10) {
      tailPositions.add(new PVector(startX-i, startY));
    }
    len=4;
    food = new Food();


    //Other variables
    leftToLive=200;
    alive=true;
    growCount=0;
    lifeTime=0;
    vision=new float[24];
    fitness=0;
    brain = new NeuralNetwork(24, 18, 4);
  }

  void setVelocity() {

    //Decision should be generated automatically from neural
    //Decision should be generated automatically from neural
    decision = brain.output(vision);

    float max=0, dir=0;
    for (int i=0; i<decision.length; i++) {
      if (max<decision[i]) {
        max=decision[i];
        dir=i;
      }
    }

    if (dir == 0) { //Go left
      vel.x=-10;
      vel.y=0;
    } else if (dir==1) { //Go down
      vel.x=0;
      vel.y=-10;
    } else if (dir==2) { //Go right
      vel.x=10;
      vel.y=0;
    } else { //Go Up
      vel.x=0;
      vel.y=10;
    }
  }

  void move() {
    leftToLive--;
    lifeTime++;
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
    fill(0,255,0);
    rect(pos.x, pos.y, 10, 10);
    //Tail
    fill(255);
    for (int i = 0; i< tailPositions.size(); i++) {
      rect(tailPositions.get(i).x, tailPositions.get(i).y, 10, 10);
    }

    //Show food
    food.show();
  }

  //Methods that involves Brain
  void mutate(float mutationRate) {
    brain.mutate(mutationRate);
  }

  //Calculate the fitness
  void calculateFitness() {

    if (len<10) {
      fitness = floor(lifeTime*lifeTime*pow(2, len));
      return;
    }
    fitness =  lifeTime*lifeTime;
    fitness *= pow(2, 10);
    fitness *= (len-9);
  }

  //Combine 2 snakes to form 1
  Snake crossOver(Snake partner) {

    Snake child = new Snake();
    child.brain = brain.crossOver(partner.brain);
    return child;
  }

  //Clone the current snake
  Snake clone() {
    Snake clone = new Snake();
    clone.brain=brain.clone();
    clone.alive=true;
    return clone;
  }

  float[] lookInDirection(PVector dir) {

    float[] currVision=new float[3]; //Input from current direction
    /*
      CurrVision  Meaning
     0       Whether food is there in this direction or not
     1       By how much distance Snake can hit tail
     2       By how much distance Snake can hit wall
     
     */
    PVector currPos = new PVector(pos.x, pos.y); //Snake head current position
    boolean foodIsFound=false; //True if food is found
    boolean tailIsFound=false; //True if tail is found
    float distance = 0;
    currPos.add(dir);
    distance++;

    while (!(currPos.x<displaySize || currPos.y<0 || currPos.x>=(displaySize+gameSize) || currPos.y>gameSize)) {
      if (!foodIsFound && food.pos.x==currPos.x && food.pos.y==currPos.y) {
        foodIsFound=true;
        currVision[0]=1;
      }

      if (!tailIsFound && tailPositions.contains(currPos)) {
        tailIsFound=true;
        currVision[1]=1/distance;
      }

      currPos.add(dir);
      distance++;
    }
    currVision[2]=1/distance;    
    return currVision;
  }

  //Looks in all possible directions
  void look() {
    vision = new float[24];
    float[] tempVision;

    //Left
    tempVision=lookInDirection(new PVector(-10, 0));
    vision[0] = tempVision[0];
    vision[1] = tempVision[1];
    vision[2] = tempVision[2];

    //Left-Up
    tempVision=lookInDirection(new PVector(-10, -10));
    vision[3] = tempVision[0];
    vision[4] = tempVision[1];
    vision[5] = tempVision[2];

    //Up
    tempVision=lookInDirection(new PVector(0, -10));
    vision[6] = tempVision[0];
    vision[7] = tempVision[1];
    vision[8] = tempVision[2];

    //Up-Right
    tempVision=lookInDirection(new PVector(10, -10));
    vision[9] = tempVision[0];
    vision[10] = tempVision[1];
    vision[11] = tempVision[2];

    //Right
    tempVision=lookInDirection(new PVector(10, 0));
    vision[12] = tempVision[0];
    vision[13] = tempVision[1];
    vision[14] = tempVision[2];

    //Right-Down
    tempVision=lookInDirection(new PVector(10, 10));
    vision[15] = tempVision[0];
    vision[16] = tempVision[1];
    vision[17] = tempVision[2];

    //Down
    tempVision=lookInDirection(new PVector(0, 10));
    vision[18] = tempVision[0];
    vision[19] = tempVision[1];
    vision[20] = tempVision[2];

    //Down-Left
    tempVision=lookInDirection(new PVector(-10, 10));
    vision[21] = tempVision[0];
    vision[22] = tempVision[1];
    vision[23] = tempVision[2];
  }
}
