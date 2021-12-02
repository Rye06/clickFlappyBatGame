/** Flappy Bat Game
 ** Created by Rye
 ** NOTE: You can play using arrow key OR mouse
 ** NEW Extra Features Added: Double Score + Extra Lives
 **/

/*
 * Add game finished mario end sound
 * Add border to double score image
 */

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
PImage maxScoreScreen; // max score screen image

/** Double Score **/

PImage[] doubleScores; // double score image array
PImage doubleScore; // double score image
int[] doubleScoreCheck; // checks for double image being touched
int[] doubleScoreY; // y coordinates of the double score images

/** Increase Lives **/

PImage[] increaseLives; // increase lives image array
PImage heart; // heart image
int heartX = 0; // heart image x coordinate
int[] increasesLiveCheck; // checks for the increase live image being touched
int[] increaseLiveY; // y coordinates of the increase live images

/** Animated Font **/

PFont animatedFont;

/** Bat Variables and Bat Frames **/

PImage[] bats; // frame bat images
int batFrame; // current frame of the bat
int frames = 3; // frames of the bat

int batX = 0; // x-axis of the bat
int batY = 0; // y-axis of the bat

/** Sounds **/

SoundFile death;
SoundFile gameMusic;
SoundFile batFlap;

/** Different Coordinates **/

int backgroundX; // x axis of the background image
int gameOverX; // x axis of the game over screen
int gameFinishedX; // x axis of the game finished screen

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
boolean mousePressAct; // boolean variable to check if mouse press action is wanted

/** Player Related Variables **/

int score = 0; // score of player
int highScore = 0; // high score of player
int livesLeft = 3; // 3 lives of player

/** Max Score **/

int maxScore = 100; // max score of the game
boolean maxScoreOnce = false; // checks to see if the user has reached max score once or not

/** Counter of Loop **/

