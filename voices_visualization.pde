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

int numVoices = 8;
float blurAmount = 80;

PShader blur;

boolean debug_mode = true;

void setup () {
  size(displayWidth, displayHeight, P2D);
  // size(800, 600, P3D);

  blur = loadShader("blur.glsl");

  screen = createGraphics(height, height, P2D);

  oscListener = new OscListener(32000);

  archive = new Archive();
  archive.load();

  ellipseMode(RADIUS);

  test_word = archive.getWord("");

  background(0);

  frameRate(30);
}

void draw () {
  screen.beginDraw();
  screen.fill(0, blurAmount);
  screen.rect(-1, -1, screen.width + 2, screen.height + 2);
  screen.stroke(255);
  screen.pushMatrix();
  screen.translate(screen.width/2, screen.height/2);
  for (Speaker s : speakers) {
    s.draw();
  }
  screen.filter(blur);
  screen.popMatrix();
  screen.endDraw();
  image(screen, 0, 0);

  if (debug_mode) debug();
}

void debug() {
  fill(255);
  text("fps: "+ frameRate, 10, 10);
}

int getSpeakerIndexFromId (String id) {
  for(int i = 0; i < speakers.size(); i++) {
    if (id.equals(speakers.get(i).id)) {
      return i;
    }
  }
  return 0;
}

int getSpeakerIndexFromVoiceIndex (int voice_index) {
  for(int i = 0; i < speakers.size(); i++) {
    println("voice_index", speakers.get(i).voiceIndex, voice_index);
    if (voice_index == speakers.get(i).voiceIndex) {
      return i;
    }
  }
  return 0;
}

void setBlur (float value) {
  blurAmount = value;
}