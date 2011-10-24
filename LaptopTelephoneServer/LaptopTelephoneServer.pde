import oscP5.*;
import netP5.*;



private OscP5 oscP5;
private NetAddress remoteLocation;
private int tempo = 120;

private int _wait_ms = 60000/tempo;
private long _nextBeat = 0;
private int _thisSubdiv = 0;

public static final int OSC_PORT = 6449;
public static final String METRONOME_ADDR = "/lorkas/ltm/clock";
public static final String SCORE_ADDR = "/lorkas/ltm/score";
public static final String NOTE_ADDR = "/lorkas/ltm/note";
public static final int SUBDIVISIONS = 16;

public void setup() {
  size(200,200);
  oscP5 = new OscP5(this,6450);
  remoteLocation = new NetAddress("127.0.0.1",OSC_PORT);
  
  oscP5.send(SCORE_ADDR,
             new Object[] {0,1,0,1,
                           0,1,0,1,
                           0,1,1,1,
                           0,1,1,1},
             remoteLocation);
}

public void draw() {
 if (millis() > _nextBeat) {
   sendBeat();
 }
}

private void sendBeat() {
  _nextBeat += _wait_ms;
  oscP5.send(METRONOME_ADDR,
             new Object[] { new Integer(tempo), new Integer(0), new Integer(_thisSubdiv) }, 
             remoteLocation);
  if ( (_thisSubdiv+=4) >= SUBDIVISIONS) {
    _thisSubdiv = 0;
  }
  //println("sent note at " + millis() + "; nextBeat is " + _nextBeat + "; wait_ms is " + _wait_ms);
}
