// Game for Nina

// Variables
// Sounds
import ddf.minim.*;
Minim minim;
AudioPlayer tune;
AudioPlayer throw_sound;
AudioPlayer glass_sound;
// Game Logic
boolean play = false;
boolean pause = false;
boolean sound_on = true;
// Text
// start_screen
PImage hbc;
String start_greeting = "Happy 16th Birthday, Sister!";
String start_wish = "Never let go the child\ninside of you (:";
String start_press = "To see my present press\nthe Start button.";
String start_button = "Start";
// pause_screen
String resume = "Resume";
// play screen
String pause_button = "pause";
String sound = "sound:";
String on = "on";
String off = "off";
// Window Light
int time = 40;
WindowLight light = new WindowLight();
// Snowball
Snowball snowball = new Snowball();
boolean fly = false;
// Mitten
PImage mitten_img;
Mitten mitten;
// Snowflakes
PImage snowflake;
float snow_vel = 1;
int sf_number = 16;
Snowflake[] snowflakes = new Snowflake[sf_number];
// Aim coordinates!
float aim_x;
float aim_y;
// Game helpers
boolean bingo = false;
int score = 0;

// Main setup and procedures
public void setup(){
  // Sound
  minim = new Minim(this);
  tune = minim.loadFile("sound/NeilSedaka.mp3");
  tune.setVolume(0.5);
  tune.loop();
  throw_sound = minim.loadFile("sound/throw.mp3");
  throw_sound.setVolume(1);
  glass_sound = minim.loadFile("sound/glass.mp3");
  glass_sound.setVolume(0.7);
  size(300, 500);
  frameRate(25);
  background(0);
  // HB Image
  hbc = loadImage("img/hbc.jpg");
  // Mitten
  mitten_img = loadImage("img/mitten.png");
  mitten_img.resize(55, 55);
  mitten = new Mitten(mitten_img);
  // Snowflakes
  snowflake = loadImage("img/snowflake.png");
  snowflake.resize(25, 25);
  for (int i = 0; i < snowflakes.length; i++) {
      snowflakes[i] = new Snowflake(snowflake);
  }
}

