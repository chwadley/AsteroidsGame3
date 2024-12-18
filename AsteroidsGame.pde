boolean[] keys = new boolean[91];

int mode = 0;

float _random(float a, float b) {
  return (float)(Math.random()*(b-a)+a);
}

float _dist(float[] a, float[] b) {
  return dist(a[0],a[1],b[0],b[1]);
}

int count=0;
int count2=0;
int shots=0;
int frameNum=0;
int totalAsteroids = 620;
boolean bullets=false;
boolean breakAsteroids=true;
boolean controls=true; //new=true
boolean laser=false;
ship s;
ArrayList <rock> rocks = new ArrayList <rock>();
ArrayList <particle> particles = new ArrayList <particle>();
input currentInput;
star[] stars = new star[20];
int totalFrames=0;

void setup() {
  size(1500,800);
  s = new ship(width/2,height/2);
  for (int i=0;i<40;i++) { //20
    rocks.add(new rock(50,new float[]{_random(0,width),_random(0,height)}));
  }
  for (int i=0;i<stars.length;i++) {
    stars[i] = new star();
  }
}

void draw() {
  background(0);
  //find the closest asteroid
  float best=10000;
  //int bestidx=0;
  float[] targetPos = new float[]{1113910203,1923094859};
  float[] pos = s.getPos();
  for (int i=0;i<rocks.size();i++) {
    rock a = rocks.get(i);
    float _d = _dist(pos,a.getPos());
    if (_d<=best) {
      best=_d;
      //bestidx=i;
      targetPos=a.getPos();
    }
  }
  //accelerate in the direction of the asteroid
  float xAcc = pos[0]-targetPos[0];
  float yAcc = pos[1]-targetPos[1];
  float[] vel = s.getVelocity();
  currentInput = new input(false,false,yAcc+vel[1]>0,yAcc+vel[1]<0,xAcc+vel[0]>0,xAcc+vel[0]<0);
  frame();
}

void frame() {
  for (int i=0;i<stars.length;i++) {
    star a = stars[i];
    a.move();
    a.show();
  }
  s.moveStepEachFrame();
  s.show();
  for (int i=0;i<rocks.size();i++) {
    rock a = (rock)rocks.get(i);
    a.move();
    a.show();
    for (int j=0;j<particles.size();j++) {
      //particle b = particles.get(j);
      if (_dist(a.getPos(),particles.get(j).getPos())<a.getSize()/2) {
        float _size=a.getSize();
        float[] _pos=a.getPos();
        rocks.remove(i);
        count++;
        if (_size>10&&breakAsteroids) {
          rocks.add(i,new rock(_size/1.5,_pos));
          rocks.add(i,new rock(_size/1.5,_pos));
          i++;
        } else {
          i--;
          smallAsteroidBroken();
        }
        particles.remove(j);
        break;
      }
    }
    if (_dist(a.getPos(),s.getPos())<a.getSize()/2) {
      if (bullets) {
        end();
      } else {
        float _size=a.getSize();
        float[] _pos=a.getPos();
        rocks.remove(i);
        count++;
        if (breakAsteroids&&_size>10) {
          rocks.add(i,new rock(_size/1.5,_pos));
          rocks.add(i,new rock(_size/1.5,_pos));
          i++;
        } else {
          i--;
          smallAsteroidBroken();
        }
      }
    }
  }
  for (int i=0;i<particles.size();i++) {
    particle a = (particle)particles.get(i);
    a.move();
    a.show();
    if (a.check()) {
      particles.remove(i);
      i--;
    }
  }
  fill(currentInput.left?255:128);
  stroke(255);
  rect(5,405,40,40);
  fill(currentInput.down?255:128);
  rect(45,405,40,40);
  fill(currentInput.right?255:128);
  rect(85,405,40,40);
  fill(currentInput.up?255:128);
  rect(45,365,40,40);
}

void smallAsteroidBroken() {
  count2++;
  if (count==totalAsteroids) {
    goodEnd();
  }
}

void keyPressed() {
  if (keyCode<keys.length) keys[keyCode]=true;
}

void keyReleased() {
  if (keyCode<keys.length) {
    keys[keyCode]=false;  
  }
}

void reset() {
  count=0;
  count2=0;
  shots=0;
  particles.clear();
  rocks.clear();
  setup();
  loop();
}

void end() {
  fill(0,128);
  noStroke();
  rect(0,0,width,height);
  fill(255);
  stroke(128);
  rect(mouseX-100,mouseY-50,200,100);
  noStroke();
  fill(0);
  textAlign(CENTER,CENTER);
  text("Asteroids hit:"+count,mouseX,mouseY-25);
  text(count2+" of those were the smallest size",mouseX,mouseY);
  text("You used "+shots+" bullets",mouseX,mouseY+25);
  noLoop();
}

void goodEnd() {
  fill(0,128);
  noStroke();
  rect(0,0,width,height);
  fill(255);
  stroke(128);
  rect(mouseX-200,mouseY-50,400,100);
  noStroke();
  fill(0);
  textAlign(CENTER,CENTER);
  text("You got all "+count+" asteroids,\n\nincluding "+count2+" asteroids of the smallest size.\n\nYou used "+shots+" bullets\n\nTime: "+frameCount/60,mouseX,mouseY);
  noLoop();
}

ArrayList <input> copyInputs(ArrayList <input> _inputs) {
  ArrayList <input> newInputs = new ArrayList <input>();
  for (int i=0;i<_inputs.size();i++) {
    newInputs.add(_inputs.get(i).copy());
  }
  return newInputs;
}
