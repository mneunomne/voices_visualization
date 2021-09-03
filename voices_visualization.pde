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

void setup () {
  size(displayWidth, displayHeight, P3D);
  // size(800, 600, P3D);

  screen = createGraphics(height, height, P3D);

  oscListener = new OscListener(32000);

  archive = new Archive();
  archive.load();

  test_word = archive.getWord("");
}

void draw () {
  background(0);
  stroke(255);
  archive.debug();
}