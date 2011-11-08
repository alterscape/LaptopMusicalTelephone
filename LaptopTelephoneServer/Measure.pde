public class Measure {
  private int _startingMeasure;
  private List<PlayerOffset> _players;
  private int[] _notes;
  private String _motiveName = "";
  
  public Measure(int startingMeasure,
                 List<PlayerOffset> players,
                 int[] notes, String motiveName) {
    _startingMeasure = startingMeasure;
    _players = players;
    _notes = notes;
    _motiveName = motiveName; 
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
    
    Measure newMeasure = new Measure(_startingMeasure, newPlayers, _notes, newMotiveName);
    return newMeasure; 
  }
}
