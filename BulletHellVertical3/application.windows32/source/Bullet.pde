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

  void show()
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

  void run()
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
      score += .05;
      if (loc.dist(p.loc) <= size / 2)
      {
        bullets.remove(this);
        //active = false;
        p.hp --;
      }
    }
  }
}

