
/***
 * Telephone Tango Client 
 * by Courtney Brown, Meng Chen and Ryan Spicer
 * for LOrkAS, 2011.
 *
 * This sketch depends on Andreas Schlegel's oscP5 library,
 * http://www.sojamo.de/libraries/oscP5/index.html
 *
 * This sketch depends on ProcessingCollider.
 * http://www.erase.net/projects/p5_sc/. 
 *
 * SuperCollider must be running or else nothing of 
 * acoustic interest will happen.
 *
 ***/

import oscP5.*;
import netP5.*;
import supercollider.*;

/**
 * Report notes to NEXT PERSON IN LINE and SERVER
 * Capability to inject scores at different places in the line.
 * Capability to re-order players during performance.
 * always inject score to first chair.
 * score always goes to second chair, then third chair, then to next first chair. 
 * Client needs to handshake with server (report chair). DONE
 * Server needs to send a message to each client saying "you send your notes to _____" DONE
 * Chair/Seat UI
 
 * Server needs to send scores to first chairs at specified measures. 
 * (so server needs to store the score data).
 *
 * Pattern has n measures, and a starting measure number and a row #.
 *
 * Record notes coming back from clients (if we're feeling ambitious)
 *
 * Add count-in and highlight on currently playing player.
 * Right/left.
 **/

public static final int MEASURE_WIDTH = 850;  //px
public static final int MEASURE_TOP = 250;
public static final int MEASURE_HEIGHT = 50;
public static final int MAX_OFFSET = 16;
public static final int STATUS_MESSAGE_Y = 600;

public static final int STATE_PRE_HOLALA = 0;
public static final int STATE_WAITING = 1;
public static final int STATE_READY = 2;
public static final int STATE_ERROR = 3;
public static final int STATE_COMMUNICATING = 4; 

public int currentState = STATE_PRE_HOLALA;

private static final int[] EMPTY_MEASURE = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// end configuration

//osc receiver
private OscP5 oscP5;

// osc receiver for multicast messages from server
private OscP5 _multicastOsc;

//how bright is the background
private int backgroundBrightness = 0;
private color backgroundColor;
// the received score you're supposed to play
private int[][] score = new int[4][SUBDIVISIONS];  
// the score you actually played.
private int[] _myScore = new int[SUBDIVISIONS];

// save the scores you actually played in past measures
private int _tempo = 100;  // in bpm
private int _beatNum = 0;
private int _delay = (60*1000/100)/4;
private long _nextSubdiv = _delay;
private int _subdivNum = 0;
private NetAddress _nextPlayerAddr;
private NetAddress _serverAddr;
private WaitingManager _waitingManager;
private int _sampleNum = 2;

private List<Measure> upcomingMeasures;
private Measure thisMeasure;

private int _rowNum;
private int _chairNum;

private boolean _playing = false;
private int _offset = 0;
private int _measureNum;

// declare early for speediness.
private long _keypressTime;   
private long _keyreleaseTime;

private int _metroColor = 255;

private Synth synth;

void setup() {
  frameRate(60);
  size(1024,768);
  
  oscP5 = new OscP5(this,6449);
 
  // handle the simple messages first. 
  oscP5.plug(this,"setNextNodeAddress",NEXT_NODE_ADDR);
  oscP5.plug(this, "waitingForNextIp", UR_WAITING_ADDR);
  oscP5.plug(this, "errorReceived",ERROR_ADDR);
  
  // the multicast listener handles metronome events
  OscProperties multicastProps = new OscProperties();
  multicastProps.setNetworkProtocol(OscP5.MULTICAST);
  multicastProps.setRemoteAddress("239.0.0.1",6453);
  multicastProps.setListeningPort(6453);
  multicastProps.setEventMethod("multicastOscEvent");
  
  _multicastOsc = new OscP5(this,multicastProps);
  _multicastOsc.plug(this,"metro",METRONOME_ADDR);
  
  upcomingMeasures = new ArrayList<Measure>();
  
  //okay now load shit so there's not that first delay!! (in Supercollider code)
  Server.init(); 
}

