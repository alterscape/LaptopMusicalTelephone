import oscP5.*;
import netP5.*;

private OscP5 oscP5;
private OscP5 _metroMulticastOsc;
private NetAddress remoteLocation;
private int tempo = 120;

private int _wait_ms = 60000/tempo;
private long _nextBeat = 0;
private int _measureNum = -5;
private int _thisSubdiv = 0;
private boolean _running = false;

String debugOutput = "";
String debugOutput2 = "";
String debugOutput3 = "";

String _status;


TelephoneNetwork network;
TelephoneSenderAssignment senderAssign; 
TelephoneTangoScore score;

private List<Pattern> _patterns = new ArrayList<Pattern>();

void setup() {
  
  size(500,500);
  
  
  _status = "Waiting for players to connect. Press spacebar to start.";
  
  oscP5 = new OscP5(this,6450);
  // Setup Multicast Properties
  OscProperties multicastProps = new OscProperties();
  multicastProps.setNetworkProtocol(OscP5.MULTICAST);
  multicastProps.setRemoteAddress("239.0.0.1",6453);
  multicastProps.setListeningPort(6451);
  multicastProps.setEventMethod("multicastOscEvent");
  _metroMulticastOsc = new OscP5(this,multicastProps);
  _metroMulticastOsc.plug(this,"assignLaptops", HOLALA_ADDR);
  _metroMulticastOsc.setTimeToLive(4);  // set sane time to live to avoid killing the network.
  remoteLocation = new NetAddress("127.0.0.1",OSC_PORT);
             
 //init my telephone networks!
 network = new TelephoneNetwork(); 
 network.testWithTwo();
 senderAssign = new TelephoneSenderAssignment(network);
 // score has to come after network, because score depends on network.

}

public void draw() {
 if ((millis() > _nextBeat) && _running) {
   sendBeat();
 }
 //noFill();
 //noStroke();
 background(0);
 fill(255);
 //text(network.toString(), 15, 15);
 
 text("Measure: " + _measureNum +"\nBeat : " + _thisSubdiv, 15, 150);
 
 text(_status,15, 200);
 
 List<TelephoneChair> chairsStillWaiting = senderAssign.chairsStillWaitingOn();
 fill(255,0,0);
 for (int i=0;i<chairsStillWaiting.size();i++) {
   text("still waiting on " + chairsStillWaiting.get(i) + ".", 15, 250+i*20);
 }

}

private void startTelephoneTango() {
  score = new TelephoneTangoScore(); 
  score.createPartIITest();
  _nextBeat = millis();
  _running = true;
  _status = "Playing...";
}


/**
 * This sends out the beat.
 **/

private void sendBeat() {
  _nextBeat += _wait_ms;
  OscMessage metro = new OscMessage(METRONOME_ADDR);
  metro.add(tempo);
  metro.add(_measureNum);
  metro.add(_thisSubdiv);
  _metroMulticastOsc.send(metro);
  // is this the end of a measure?
  if ( (_thisSubdiv+=4) >= SUBDIVISIONS) {
    _thisSubdiv = 0;
    _measureNum++;
    // check all the measures we're waiting to start
    for (Measure m : score.getMeasures()) {
      // check if it starts now.
      if (m.getStartingMeasure() == (_measureNum+4)) {
        // get our first player (the person the server has to send it to)
        PlayerOffset p = m.getPlayers().get(0);
        println("SERVER: About to send m:" +m);
        NetAddress playerAddress = new NetAddress(p.getAddress(),OSC_PORT);
        println("SERVER: playerAdddress: " + playerAddress);
        OscMessage deathMessage = assembleMessage(m);
        oscP5.send(deathMessage,playerAddress);
        println("SERVER: Sending " + deathMessage);
      }
    }
  }
}

private void multicastOscEvent(OscMessage mess) {
  //println(mess);
}

private void sendScore(Object[] measure, NetAddress target) {
  oscP5.send(SCORE_ADDR,
             measure,
             target);
}

public void assignLaptops(String ip, int part, int chair)
{
  println("SERVER: laptops assigned!");
  senderAssign.holala(ip, part, chair);
}

public void keyPressed() {
  if (key == ' ') {
    startTelephoneTango();
  }
}
