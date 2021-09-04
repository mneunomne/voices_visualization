class Word {
  String source_path = "C:/Users/mneunomne/Documents/Processing/voices_controller/data/points/";
  String audio_id;
  String user_id;
  String text;
  boolean isEmpty = false;
  ArrayList<PVector> points;
  int w;
  int h;
  boolean isLoaded = false; 

  Word (JSONObject audio) {
    // word
    audio_id = audio.getString("id");
    user_id = audio.getString("user_id");
    text = audio.getString("text");
  }

  void load () {
    if (text.equals("")) {
      isEmpty = true;
      return;
    }
    points = new ArrayList<PVector>();
    // load json file data
    JSONObject wordData = loadJSONObject(source_path + audio_id + ".json");
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

  void drawDebug (float scale) {
    if (!isLoaded) return; 
    for (PVector point : points) {
      point(point.x * scale, point.y * scale);
    }
  }

  void draw (float theta, float radius) {
  float circ = TWO_PI * radius;
  float segment_angle = (w / circ) * TWO_PI;
   for (PVector point : points) {
      float angle = (segment_angle / w) * point.x + theta;
      float r = radius - point.y;
      float posx = cos(theta) * r;
      float posy = sin(theta) * r;
      
      rect(posx, posy, 1, 1);
    }
  }

  String getId () {
    return audio_id;
  }
}