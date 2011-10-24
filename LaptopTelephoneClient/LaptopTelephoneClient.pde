/***
 * Laptop Telephone Music Client 
 * by Courtney Brown, Meng Chen and Ryan Spicer
 * for LOrkAS, 2011.
 *
 * This sketch depends on Andreas Schlegel's oscP5 library,
 * http://www.sojamo.de/libraries/oscP5/index.html
 *
 ***/

import oscP5.*;
import netP5.*;

// begin configuration
public static final int SUBDIVISIONS = 16;  // use 16th notes
public static final int OSC_PORT = 6449;
public static final String METRONOME_ADDR = "/lorkas/ltm/clock";
public static final String SCORE_ADDR = "/lorkas/ltm/score";
public static final String NOTE_ADDR = "/lorkas/ltm/note";

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


void setup() {
 
  size(1024,768);
   oscP5 = new OscP5(this,OSC_PORT);
  // handle the simple messages first.
  oscP5.plug(this,"metro",METRONOME_ADDR);
  oscP5.plug(this,"note",NOTE_ADDR);
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

private void metro(int tempo, int tickCount, int beatNum) {
  _tempo = tempo;
  _beatNum = beatNum;
}

private void note(int note) {
  println("got a note: " + note);
}

void oscEvent(OscMessage message) {
  // handle metronome click
  if (message.checkAddrPattern(SCORE_ADDR) == true) {
    // update the score for this node
    for (int i=0;i<SUBDIVISIONS;i++) {
      score[i] = message.get(i).intValue();
    }
  }
}
