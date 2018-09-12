
int gameSize=400;
int displaySize=400;
int startX = 600;
int startY = 200;
int speed=30;

Snake snake;

void setup(){
  frameRate(speed);
  size(800,500);
  snake=new Snake();
}

void draw(){
  background(40);
  drawData(snake.len-3);
  if(snake.alive){
    snake.setVelocity();
    snake.move();
  }else{
    noLoop();
    //text("Game over", displaySize+10, 100); 
  }
    snake.show();
}

void drawData(int score){

  fill(255);
  stroke(255);
  line(400, 0, 400, 400);
  line(0, 400, 800, 400);
  textSize(30);
  
  text("Score: " + score, 10, 100); 
  
}
