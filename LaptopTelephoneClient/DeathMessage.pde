// so the algorithm here is to receieve the message, stuff it into memory
// you read your own information but don't add it to the stack
// you add everyone else to the stack
// and then pass it along at the end of your measure.

// the measure we got is displayed at m- (4 or the offset, whichever is less).

public OscMessage assembleMessage(Measure measure) {
  int[] notes = measure.getNotes(); 
  List<PlayerOffset> nextPlayers = measure.getPlayers();
  
  OscMessage death = new OscMessage(MEASURE_ADDR);
  death.add(NetInfo.lan()); 
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
  int indexAdd = 0; //cycle through... this is incredibly dumb but we've totally had too many problems with this
  
  String senderAddr = death.get(indexAdd).stringValue(); 
  indexAdd++;
  
  int startingMeasure = death.get(indexAdd).intValue();
  indexAdd++;
  
  int numSubdivs = death.get(indexAdd).intValue();
  indexAdd++;
  
  thisMeasureNotes = new int[numSubdivs];
  for (int i=0;i<numSubdivs;i++) {
    thisMeasureNotes[i] = death.get(i+indexAdd).intValue();
  }
  int numPlayers = death.get(indexAdd+numSubdivs).intValue();
  indexAdd++;

  println("CLIENT: I totally have this many players: " + numPlayers);
  
  for (int i=0;i<numPlayers;i++) {
    int offsetM = death.get(indexAdd+numSubdivs+(i*5)).intValue();
    int offsetS = death.get(indexAdd+numSubdivs+(i*5+1)).intValue();
    String addr = death.get(indexAdd+numSubdivs+(i*5+2)).stringValue();
    int chair = death.get(indexAdd+numSubdivs+(i*5+3)).intValue();
    int part = death.get(indexAdd+numSubdivs+(i*5+4)).intValue();
    
    PlayerOffset newPlyr = new PlayerOffset(offsetM,offsetS,addr, chair, part);
    thesePlayers.add(newPlyr);    
  }
  
  return new Measure(startingMeasure,thesePlayers,thisMeasureNotes,"foo", senderAddr);
}
