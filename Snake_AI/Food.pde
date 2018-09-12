class Food{
  PVector pos;
  
  Food(){
    pos = new PVector();
    
    //Keep the apple at random spot
    pos.x= displaySize + floor(random(0,gameSize/10))*10;
    pos.y = floor(random(0,gameSize/10))*10;
    
  }
  
  //Show apple on the screen
  void show(){
    fill(255,0,0);
    rect(pos.x,pos.y,10,10);
  }
  
  Food clone(){
    Food nFood = new Food();
    nFood.pos = new PVector(pos.x,pos.y);
    return nFood;
  }
  
  
}
