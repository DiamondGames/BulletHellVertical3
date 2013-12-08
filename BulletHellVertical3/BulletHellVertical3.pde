/* @pjs font=""Aparajita-48.vlw""; 
 globalKeyEvents=true; 
 pauseOnBlur=true; 
 */

Player p;
Button[] buttons;
ArrayList < Bullet > bullets;
ArrayList < Enemy > enemies;
ArrayList < Integer > highScores;
boolean[] keys;
boolean shouldRestart, fire, paused, runOnce, inShop;
int timesToRun, currentLevel, fontSize, bombs, hpCost, timeIntoScoreCost, grazeIntoScoreCost, killsIntoScoreCost, bombNumCost, perkPoints, bombNumModifier, hpModifier;
float score, timeIntoScoreModifier, grazeIntoScoreModifier, killsIntoScoreModifier, highScoreModifier;
float[] enemyCreateRates;
int[] enemyCreateTimers, perkEquiped;
PFont font;

final int BORDER_WIDTH = 25;
final int BUTTON_NUM = 10;

void setup() {
  size(550, 675);
  frameRate(60);
  smooth();
  //restart();
  highScoreModifier = 0;
  perkPoints = 10;
  perkEquiped = new int[BUTTON_NUM];
  for (int i = 0; i < BUTTON_NUM; i++)
    perkEquiped[i] = 0;
  highScores = new ArrayList < Integer > ();
  highScores.add(0);
  highScores.add(25);
  inShop = false;
  hpCost = 6;
  bombNumCost = 6;
  timeIntoScoreCost = 1;
  grazeIntoScoreCost = 1;
  killsIntoScoreCost = 1;
  hpModifier = 0;
  bombNumModifier = 0;
  timeIntoScoreModifier = 0;
  grazeIntoScoreModifier = 0;
  killsIntoScoreModifier = 0;
  buttons = new Button[BUTTON_NUM];
  buttons[0] = new Button(new PVector(width / 4, 150), fontSize, "HP - $" + hpCost);
  buttons[1] = new Button(new PVector(width / 4, 250), fontSize, "Unequip");
  buttons[2] = new Button(new PVector(width * .75, 150), fontSize, "Time Into Score - $" + timeIntoScoreCost);
  buttons[3] = new Button(new PVector(width * .75, 250), fontSize, "Unequip");
  buttons[4] = new Button(new PVector(width * .75, 350), fontSize, "Graze Into Score - $" + grazeIntoScoreCost);
  buttons[5] = new Button(new PVector(width * .75, 450), fontSize, "Unequip");
  buttons[6] = new Button(new PVector(width * .75, 550), fontSize, "Kills Into Score - $" + killsIntoScoreCost);
  buttons[7] = new Button(new PVector(width * .75, 650), fontSize, "Unequip");
  buttons[8] = new Button(new PVector(width / 4, 350), fontSize, "Bombs - $" + bombNumCost);
  buttons[9] = new Button(new PVector(width / 4, 450), fontSize, "Unequip");
  keys = new boolean[5];
  timesToRun = 1;
  currentLevel = 0;
  fontSize = 23;
  font = loadFont("Aparajita-48.vlw");
  textFont(font, fontSize);
  fire = true;
  shouldRestart = true;
}

void restart() {
  runOnce = true;
  shouldRestart = false;
  inShop = false;
  paused = false;
  p = new Player(new PVector(width / 2, height - BORDER_WIDTH - 1));
  bullets = new ArrayList < Bullet > ();
  enemies = new ArrayList < Enemy > ();
  enemyCreateRates = new float[3];
  enemyCreateRates[0] = 300;
  enemyCreateRates[1] = 500;
  enemyCreateRates[2] = 700;
  enemyCreateTimers = new int[enemyCreateRates.length];
  for (int i = 0; i < enemyCreateTimers.length; i++)
    enemyCreateTimers[i] = 0;
  score = 0;
  bombs = 3 + bombNumModifier;
  enemies.add(new Enemy(new PVector(random(BORDER_WIDTH, width - BORDER_WIDTH), random(BORDER_WIDTH, height / 4)), 1));
}

