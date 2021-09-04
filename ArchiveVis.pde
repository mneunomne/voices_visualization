class Archive {
  JSONArray audios;
  JSONArray users;
  ArrayList<Word> words = new ArrayList<Word>();
  String server_url = "https://pandemic-archive-of-voices-db.herokuapp.com"; // http://localhost:7777
  
  Archive () {
    // loadDatabase();
  }

  void load () {
    // get database data from api
    GetRequest get = new GetRequest(server_url + "/api/data");
    get.send();
    get.addHeader("Accept", "application/json");
    JSONObject json = parseJSONObject(get.getContent());

    // save audio and user list locally
    audios = json.getJSONArray("audios");
    users = json.getJSONArray("users");

    // create .json points for each word in database
    for (int i = 0; i < audios.size(); i++) {    
      JSONObject audio = audios.getJSONObject(i);
      String text = audio.getString("text");
      // create words only for audio with text
      if (text.length() > 0) {
        Word word = new Word(audio);
        word.load();
        words.add(word);
      }
    }
    
    // create the moving points for each user
    for (int i = 0; i < users.size(); i++) {    
      JSONObject user = users.getJSONObject(i); 
      String name = user.getString("name");
      String id = user.getString("id");
      Speaker s = new Speaker(id, i);
      speakers.add(s);
    }
    println("[ArchiveVis] Loaded database with " + audios.size() + " audios");
    // loaded!
  }

  void addNewAudio (JSONObject new_audio_data) {
    audios.append(new_audio_data);
    println("[ArchiveVis] New audio data appended, with now " + audios.size() + " audios");
    // create points json file for new audio...

    Word word = new Word(new_audio_data);
    words.add(word);
    word.load();
  }

  void firstLoad () {
    for (Word word : words) {
      word.load();
    }
  }

  void addNewSpeaker (JSONObject new_speaker) {
    // append new speaker
    String id = new_speaker.getString("id");
    Speaker s = new Speaker(id, speakers.size());
    speakers.add(s);
    println("[ArchiveVis] New speaker data appended, with now " + speakers.size() + " users");
  }

  Word getWord (String id) {
    for (Word w : words) {
      if (w.getId().contains(id)) {
        return w;
      }
    }
    // else just get first word
    return words.get(0);
  }

  void debug () {
    int x = 20;
    int y = 20;
    for (int i = 0; i < 20; i++) {
      Word w = words.get(i);
      translate(x, y);
      w.drawDebug(1);
      translate(-x, -y);
      y+=30;
      if (y > height - 10) {
        y = 80;
        x+=200;
      }
    }
  }

  JSONArray getAudios () {
    return audios;
  }

  JSONArray getUsers () {
    return users;
  }
}