float x = 400;
float y = 500;
  

void setup() {
 size(800, 600, P3D); 
 frameRate(60);
}

void draw() {
  background(0,0,0);
  color c1 = color(255,0,0);
  pushMatrix();
    translate(x, y, 0);
    rotateZ(radians(45));
    rotateY(frameCount * radians(5));
    fill(c1);
    rect(-50,-50,100,100);
  popMatrix();
  
  color c2 = get(mouseX, mouseY);
  if (c1 == c2) {
      x = random(50, width - 50);
      y = random(50, height - 50);
  }
}