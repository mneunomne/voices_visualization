class OscListener {
  OscP5 oscP5;
  OscListener(int port) {
    oscP5 = new OscP5(this,port);
  }

  void oscEvent(OscMessage theOscMessage) {
    if (!ready || speakers.size() == 0) return;

    /* 
    get and print the address pattern and the typetag of the received OscMessage 
    // println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
    // theOscMessage.print();
     */
    if (theOscMessage.checkAddrPattern("/pos")==true) {
      onPosMessage(theOscMessage);
      return;
    }

    
    if (theOscMessage.checkAddrPattern("/play")==true) {
      onPlayMessage(theOscMessage);
      return;
    }
    
    if (theOscMessage.checkAddrPattern("/end")==true) {
      onEndMessage(theOscMessage);
      return;
    }

    if (theOscMessage.checkAddrPattern("/reverb")==true) {
      onReverbMessage(theOscMessage);
      return;
    }
    
   
    if (theOscMessage.checkAddrPattern("/blur")==true) {
      onBlurMessage(theOscMessage);
      return;
    }

    if (theOscMessage.checkAddrPattern("/new_audio")==true) {
      onNewAudio(theOscMessage);
      return;
    }
  }

  void onPosMessage (OscMessage theOscMessage) {
    int index = theOscMessage.get(0).intValue();
    float theta = theOscMessage.get(1).floatValue();
    float radius = theOscMessage.get(2).floatValue() * height * 2;
    // println(index, theta, radius);
    // set speaker position
    if (speakers.size() > 0) {
      speakers.get(index).updatePos(theta, radius);
    }
    return;
  }

  // String speaker_id, String audio_id, int voice_index 
  void onPlayMessage(OscMessage theOscMessage) {
    String speaker_id = theOscMessage.get(0).stringValue();
    String audio_id = theOscMessage.get(1).stringValue();
    int voice_index = theOscMessage.get(2).intValue();
    // String word = URLDecoder.decode(theOscMessage.get(2).stringValue());
    Word word = archive.getWord(audio_id);
    // get speaker index
    int index = getSpeakerIndexFromId(speaker_id);
    println("/play", speaker_id, audio_id, index);
    // show word
    speakers.get(index).setVoiceIndex(voice_index);
    speakers.get(index).appearWord(word);
  }

  // String speaker_id, int voice_index 
  void onEndMessage(OscMessage theOscMessage) {
    String speaker_id = theOscMessage.get(0).stringValue();
    // int audio_id = theOscMessage.get(1).intValue();
    // get speaker index
    int index = getSpeakerIndexFromId(speaker_id);
    // hide word
    // println("end", index);
    speakers.get(index).hide();
  }

  // String audio_id, String fx_type, float fx_value int voice_index
  void onReverbMessage (OscMessage theOscMessage) {
    String speaker_id = theOscMessage.get(0).stringValue();
    float value = theOscMessage.get(1).floatValue();
    int index = getSpeakerIndexFromId(speaker_id);
    speakers.get(index).setReverb(value);
  }

  void onBlurMessage (OscMessage theOscMessage) {
    float value = theOscMessage.get(0).floatValue();
    setBlur(value);
  }

  void onNewAudio (OscMessage theOscMessage) {
    String jsonString = theOscMessage.get(0).stringValue();
    JSONObject audio_data = parseJSONObject(jsonString);
    println("[OscListener] new audio!", audio_data);
    archive.addNewAudio(audio_data);
  }
}