void draw() {
  for (int i2 = 0; i2 < timesToRun; i2++) {
    background(127);
    if (!inShop) {
      if (!shouldRestart && !paused) {
        if (currentLevel == 0) {
          for (int i = 0; i < bullets.size(); i++) {
            Bullet b = bullets.get(i);
            b.run();
            b.show();
          }
          for (int i = 0; i < enemies.size(); i++) {
            Enemy e = enemies.get(i);
            e.run();
            e.show();
          }
          p.run();
          p.show();
          for (int i = 0; i < enemyCreateTimers.length; i++)
            enemyCreateTimers[i]++;
          for (int i = 0; i < enemyCreateTimers.length; i++)
            if (enemyCreateTimers[i] >= enemyCreateRates[i]) {
              enemyCreateTimers[i] = 0;
              enemyCreateRates[i] *= .99;
              enemies.add(new Enemy(new PVector(random(BORDER_WIDTH, width - BORDER_WIDTH), random(BORDER_WIDTH, height / 4)), i + 1));
            }
          score += 1 / frameRate + timeIntoScoreModifier;
          fill(0);
          textAlign(LEFT, TOP);
          text("Score: " + round(score), 0, fontSize * 0);
          text("HP: " + p.hp, 0, fontSize * 1);
          text("Bombs: " + bombs, 0, fontSize * 2);
          if (score > highScores.get(highScores.size() - 1)) {
            highScores.add(int(highScores.get(highScores.size() - 1) + highScoreModifier));
            highScoreModifier = int(highScores.get(highScores.size() - 1));
            perkPoints++;
          }
        }
      } 
      else if (shouldRestart || paused) {

        fill(0);
        textAlign(CENTER, TOP);
        text("[r] to (re)start a new game", width / 2, fontSize * 6);
        text("[w,a,s,d] to move", width / 2, fontSize * 7);
        text("[SHIFT] to slow", width / 2, fontSize * 8);
        text("[SPACE] to clear all bullets", width / 2, fontSize * 9);
        text("[e] to enter shop", width / 2, fontSize * 10);
        text("[f] to toggle autofire", width / 2, fontSize * 11);
        text("[p] to pause", width / 2, fontSize * 12);
      }
    } 
    else {
      fill(0);
      textAlign(CENTER, TOP);
      text("Perk points: " + perkPoints, width / 2, fontSize * 0);
      text("Reach " + highScores.get(highScores.size() - 1) + " score in survival mode, beat levels, or get", width / 2, fontSize);
      text("achievements to earn perk points", width / 2, fontSize * 2);
      buttons[0].isVisible = true;
      buttons[2].isVisible = true;
      buttons[4].isVisible = true;
      buttons[6].isVisible = true;
      buttons[8].isVisible = true;
      if (hpCost > 6) buttons[1].isVisible = true;
      if (timeIntoScoreCost > 1) buttons[3].isVisible = true;
      if (grazeIntoScoreCost > 1) buttons[5].isVisible = true;
      if (killsIntoScoreCost > 1) buttons[7].isVisible = true;
      if (bombNumCost > 6) buttons[9].isVisible = true;
      for (int i = 0; i < BUTTON_NUM; i++) {
        if (buttons[i].isVisible) {
          if (buttons[i].pressed) {
            if (i == 0 && perkPoints >= hpCost) {
              if (perkEquiped[0] == 0) perkEquiped[0] = 1;
              perkPoints -= hpCost;
              hpCost++;
              hpModifier++;
            } 
            else if (i == 2 && perkPoints >= timeIntoScoreCost) {
              if (perkEquiped[2] == 0) perkEquiped[2] = 1;
              perkPoints -= timeIntoScoreCost;
              timeIntoScoreCost++;
              timeIntoScoreModifier += .01;
            } 
            else if (i == 4 && perkPoints >= grazeIntoScoreCost) {
              if (perkEquiped[4] == 0) perkEquiped[4] = 1;
              perkPoints -= grazeIntoScoreCost;
              grazeIntoScoreCost++;
              grazeIntoScoreModifier += .1;
            } 
            else if (i == 6 && perkPoints >= killsIntoScoreCost) {
              if (perkEquiped[6] == 0) perkEquiped[6] = 1;
              perkPoints -= killsIntoScoreCost;
              killsIntoScoreCost++;
              killsIntoScoreModifier += 1;
            } 
            else if (i == 8 && perkPoints >= bombNumCost) {
              if (perkEquiped[8] == 0) perkEquiped[8] = 1;
              perkPoints -= bombNumCost;
              bombNumCost++;
              bombNumModifier++;
            } 
            else if (i == 1) {
              if (perkEquiped[0] == 1) perkEquiped[0] = -1;
              else if (perkEquiped[0] == -1) perkEquiped[0] = 1;
            } 
            else if (i == 3) {
              if (perkEquiped[2] == 1) perkEquiped[2] = -1;
              else if (perkEquiped[2] == -1) perkEquiped[2] = 1;
            } 
            else if (i == 5) {
              if (perkEquiped[4] == 1) perkEquiped[4] = -1;
              else if (perkEquiped[4] == -1) perkEquiped[4] = 1;
            } 
            else if (i == 7) {
              if (perkEquiped[6] == 1) perkEquiped[6] = -1;
              else if (perkEquiped[6] == -1) perkEquiped[6] = 1;
            } 
            else if (i == 9) {
              if (perkEquiped[8] == 1) {
                perkEquiped[8] = -1;
                bombs -= bombNumCost - 5;
              } 
              else if (perkEquiped[8] == -1) {
                perkEquiped[8] = 1;
                bombs += bombNumCost - 5;
              }
            }
          }
          buttons[i].run();
          buttons[i].show();
          buttons[i].pressed = false;
        }
      }
      buttons[0].btnText = "HP - $" + hpCost;
      buttons[2].btnText = "Time Into Score - $" + timeIntoScoreCost;
      buttons[4].btnText = "Graze Into Score - $" + grazeIntoScoreCost;
      buttons[6].btnText = "Kills Into Score - $" + killsIntoScoreCost;
      buttons[8].btnText = "Bombs - $" + bombNumCost;
      if (perkEquiped[0] == -1) buttons[1].btnText = "Equip";
      else if (perkEquiped[0] == 1) buttons[1].btnText = "Unequip";
      if (perkEquiped[2] == -1) buttons[3].btnText = "Equip";
      else if (perkEquiped[2] == 1) buttons[3].btnText = "Unequip";
      if (perkEquiped[4] == -1) buttons[5].btnText = "Equip";
      else if (perkEquiped[4] == 1) buttons[5].btnText = "Unequip";
      if (perkEquiped[6] == -1) buttons[7].btnText = "Equip";
      else if (perkEquiped[6] == 1) buttons[7].btnText = "Unequip";
      if (perkEquiped[8] == -1) buttons[9].btnText = "Equip";
      else if (perkEquiped[8] == 1) buttons[9].btnText = "Unequip";
    }
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') keys[0] = true;
  else if (key == 'd' || key == 'D') keys[1] = true;
  else if (key == 'w' || key == 'W') keys[2] = true;
  else if (key == 's' || key == 'S') keys[3] = true;
  else if (keyCode == SHIFT) keys[4] = true;
  else if (key == ' ' && runOnce && bombs > 0) {
    bullets.clear();
    bombs--;
    runOnce = false;
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') keys[0] = false;
  else if (key == 'd' || key == 'D') keys[1] = false;
  else if (key == 'w' || key == 'W') keys[2] = false;
  else if (key == 's' || key == 'S') keys[3] = false;
  else if (keyCode == SHIFT) keys[4] = false;
  else if (key == 'r' || key == 'R') restart();
  else if (key == 'f' || key == 'F') fire = !fire;
  else if (key == 'p' || key == 'P') paused = !paused;
  else if (key == ' ') runOnce = true;
  else if (key == 'e' || key == 'E') inShop = !inShop;
}

void mouseReleased() {
  for (int i = 0; i < BUTTON_NUM; i++) {
    if (buttons[i].isVisible) {
      if (buttons[i].beingPressed && mouseX > buttons[i].loc.x - (buttons[i].buttonSize.x / 2) && mouseX < buttons[i].loc.x + (buttons[i].buttonSize.x / 2) && mouseY > buttons[i].loc.y - (buttons[i].buttonSize.y / 2) && mouseY < buttons[i].loc.y + (buttons[i].buttonSize.y / 2)) buttons[i].pressed = true;
    }
  }
}

class Bullet {
  PVector loc, vel;
  float speed;
  int size, GRAZE_RADIUS;
  boolean MADE_BY_PLAYER;

  Bullet(PVector loc, PVector vel, int size, float speed, boolean MADE_BY_PLAYER) {
    this.vel = vel;
    this.loc = loc;
    this.speed = speed;
    this.size = size;
    this.MADE_BY_PLAYER = MADE_BY_PLAYER;
    GRAZE_RADIUS = size + 50;
  }

  void show() {
    noStroke();
    if (!MADE_BY_PLAYER) {
      fill(255, 50);
      ellipse(loc.x, loc.y, size + GRAZE_RADIUS, size + GRAZE_RADIUS);
    }
    if (MADE_BY_PLAYER) fill(0, 255, 0);
    else fill(255, 255, 0);
    ellipse(loc.x, loc.y, size, size);
  }

  void run() {
    vel.limit(speed);

    PVector nextLoc = PVector.add(loc, vel);

    boolean onMap = nextLoc.x > -(GRAZE_RADIUS / 2) && nextLoc.x < width + (GRAZE_RADIUS / 2) && nextLoc.y > -(GRAZE_RADIUS / 2) && nextLoc.y < height + (GRAZE_RADIUS / 2);
    if (onMap) loc.set(nextLoc);
    else {
      bullets.remove(this);
    }
    for (int i = 0; i < enemies.size(); i++) {
      Enemy e = enemies.get(i);
      if (MADE_BY_PLAYER && loc.dist(e.loc) <= size / 2 + (e.size / 2)) {
        bullets.remove(this);
        e.hp -= p.damage;
      }
    }
    if (!MADE_BY_PLAYER && loc.dist(p.loc) <= GRAZE_RADIUS / 2) {
      score += .05 + grazeIntoScoreModifier;
      if (loc.dist(p.loc) <= size / 2) {
        bullets.remove(this);
        p.hp--;
      }
    }
  }
}

class Enemy {
  PVector loc, vel;
  float speed;
  int shootRate, shootTimer, PRESET, bulletSize, bulletSpeed, size, hp, value;
  //boolean active;

  Enemy(PVector loc, int PRESET) {
    this.loc = loc;
    this.PRESET = PRESET;
    size = 25;
    //active = true;
    vel = new PVector();
    if (PRESET == 1) {
      speed = 0;
      shootRate = 45;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 3;
      hp = 3;
      value = 1;
    } 
    else if (PRESET == 2) {
      speed = 0;
      shootRate = 30;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 3;
      hp = 5;
      value = 2;
    } 
    else if (PRESET == 3) {
      speed = 1.5;
      shootRate = 25;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 1;
      hp = 4;
      value = 2;
    }
  }

  void show() {
    strokeWeight(2);
    stroke(255, 0, 0);
    if (PRESET == 1) fill(255, 0, 0);
    else if (PRESET == 2) fill(255, 0, 255);
    else if (PRESET == 3) fill(0, 255, 255);
    ellipse(loc.x, loc.y, size, size);
  }

  void run() {
    if (hp <= 0) {
      enemies.remove(this);
      score += value + killsIntoScoreModifier;
    }
    if (PRESET == 3) {
      vel = PVector.sub(p.loc, loc);
      vel.limit(speed);
      loc.add(vel);
    }
    shootTimer++;
    if (shootTimer > shootRate) {
      shootTimer = 0;
      if (PRESET == 1 || PRESET == 3) bullets.add(new Bullet(new PVector(loc.x, loc.y), PVector.sub(p.loc, loc), bulletSize, bulletSpeed, false));
      else if (PRESET == 2) {
        PVector direction = PVector.sub(p.loc, loc);
        float m = direction.mag();
        float a = direction.heading2D();
        a -= .25;
        direction.x = m * cos(a);
        direction.y = m * sin(a);
        bullets.add(new Bullet(new PVector(loc.x, loc.y), new PVector(direction.x, direction.y), bulletSize, bulletSpeed, false));
        a += .5;
        direction.x = m * cos(a);
        direction.y = m * sin(a);
        bullets.add(new Bullet(new PVector(loc.x, loc.y), new PVector(direction.x, direction.y), bulletSize, bulletSpeed, false));
      }
    }
  }
}

class Player {
  PVector loc, vel;
  float speed;
  int shootRate, shootTimer, damage, hp;

  Player(PVector loc) {
    this.loc = loc;
    vel = new PVector();
    speed = 3;
    shootRate = 7;
    shootTimer = 0;
    damage = 1;
    hp = 3 + hpModifier;
  }

  void show() {
    noStroke();
    fill(0, 255, 0);
    triangle(loc.x - 15, loc.y + 15, loc.x + 15, loc.y + 15, loc.x, loc.y - 15);
    strokeWeight(6);
    stroke(255, 0, 0);
    point(loc.x, loc.y);
  }

  void run() {
    if (hp <= 0) shouldRestart = true;
    shootTimer++;
    if (shootTimer > shootRate && fire) {
      shootTimer = 0;
      bullets.add(new Bullet(new PVector(p.loc.x, p.loc.y), new PVector(0, -MAX_INT), 15, 6, true));
    }
    if (keys[0] || keys[1] || keys[2] || keys[3]) {
      vel.set(0, 0, 0);

      if (keys[4]) speed = 2;
      else speed = 4;

      if (keys[0]) vel.x = -speed;
      if (keys[1]) vel.x = speed;
      if (keys[2]) vel.y = -speed;
      if (keys[3]) vel.y = speed;
      vel.limit(speed);

      PVector nextLoc = PVector.add(loc, vel);

      boolean onMap = nextLoc.x > BORDER_WIDTH && nextLoc.x < width - BORDER_WIDTH && nextLoc.y > BORDER_WIDTH && nextLoc.y < height - BORDER_WIDTH;
      if (onMap) loc.set(nextLoc);
    }
  }
}

class Button {
  PVector loc, buttonSize;
  float fontSize;
  boolean beingPressed, pressed, isVisible;
  color buttonColor;
  String btnText;

  Button(PVector loc, float fontSize, String btnText) {
    this.loc = loc;
    this.fontSize = fontSize;
    this.btnText = btnText;
    buttonColor = color(100);
    beingPressed = false;
    pressed = false;
    isVisible = false;
  }

  void show() {
    if (!isVisible) return;
    buttonSize = new PVector(textWidth(btnText) + 25, fontSize + 25);
    noStroke();
    rectMode(CENTER);
    fill(buttonColor);
    rect(loc.x, loc.y, buttonSize.x, buttonSize.y);
    fill(0);
    textAlign(CENTER, CENTER);
    text("" + btnText, loc.x, loc.y);
  }

  void run() {
    if (mousePressed && mouseX > loc.x - (buttonSize.x / 2) && mouseX < loc.x + (buttonSize.x / 2) && mouseY > loc.y - (buttonSize.y / 2) && mouseY < loc.y + (buttonSize.y / 2)) {
      beingPressed = true;
      buttonColor = color(175);
    } 
    else buttonColor = color(100);
  }
}

