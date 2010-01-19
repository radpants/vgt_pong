/*
 __     ______ _____   . 
 \ \   / / ___|_   _|  | Video Game Tutorials (C) 2010
  \ \ / / |  _  | |    | Pong, by AJ Austinson
   \ V /| |_| | | |    | You may use this code in all your pursuits.
    \_/  \____| |_|    | If you found it helpful, send others our way.
                       | http://video-game-tutorials.com
*/

PlayerPaddle leftPaddle, rightPaddle;
Ball ball;
Scoreboard scoreboard;
Keyboard keyboard;

PFont arial;

final int PLAY_UNTIL = 3;
boolean win = false;
int whoWon = -1;

void setup(){
	size(800,500);
	
	keyboard = new Keyboard();
	
	leftPaddle = new PlayerPaddle(LEFT_SIDE);
	rightPaddle = new PlayerPaddle(RIGHT_SIDE);
	
	ball = new Ball();
	
	scoreboard = new Scoreboard();
	
	arial = createFont("Arial", 72);
	textFont(arial);
	textAlign(CENTER);
	
	fill(255);
	noStroke();
	smooth();
}

void draw(){
	background(0);
	fill(255);
	if(win){
		if(whoWon == LEFT_SIDE){ text("Left side wins!", 100, 100); }
		else{ text("Right side wins!", 100, 100); }
	}
	else{
		leftPaddle.update();
		rightPaddle.update();
		ball.update();
		scoreboard.update();
	}
}

void keyPressed(){
	switch(key){
		case 'w':
		keyboard.key_w = true;
		break;
		
		case 's':
		keyboard.key_s = true;
		break;
		
		case 'i':
		keyboard.key_i = true;
		break;
		
		case 'k':
		keyboard.key_k = true;
		break;
	}
}

void keyReleased(){
	switch(key){
		case 'w':
		keyboard.key_w = false;
		break;
		
		case 's':
		keyboard.key_s = false;
		break;
		
		case 'i':
		keyboard.key_i = false;
		break;
		
		case 'k':
		keyboard.key_k = false;
		break;
	}
}

final int LEFT_SIDE = 0;
final int RIGHT_SIDE = 1;
class Paddle{
  // renders a paddle to the screen
  // can be placed on either side
  float x, y, w, h;
  int side;
  Paddle(int side){
    this.side = side;
    if(side == LEFT_SIDE){
      x = 40; 
    }
    else{
			x = width - 40;
		}
    w = 20;
    h = 100;
    y = height / 2;
  }  
  void render(){
    rect(x-w/2,y-h/2,w,h); 
  }
}

class Keyboard{
	boolean key_w, key_s, key_i, key_k;
	Keyboard(){
		key_w = false;
		key_s = false;
		key_i = false;
		key_k = false;
	}	
}

class PlayerPaddle extends Paddle{
  // is controlled by keyboard inputs
	boolean upKey, downKey;
	
  PlayerPaddle(int side){
    super(side);
  }  
  void update(){
	if(side == LEFT_SIDE){
		if( keyboard.key_w ){ y -= 5; }
		if( keyboard.key_s ){ y += 5; }
	}
	else{ // RIGHT_SIDE
		if( keyboard.key_i ){ y -= 5; }
		if( keyboard.key_k ){ y += 5; }
	}
    render();
  }
}

class ComputerPaddle extends Paddle{
  // is controlled by computer
  ComputerPaddle(int side){
    super(side);
  }
}

class Ball{
  // flies around, bounces off paddles, ceiling & floor
  // if it passes either side, adds to the score
  float x,y,vx,vy,sz;
  Ball(){
    x = width/2;
    y = height/2;
    vx = 4;
    vy = 0;
    sz = 20;
  }
  
	void update(){
		// update position
		// ----------------------------------------------------------------
		x += vx;
		y += vy;
		
		// check for collisions with paddles
		// ----------------------------------------------------------------	
		if( abs( x - rightPaddle.x ) < rightPaddle.w/2 + sz/2 ){ // then we are crossing where the right paddle is
			if( abs( y - rightPaddle.y ) < rightPaddle.h/2 + sz/2 ){
				// then we hit the paddle
				vx *= -1;
				vy += ( y - rightPaddle.y ) * 0.1;
				x += vx;
			}
		}
		else if( abs( x - leftPaddle.x ) < leftPaddle.w/2 + sz/2 ){
			if( abs( y - leftPaddle.y ) < leftPaddle.h/2 + sz/2){
				// then we hit the paddle
				vx *= -1;
				vy += ( y - leftPaddle.y ) * 0.1;
				x += vx;
			}
		}
		
		// check for collisions with ceiling & floor
		// ----------------------------------------------------------------
		if(y<sz/2){
			vy *= -1;
		}
		else if(y>height-sz/2){
			vy *= -1;
		}
		
		// check to see if it's scored
		// ----------------------------------------------------------------
		if(x < 0){
			scoreboard.leftGoal();
		}
		else if( x > width ){
			scoreboard.rightGoal();
		}
		
		
		render();
  }

	void reset(){
		x = width/2;
		y = height/2;
		vy = 0;
		vx = 5;
	}
	
	void render(){
		ellipse(x,y,sz,sz);
	}
    
}

class Scoreboard{
	int leftScore, rightScore;
	Scoreboard(){
		leftScore = 0;
		rightScore = 0;
	}
  // keeps track of score, displays it to the screen
	void leftGoal(){
		rightScore++;
		ball.reset();
	}
	void rightGoal(){
		leftScore++;
		ball.reset();
	}
	void update(){
		if( leftScore > PLAY_UNTIL ){
			win = true;
			whoWon = LEFT_SIDE;
		}
		else if( rightScore > PLAY_UNTIL ){
			win = true;
			whoWon = RIGHT_SIDE;
		}
		render();
	}
	void render(){
		stroke(255);
		line(width/2,5,width/2,25);
		for(int i=0;i<leftScore;i++){
			ellipse( width/2 - i*30-30, 15, 10, 10);
		}
		for(int i=0;i<rightScore;i++){
			ellipse( width/2 + i*30+30, 15, 10, 10);
		}
	}
}
