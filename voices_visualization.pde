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

boolean debug_mode = false;

JSONObject config;

int osc_port;
String points_path = "/Users/hfkmacmini/voices_controller/data/points/";

boolean is_fullscreen;

boolean hasNewUser = false;
Speaker newSpeaker;

void setup () {
  // size(displayWidth, displayHeight, P3D);
  fullScreen(P3D, 2);
  // size(800, 600, P3D);

  // load config
  config = loadJSONObject("data/config.json");
  points_path = config.getString("points_path");
  osc_port = config.getInt("osc_port");
  is_fullscreen = config.getBoolean("is_fullscreen");


  blur = loadShader("blur.glsl");
  ks = new Keystone(this);
  screen = createGraphics(height, height, P3D);
  surface = ks.createCornerPinSurface(height, height, 20);

  oscListener = new OscListener(osc_port);

  archive = new Archive();
  archive.load();

  ellipseMode(RADIUS);

  test_word = archive.getWord("");

  background(0);

  frameRate(30);

  ks.load();
}

void draw () {
  if (hasNewUser) {
    speakers.add(newSpeaker);
    hasNewUser =false;
  }


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
  if (debug_mode) {
    screen.noFill();
    screen.stroke(255);
    screen.strokeWeight(3);
    screen.ellipse(0, 0, screen.height, screen.height);
    screen.line(0, -screen.height/2, 0, screen.height/2);
    screen.line(-screen.height/2, 0, screen.height/2, 0);
  }
  screen.popMatrix();
  screen.endDraw();
  // image(screen, 0, 0);
  background(0);
  surface.render(screen);

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

void keyPressed () {
  switch(key) {
    case 'c':
      // enter/leave calibration mode, where surfaces can be warped 
      // and moved
      ks.toggleCalibration();
      break;
    case 'l':
      // loads the saved layout
      ks.load();
      break;
    case 's':
      // saves the layout
      ks.save();
      break;
    case 'r':
      background(0);
      blur = loadShader("blur.glsl"); 
      break;
    case 'd':
      debug_mode = !debug_mode;
      break;
  }
}