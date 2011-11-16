public class Measure {
  private int _startingMeasure;
  private List<PlayerOffset> _players;
  private int[] _notes;
  private String _motiveName = "";
  private String _senderIP = ""; //just like your mom.
  
  public Measure(int startingMeasure,
                 List<PlayerOffset> players,
                 int[] notes, String motiveName, String senderIP) {
    _startingMeasure = startingMeasure;
    _players = players;
    _notes = notes;
    _motiveName = motiveName;
    _senderIP = senderIP;
    
  }
  
  public Measure(int startingMeasure,
                 List<PlayerOffset> players,
                 int[] notes, String motiveName) {
                   
    this(startingMeasure, players, notes, motiveName, "");
    try {
      throw new Exception("BLARGH! IP NOT SET");
    } catch (Exception e) {
      println("WARNING: " + motiveName + " does not have the sender IP address set"); 
      e.printStackTrace();
    }
  }  
  

  public int getStartingMeasure() {
    return _startingMeasure;
  }

  public List<PlayerOffset> getPlayers() {
    return _players;
  }
  
  public int[] getNotes() {
    return _notes;
  }
  
  public void incOneMeasure() //increment one measure
  {
    _startingMeasure += 1;
  }
  
  public void setNotes(int[] notes)
  {
    _notes = notes;  
  }
  
  public Measure copy(String newMotiveName)
  {
    ArrayList<PlayerOffset> newPlayers = new ArrayList<PlayerOffset>(); 
    for(int i=0; i<_players.size(); i++)
    {
      newPlayers.add( _players.get(i).copy());
    }
    
    Measure newMeasure = new Measure(_startingMeasure, newPlayers, _notes, newMotiveName, _senderIP);
    return newMeasure; 
  }
  
  public String toString()
  {
    String mine =  "_startingMeasure " + _startingMeasure +  "  _notes: " + Arrays.toString(_notes) + "  newMotiveName: " + _motiveName +"\n";
    mine = mine +"   _players: \n";
    for (int i=0; i < _players.size(); i++)
    {
      mine = mine + nf(i, 2) + _players.get(i).toString() + "\n"; 
    }
    mine = mine + "=========\n";
    return mine;
  }
  
  public boolean equals(Object otherObj) {
    if (!(otherObj instanceof Measure) )
      return false;
    Measure other = (Measure) otherObj;
    return (this.getStartingMeasure() == other.getStartingMeasure() &&
            this.getPlayers().equals(other.getPlayers()) &&
            Arrays.equals(this.getNotes(),other.getNotes()));
    
  }

  public void setSenderIP(String senderIP)
  {
     _senderIP = senderIP;
  }
  
  public String senderIP()
  {
    return _senderIP;
  }
  
  public int nextChairInLine()
  {
    return ( (PlayerOffset) getPlayers().get(0)  ).getChair(); 
  }
  
  public int nextPartInLine()
  {
    return ( (PlayerOffset) getPlayers().get(0)  ).getPart(); 
  
  }
  
  public boolean sameMeasure(int start, int part, int chair)
  {
    boolean same = part == nextPartInLine();
    same = same && ( chair == nextChairInLine() ); 
    same = same && ( start == _startingMeasure ); 
    return same; 
  }
  
  public String getMotiveName() {
    return _motiveName;
  }
  
}


class MeasureResendAttempts //fucking bitch
{
  public Measure measure; 
  public int attempts = 0; 
  
  public MeasureResendAttempts(Measure m) { measure = m; } //the end 
}
