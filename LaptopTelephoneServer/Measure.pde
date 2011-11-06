/**
 * 
 **/

public class Measure {
  private int _startingMeasure;
  private int _startingChair;
  private Object[][] _measures;
  
  public Pattern(int startingMeasure,
                 int startingChair,
                 Object[][] measures) {
    _startingMeasure = startingMeasure;
    _startingChair = startingChair;
    _measures = measures;
  }

  public int getStartingMeasure() {
    return _startingMeasure;
  }

  public int getStartingChair() {
    return _startingChair;
  }
  
  public Object[][] getMeasures() {
    return _measures;
  }
}