void draw() {
  //setup stuff
  if (_nextSubdiv <= millis()) {
    _nextSubdiv = millis() + _delay;
    if (++_subdivNum >= SUBDIVISIONS) {
      _subdivNum = 0;
    }
  }
  
  String statusMessage = "You are Chair " + _chairNum + " in row " + _rowNum + ".";
  background(backgroundColor);
  switch(currentState) {
    case STATE_PRE_HOLALA:
      backgroundColor = color(255,255,0);
      //background(255,255,0);
      statusMessage = "You are NOT connected. Get your chair and row number from the conductor and then commit!\nRight now you are part " + _rowNum + ", chair " + _chairNum + ".";
      break;
    case STATE_WAITING:
      backgroundColor = color(255,255,100);
      statusMessage = "You are now waiting for the server to tell you who to talk to! You are Chair " + _chairNum + " in row " + _rowNum + ".";
      break;
    case STATE_COMMUNICATING:
      backgroundColor = color(255,255,100);
      statusMessage = "Waiting for the server to acknowledge you said something.";
      if (_waitingManager.shouldResend(millis())) {
        sayHolala();
      }
      // if it's been more than n millis since we last sent holala, send it again!
      break;
    case STATE_ERROR:
      backgroundColor = color(255,0,0);
      break;
    default:
      // made this a variable, because I think we might want to change it such that
      // peoples' faces are more brightly lit when they're playing.
      if (_playing) {
        backgroundColor = color(255);
      } else {
        backgroundBrightness = color(0);
      }
      
      float measureLeft = 75;
      int beatW = (MEASURE_WIDTH/SUBDIVISIONS);

      drawMeasure((int)measureLeft,MEASURE_TOP,MEASURE_WIDTH,MEASURE_HEIGHT,score[0],_beatNum);
      
      // draw the score as I've played it
      for (int i=0; i<SUBDIVISIONS; i++) {
        if (_myScore[i] != 0) {
          float beatX = measureLeft + i*beatW;
          fill(0,255,0,128);
          rect(beatX,MEASURE_TOP,beatW,MEASURE_HEIGHT);
        }
      }
      
      // highlight current beat.
      //float beatX = measureLeft + _beatNum * beatW;
     
      
      //fill(255,0,0,128);
      //rect(beatX,MEASURE_TOP-100,beatW,MEASURE_HEIGHT);
      
      pushStyle();
      
      stroke(0);
      
      if (_metroColor > 0) {
        _metroColor-= 10;
      }
      fill(_metroColor);
      ellipse(width/2, 125, 100, 100);
      popStyle();
      
      // draw current subdiv drum-machine size
      float subdivX = measureLeft + _subdivNum * beatW;
      fill(255,0,255,128);
      rect(subdivX,MEASURE_TOP-35,beatW,25);
      
      //draw what's coming
      fill(0);
      text("Now",10,300);
      text("Next",10,375);
      
      drawMeasure((int)measureLeft,MEASURE_TOP+100,MEASURE_WIDTH,(int)(MEASURE_HEIGHT/1.5),score[1],_beatNum);
      
      drawMeasure((int)measureLeft,MEASURE_TOP+200,MEASURE_WIDTH,(int)(MEASURE_HEIGHT/2),score[2],_beatNum);
      
      drawMeasure((int)measureLeft,MEASURE_TOP+300,MEASURE_WIDTH,(int)(MEASURE_HEIGHT/2.5),score[3],_beatNum);
      
      text("subdiv num is: " + _subdivNum, 50, 750);
  }
  
  fill(0);
  if(backgroundColor != color(0,0,0))
    fill(0);
  else
    fill(255);
  text(statusMessage,300,STATUS_MESSAGE_Y); 
}

// detects keypresses. 
public void keyPressed() {
  _keypressTime = millis();
 
  if (currentState == STATE_PRE_HOLALA) {
    if (key == 'q') {
      _rowNum++;
    } else if (key == 'a' && _rowNum > 0) {
      _rowNum--;
    } else if (key == 'w') {
      _chairNum++;
    } else if (key == 's' && _chairNum > 0) {
      _chairNum--;
    } else if (key == ' ') {
      commit(0);
    }
    
  } else {
    if (key == ' ') {  // player trying to play.
      noteHappened(_keypressTime);
      playNote(); 
    } else if (key == '1') {
      _sampleNum = 0;
    } else if (key == '2') {
      _sampleNum = 1;
    } else if (key == '3') {
      _sampleNum = 2;
    } else if (key == '4') {
      _sampleNum = 3;
    }
  }
}

