/** Flappy Bat Game
 ** Created by Rye
 ** NOTE: You can play using arrow keys OR mouse
 **/

//------------------------------------------------------------------------------------------

/** Imports Sound Library **/

import processing.sound.*;

/***************************************************
      Global Essential Variables of the Game
 ****************************************************/

/** Images **/

PImage start; // start screen image
PImage backgroundPic; // background image
PImage topWall; // top wall image
PImage bottomWall; // bottom wall image
PImage gameOver; // game over image
PImage gameFinished; // game finished image
PImage heart; // heart image
PImage maxScoreScreen; // max score screen image

/** Animated Font **/

PFont animatedFont;

/** Bat Variables and Array **/

PImage[] bats; // frame bat images
int batFrame; // current frame of the bat
int frames = 3; // frames of the bat

/** Sound **/

SoundFile death;
SoundFile gameMusic;
SoundFile batFlap;

/** Heart Variables **/

int heartX = 0;

/** Coordinates and Gravity **/

int backgroundX; // x-axis of the background image
int gameOverX; // x axis of the game over screen
int gameFinishedX; // x axis of the game finished screen

int batX = 0; // x-axis of the bat
int batY = 0; // y-axis of the bat

int[] wallX; // wall x-axis array
int[] wallY; // wall y-axis array

float gravity = 0; // gravity in game

/** Game States **/

String gameState; // state of the game

// 3 states-

// 1. START Screen
// 2. PLAY/Main Screen (also called "backgroundPic" or as background screen)
// 3. END GAME Screen (Game Over/Game Finished)
// 4. Max Score Screen (maxScoreScreen) (Called only if the Player Reaches the Max Score)

/** Other Crucial Variables **/

boolean continueGame = false; // continue the game or not
boolean mousePressAct; // perform any mouse press action

/** Player Related Variables **/

int score = 0; // score of player
int highScore = 0; // high score of player
int livesLeft = 3; // 3 lives of player

/** Max Score **/

int maxScore = 100; // max score of the game
boolean maxScoreOnce = false; // checks to see if the user has reached max score once or not

/** Counter of Loop **/

int counterLoop = 0;

//------------------------------------------------------------------------------------------

void setup()
{

  /****************************************************
        Sets up configuration for the program
   ****************************************************/

  size(600, 800); // size of game window

  /** Initializes the Bat Coordinates **/

  batX = 50;
  batY = 320;

  /** Resets Global Coordinates **/

  backgroundX = 0;
  gravity = 0;
  score = 0;
  gameOverX = 0;
  gameFinishedX = 0;
  heartX = 0;

  /** Resets Counter **/

  counterLoop = 0;

  /** Loads Sounds **/

  gameMusic = new SoundFile(this, "menu.wav");
  death = new SoundFile(this, "death.wav");
  batFlap = new SoundFile(this, "batFlap.wav");

  /** Loads Images **/

  backgroundPic = loadImage("background.png"); // loads background image
  start = loadImage("start.png"); // loads start screen image
  gameOver = loadImage("gameOver.png"); // loads game over screen overlay image
  maxScoreScreen = loadImage("maxScoreScreen.png"); // loads max score screen overlay image
  topWall = loadImage("wall.png"); // loads wall image
  bottomWall = loadImage("wall.png"); // loads wall image
  gameFinished = loadImage("gameFinished.png"); // loads game finished image

  /** Creates The Animated Font **/

  animatedFont = createFont("minecraft.ttf", 24);

  /** Sets The Animated Font **/

  textFont(animatedFont);

  /** Loads the Heart Lives of the Player Images **/

  heart = loadImage("heart.png"); // loads heart image
  heart.resize(width/15, width/20); // resizes heart images

  bats = new PImage[frames]; // initializes the bat array

  initBat(); // draws the bat

  /** Intializes the Wall Coordinates **/

  wallX = new int[backgroundPic.width]; // x coordinate of the wall
  wallY = new int[wallX.length]; // y coordinate of the wall

  /** Adds Values to the Wall Coordinates **/

  for (int k = 0; k < wallX.length; k++)
  {
    wallX[k] = (200 * k) + 600;
    wallY[k] = int(random(-350, 0));
  }

  mousePressAct = true; // makes mouse press action work

  gameState = "START"; // sets game to "START" screen

  gameMusic.loop(); // plays main game music in a loop
}

//------------------------------------------------------------------------------------------

void draw()
{

  /****************************************************
          Function for the Main Program
   ****************************************************/

  //------------------------------------------------------------------------------------------

  if (gameState == "START") {
    startGame(); // displays start screen
  } // start screen ends

  else if (gameState == "PLAY") {

    //------------------------------------------------------------------------------------------

    /** Background and Score **/

    setBGScore(); // calls background and score function

    //------------------------------------------------------------------------------------------

    /** Represent the Lives of the Player **/

    lives(); // calls lives function to represent the lives left of the player

    //------------------------------------------------------------------------------------------

    /** Bat, Wall and Collide **/

    setPipesCollide(); // calls the function to place wall images and check for collisions

    image(bats[batFrame], batX, batY);  // draws bat image on screen based on frame
    delay(6); // delay 6ms before resetting bat frame
    batFrame = 0; // resets bat frame

    batX+=.5; // moves the bat forward

    /** Moves bat down based on gravity acceleration **/

    gravity+= 1;
    batY+=gravity;
  } // play or main screen ends

  //------------------------------------------------------------------------------------------

  /** End Game **/

  else if (gameState == "END GAME") {
    endGame(); // calls end game function
  } // end game screen ends

  //------------------------------------------------------------------------------------------

  // MAIN CODE FINISHED
}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

