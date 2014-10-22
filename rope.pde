//import toxi.physics2d.*;
import java.util.*;
import toxi.geom.*;
import toxi.physics.*;
import toxi.physics.behaviors.*;


VerletPhysics physics;
Particle repeller;

color bg, fg;

void setup() {
  size(1024, 768);
  frameRate(120);
  bg = color(0);
  fg = color(255);
  smooth(8);
  initPhysics();
  repeller = new Particle(new Vec3D(width/2,height/2,0));
}

void draw() {
  repeller.set(mouseX, mouseY, 0);
  physics.update();
  background(bg);
  stroke(fg);
  strokeWeight(3);
  beginShape(LINES);
  for (Iterator i = physics.springs.iterator(); i.hasNext();) {
    VerletSpring s = (VerletSpring) i.next();
    vertex(s.a);
    vertex(s.b);
  }
  endShape();
  if (mouseX == pmouseX || mouseY == pmouseY) {
    //repeller.deactivate();
    
  }
  repeller.display();
}

void initPhysics() {
  physics = new VerletPhysics();
  Vec3D startPos;
  Vec3D dir;
  physics.addBehavior(new GravityBehavior(Vec3D.Y_AXIS.scale(0.05)));
  for (int i = 0; i <= width; i+=width/144) {
    startPos = new Vec3D(i, 0, 0);
    dir = new Vec3D(0, 20, 0);
    ParticleString string = 
      new ParticleString(physics, startPos, dir, height/20, 10, 1.8);
    string.getHead().lock();
    string.getTail().lock();
  }
  /*
  Vec3D startPos = new Vec3D(width/2, 0, 0);
  Vec3D dir = new Vec3D(0, 10, 0);
  ParticleString string = 
    new ParticleString(physics, startPos, dir, height/10, 1, 1.0);
  string.getHead().lock();
  string.getTail().lock();
  startPos = new Vec3D(width/2-10, 0, 0);
  dir = new Vec3D(0, 10, 0);
  string = 
    new ParticleString(physics, startPos, dir, height/10, 10, 1.0);
  string.getHead().lock();
  string.getTail().lock();
  */
}


class Particle extends VerletParticle {
  float r;
  boolean attractionActive = true;
  AttractionBehavior attraction ;
  public Particle(Vec3D loc) {
    super(loc);
    r = 8;
    attraction = new AttractionBehavior(this, r*8, -0.5, 1);
    physics.addParticle(this);
    physics.addBehavior(attraction);
  }

  void display() {
    fill(255);
    ellipse (x, y, r, r);
  }
  
  void activate() {
    
    if (!attractionActive) {
      print("adding particle: ");
      physics.addBehavior(attraction);
    }
    attractionActive = true;
  }
  
  void deactivate() {
    
    if (attractionActive) {
      print("removing particle behavior: ");
      physics.removeBehavior(attraction);
    }
    attractionActive = false;
  }
}

void vertex(Vec3D v) {
  vertex(v.x, v.y);
}

void mouseMoved() {
  //repeller.activate();
}

void mouseClicked() {
  repeller.deactivate();
}
