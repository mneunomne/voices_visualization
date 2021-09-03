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

  void draw (float scale) {
    if (!isLoaded) return; 
    for (PVector point : points) {
      point(point.x * scale + (random(5) - 10), point.y * scale + (random(5) - 10));
    }
  }

  String getId () {
    return audio_id;
  }
}