int counterLoopCollision = 0; // maintains the counter of the loop collision

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
  gameOverX = 0;
  gameFinishedX = 0;
  heartX = 0;

  /** Resets Other Variables **/

  gravity = 0;
  score = 0;

  /** Resets Counter of the Loop Collision **/

  counterLoopCollision = 0;

  /** Loads Sounds **/

  gameMusic = new SoundFile(this, "menu.wav");
  death = new SoundFile(this, "death.wav");
  batFlap = new SoundFile(this, "batFlap.wav");

  /** Loads Images **/

  backgroundPic = loadImage("background.png"); // loads background image
  start = loadImage("start.png"); // loads start screen image
  gameOver = loadImage("gameOver.png"); // loads game over screen overlay image
  maxScoreScreen = loadImage("maxScoreScreen.png"); // loads max score screen overlay image
  topWall = loadImage("wall.png"); // loads wall image (for the top)
  bottomWall = loadImage("wall.png"); // loads wall image (for the bottom)
  gameFinished = loadImage("gameFinished.png"); // loads game finished image

  /** Double Score Initialization **/

  doubleScores = new PImage[backgroundPic.width]; // initializes double score image array
  doubleScore = loadImage("doubleScore.png"); // loads double score image
  doubleScoreCheck = new int[backgroundPic.width]; // creates the double score check array
  doubleScoreY = new int[backgroundPic.width]; // sets the y coordinate of the double score image to 0

  /** Increase Live Initialization **/

  increaseLives = new PImage[backgroundPic.width]; // initializes increase live image array
  heart = loadImage("heart.png"); // loads heart image
  heart.resize(width/15, width/20); // resizes heart images
  increasesLiveCheck = new int[backgroundPic.width]; // creates the increase lives check array
  increaseLiveY = new int[backgroundPic.width]; // sets the y coordinate of the increase live image to 0

  /** Creates The Animated Font **/

  animatedFont = createFont("minecraft.ttf", 24);

  /** Sets The Animated Font **/

  textFont(animatedFont);

  bats = new PImage[frames]; // initializes the bat array of frames

  initBat(); // draws the bat on screen

  /** Intializes the Wall Coordinates **/

  wallX = new int[backgroundPic.width]; // x coordinate of the wall
  wallY = new int[wallX.length]; // y coordinate of the wall

  /** Adds Values to the Wall Coordinate Arrays + Double Score Arrays + Extra Lives Arrays **/

  for (int k = 0; k < wallX.length; k++)
  {
    wallX[k] = (200 * k) + 600;
    wallY[k] = int(random(-350, 0));

    doubleScores[k] = doubleScore;  // adds double score image to the array
    increaseLives[k] = heart;  // adds heart image to the increase lives array

    doubleScoreY[k] = wallY[k]; // adds the wall Y element to double score y coordinate array
    increaseLiveY[k] = wallY[k]; // adds the wall Y element to increase lives y coordinate array
  }

  mousePressAct = true; // enables the working of the mouse press action

  gameState = "START"; // sets game state to "START" screen

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

    /** Background + Display Score **/

    setBGScore(); // calls background and displaying score function

    //------------------------------------------------------------------------------------------

    /** Represent the Lives of the Player **/

    lives(); // calls lives function to represent the lives left of the player

    //------------------------------------------------------------------------------------------

    /** Placing Bat and Wall on Screen + Checking for Collisions and Boosts **/

    setPipesCollideBoosts(); // calls the function to place wall images + check for collisions + check for player capturing boosts

    image(bats[batFrame], batX, batY);  // draws bat image on screen based on frame
    delay(6); // delay 6ms before resetting bat frame
    batFrame = 0; // resets bat frame

    batX+=.5; // moves the bat forward

    /** Moves bat down based on gravity acceleration **/

    gravity+= 1; // increase gravity in game
    batY+=gravity; // moves the bat based on the gravity
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

    text("High Score: " + highScore, width-410, height-50); // displays high score on main screen
  } // if game is being continued
  else {
    // styling for new game text
    fill(255);
    textSize(30);

    text("New Game", width-390, height-40); // displays new game on main screen
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
   Function for the Background of the Game +  Score
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

void setPipesCollideBoosts()
{
  /***********************************************************************************************
   Function for Placing the Walls in the Game + Checks for Collsion + Checks for Player Capturing Boosts
   **********************************************************************************************/

  for (int i = 0; i < wallX.length; i++)
  {
    doubleScoreCheck[i]=0; // sets the first element of this array to false

    image(topWall, wallX[i], wallY[i]-400); // places first (top) wall image on screen
    image(bottomWall, wallX[i], wallY[i]+680); // places second (bottom) wall image on screen

    /** Double Score **/

    if (i%6==0 && i > 10) {
      image(doubleScores[i], wallX[i], doubleScoreY[i]+500); // places the double score image on the screen

      if (dist(wallX[i], doubleScoreY[i] + 500, batX, batY) <= 30) {
        doubleScoreCheck[i]=1; // sets the doubles check to true
      }
    } // presents the double score boost every 6 walls after a total of 10 walls have been successfully passed

    /** Increase Lives**/

    if (i%9==0 && i > 20) {
      image(increaseLives[i], wallX[i], increaseLiveY[i]+500); // places the heart image on the screen for live increase boost
      if (dist(wallX[i], increaseLiveY[i] + 500, batX, batY) <=50) {
        increasesLiveCheck[i]=1; // sets the increase live check to true
      }
    } // presents the increase lives boost every 9 walls after a total of 20 walls have been successfully passed


    /** Collision with Wall Detection or if Bat goes off the Screen + Calling Live Increase + Double Score Functions **/

    if (((batX < wallX[i]+45 && batX > wallX[i]-25) && (batY >= wallY[i]+660 || batY <= wallY[i] + 400))|| batY > height) {
      if (counterLoopCollision == 0) {
        continueGame = true; // sets continuing game to true
        death(); // calls function death for the bat
      } // condition is only called based on the counter of the loop collision
    } // checks for collision with wall OR if the bat falls down the screen
    else if (batX == wallX[i]) {
      score += 1;
      if (doubleScoreCheck[i] == 1) {
        doubleScoreY[i] = doubleScoreY[i] - 5000; // makes the double score image disappear once captured
        doubleScore(); // calls the double score function
      } // checks to call if the double score function if the double score check is true
      else if (increasesLiveCheck[i] == 1) {
        increaseLiveY[i] = increaseLiveY[i] -5000; // makes the heart image disappear once captured
        increaseLives(); // calls the increase lives function
      }
    } // increments score by 1 if no collision is found

    wallX[i]-=5; // scrolls through the walls
  }
}

void doubleScore() {

  /****************************************************
   Function for Doubling the Score of the Player
   ****************************************************/

  score *= 2; // doubles the score
}

void increaseLives() {

  /****************************************************
   Function for Increasing Lives of the Player
   ****************************************************/

  livesLeft += 1; // inceases the lives left of the player
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

  if (livesLeft >= 1) {
    livesLeft--; // reduces live of player
  } // only execute if the lives left are greater than 1

  counterLoopCollision++; // increments counter of loop

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

    livesLeftScreen(); // calls the lives left screen function
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

void livesLeftScreen() {

  /*****************************************************************************
   Function to Display the Appropriate Screen Depending on the Lives Left of the Player
   ******************************************************************************/

  if (highScore < score) {
    highScore = score; // sets the high score to the new score if its less than the score
  }

  /** Lives Left are Greater than 1 **/
  /** Game Over Screen **/

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
  /** Game Finished Screen **/

  else {

    // styling for game finished text
    fill(230, 202, 202);

    image(gameFinished, gameFinishedX+50, 0); // displays game finished image

    // changes font for lives left if they are 0
    animatedFont = createFont("yoster.ttf", 25);
    textFont(animatedFont);

    text("Your Highest Score: " + highScore, width-475, height-400); // displays final high score of player

    textSize(23);// changes text size for the repeat game text

    text("Would you like to continue playing or not?", width/2-250, height-300); // game finished text
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
