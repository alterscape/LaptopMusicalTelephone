public class Measure {
  private int _startingMeasure;
  private List<PlayerOffset> _players;
  private int[] _notes;
  
  public Measure(int startingMeasure,
                 List<PlayerOffset> players,
                 int[] notes) {
    _startingMeasure = startingMeasure;
    _players = players;
    _notes = notes;
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
