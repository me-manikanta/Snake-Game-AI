class World{

  int gen=0;
  
  //All the populations of the world
  Population[] species;
  
  int worldBestScore = 0;

  World(int numSpecies,int populationSize){
    species=new Population[numSpecies];
    for(int i=0;i<numSpecies;i++) species[i]=new Population(populationSize);
  }

  boolean done(){
    for(int i=0;i<species.length;i++) if(!species[i].done()) return false;
    return true;
  }
  
  void updateAlive(){
    for(int i=0;i<species.length;i++) species[i].updateAlive();
  }
  
  void geneticAlgorithm(){
    for(int i=0;i<species.length;i++){
      species[i].calculateFitness();
      species[i].naturalSelection();
    }
    gen++;
    setTopScore();
  }
  
  void setTopScore() {
    long max = 0;
    int maxIndex = 0;
    for (int i = 0; i< species.length; i++) {
      if (species[i].globalBestFitness > max ) {
        max = species[i].globalBestFitness;
        maxIndex = i;
      }
    }
    worldBestScore = species[maxIndex].globalBest;
  }

}