public void playNote()
//play a note via Supercollider
{ 
  synth = new Synth("playPotsAndPans");
  synth.set("trig", 1);
  synth.set("whichPot", _sampleNum); //which sample to trigger... right now there are 4
  synth.create();  
}

public void keyReleased() {
  _keyreleaseTime = millis();
  if (key == ' ' && currentState != STATE_PRE_HOLALA) {
    noteEnded(_keyreleaseTime);
  }
}

private void noteHappened(long whenItHappened) {
  long deltaThisMeasure = _nextSubdiv - whenItHappened;
  int whichSubdiv = quantize(deltaThisMeasure);  //simple quantizing
  if (whichSubdiv > SUBDIVISIONS-1)
    whichSubdiv = SUBDIVISIONS-1;
  _myScore[whichSubdiv] = 1;  // record the note we just played
  playNote(); // actually play it
}


private void noteEnded(long whenItHappened) {}

private int quantize(long deltaThisMeasure) {
  int whichSubdiv = 0;
    if (deltaThisMeasure < (_delay/2)){
      whichSubdiv = _subdivNum + 1;
      if (whichSubdiv > _myScore.length-1)
        whichSubdiv = _myScore.length-1;
    } else {
      whichSubdiv = _subdivNum;
    }   
    return whichSubdiv;
}

private void metro(int tempo, int measureNum, int beatNum) {
  _tempo = tempo;
  _beatNum = beatNum;
  _delay = (60*1000)/(_tempo*4);
  _nextSubdiv = millis() + _delay;
  _subdivNum = _beatNum;
  _measureNum = measureNum;
  if (_subdivNum % 4 == 0) {
    _metroColor = 255;
    println("should start flashing metro");
  }
  if (beatNum == 0) {  // on first beat of new measure
println("CLIENT: FIRST BEAT OF NEW MEASURE "+ _measureNum + "\t FIRST BEAT OF NEW MEASURE MEASURE NUM IS " + _measureNum);;
    // check if we were playing something
    if (thisMeasure != null && thisMeasure.getPlayers().size() > 2) {
      // construct the new measure that we're gonna send out to the next person.
      List<PlayerOffset> outgoingPlayers = new ArrayList<PlayerOffset>(thisMeasure.getPlayers());
      outgoingPlayers.remove(0);  //remove ourselves
println("CLIENT: myScore is: " + Arrays.toString(_myScore));

      int[] scoreToSend = new int[SUBDIVISIONS];
      System.arraycopy(_myScore,0,scoreToSend,0,SUBDIVISIONS);
      println("CLIENT: scoreToSend is " + Arrays.toString(scoreToSend));
      Measure outgoingMeasure = new Measure(thisMeasure.getStartingMeasure(),
                                            outgoingPlayers,
                                            scoreToSend, "foo");
println("CLIENT: outgoing measure is " + outgoingMeasure);
      OscMessage outgoingMessage = assembleMessage(outgoingMeasure);
      NetAddress outgoingAddr = new NetAddress(outgoingPlayers.get(0).getAddress(),OSC_PORT);
      oscP5.send(outgoingMessage,outgoingAddr);
      _playing = false;
      upcomingMeasures.remove(thisMeasure);
    }
  
    // clean up
    _myScore = new int[SUBDIVISIONS];
    for (int i =0; i< 4; i++) {
      System.arraycopy(EMPTY_MEASURE,0,score[i],0,16);
    }
    thisMeasure = null;
    _playing = false;
          
  }
  // do this all the time.
  getUpcomingMeasuresAndPutThemHappyPlaces();
  
}

