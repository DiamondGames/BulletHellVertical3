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
      speed = 1.5;
      shootRate = 10;
      shootTimer = 0;
      bulletSize = 25;
      bulletSpeed = 1;
      hp = 4;
      value = 2;
    }
  }

  void show()
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

  void run()
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

