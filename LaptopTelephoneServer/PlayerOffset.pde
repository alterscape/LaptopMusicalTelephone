public class PlayerOffset {
  public int _offsetMeasures;  // in measures
  public int _offsetSixteenths;
  public int _chair;
  public int _part;
  public String _addr;
  
  public PlayerOffset(int offsetM, int offsetS, String addr, int chair, int part) {
    _offsetMeasures = offsetM;
    _offsetSixteenths = offsetS;
    _addr = addr;
    _chair = chair; 
    _part = part;
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
  
  public int getChair()
  {
    return _chair; 
  }
  
  public int getPart()
  {
    return _part;
  }
  
  public void setChairPart(int chair, int part)
  {
    _chair = chair; 
    _part = part; 
  }
  
  public PlayerOffset copy()
  {
    PlayerOffset player = new PlayerOffset(_offsetMeasures, _offsetSixteenths, _addr, _chair, _part);
    return player; 
  }
  
  String toString()
  {
       return "_offsetMeasures: " + _offsetMeasures + "  _offsetSixteenths:" + _offsetSixteenths + "  _addr: " + _addr + "  _chair" + _chair + "  _part:" + _part;
  }
  
  public boolean equals(Object otherObj) {
    if (! (otherObj instanceof PlayerOffset)) 
      return false;
    PlayerOffset other = (PlayerOffset) otherObj;
    return (this.getOffsetMeasures() == other.getOffsetMeasures() &&
            this.getOffsetSixteenths() == other.getOffsetSixteenths() &&
            this.getAddress().equals(other.getAddress()) &&
            this.getChair() == other.getChair() &&
            this.getPart() == other.getPart() );
  }
  
}
