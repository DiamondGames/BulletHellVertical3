import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BulletHellVertical2 extends PApplet {

/* @pjs font=""Aparajita-48.vlw""; 
 globalKeyEvents=true; 
 pauseOnBlur=true; 
 */

Player p;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
boolean[] keys;
boolean shouldRestart, fire, paused, runOnce;
int timesToRun, currentLevel, fontSize, bombs;
float score;
float[] enemyCreateRates;
int[] enemyCreateTimers;
PFont font;

final int BORDER_WIDTH = 25;

public void setup()
{
  size(500, 700);
  frameRate(60);
  smooth();
  restart();
  keys = new boolean[5];
  timesToRun = 1;
  currentLevel = 0;
  fontSize = 32;
  font = loadFont("Aparajita-48.vlw");
  textFont(font, fontSize);
  fire = true;
  restart();
}

public void restart()
{
  runOnce = true;
  shouldRestart = false;
  paused = false;
  p = new Player(new PVector(width / 2, height - BORDER_WIDTH - 1));
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();
  enemyCreateRates = new float[3];
  enemyCreateRates[0]= 300;
  enemyCreateRates[1]= 500;
  enemyCreateRates[2]= 700;
  enemyCreateTimers = new int[enemyCreateRates.length];
  for (int i = 0; i < enemyCreateTimers.length; i ++)
    enemyCreateTimers[i] = 0;
  score = 0;
  bombs = 3;
  enemies.add(new Enemy(new PVector(random(BORDER_WIDTH, width - BORDER_WIDTH), random(BORDER_WIDTH, height / 4)), 1));
}

public void draw()
{
  for (int i2 = 0; i2 < timesToRun; i2 ++)
  {
    if (!shouldRestart && !paused)
    {
      if (currentLevel == 0)
      {
        background(127);
        for (int i = 0; i < bullets.size(); i ++)
        {
          Bullet b = bullets.get(i);
          //if (b.active)
          //{
          b.run();
          b.show();
          //}
        }
        for (int i = 0; i < enemies.size(); i ++)
        {
          Enemy e = enemies.get(i);
          //if (e.active)
          //{
          e.run();
          e.show();
          //}
        }
        p.run();
        p.show();
        for (int i = 0; i < enemyCreateTimers.length; i ++)
          enemyCreateTimers[i] ++;
        for (int i = 0; i < enemyCreateTimers.length; i ++)
          if (enemyCreateTimers[i] >= enemyCreateRates[i])
          {
            enemyCreateTimers[i] = 0;
            enemyCreateRates[i] *= .99f;
            enemies.add(new Enemy(new PVector(random(BORDER_WIDTH, width - BORDER_WIDTH), random(BORDER_WIDTH, height / 4)), i + 1));
          }
        score += 1 / frameRate;
        fill(0);
        textAlign(LEFT, TOP);
        text("Score: " + round(score), 0, fontSize * 0);
        text("HP: " + p.hp, 0, fontSize * 1);
        text("Bombs: " + bombs, 0, fontSize * 2);
      }
    }
    else
    {
      textAlign(CENTER, BASELINE);
      text("[r] to restart", width / 2, height / 2);
    }
  }
}

public void keyPressed()
{
  if (key == 'a' || key == 'A')
    keys[0] = true;
  else if (key == 'd' || key == 'D')
    keys[1] = true;
  else if (key == 'w' || key == 'W')
    keys[2] = true;
  else if (key == 's' || key == 'S')
    keys[3] = true;
  else if (keyCode == SHIFT)
    keys[4] = true;
  else if (key == ' ' && runOnce && bombs > 0)
  {
    bullets.clear();
    bombs --;
    runOnce = false;
  }
}

public void keyReleased()
{
  if (key == 'a' || key == 'A')
    keys[0] = false;
  else if (key == 'd' || key == 'D')
    keys[1] = false;
  else if (key == 'w' || key == 'W')
    keys[2] = false;
  else if (key == 's' || key == 'S')
    keys[3] = false;
  else if (keyCode == SHIFT)
    keys[4] = false;
  else if (key == 'r' || key == 'R')
    restart();
  else if (key == 'f' || key == 'F')
    fire = !fire;
  else if (key == 'p' || key == 'P')
    paused = !paused;
  else if (key == ' ')
    runOnce = true;
}

class Bullet
{
  PVector loc, vel;
  float speed;
  int size, GRAZE_RADIUS;
  boolean MADE_BY_PLAYER;

  Bullet(PVector loc, PVector vel, int size, float speed, boolean MADE_BY_PLAYER)
  {
    this.vel = vel;
    this.loc = loc;
    this.speed = speed;
    this.size = size;
    this.MADE_BY_PLAYER = MADE_BY_PLAYER;
    //active = true;
    GRAZE_RADIUS = size + 50;
  }

  public void show()
  {
    noStroke();
    if (MADE_BY_PLAYER)
      fill(0, 255, 0);
    else
      fill(255, 255, 0);
    ellipse(loc.x, loc.y, size, size);
    if (!MADE_BY_PLAYER)
    {
      fill(255, 70);
      ellipse(loc.x, loc.y, size + GRAZE_RADIUS, size + GRAZE_RADIUS);
    }
  }

  public void run()
  {
    vel.limit(speed);

    PVector nextLoc = PVector.add(loc, vel);

    boolean onMap = nextLoc.x > -(GRAZE_RADIUS / 2) && nextLoc.x < width + (GRAZE_RADIUS / 2) && nextLoc.y > -(GRAZE_RADIUS / 2) && nextLoc.y < height + (GRAZE_RADIUS / 2);
    if (onMap)
      loc.set(nextLoc);
    else
    {
      bullets.remove(this);
      //active = false;
    }
    for (int i = 0; i < enemies.size(); i ++)
    {
      Enemy e = enemies.get(i);
      if (MADE_BY_PLAYER && loc.dist(e.loc) <= size / 2 + (e.size / 2))
      {
        bullets.remove(this);
        //active = false;
        e.hp -= p.damage;
      }
    }
    if (!MADE_BY_PLAYER && loc.dist(p.loc) <= GRAZE_RADIUS / 2)
    {
      score += .05f;
      if (loc.dist(p.loc) <= size / 2)
      {
        bullets.remove(this);
        //active = false;
        p.hp --;
      }
    }
  }
}

class Enemy
{
  PVector loc, vel;
  float speed;
  int shootRate, shootTimer, PRESET, bulletSize, bulletSpeed, size, hp, value;
  //boolean active;

  Enemy(PVector loc, int PRESET)
  {
    this.loc = loc;
    this.PRESET = PRESET;
    size = 25;
    //active = true;
    vel = new PVector();
    if (PRESET == 1)
    {
      speed = 0;
      shootRate = 45;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 3;
      hp = 3;
      value = 1;
    }
    else if (PRESET == 2)
    {
      speed = 0;
      shootRate = 30;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 3;
      hp = 5;
      value = 2;
    }
    else if (PRESET == 3)
    {
      speed = 1.5f;
      shootRate = 10;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 1;
      hp = 4;
      value = 2;
    }
  }

  public void show()
  {
    strokeWeight(2);
    stroke(255, 0, 0);
    if (PRESET == 1)
      fill(255, 0, 0);
    else if (PRESET == 2)
      fill(255, 0, 255);
    else if (PRESET == 3)
      fill(0, 255, 255);
    ellipse(loc.x, loc.y, size, size);
  }

  public void run()
  {
    if (hp <= 0)
    {
      enemies.remove(this);
      //active = false;
      score += value;
    }
    if (PRESET == 3)
    {
      vel = PVector.sub(p.loc, loc);
      vel.limit(speed);
      loc.add(vel);
    }
    shootTimer ++;
    if (shootTimer > shootRate)
    {
      shootTimer = 0;
      if (PRESET == 1 || PRESET == 3)
        bullets.add(new Bullet(new PVector(loc.x, loc.y), PVector.sub(p.loc, loc), bulletSize, bulletSpeed, false));
      else if (PRESET == 2)
      {
        PVector direction = PVector.sub(p.loc, loc);
        float m = direction.mag();
        float a = direction.heading2D();
        a -= .25f;
        direction.x = m * cos(a);
        direction.y = m * sin(a);
        bullets.add(new Bullet(new PVector(loc.x, loc.y), new PVector(direction.x, direction.y), bulletSize, bulletSpeed, false));
        a += .5f;
        direction.x = m * cos(a);
        direction.y = m * sin(a);
        bullets.add(new Bullet(new PVector(loc.x, loc.y), new PVector(direction.x, direction.y), bulletSize, bulletSpeed, false));
      }
    }
  }
}

class Player
{
  PVector loc, vel;
  float speed;
  int shootRate, shootTimer, damage, hp;

  Player(PVector loc)
  {
    this.loc = loc;
    vel = new PVector();
    speed = 3;
    shootRate = 7;
    shootTimer = 0;
    damage = 1;
    hp = 3;
  }

  public void show()
  {
    noStroke();
    fill(0, 255, 0);
    triangle(loc.x - 15, loc.y + 15, loc.x + 15, loc.y + 15, loc.x, loc.y - 15);
    strokeWeight(6);
    stroke(255, 0, 0);
    point(loc.x, loc.y);
  }

  public void run()
  {
    if (hp <= 0)
      shouldRestart = true;
    shootTimer ++;
    if (shootTimer > shootRate && fire)
    {
      shootTimer = 0;
      bullets.add(new Bullet(new PVector(p.loc.x, p.loc.y), new PVector(0, -MAX_INT), 15, 6, true));
    }
    if (keys[0] || keys[1] || keys[2] || keys[3])
    {
      vel.set(0, 0, 0);

      if (keys[4])
        speed = 2;
      else
        speed = 4;

      if (keys[0])
        vel.x = -speed;
      if (keys[1])
        vel.x = speed;
      if (keys[2])
        vel.y = -speed;
      if (keys[3])
        vel.y = speed;
      vel.limit(speed);

      PVector nextLoc = PVector.add(loc, vel);

      boolean onMap = nextLoc.x > BORDER_WIDTH && nextLoc.x < width - BORDER_WIDTH && nextLoc.y > BORDER_WIDTH && nextLoc.y < height - BORDER_WIDTH;
      if (onMap)
        loc.set(nextLoc);
    }
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BulletHellVertical2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
