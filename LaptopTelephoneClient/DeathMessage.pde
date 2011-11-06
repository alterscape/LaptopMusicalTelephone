// so the algorithm here is to receieve the message, stuff it into memory
// you read your own information but don't add it to the stack
// you add everyone else to the stack
// and then pass it along at the end of your measure.

// the measure we got is displayed at m- (4 or the offset, whichever is less).

public void assembleMessage(Measure measure) {
  Object[] notes = measure.getNotes(); 
  List<PlayerOffset> nextPlayers = measure.getPlayers();
  
  OscMessage death = new OscMessage("/lorkas/ltm/death");
  death.add(aMeasure.length);
  for(int i=0;i<aMeasure.length;i++) {
    death.add((int)aMeasure[i]);
  }
  
  // we need a list of players who are going to get this
  // each player has an offset in measures
  // an offset in 16ths from that measure
  // an IP.
  
  // how many players are coming? (for ease of parsing)
  death.add(nextPlayers.size());
  for (PlayerOffset p: nextPlayers) {
    death.add(p.getOffsetMeasures());
    death.add(p.getOffsetSixteenths());
    death.add(p.getAddress());
  }
}

public void disassembleMessage(OscMessage death) {
  //setup variables
  int[] thisMeasure;
  List<Player> thesePlayers = new ArrayList<Player>();
  
  // decode crazy shit yo
  int numSubdivs = death.get(0).intValue();
  thisMeasure = new int[numSubdivs];
  for (int i=0;i<numSubdivs;i++) {
    thisMeasure[i] = death.get(i+1).intValue();
  }
  int numPlayers = death.get(1+numSubdivs).intValue();
  
  for (int i=0;i<numPlayers;i++) {
    int offsetM = death.get(2+numSubdivs+(i*3).intValue();
    int offsetS = death.get(2+numSubdivs+(i*3+1).intValue();
    String addr = death.get(2+numSubdivs+(i*3+2).intValue();
    Player newPlyr = new Player(offsetM,offsetS,addr);
    thesePlayers.add(newPlyr);    
  }
}
