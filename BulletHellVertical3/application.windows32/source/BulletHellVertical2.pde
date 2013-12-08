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

void setup()
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

void restart()
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

void draw()
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
            enemyCreateRates[i] *= .99;
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

void keyPressed()
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

void keyReleased()
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

