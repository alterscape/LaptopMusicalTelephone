import oscP5.*;
import netP5.*;

private OscP5 oscP5;
private NetAddress remoteLocation;
private int tempo = 120;

private int _wait_ms = 60000/tempo;
private long _nextBeat = 0;
private int _thisSubdiv = 0;

TelephoneNetwork network;
TelephoneSenderAssignment senderAssign; 

void setup() {
  size(200,200);
  oscP5 = new OscP5(this,6450);
  remoteLocation = new NetAddress("127.0.0.1",OSC_PORT);
  
  oscP5.send(SCORE_ADDR,
             new Object[] {0,1,0,1,
                           0,1,0,1,
                           0,1,1,1,
                           0,1,1,1},
             remoteLocation);
             
             
 //init my telephone networks!
 network = new TelephoneNetwork(); 
 senderAssign = new TelephoneSenderAssignment(network); 
 oscP5.plug(this,"assignLaptops", HOLALA_ADDR);

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

public void assignLaptops(String ip, int part, int chair)
{
  senderAssign.holala(ip, part, chair);
}