/** Other Functions Used **/

void startGame()
{
  /****************************************************
           Function for the Start Screen
   ****************************************************/

  image(start, 0, 0); // displays start screen image

  if (continueGame) {

    // styling for high score text
    fill(255);
    textSize(30);

    text("High Score: " + highScore, width-380, height-50); // displays high score on main screen
  } // if game is being continued
  else {
    // styling for new game text
    fill(255);
    textSize(30);

    text("New Game", width-380, height-50); // displays new game on main screen
  } // if its a new game

  if (mousePressed) {
    gameState = "PLAY";
  } // checks for mouse press and changes to the main "PLAY" screen
}

void lives()
{

  /****************************************************
   Function for Representing the Lives Left of the Player
   ****************************************************/

  for (int s = 0; s < livesLeft; s++) {
    image(heart, heartX+(s*30), 0);
  } // displays the lives left of the player with hearts
}

void initBat()
{

  /****************************************************
           Function for Initliazing Bat Array
   ****************************************************/

  /** Adds Bat Elements to the Array **/

  for (int f = 0; f < frames; f++) {

    bats[f] = loadImage("bat" + f +".png"); // loads bat images
    bats[f].resize(width/15, width/20); // resizes bat images
    batFrame = 0; // sets bat frame to the first one or 0
  }
}

void setBGScore()
{
  /****************************************************
     Function for the Background of the Game and Score
   ****************************************************/

  /** Background **/

  image(backgroundPic, backgroundX, 0);  // draws background image on screen
  image(backgroundPic, backgroundX+backgroundPic.width, 0); // places second background image on screen

  backgroundX-=5; // scrolls through the background

  if (backgroundX == -1800) {
    backgroundX = 0;
  } // resets background once first image is fully done

  // Score Text

  // styling for current score text
  fill(0);
  textSize(20);

  text("Score: " + score, 0, 50); // current score text
}

void setPipesCollide()
{
  /*******************************************************
  Function for the Walls in the Game and Checks for Collsion
   ******************************************************/

  for (int i = 0; i < wallX.length; i++)
  {

    image(topWall, wallX[i], wallY[i]-400); // places first (top) wall image on screen
    image(bottomWall, wallX[i], wallY[i]+680); // places second (bottom) wall image on screen

    if (((batX < wallX[i]+45 && batX > wallX[i]-25) && (batY >= wallY[i]+660 || batY <= wallY[i] + 400))|| batY > height) {
      if (counterLoop == 0) {
        continueGame = true; // sets continuing game to true
        death(); // calls function death for the bat
      } // if condition is only called based on the counter loop
    } // checks for collision with wall OR if the bat falls down the screen
    else if (batX == wallX[i]) {
      score += 1;
    } // increments score by 1 if no collision is found

    wallX[i]-=5; // scrolls through the walls
  }
}

void keyReleased()
{

  /****************************************************
    Function for the Movement of the Bat by Arrow Keys
   ****************************************************/

  /** Moves the bat Up or Down Based on Arrow Keys and Gravity **/

  if (keyCode == UP) {
    batFrame = 1; // changes the bat frame
    batFlap.play(); // plays flap music when bat flaps

    delay(5); // delays the bat frame change by 5ms
    batFrame = 2; // moves to last frame

    gravity-=15; // decreases gravity in game
  } // moves the bat up if the up arrow key is pressed

  if (gameState == "END GAME") {
    if (key == 'P' || key == 'p') {
      gameMusic.stop(); // stops game music
      setup(); // calls setup screen if 'P' or 'p' is pressed
    }
  } // switch to main from end game screen(s) and stops game music to avoid an amplified loop
}

void mousePressed()
{

  /****************************************************
      Function for the Movement of the Bat by Mouse
   ****************************************************/

  /** Moves the bat Up or Down Based on Gravity and Mouse being Pressed **/
  if (mousePressAct) {
    if (keyPressed == false) {
      batFrame = 1; // changes the bat frame
      batFlap.play(); // plays flap music when bat flaps

      delay(5); // delays the bat frame change by 5ms
      batFrame = 2; // moves to last frame

      gravity-=15; // decreases gravity in game
    } // moves the bat up if the mouse is pressed

    if (gameState == "END GAME") {
      gameMusic.stop(); // stops game music
      setup(); // calls setup screen if mouse is clicked
    } // switch to main from end game screen(s) and stops game music to avoid an amplified loop

    // NOTE: only uses mouse if a key is not pressed at the same time
  }
}


