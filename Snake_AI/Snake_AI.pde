int gameSize=400;
int displaySize=400;
int startX = 600;
int startY = 200;
int speed=30;

boolean showBestOnly=true;

//Snake snake;
World world;
float globalMutationRate = 0.01;

void setup(){
  frameRate(speed);
  size(800,400);
  //snake=new Snake();
  world=new World(5,2000);
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
  text("Mutation Rate: " + globalMutationRate, 10, 200);
  textSize(20);
  text("Helper keys\n M - Toggle show all/show best\n + - Increase frame rate\n - - Decrease Frame rate",10,250);
}

void keyPressed(){

  switch(key){
    case 'm':
      showBestOnly=!showBestOnly;
      break;
    case '+':
      speed+=10;
      frameRate(speed);
      break;
    case '-':
      speed-=10;
      if(speed<30) speed=30;
      frameRate(speed);
      break;
    case 's':
    
  }
  
}
