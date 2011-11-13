SpamAck spamAck;
Thread ackThread;

class TelephoneChair
{
  String ip = "";
  TelephoneChair nextChair = null; 
  boolean _ipAssigned; 
  
  //actually it is good id these here, too
  int part; int chair;
  
  TelephoneChair(int p, int c)
  {
    part = p;
    chair = c; 
    _ipAssigned = false;
  }
  
  String getIP(){ return ip; }
  TelephoneChair getNextChair(){ return nextChair; }
  
  void setIP(String ipNum)
  {
    ip = ipNum; 
    _ipAssigned = true;
  }
  void setNextChair(TelephoneChair chair)
  {
    nextChair = chair;
  }
  int getPart(){ return part; }
  int getChair(){ return chair; }
  boolean hasIP(){ return _ipAssigned;}
  
  public String toString() {
    return "Row " + part + ", chair " + chair;
  }
}

//------------------------------------------------------------------------------------------------------------
class TelephoneNetwork
{
  ArrayList<TelephoneChair[]> parts; //holds array of chairs for each part
  int partSize = 3;
  boolean isInit = false; 
  int partsInit = 0;
  
  TelephoneNetwork(int partNum)
  {
      parts = new ArrayList(partNum);  
      partSize = partNum;
  }  

  TelephoneNetwork()
  {
    //default network, 3 X 4... all equal... change for implementation
    this(3);
    createPart(0, 3);
    createPart(1, 3);
    createPart(2, 4);

    defaultPath();    
  }
  
  void testWithTwo()
  {
    parts = new ArrayList(1);
    partSize = 1; 
    createPart(0, 2);
    isInit = true; //that's RIGHT I am circumventing my own safegaurds...!!!!!!!! 
  }
  
  int getPartSize(){ return parts.size(); }
  int getChairSize(int index)
  {
    assert( index < getPartSize() );
    
    return ( (TelephoneChair[]) parts.get(index) ).length; 
  } 
  
  void createPart(int partIndex, int chairNum)
  //create a part with a particular 
  {
    TelephoneChair[] chairs = new TelephoneChair[chairNum]; 
    for (int i=0; i<chairNum; i++)
    {
      chairs[i] = new TelephoneChair(partIndex, i);
    }
    parts.add(chairs);

   //TODO: check initialization more thoroughly, obv.  
    partsInit++;
    if (parts.size() <= partsInit)
    {
      isInit = true;
    }    
  }
  
  void defaultPath()
  {
    assert( isInit );
    
    //set-up default path
    for (int partIndex=0; partIndex<parts.size(); partIndex++)
    {
      TelephoneChair[] chairs = (TelephoneChair[]) parts.get(partIndex);
      for (int i=0; i<chairs.length; i++)
      {
        if(i<chairs.length-1)
        {
          chairs[i].setNextChair(getNode(partIndex, i+1));
        }
        else if(partIndex < parts.size()-1 )
        {
          chairs[i].setNextChair(getNode(partIndex+1, 0));
        }
        else
        {
          chairs[i].setNextChair(getNode(0, 0));
        }
      }
    }
  }
  
  void pathThroughChairs() //from first chairs to last chairs
  {
     assert( isInit );
    
    //set-up default path
    for (int i=0; i<parts.size(); i++)
    { 
        if(i<parts.size()-1)
        {
          
        }

    
    }
  }
  
  String toString() //for debugging, etc. ... only works if first == last, else it is infinite.
  {
    assert( isInit );       
    TelephoneChair first = ( (TelephoneChair[]) parts.get(0) )[0];
    String output = nf(first.getPart(), 1) + " " + nf(first.getChair(), 1) + " --> " ; 
    TelephoneChair next = first.getNextChair(); 
    int index = 0; 
    
    while (first != next)
    {
        output += next.getPart() + "," + nf(next.getChair(), 1) + " --> " ; 
        next = next.getNextChair(); 
        index++;
        if (index%5 == 0) output += "\n"; //formatting
     } 
     output += nf(first.getPart(), 1) + " " + nf(first.getChair(), 1); 
     return output;

  }
  
