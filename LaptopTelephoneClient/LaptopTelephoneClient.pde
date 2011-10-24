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

// end configuration

//osc receiver
private OscP5 oscP5;     
//how bright is the background
private int backgroundBrightness = 0;
private int[] score = new int[SUBDIVISIONS];
private int tempo;  // in bpm


void setup() {
 
  size(1024,768);
   oscP5 = new OscP5(this,OSC_PORT);
  // handle the simple messages first.
  oscP5.plug(this,"metro",METRONOME_ADDR);
  oscP5.plug(this,"note",NOTE_ADDR);
}

void draw() {
  background(backgroundBrightness);
}

private void metro(int tempo, int tickCount) {
  println("got a metro tick, tempo " + tempo + "; tickCount: " + tickCount);
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
