/***
 * Laptop Telephone Music Client 
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
 * quantize +/- 1/32nd from the division to that bucket. -- DONE, and generalized (use NoteHappened)
 * Ryan will do keyboard input -- DONE
 * Report notes to NEXT PERSON IN LINE and SERVER
 * Capability to inject scores at different places in the line.
 * Capability to re-order players during performance.
 * n rows of First, second, third "chairs."
 * always inject score to first chair.
 * score always goes to second chair, then third chair, then to next first chair.

 * Client needs to handshake with server (report chair).
 * Server needs to send a message to each client saying "you send your notes to _____"
 
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

public static final int MEASURE_WIDTH = 975;  //px
public static final int MEASURE_TOP = 50;
public static final int MEASURE_HEIGHT = 50;

// end configuration

//osc receiver
private OscP5 oscP5;

// osc receiver for multicast messages from server
private OscP5 _multicastOsc;

//how bright is the background
private int backgroundBrightness = 0;
// the received score you're supposed to play
private int[] score = new int[SUBDIVISIONS];  
// the score you actually played.
private int[] _myScore = new int[SUBDIVISIONS];
// save the scores you actually played in past measures
private List<int[]> _myScores = new ArrayList<int[]>();
private int _tempo = 120;  // in bpm
private int _beatNum = 0;
private int _delay = 1;
private long _nextSubdiv = _delay;
private int _subdivNum = 0;
private NetAddress _nextPlayerAddr;
private NetAddress _serverAddr;

private boolean _playing = true;

// declare early for speediness.
private long _keypressTime;   
private long _keyreleaseTime;

private Synth synth;

void setup() {
  frameRate(60);
  size(1024,768);
  
   oscP5 = new OscP5(this,6449);
  // handle the simple messages first.
  
  oscP5.plug(this,"note",NOTE_ADDR);
  oscP5.plug(this,"setNextNodeAddress",NEXT_NODE_ADDR);
  oscP5.plug(this, "waitingForNextIp", UR_WAITING_ADDR);
  
  // the multicast listener handles metronome events
  OscProperties multicastProps = new OscProperties();
  multicastProps.setNetworkProtocol(OscP5.MULTICAST);
  multicastProps.setRemoteAddress("239.0.0.1",6453);
  multicastProps.setListeningPort(6453);
  multicastProps.setEventMethod("multicastOscEvent");
  
  _multicastOsc = new OscP5(this,multicastProps);
  _multicastOsc.plug(this,"metro",METRONOME_ADDR);
  
  //okay now load shit so there's not that first delay!! (in Supercollider code)
  Server.init(); 
  sayHolala();
}

void draw() {
  //setup stuff
  if (_nextSubdiv <= millis()) {
    _nextSubdiv = millis() + _delay;
    if (_subdivNum++ > SUBDIVISIONS) {
      _subdivNum = 0;
    }
  }
  
  // made this a variable, because I think we might want to change it such that
  // peoples' faces are more brightly lit when they're playing.
  background(backgroundBrightness);
  
  fill(128,128,128);
  stroke(255,255,255);
  float measureLeft = (width-MEASURE_WIDTH)/2.0;
  rect(measureLeft,MEASURE_TOP,MEASURE_WIDTH,MEASURE_HEIGHT);
  
  int beatW = (MEASURE_WIDTH/SUBDIVISIONS);
  
  for (int i=0; i < SUBDIVISIONS; i++) {
    float xPos = measureLeft + i*beatW;
    line(xPos,MEASURE_TOP,xPos,MEASURE_TOP+MEASURE_HEIGHT);
  }
  
  // draw score
  for (int i=0; i<SUBDIVISIONS;i++) {
    if (score[i] != 0) {
      float beatX = measureLeft + i*beatW;
      fill(0,255,0,128);
      rect(beatX,MEASURE_TOP,beatW,MEASURE_HEIGHT);
    }
    
  }
  
  // draw the score as I've played it
  for (int i=0; i<SUBDIVISIONS; i++) {
    if (_myScore[i] != 0) {
      float beatX = measureLeft + i*beatW;
      fill(0,255,0,128);
      rect(beatX,MEASURE_TOP,beatW,MEASURE_HEIGHT);
    }
  }
  
  // highlight current beat.
  float beatX = measureLeft + _beatNum * beatW;
  fill(255,0,0,128);
  rect(beatX,MEASURE_TOP,beatW,MEASURE_HEIGHT);
  
  // highlight current beat.
  float subdivX = measureLeft + _subdivNum * beatW;
  fill(255,0,255,128);
  rect(subdivX,MEASURE_TOP,beatW,MEASURE_HEIGHT);
}

// detects keypresses. 


public void keyPressed() {
  _keypressTime = millis();
  if (key == ' ') {  // player trying to play.
    noteHappened(_keypressTime);
    playNote(); 
  }
}

public void playNote()
//play a note via Supercollider
{
 // buffer.setn(0, width, samples);
  
  synth = new Synth("playPotsAndPans");
  synth.set("trig", 1);
  synth.set("whichPot", 2); //which sample to trigger... right now there are 4
  synth.create();  
}

public void keyReleased() {
  _keyreleaseTime = millis();
  if (key == ' ') {
    noteEnded(_keyreleaseTime);
  }
}

private void noteHappened(long whenItHappened) {
   long deltaThisMeasure = _nextSubdiv - whenItHappened;
    // simple quantizing.
    int whichSubdiv = quantize(deltaThisMeasure);
    if (whichSubdiv > SUBDIVISIONS-1)
      whichSubdiv = SUBDIVISIONS-1;
    // record the note we just played
    _myScore[whichSubdiv] = 1;
    
    //TODO: notify the next player that a note was played.
    
}


private void noteEnded(long whenItHappened) {
  
}

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


private void metro(int tempo, int tickCount, int beatNum) {
  _tempo = tempo;
  _beatNum = beatNum;
  _delay = (60*1000)/(_tempo*4);
  _nextSubdiv = millis() + _delay;
  _subdivNum = _beatNum;
  if (beatNum == 0) {  // on first beat of new measure
    _myScore = new int[SUBDIVISIONS];
    _myScores.add(_myScore);
    // send back to server.
  }
}


// called by OscP5 when a note message comes in.
private void note(int note) {
  println("got a note: " + note);
}

// handles the complex score message, which I couldn't
// find a good way to handle through Plug, due to the arbitrary
// length of the message.
void oscEvent(OscMessage message) {
  if (message.checkAddrPattern(SCORE_ADDR) == true) {
    // update the score for this node
    for (int i=0;i<SUBDIVISIONS;i++) {
      score[i] = message.get(i).intValue();
    }
  }
}

/**
 * Says hello to the server, so the server knows the client is here.
 **/

void sayHolala() {
  println("Saying holala!");
  OscMessage holalaMsg = new OscMessage(HOLALA_ADDR);
  holalaMsg.add(NetInfo.lan());
  holalaMsg.add(0);
  holalaMsg.add(0);
  _multicastOsc.send(holalaMsg);
}

/**
 * This is how the server tells the client who to talk to next, and also
 * where it is.
 **/

void setNextClientAddress(String nextIp, String serverIp) {
  println("next client address is: " + nextIp);
  println("server address is: " + serverIp);
  _nextPlayerAddr = new NetAddress(nextIp,OSC_PORT);
  _serverAddr = new NetAddress(serverIp,OSC_PORT);
  
}

// help supercollider clean up its dirty laundry.
void exit() {
  super.exit();
}

void waitingForNextIp()
{
  //give some UI message here
}