  TelephoneChair getNode(int part, int chair)
  //returns the node at a particular part & chair
  {
    assert( isInit ); 
    assert( (part < parts.size()) ) ;
    assert( (chair <  ((TelephoneChair[]) parts.get(part)).length) );
    
    TelephoneChair[] chairs = (TelephoneChair[]) parts.get(part);
    return chairs[chair];
  }
  
}

//------------------------------------------------------------------------------------------------------------

//TODO: keep track of whether everyone has been assigned or not. 
class TelephoneSenderAssignment
{
  TelephoneNetwork network = null;
  ArrayList<TelephoneChair> waitingQueue; 
  
  TelephoneSenderAssignment(TelephoneNetwork net)
  {
    network = net; 
    waitingQueue = new ArrayList<TelephoneChair>();
  }
  
  void holala(String ip, int part, int chairNum)
  {
    //set the ip address of the node
    TelephoneChair chair = network.getNode(part, chairNum); 
    if (chair.hasIP() && (!chair.getIP().equals(ip))) {
      sendChairError(ip);
      return;
    }
    chair.setIP(ip); 
    
/*    
    //check if someone is waiting on this node & if so send them that ip
    checkQueue(chair);
    
    //check if sender has sent ip, if so go ahead and send if not put in queue
    if ( chair.getNextChair().getIP().isEmpty() )
    {
      //TODO: send status message that we're waiting.
      waitingQueue.add(chair); 
      sendChairWaitingMessage(chair);
    }
    else
    {
      sendChairNextIP(chair); 
    }
  */
   //we're ALIVE!!!!!!!
   sendChairWaitingMessage(chair);
   
           
  // Create the object with the run() method
  spamAck = new SpamAck(chair);
    
  // Create the thread supplying it with the runnable object
  ackThread = new Thread();
    
  // Start the thread
  ackThread.start(); 
   
  }
  
  void sendChairNextIP(TelephoneChair chair)
  {
    //sends the next chair IP, THEN the server IP to the client that needs them.
    OscMessage msg = new OscMessage(NEXT_NODE_ADDR);
    msg.add(chair.getNextChair().getIP());
    msg.add(NetInfo.lan()); 
    
    NetAddress laptop_location = new NetAddress(chair.getIP(),OSC_PORT);
    
    oscP5.send(msg, laptop_location); 
  }
  
  void sendChairWaitingMessage(TelephoneChair chair)
  {
     OscMessage msg = new OscMessage(UR_WAITING_ADDR);
     NetAddress laptop_location = new NetAddress(chair.getIP(),OSC_PORT);

     oscP5.send(msg, laptop_location);  
  }
  
  void sendChairError(String ip) {
    OscMessage msg = new OscMessage(ERROR_ADDR);
    msg.add("Someone already requested this part/chair! Try again!");
    oscP5.send(msg,new NetAddress(ip,OSC_PORT)); 
  }
  
  //destroy everything and do it again
  void reset()
  {
    network = new TelephoneNetwork();
    waitingQueue.clear();
  }
  
  void checkQueue(TelephoneChair chair)
  {
    //check if someone is waiting on this node
    boolean found = false; 
    int index = 0; 
    TelephoneChair waitingChair = new TelephoneChair(0,0); //fucking JAVA fucking fuck:'may have been not initialized' my ass
    while( index < waitingQueue.size() && !found )
    {
      waitingChair = (TelephoneChair) waitingQueue.get(index);
      found = ( chair == waitingChair.getNextChair() ) ;
      index++;
     }
     if (found){ sendChairNextIP(waitingChair); }
  }

  List<TelephoneChair> chairsStillWaitingOn()
  {
    ArrayList<TelephoneChair> chairs = new ArrayList<TelephoneChair>();
    for(int i=0; i<network.getPartSize(); i++)
      for(int j=0; j<network.getChairSize(i); j++)
      {
        TelephoneChair chair = network.getNode(i, j); 
        if (!chair.hasIP()) chairs.add(chair);
      }
      
      return chairs; 
  }

}