void getUpcomingMeasuresAndPutThemHappyPlaces() {
  // iterate over all upcoming measures.
  // remember: preroll is min(4,offset);
  //println("CLIENT: iterating over "+ upcomingMeasures.size() +" upcoming measures.");
  for(Measure m : upcomingMeasures) {
    //println("CLIENT: " + m.getPlayers().get(0).getAddress() + " (this should be my IP)");
    int startingMeasure = m.getStartingMeasure()+m.getPlayers().get(0).getOffsetMeasures();
    // if it falls outside of the area we can draw or play, ignore it.
    
    //print("CLIENT: starting measure: " + m.getStartingMeasure() + "\t");
    //print(" calculated start" + startingMeasure +"\t");
    //println(" the first player's offset: "+ m.getPlayers().get(0).getOffsetMeasures());
    
    if ((startingMeasure < _measureNum) || (startingMeasure > _measureNum + 3 )) {
      continue;
    }
    // ok, so where is it?
    
    int drawOffset = startingMeasure-_measureNum;
    //println("CLIENT: drawOffset is " + drawOffset);
    assert(drawOffset < 4 && drawOffset >=0);
    //println("CLIENT: ASSERTS PASSED");
    System.arraycopy( m.getNotes(),0,score[drawOffset],0,SUBDIVISIONS);
    //println("CLIENT: ARRAYCOPY WORKED");
    // if it's now, then update things!
    if (drawOffset == 0) {
      thisMeasure = m;
      _playing = true;
    }
  }  
}

// handles the complex score message, which I couldn't
// find a good way to handle through Plug, due to the arbitrary
// length of the message.
void oscEvent(OscMessage message) {
println("CLIENT received message (before forwarding on):" + message);
  if (message.checkAddrPattern(MEASURE_ADDR) == true) {
//println("CLIENT received a MEASURE_ADDR; about to forward");
    Measure receivedMeasure = disassembleMessage(message);
println("CLIENT: decoded received measure: " + receivedMeasure);
    upcomingMeasures.add(receivedMeasure);
//println("CLIENT: Added to upcomingMeasures");
  }
  //println("CLIENT AFTER SORTING OUT MESSAGE: " + message);
}

/**
 * Says hello to the server, so the server knows the client is here.
 **/

void sayHolala() {
  println("CLIENT: Saying holala!");
  OscMessage holalaMsg = new OscMessage(HOLALA_ADDR);
  holalaMsg.add(NetInfo.lan());
  holalaMsg.add(_rowNum);
  holalaMsg.add(_chairNum);  
  _multicastOsc.send(holalaMsg);
 // currentState = STATE_READY;
 currentState = STATE_COMMUNICATING;
}

/**
 * This is how the server tells the client who to talk to next, and also
 * where it is.
 **/

void setNextClientAddress(String nextIp, String serverIp) {
  currentState = STATE_READY;
  _nextPlayerAddr = new NetAddress(nextIp,OSC_PORT);
  _serverAddr = new NetAddress(serverIp,OSC_PORT);
  
}

void waitingForNextIp() {
  // we're not actually using this, so I'm just hacking around it for now - RS
  //currentState = STATE_WAITING;
  currentState = STATE_READY;
}

// UI CODE STARTS HERE
public void commit(int code) {
  
  println("CLIENT: Committing!");
  sayHolala();
  _waitingManager = new WaitingManager(millis(),1000);
}
// UI CODE ENDS HERE.

public void chair(int chairNum) {
  _chairNum = chairNum;
}

public void row(int rowNum) {
  _rowNum = rowNum;
}

/**
 * Draws a measure (generalized fun function)
 **/

public void drawMeasure(int leftPx, int topPx, int widthPx, int heightPx, int[] measure, int currentIndex) {
  
  int beatW = widthPx / SUBDIVISIONS;
  
  fill(128,128,128);
  stroke(255,255,255);
  rect(leftPx,topPx,widthPx,heightPx);
  
  for (int i=0; i < SUBDIVISIONS; i++) {
    float xPos = leftPx + i*beatW;
    line(xPos,topPx,xPos,topPx+heightPx);
  }
  
  // draw score
  for (int i=0; i<SUBDIVISIONS;i++) {
    if (measure[i] != 0) {
      float beatX = leftPx + i*beatW;
      fill(0,255,0,128);
      rect(beatX,topPx,beatW,heightPx);
    }
  }
}

public void errorReceived(String theError) {
  currentState = STATE_ERROR;
}


