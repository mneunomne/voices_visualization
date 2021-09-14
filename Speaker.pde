class Speaker {
  String id; 
  int index;
  Word curWord;
  int voiceIndex;
  // movement data
  float curPosX;
  float curPosY;
  float curTheta;
  float curRadius; 
  float posX = 0;
  float posY = 0;
  float theta, radius;
  // effects
  float reverb = 0;
  // states 
  boolean loaded = false;
  boolean showWord = false;
  Speaker (String _id, int _index) {
    id = _id;
    index = _index;
  }

  void updatePos (float _theta, float _radius) {
    // println("updatePos!", theta, radius);
    _radius = _radius * (height/ (2 * 6));
    loaded = true;
    curTheta = _theta;
    curRadius = _radius;
    if (posX == 0 && posY == 0) {
      posX = radius * cos( theta );
      posY = radius * sin( theta );
      theta = _theta;
      radius = _radius;
    }
    curPosX = radius * cos( theta );
    curPosY = radius * sin( theta );
  }

  String getId() {
    return id;
  }

  void appearWord (Word word) {
    // println("Show word!", word.text, id, index);
    showWord = true;
    curWord = word;
    curWord.show();
  }

  void hideWord () {
    showWord = false;
  }

  void setVoiceIndex (int index) {
    voiceIndex = index;
  }

  void setReverb (float value) {
    reverb = value;
  }

  void hide () {
    // showWord = false;
    curWord.hide();
  }

  void draw () {
    if (!loaded) return;
    posX = posX + (curPosX - posX) * 0.1;
    posY = posY + (curPosY - posY) * 0.1;
    
    theta = theta + (curTheta - theta) * 0.1;
    radius = radius + (curRadius - radius) * 0.1;

    screen.stroke(255);
    screen.fill(255);
    // screen.ellipse(0, 0, radius, radius);
    if (showWord) {
      curWord.draw(theta, radius, reverb);  
    }
     
    screen.ellipse(curPosX, curPosY, 1, 1);
    
  }
}