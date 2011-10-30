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

public static final int MEASURE_WIDTH = 975;  //px
public static final int MEASURE_TOP = 50;
public static final int MEASURE_HEIGHT = 50;

// end configuration

//osc receiver
private OscP5 oscP5;     
//how bright is the background
private int backgroundBrightness = 0;
private int[] score = new int[SUBDIVISIONS];
private int _tempo;  // in bpm
private int _beatNum = 0;

private Synth synth;


void setup() {
 
  size(1024,768);
   oscP5 = new OscP5(this,OSC_PORT);
  // handle the simple messages first.
  oscP5.plug(this,"metro",METRONOME_ADDR);
  oscP5.plug(this,"note",NOTE_ADDR);
  
  synth = new Synth("sine");
  synth.set("amp", 0.5);
  synth.set("freq",80);
  synth.create();
}

void draw() {
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
  
  // highlight current beat.
  float beatX = measureLeft + _beatNum * beatW;
  fill(255,0,0,128);
  rect(beatX,MEASURE_TOP,beatW,MEASURE_HEIGHT);
}

// detects keypresses. 

public void keyPressed() {
  if (key == ' ') {
    System.out.println("note");
  }
}


private void metro(int tempo, int tickCount, int beatNum) {
  _tempo = tempo;
  _beatNum = beatNum;
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

// help supercollider clean up its dirty laundry.
void exit() {
  synth.free();
  super.exit();
}
