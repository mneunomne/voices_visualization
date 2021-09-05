import deadpixel.keystone.*;
import netP5.*;
import oscP5.*;
import java.net.URLEncoder;
import http.requests.*;

Keystone ks;
CornerPinSurface surface;

OscP5 oscP5;

PGraphics screen;

ArrayList<Speaker> speakers = new ArrayList<Speaker>();

Archive archive;

OscListener oscListener;

Word test_word; 

boolean ready = true; 

void setup () {
  size(displayWidth, displayHeight, P3D);
  // size(800, 600, P3D);

  background(0);

  screen = createGraphics(height, height, P3D);

  oscListener = new OscListener(32000);

  archive = new Archive();
  archive.load();

  ellipseMode(RADIUS);

  test_word = archive.getWord("");
}

void draw () {
  background(0);
  stroke(255);

  // archive.debug();

  pushMatrix();
  translate(width/2, height/2);
  for (Speaker s : speakers) {
    s.draw();
  }
  popMatrix();
}

int getSpeakerIndexFromId (String id) {
  for(int i = 0; i < speakers.size(); i++) {
    if (id.equals(speakers.get(i).id)) {
      return i;
    }
  }
  return 0;
}