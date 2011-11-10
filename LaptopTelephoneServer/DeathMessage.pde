// so the algorithm here is to receieve the message, stuff it into memory
// you read your own information but don't add it to the stack
// you add everyone else to the stack
// and then pass it along at the end of your measure.

// the measure we got is displayed at m- (4 or the offset, whichever is less).

public OscMessage assembleMessage(Measure measure) {
  int[] notes = measure.getNotes(); 
  List<PlayerOffset> nextPlayers = measure.getPlayers();
  
  OscMessage death = new OscMessage(MEASURE_ADDR);
  death.add(measure.getStartingMeasure());
  death.add(notes.length);
  for(int i=0;i<notes.length;i++) {
    death.add(notes[i]);
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
    death.add(p.getChair());
    death.add(p.getPart());
  }
  
  return death;
}

public Measure disassembleMessage(OscMessage death) {
  //setup variables
  int[] thisMeasureNotes;
  List<PlayerOffset> thesePlayers = new ArrayList<PlayerOffset>();
  
  // decode crazy shit yo
  
  int startingMeasure = death.get(0).intValue();
  int numSubdivs = death.get(1).intValue();
  thisMeasureNotes = new int[numSubdivs];
  for (int i=0;i<numSubdivs;i++) {
    thisMeasureNotes[i] = death.get(i+2).intValue();
  }
  int numPlayers = death.get(1+numSubdivs).intValue();
  
  for (int i=0;i<numPlayers;i++) {
    int offsetM = death.get(3+numSubdivs+(i*5)).intValue();
    int offsetS = death.get(3+numSubdivs+(i*5+1)).intValue();
    String addr = death.get(3+numSubdivs+(i*5+2)).stringValue();
    int chair = death.get(3+numSubdivs+(i*5+3)).intValue();
    int part = death.get(3+numSubdivs+(i*5+4)).intValue();
    
    PlayerOffset newPlyr = new PlayerOffset(offsetM,offsetS,addr, chair, part);
    thesePlayers.add(newPlyr);    
  }
  
  
  return new Measure(startingMeasure,thesePlayers,thisMeasureNotes,"foo");
}