void death()
{

  /****************************************************
          Function for the Death of the Bat
   ****************************************************/

  death.play(); // plays death music

  livesLeft--; // reduces live of player

  counterLoop++; // increments counter of loop

  gameState = "END GAME"; // sets game state to end screen
}

void newGame()
{
  /****************************************************
                Function for a New Game
   ****************************************************/

  /** Resets Variables **/

  livesLeft = 3;
  highScore = 0;
  score = 0;
}

void endGame()

{
  /****************************************************
          Function for the End Screen(s)
   ****************************************************/

  /** Continues Moving Background Image **/

  image(backgroundPic, backgroundX, 0);  // overrides all previous images on screen
  image(backgroundPic, backgroundX+backgroundPic.width, 0); // places second background image on screen

  backgroundX -= 5; // moves end screen background

  if (backgroundX == -1800) {
    backgroundX = 0;
  } // resets background once first image is fully done

  /** If the Player Reaches the Max Score **/

  if (score >= maxScore && livesLeft > 0 && maxScoreOnce == false) {
    maxScore(); // calls the maxScore function
  } // special screen if the player exceeds the max score

  /** If the Player Doesn't Reach the Max Score **/

  else {

    // changes font for game over screen and game finished
    animatedFont = createFont("ARCADECLASSIC.TTF", 24);
    textFont(animatedFont);

    // styling for game over screen/game finished text
    fill(230, 202, 202);

    livesLeft(); // calls the lives left function
  } // if player hasn't reached max score
}

void maxScore() {

  /****************************************************
      Function for if the Player Reaches the Max Score
   ****************************************************/

  image(maxScoreScreen, 0, 0);  // places the max score screen image

  // styling for max score screen
  fill(255);
  textSize(20);

  // text for the max score screen
  text("Press C to continue and N to play a new game", width/2-200, height-150); // max score text // presents the user with the option to continue this game or play a new one

  mousePressAct = false; // prevents any mouse action

  if (keyPressed) {
    if (key == 'N' || key == 'n') {
      newGame(); // calls new game function
      continueGame = false; // sets continuing game to false
      gameMusic.stop(); // stops game music
      setup(); // calls setup function
    } // new game
    else if (keyPressed) {
      if (key == 'C' || key == 'c') {
        highScore = score; // keeps the high score
        continueGame = true; // displays high score on start screen
        gameMusic.stop(); // stops game music
        maxScoreOnce = true; // doesnt allow this prompt screen again
        setup(); // calls setup function
      } // continue the game
    }
  } // checks to see if player wants to play a new game or continue this one
}

void livesLeft() {

  /*****************************************************************************
      Function to Display the Appropriate Screen Depending on the Lives Left
   ******************************************************************************/

  if (highScore < score) {
    highScore = score; // sets the high score to the new score if its less than the score
  }

  /** Lives Left are Greater than 1 **/

  if (livesLeft >= 1) {

    image(gameOver, gameOverX-15, 0); // displays game over image

    // styling for game over screen text
    fill(230, 202, 202);

    // changes font
    animatedFont = createFont("yoster.ttf", 25);
    textFont(animatedFont);


    if (score == 0 && highScore == 0) {
      text("Aww cmon try again!", width-500, height-315); // displays text if player has a score and high score of 0
    } else {
      text("Your High Score:  " + highScore, width-500, height-325); // display high score text
    }

    // changes font for play again text
    animatedFont = createFont("minecraft.ttf", 20);
    textFont(animatedFont);

    text("C lick  the  Mouse  or  Press  P  to  Play  Again", width-500, height-275); // displays play again text

    fill(0); // changes color of text for lives left
    text("Lives Left: " + livesLeft, width-500, height-50); // displays lives left of player
  } // if lives of player are still left

  /** Lives Left are 0 **/

  else {

    image(gameFinished, gameFinishedX+50, 0); // displays game finished image

    // changes font for lives left if they are 0
    animatedFont = createFont("yoster.ttf", 25);
    textFont(animatedFont);

    text("Your Highest Score: " + highScore, width-475, height-400); // displays final high score of player

    textSize(23);// changes text size for the repeat game text

    text("Would you like to continue playing or not?", width/2-250, height-300); // end screen game finished text
    text("Press Y to continue and N to not.", width/2-200, height-250); // game finished text asking to user to continue with a new game or close the program

    // styling of lives left text
    fill(0);
    text("Lives Left: " + livesLeft, width-500, height-50); // displays the lives left of player

    mousePressAct = false; // prevents any mouse action

    if (keyPressed) {
      if (key == 'Y' || key == 'y') {
        newGame();
        continueGame = false; // sets continuing game to false
        gameMusic.stop(); // stops game music
        maxScoreOnce = false; // sets max score reached once to false
        setup(); // calls setup function
      } // new game if key 'Y'/'y' is pressed
      else if (keyPressed) {
        if (key == 'N' || key == 'n') {
          exit();
        } // exits the program if the key 'N'/'n' is pressed
      }
    }
  } // if lives left is 0
}

// FULL CODE FINISHES
