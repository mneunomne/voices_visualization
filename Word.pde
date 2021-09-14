class Word {
  String audio_id;
  String user_id;
  String text;
  boolean isEmpty = false;
  ArrayList<PVector> points;
  int w;
  int h;
  boolean isLoaded = false; 
  float opacity = 0;
  int startTransitionTime = 0;
  int transitionTime = 500;

  float gaussianRadius = 30;

  boolean show = false;
  boolean hideTransition = false;
  Speaker mySpeaker;

  int speaker_index;

  boolean hide = false;

  Word (JSONObject audio, Speaker s, int _speaker_index) {
    // word
    audio_id = audio.getString("id");
    user_id = audio.getString("user_id");
    text = audio.getString("text");
    mySpeaker = s;
    _speaker_index = speaker_index;
  }

  void load () {
    if (text.equals("")) {
      isEmpty = true;
      return;
    }
    points = new ArrayList<PVector>();
    // load json file data
    String path = points_path + audio_id + ".json";
    File f = dataFile(path);
    boolean exist = f.isFile();
    if (!exist) {
      println("[Word] file doesnt exist, skipping", path);
      return;
    }
    JSONObject wordData = loadJSONObject(points_path + audio_id + ".json");
    JSONArray jsonPoints = wordData.getJSONArray("points");
    w = wordData.getInt("width");
    h = wordData.getInt("height");
    for (int i = 0; i < jsonPoints.size(); i++) {
      JSONObject posObj = jsonPoints.getJSONObject(i);
      float x = posObj.getFloat("x");
      float y = posObj.getFloat("y");
      PVector pos = new PVector(x, y);
      points.add(pos);
    }
    println("[Word] loaded json data", points.size());
    isLoaded = true;
  }

  void show (float _opacity, int _startTransitionTime) {
    startTransitionTime = _startTransitionTime;
    opacity = _opacity;
    if (!show) {
      show = true;
      hide = false;
      gaussianRadius = 30;
    }
  }

  void reset () {
    startTransitionTime = 0;
    show = false; 
    opacity = 0.0;
  }

  void hide () {
    show = false;
    hide = true;
    startTransitionTime = millis();
  }

  void drawDebug (float scale) {
    if (!isLoaded) return; 
    for (PVector point : points) {
      screen.point(point.x * scale, point.y * scale);
    }
  }

  void update () {
    if (show) {
      int now = millis();
      opacity = float(min(now - startTransitionTime, 1000))/1000;
    } else {
      int now = millis();
      opacity = 1 - float(min(now - startTransitionTime, 1000))/1000;
      if (opacity == 0.0 && hide) {
        hide = false;
        speakers.get(speaker_index).hideWord();
      }
    }
  }

  void draw (float theta, float radius, float reverb) {

    float circ = TWO_PI * radius;
    float segment_angle = (w / circ) * TWO_PI;
    // println("opacity", opacity)
    screen.stroke(255, 255 * opacity);
    for (PVector point : points) {
      float angle = (segment_angle / w) * point.x + (theta - segment_angle/2);
      float r = radius - point.y + h/2;
      float posx = cos(angle) * r;
      float posy = sin(angle) * r;
      float noiseX = randomGaussian() * gaussianRadius * (1 - opacity);
      float noiseY = randomGaussian() * gaussianRadius * (1 - opacity);

      posx = posx + noiseX;
      posy = posy + noiseY;
      strokeWeight(1);
      screen.point(posx, posy);
    }
  }

  String getId () {
    return audio_id;
  }
}