
int gameSize=400;
int displaySize=400;
int startX = 600;
int startY = 200;
int speed=30;

//Snake snake;
World world;
float globalMutationRate = 0.01;

void setup(){
  frameRate(speed);
  size(800,400);
  //snake=new Snake();
  world=new World(10,100);
}

void draw(){
  background(40);
  
  drawData();
  
  if(!world.done()){
    world.updateAlive();
  }else{
    world.geneticAlgorithm();
  }
  
}

void drawData(){
  fill(255);
  stroke(255);
  line(displaySize, 0, displaySize, gameSize);
  line(0, gameSize, displaySize+gameSize, gameSize);
  textSize(30);
  text("Generation: " + (world.gen), 10, 100); 
  text("Global Best: " + (world.worldBestScore), 10, 150);
  text("mutation Rate: " + globalMutationRate, 10, 200);

}
