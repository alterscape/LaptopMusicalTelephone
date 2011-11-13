class SpamMeasuresThread implements Runnable {
  
          private final int _attempts = 5;    
          OscMessage _deathMessage;
          NetAddress _playerAddress;
  
          public SpamMeasuresThread(OscMessage msg, NetAddress addr)
          {
            super(); 
            _deathMessage = msg;
            _playerAddress = addr;
          }
  
	  // This method is called when the thread runs
	  public void run() {
            for (int i=0; i<_attempts; i++)
            {
              oscP5.send(_deathMessage,_playerAddress);
              try {
                  spamThread.sleep(500); 
	          } catch(InterruptedException e) {
	          e.printStackTrace();
	          }
            }
          }
}

class SpamAck implements Runnable {
  
          private final int _attempts = 5;    
          TelephoneChair _chair;
  
          public SpamAck(TelephoneChair chair)
          {
            super(); 
            _chair = chair;
          }
  
	  // This method is called when the thread runs
	  public void run() {
            for (int i=0; i<_attempts; i++)
            {
    
              //sends the next chair IP, THEN the server IP to the client that needs them.
              OscMessage msg = new OscMessage(NEXT_NODE_ADDR);
              msg.add(chair.getNextChair().getIP());
              msg.add(NetInfo.lan()); 
    
              NetAddress laptop_location = new NetAddress(chair.getIP(),OSC_PORT);
    
              oscP5.send(msg, laptop_location); 
              try {
                  spamAckThread.sleep(500); 
	          } catch(InterruptedException e) {
	          e.printStackTrace();
	          }
            }
          }
}