void draw(){
  
  // Game Logic
  if (play == false && pause == false) { // start screen
    tune.play();
    noStroke();
    background(125, 125, 255);
    image(hbc, 0, 0);
    fill(200, 200, 255);
    textSize(20);
    text(start_greeting, 15, 100);
    fill(255, 125, 125);
    rect(100, 150, 100, 50);
    fill(125, 125, 255);
    textSize(20);
    text(start_button, 128, 182);
    fill(125, 125, 255);
    textSize(20);
    text(start_press, 40, 265);
    fill(255, 255, 255);
    text(start_wish, 40, 372);
  } else if (play == true && pause == false) { // play screen
    // play settening
    strokeWeight(2);
    background(0);
    fill(255);
    stroke(255);
    rect(50, 400, 200, 100);
    triangle(0, 500, 50, 400, 50, 500);
    triangle(250, 400, 250, 500, 300, 500);
    // house
    fill(205, 100, 0);
    stroke(205, 100, 0);
    rect(50, 75, 200, 325);
    fill(255);
    stroke(255);
    strokeJoin(MITER);
    triangle(50, 75, 75, 75, 75, 50);
    rect(75, 50, 150, 25);
    triangle(225, 50, 225, 75, 250, 75);
    // windows
    for (int i = 0; i < 81; i += 80) {
      for (int j = 0; j < 181; j+= 60) {
        pushMatrix();
        translate(i, j);
        beginShape();
        fill(#5fccff);
        stroke(#5fccff);
        rect(75, 100, 70, 50);
        stroke(255);
        line(110, 100, 110, 150);
        line(75, 125, 145, 125);
        endShape();
        popMatrix();
      }
    }
    // door
    fill(175);
    stroke(175);
    rect(145, 375, 10, 25);
    
    // Window Light Blink
    light.shine();
    
    // Snowball
    if (fly) {
      snowball.thrown();
    } else {
      snowball.hold();
    }
    
    // Mitten move
    mitten.show();
  
    // Info
    fill(255, 0, 0);
    textSize(15);
    text("score: "+score, 200, 15);
    // Buttons
    stroke(255);
    fill(0);
    rect(5, 5, 55, 15);
    fill(255, 0, 0);
    text(pause_button, 12, 17);
    fill(0);
    rect(62, 5, 80, 15);
    fill(255, 0, 0);
    if (sound_on == true) {
      text(sound + on, 68, 17);
    } else {
      text(sound + off, 68, 17);
    }
    
    // falling snow
    for (Snowflake flake : snowflakes) {
      flake.fall();
    }
    
    // Game logic
    if (bingo && score % 10 == 1) { // Decrease each time score gets bigger by ten
      time--;
    }
    
    // Sound Logic
    if (sound_on) {
      tune.play();
    } else {
      tune.pause();
    }
    
  } else { // pause screen
    noStroke();
    fill(#5fccff);
    rect(35, 150, 227, 70);
    fill(255);
    textSize(52);
    text(resume, 50, 200);
  } 
}

// MousePress helder
void mousePressed() {
  if (play) { // Game on
    if (pause) { // Game is paused
      if (mouseX > 35 && mouseX < 262 && mouseY > 150 && mouseY < 220) { // Resume button is pressed
        pause = false;
      }
    } else {
      //Pause button
      if (mouseX > 5 && mouseX < 60 && mouseY > 5 && mouseY < 20) { // Pause button is pressed
        pause = true;
      }
      // Sound button
      if (mouseX > 62 && mouseX < 142 && mouseY > 5 && mouseY < 20) { // Pause button is pressed
        sound_on = !sound_on;
      }
      // Snowball throw
      if (mouseY > 30) {
        fly = true;
      }
    }
  } else { // Start screen
    if (mouseX > 100 && mouseX < 200 && mouseY > 150 && mouseY < 200) { // Check if the Start button is pressed
      play = true;
    }
  }
}


// Objects
class Snowflake {
  PImage obj_img;
  float rate_x = width/9;
  float pos_x = random(rate_x, width-rate_x);
  float pos_y = random(-height);
  float acceleration = random(3, 5);
  public Snowflake(PImage img) {
    this.obj_img = img;
  }
  
  private void fall() {
    pos_y += snow_vel*this.acceleration;
    image(this.obj_img, pos_x, pos_y);
    if (pos_y > height) {
      pos_x = random(rate_x, width-rate_x);
      pos_y = random(-height);
    }
  }
}

class WindowLight {
  float translateX;
  float translateY;
  color fill_color;
  private void shine() {
    if (frameCount % time == 0) {
      this.translateX = floor(random(2))*80;
      this.translateY = floor(random(4))*60;
    }
    if (bingo) {
      fill_color = color(255, 0, 0);
      bingo = false;
    } else {
      fill_color = color(255, 255, 0);
    }
    pushMatrix();
    translate(this.translateX, this.translateY);
    beginShape();
    fill(fill_color);
    stroke(fill_color);
    rect(75, 100, 70, 50);
    stroke(255);
    line(110, 100, 110, 150);
    line(75, 125, 145, 125);
    endShape();
    popMatrix();
    aim_x = 75 + this.translateX;
    aim_y = 100 + this.translateY;
  }
}

class Mitten {
  PImage img;
  Mitten(PImage i) {
    this.img = i;
  }
  
  private void show() {
    imageMode(CENTER);
    image(this.img, mouseX, mouseY);
  }
}

class Snowball {
  float size;
  float x;
  int x_direction;
  float y;
  float scaleX = cos(PI/3);
  float scaleY = sin(PI/3);
  float speed = 10;
  float velX = speed*scaleX;
  float velY = speed*scaleY;
  private void hold() {
    this.size = 50;
    fill(255);
    stroke(255);
    ellipse(mouseX+5, mouseY-10, size, size);
    this.x = mouseX;
    this.y = mouseY;
    if (mouseX < width/2) {
      this.x_direction = 1;
    } else {
      this.x_direction = -1;
    }
  }
  
  private void thrown() {
    if (size > 0) {
      throw_sound.rewind();
      throw_sound.play();
      fill(255);
      stroke(255);
      ellipse(this.x, this.y, this.size, this.size);
      this.x += x_direction*velX;
      this.y -= velY;
      this.size -= 5;
    } else {
      //throw_sound.pause();
      //throw_sound.rewind();
      if (this.x > aim_x && this.x < (aim_x+70) && this.y > aim_y && this.y < (aim_y+50)) {
        throw_sound.pause();
        glass_sound.rewind();
        glass_sound.play();
        score += 1;
        bingo = true;
      } else {
        score -= 1;
      }
      fly = false;
    }
  }
}