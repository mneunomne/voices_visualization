class OscListener {
  OscP5 oscP5;
  OscListener(int port) {
    oscP5 = new OscP5(this,port);
  }

  void oscEvent(OscMessage theOscMessage) {
    if (speakers.size() == 0) return;

    /* get and print the address pattern and the typetag of the received OscMessage */
    // println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
    // theOscMessage.print();
    
    if (theOscMessage.checkAddrPattern("/pos")==true) {
      int index = theOscMessage.get(0).intValue();
      float theta = theOscMessage.get(1).floatValue();
      float radius = theOscMessage.get(2).floatValue() * height; 
      // set speaker position
      speakers.get(index).updatePos(theta, radius);
      return;
    }

    
    if (theOscMessage.checkAddrPattern("/play")==true) {
      String speaker_id = theOscMessage.get(0).stringValue();
      
      String audio_id = theOscMessage.get(1).stringValue();
      // String word = URLDecoder.decode(theOscMessage.get(2).stringValue());
      Word word = archive.getWord(audio_id);
      // get speaker index
      int index = getSpeakerIndexFromId(speaker_id);
      // show word
      speakers.get(index).appearWord(word);
      return;
    }
    
    if (theOscMessage.checkAddrPattern("/end")==true) {
      String speaker_id = theOscMessage.get(0).stringValue();
      // int audio_id = theOscMessage.get(1).intValue();
      // get speaker index
      int index = getSpeakerIndexFromId(speaker_id);
      // hide word
      // println("end", index);
      speakers.get(index).hide();
      return;
    }
  }
}