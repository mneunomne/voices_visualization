class OscListener {
  OscP5 oscP5;
  OscListener(int port) {
    oscP5 = new OscP5(this,port);
  }

  void oscEvent(OscMessage theOscMessage) {
    if (speakers.size() == 0) return;
  }
}