/**
 * 
 **/

public class Measure {
  private int _startingMeasure;
  private List<Player> _players;
  private Object[] _notes;
  
  public Pattern(int startingMeasure,
                 List<PlayerOffset> players,
                 Object[] notes) {
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
  
  public Object[] getNotes() {
    return _measure;
  }
}
