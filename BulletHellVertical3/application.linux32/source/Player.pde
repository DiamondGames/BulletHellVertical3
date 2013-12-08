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

  void show()
  {
    noStroke();
    fill(0, 255, 0);
    triangle(loc.x - 15, loc.y + 15, loc.x + 15, loc.y + 15, loc.x, loc.y - 15);
    strokeWeight(6);
    stroke(255, 0, 0);
    point(loc.x, loc.y);
  }

  void run()
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

