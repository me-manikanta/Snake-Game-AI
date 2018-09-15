class Population {

  Snake[] snakes; //All the snake sin current generation

  int gen=1;
  int globalBest=4;
  long globalBestFitness=0;
  int currBest=4;
  int currBestSnake=0;

  Snake globalBestSnake;

  Population(int size) {
    snakes = new Snake[size];

    //Initialize all snakes
    for (int i=0; i<size; i++) snakes[i]=new Snake();

    globalBestSnake = snakes[0].clone();
  }

  Population(int size, Snake best) {

    snakes = new Snake[size];

    //Set all the snakes as mutated clones of the best snake
    for (int i=0; i<snakes.length; i++) {
      snakes[i] = best.clone();
      snakes[i].mutate(globalMutationRate);
    }

    globalBestSnake = best.clone();
  }

  void updateAlive() {
    for (int i=0; i<snakes.length; i++) {
      if (snakes[i].alive) {
        snakes[i].look();
        snakes[i].setVelocity();
        snakes[i].move();
        if ((snakes[i].alive && showBestOnly) || i==currBestSnake) snakes[i].show();
      }
    }
    setcurrBest();
  }

  boolean done() {
    for (int i=0; i<snakes.length; i++) if (snakes[i].alive) return false;
    return true;
  }

  void setcurrBest() {
    if (!done()) {
      float max =0;
      int maxIndex = 0;
      for (int i =0; i<snakes.length; i++) {
        if (snakes[i].alive && snakes[i].len > max) {
          max = snakes[i].len;
          maxIndex = i;
        }
      }

      if (max > currBest) {
        currBest = floor(max);
      }
      if (!snakes[currBestSnake].alive || max > snakes[currBestSnake].len +5   ) {

        currBestSnake  = maxIndex;
      }


      if (currBest > globalBest) {
        globalBest = currBest;
      }
    }
  }

  //Functions for natural selection

  //Selecting snake for next generation on the basis of fitness
  Snake selectSnake() {
    long totalFitness=0;
    for (int i=0; i<snakes.length; i++) totalFitness += snakes[i].fitness;

    long rand = floor(random(totalFitness));
    long currSum=0;
    for (int i=0; i<snakes.length; i++) {
      currSum+=snakes[i].fitness;
      if (currSum>rand) return snakes[i];
    }
    return snakes[0];
  }

  //Set the best snake globally and for current generation
  void setBestSnake() {

    long max=0;
    int maxIndex=0;
    for (int i=0; i<snakes.length; i++) {
      if (snakes[i].fitness>max) {
        max=snakes[i].fitness;
        maxIndex=i;
      }
    }
    if (max>globalBestFitness) {
      globalBestFitness = max;
      globalBestSnake = snakes[maxIndex].clone();
    }
  }

  void naturalSelection() {

    Snake[] newSnakes = new Snake[snakes.length]; //The next gen of snakes

    setBestSnake();
    newSnakes[0] = globalBestSnake.clone();
    for (int i=1; i<snakes.length; i++) {

      //Select 2 parents randomly based on fitness
      Snake parent1 = selectSnake();
      Snake parent2 = selectSnake();

      //Crossover the 2 snakes
      Snake child = parent1.crossOver(parent2);
      child.mutate(globalMutationRate);
      newSnakes[i]=child;
    }
    snakes= newSnakes.clone();
  }

  //Methods that involves brain of the population
  void calculateFitness() {
    for (int i=0; i<snakes.length; i++) snakes[i].calculateFitness();
  }

  void mutate() {
    for (int i=0; i<snakes.length; i++) snakes[i].mutate(globalMutationRate);
  }
}
