/**
 * This object is used to check if we should re-send the message.
 **/

public class WaitingManager {
  private long _millis;
  private long _delay = 500;  //milliseconds
  private int _maxRetries = 0;
  private int _numRetries = 0;
  
  /**
   * Checks to see if we should send out more stuff.
   * @param the time when we created this thing.
   **/
  public WaitingManager( long millisecs, long delayMillis) {
    _millis = millisecs;
    _delay = delayMillis;
    _maxRetries = 4;
  }
  
  /**
   * Tests to see if we should resend the message
   * @param millisecs the current time, as retrieved by millis() from within
   * the p5 sketch, or from somewhere else if you're feeling particularly
   * adventurous.
   **/
  public boolean shouldResend(long millisecs) {
    boolean shouldResend = false;
    _numRetries++;
    if ( ( (_millis + _delay) > millisecs ) && _numRetries <= _maxRetries) {
      shouldResend = true;
      _millis = millisecs;
      println("CLIENT: WAITING MANAGER: RESENDING");
    }
    if (_numRetries > _maxRetries) {
      println("CLIENT: GIVING UP!");
    }
    return shouldResend;
  }
}
