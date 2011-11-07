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
}
