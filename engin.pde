// Game for Nina

// Variables
// Window Light
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
  size(300, 500);
  frameRate(25);
  background(0);
  // Mitten
  mitten_img = loadImage("img/mitten.png");
  mitten_img.resize(50, 50);
  mitten = new Mitten(mitten_img);
  // Snowflakes
  snowflake = loadImage("img/snowflake.png");
  snowflake.resize(25, 25);
  for (int i = 0; i < snowflakes.length; i++) {
      snowflakes[i] = new Snowflake(snowflake);
  }
}

void draw(){
  // settening
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
  // Snowball fly
  if (mousePressed) {
    fly = true;
  }
  
  if (fly) {
    snowball.thrown();
  } else {
    snowball.hold();
  }
  
  // Mitten move
  mitten.show();

  // falling snow
  for (Snowflake flake : snowflakes) {
    flake.fall();
  }
  
  // Info
  fill(255, 0, 0);
  textSize(15);
  text("score: "+score, 200, 15);
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
  int time = 40;
  float translateX;
  float translateY;
  color fill_color;
  private void shine() {
    if (frameCount % this.time == 0) {
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
    ellipse(mouseX, mouseY, size, size);
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
      fill(255);
      stroke(255);
      ellipse(this.x, this.y, this.size, this.size);
      this.x += x_direction*velX;
      this.y -= velY;
      this.size -= 5;
    } else {
      if (this.x > aim_x && this.x < (aim_x+70) && this.y > aim_y && this.y < (aim_y+50)) {
        score += 1;
        bingo = true;
      }
      fly = false;
    }
  }
}