import oscP5.*;
import netP5.*;
import java.util.ArrayList;

private OscP5 oscP5;
private OscP5 _metroMulticastOsc;
private NetAddress remoteLocation;
private int tempo = 120;

private int _wait_ms = 60000/tempo;
private long _nextBeat = 0;
private int _measureNum = 0;
private int _thisSubdiv = 0;

public static final int OSC_PORT = 6449;
public static final String METRONOME_ADDR = "/lorkas/ltm/clock";
public static final String SCORE_ADDR = "/lorkas/ltm/score";
public static final String NOTE_ADDR = "/lorkas/ltm/note";
public static final int SUBDIVISIONS = 16;

private List<Pattern> _patterns = new ArrayList<Pattern>();


public void setup() {
  size(200,200);
  oscP5 = new OscP5(this,6450);
  // Setup Multicast Properties
  OscProperties multicastProps = new OscProperties();
  multicastProps.setNetworkProtocol(OscP5.MULTICAST);
  multicastProps.setRemoteAddress("239.0.0.1",6453);
  multicastProps.setListeningPort(6451);
  _metroMulticastOsc = new OscP5(this,multicastProps);
  _metroMulticastOsc.setTimeToLive(4);  // set sane time to live to avoid killing the network.
  remoteLocation = new NetAddress("127.0.0.1",OSC_PORT);

}

public void draw() {
 if (millis() > _nextBeat) {
   sendBeat();
 }
}

/**
 * This sends out the beat.
 **/

private void sendBeat() {
  _nextBeat += _wait_ms;
  OscMessage metro = new OscMessage(METRONOME_ADDR);
  metro.add(tempo);
  metro.add(0);
  metro.add(_thisSubdiv);
  _metroMulticastOsc.send(metro);
  // is this the end of a measure?
  if ( (_thisSubdiv+=4) >= SUBDIVISIONS) {
    _thisSubdiv = 0;
    _measureNum++;
    // iterate over every pattern we have in the score.
    for (Pattern p : _patterns) {
      // if any of them start on the measure we're about to start, send 'em out!
      if (p.getStartingMeasure() == _measureNum) {
        // FIXME: look up the IP for the starting chair
        NetAddress startingChair = new NetAddress("127.0.0.1",OSC_PORT);
        // send it out.
        sendScore(p.getMeasures()[0],startingChair);
      }
    }
  }
}

private void sendScore(Object[] measure, NetAddress target) {
  oscP5.send(SCORE_ADDR,
             measure,
             target);
}

/**
 * 
 **/

public class Pattern {
  private int _startingMeasure;
  private int _startingChair;
  private Object[][] _measures;
  
  public Pattern(int startingMeasure,
                 int startingChair,
                 Object[][] measures) {
    _startingMeasure = startingMeasure;
    _startingChair = startingChair;
    _measures = measures;
  }

  public int getStartingMeasure() {
    return _startingMeasure;
  }

  public int getStartingChair() {
    return _startingChair;
  }
  
  public Object[][] getMeasures() {
    return _measures;
  }
}
