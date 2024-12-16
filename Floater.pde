class Floater {
  protected int corners, col;
  protected int[] cx, cy;
  protected float x, y, dx, dy, dir;
  
  public void accelerate(float a) {
    dx += a * Math.cos(dir);
    dy += a * Math.sin(dir);
  }
  
  public void turn(double a) {
    dir+=a;
  }
  
  public void move() {
    x += dx;
    y += dy;
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
  }
  
  public void show() {
    fill(col);
    translate(x,y);
    rotate(dir);
    beginShape();
    for (int i = 0; i < corners; i++) vertex(cx[i], cy[i]);
    endShape(CLOSE);
    rotate(-dir);
    translate(-x,-y);
  }   
}
