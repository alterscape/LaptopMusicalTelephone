class TelephoneChair
{
  String ip = "";
  TelephoneChair nextChair = null; 
  
  String getIP(){ return ip; }
  TelephoneChair getNextChair(){ return nextChair; }
  
  void setIP(String ipNum)
  {
    ip = ipNum; 
  }
  void setNextChair(TelephoneChair chair)
  {
    nextChair = chair;
  }
}

//------------------------------------------------------------------------------------------------------------
class TelephoneNetwork
{
  ArrayList parts; //holds array of chairs for each part
  boolean isInit = false; 
  int partsInit = 0;
  
  TelephoneNetwork(int partNum)
  {
      parts = new ArrayList(partNum);  
  }  

  TelephoneNetwork()
  {
    //default network, 3 X 4... all equal... change for implementation
    this(3);
    for(int i=0; i<parts.size(); i++)
    {
       createPart(0, 4);
    }
    for (int i=0; i<parts.size(); i++)
    {
      defaultPath( (TelephoneChair[]) parts.get(i), i);
    }
  }
  
  void createPart(int partIndex, int chairNum)
  {
    TelephoneChair[] chairs = new TelephoneChair[chairNum]; 
    for (int i=0; i<chairs.length; i++)
    {
      chairs[i] = new TelephoneChair();
    }

   //TODO: check initialization more thoroughly, obv.  
    partsInit++;
    if (parts.size() >= partsInit)
    {
      isInit = true;
    }
    
  }
  
  void defaultPath(TelephoneChair[] chairs, int partIndex)
  {
    assert( isInit );
    
    //set-up default path
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
  
  TelephoneChair getNode(int part, int chair)
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
  ArrayList waitingQueue; 
  
  TelephoneSenderAssignment(TelephoneNetwork net)
  {
    network = net; 
    waitingQueue = new ArrayList();
  }
  
  void holala(String ip, int chairNum, int part)
  {
    //set the ip address of the node
    TelephoneChair chair = network.getNode(part, chairNum); 
    
    chair.setIP(ip); 
    
    
    //check if someone is waiting on this node & if so send them that ip
    checkQueue(chair);
    
    //check if sender has sent ip, if so go ahead and send if not put in queue
    if ( chair.getNextChair().getIP().isEmpty() )
    {
      //TODO: send status message that we're waiting.
      waitingQueue.add(chair); 
    }
    else
    {
      sendChairNextIP(chair); 
    }
  
  }
  
  void sendChairNextIP(TelephoneChair chair)
  {
    OscMessage msg = new OscMessage(NEXT_NODE_ADDR);
    msg.add(chair.getNextChair().getIP());
    
    NetAddress laptop_location = new NetAddress(chair.getIP(),OSC_PORT);
    
    oscP5.send(msg, laptop_location); 
  }
  
  void checkQueue(TelephoneChair chair)
  {
    //check if someone is waiting on this node
    boolean found = false; 
    int index = 0; 
    TelephoneChair waitingChair = new TelephoneChair(); //fucking JAVA fucking fuck:'may have been not initialized' my ass
    while( index < waitingQueue.size() && !found )
    {
      waitingChair = (TelephoneChair) waitingQueue.get(index);
      found = ( chair == waitingChair.getNextChair() ) ;
      index++;
     }
     if (found){ sendChairNextIP(waitingChair); }
  }

}

