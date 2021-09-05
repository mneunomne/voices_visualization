class Speaker {
  String id; 
  int index;
  Word curWord;
  // movement data
  float curPosX;
  float curPosY;
  float curTheta;
  float curRadius; 
  float posX = 0;
  float posY = 0;
  float theta, radius;
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
    println("Show word!", word.text);
    showWord = true;
    curWord = word; 
  }

  void hide () {
    showWord = false;
  }

  void draw () {
    if (!loaded) return;
    posX = posX + (curPosX - posX) * 0.1;
    posY = posY + (curPosY - posY) * 0.1;
    
    theta = theta + (curTheta - theta) * 0.1;
    radius = radius + (curRadius - radius) * 0.1;

    noFill();
    stroke(0, 0, 125);
    ellipse(0, 0, radius, radius);
    stroke(255);

    if (showWord) {
      curWord.draw(theta, radius);
    } else {
      ellipse(curPosX, curPosY, 5, 5);
    }
  }
}