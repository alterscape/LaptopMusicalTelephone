public class PlayerOffset {
  public int _offsetMeasures;  // in measures
  public int _offsetSixteenths;
  public String _addr;
  
  public PlayerOffset(int offsetM, int offsetS, String addr) {
    _offsetMeasures = offsetM;
    _offsetSixteenths = offsetS;
    _addr = addr;
  }
  
  public int getOffsetMeasures() {
    return _offsetMeasures;
  }
  
  public int getOffsetSixteenths() {
    return _offsetSixteenths;
  }
  
  public String getAddress() {
    return _addr;
  }
}
