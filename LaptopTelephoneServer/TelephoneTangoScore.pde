class TelephoneTangoScore
{
  ArrayList<Measure> measures;
  
  //note durations for easy transcription
  private final int[] h =    {1,0,0,0,0,0,0};
  private final int[] q =    {1,0,0,0};
  private final int[] e =    {1,0};
  private final int[] hr =   {0,0,0,0,0,0,0,0};
  private final int[] dq =   {1,0,0,0,0,0};
  private final int[] de =   {1,0,0};
  private final int[] qr =   {0,0,0,0};
  private final int[] er =   {0,0};  
  private final int[] s =    {1};
  private final int[] sr =   {0};
  private final int[] t332 = {1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0};
  
  public TelephoneTangoScore()
  {
    measures = new ArrayList<Measure>(); 
  }
     
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 
  public String toString()
  {
    return measures.toString();
  }   
     
  public int createPartIII(int startMeasure)
  {    
    int[][] F1 = { e, qr, e, er, e, s, s }; //Line F
    int[][] F2 = { e, q, s, s, e, e, er, e }; //Line F
    startMeasure = createPartIII(startMeasure, F1, F2);
    
    int[][] F3 = { e, e, s, s, q, s, s, er, e }; //Line F
    int[][] F4 = { s, s, s, s, e, s, s, e, er, e }; //Line F
    startMeasure =  createPartIII(startMeasure, F3, F4);    
    
    return startMeasure;
  }  
     
     
    
  public int createPartIII(int startMeasure, int[][] F1, int[][] F2)
  {  
    
    //Part III
    int F_1[] = createMeasure(F1); 
    int F_2[] = createMeasure(F2); 
    
    
    final int motiveRepeat = 5; 
    
    for (int index=0; index<network.getPartSize(); index++)
    for (int j=0; j<network.getChairSize(index); j++)
    {
       int partIndex = index;
       int chairIndex = j;
       ArrayList<PlayerOffset> playerMeasures = new ArrayList<PlayerOffset>();

        
       for( int i=0; i<motiveRepeat; i++ )
       {
         TelephoneChair chair = network.getNode(partIndex, chairIndex);
         playerMeasures.add( new PlayerOffset(i*2, 0, chair.getIP() , chairIndex, partIndex) );   
 
          //println("chair is: " + chairIndex + " partIndex is: " + partIndex); 

      
         chairIndex++;
         if (chairIndex >= network.getChairSize(partIndex))
         {
           chairIndex = 0;
           partIndex++; 
           if (partIndex >= network.getPartSize()) 
           {
             partIndex = 0;
           }   
         }   
      }
    
      Measure measure1 =  new Measure(startMeasure, playerMeasures, F_1, "Line F, Measure 1");  
      Measure measure2 = measure1.copy("Line F, Measure 2"); 
      measure2.incOneMeasure();
      measure2.setNotes(F_2); 
      measures.add(measure1);
      measures.add(measure2);    
      
    }
    
    startMeasure += motiveRepeat; 
    return startMeasure;
  }
  
  
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 int[][] fuckingBitchReally(int[][] myArray, int index, int[] notes)
 //this makes shit happen
 {
   for (int i=0;  i<SUBDIVISIONS; i++)
   {
     myArray[index][i] = notes[i];
   }
   return myArray;
 }
   //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 

  
  public int createPartI(int startMeasure)
  {
    
    //OMFG THIS IS A CLUSTER FUCK
   
    
    int[][] firstPart = new int[10][SUBDIVISIONS];
    
    int[][] mm =  { sr, s, s, er, sr, er, e, er, e } ;
    firstPart = fuckingBitchReally( firstPart, 0, createMeasure(mm) );
    
    mm =  new int[][] { hr, qr, s, s, s, s } ;
    firstPart = fuckingBitchReally( firstPart, 1, createMeasure(mm) );

    mm = new int[][] { sr, s, s, sr, er, e, hr };
    firstPart = fuckingBitchReally( firstPart, 2, createMeasure(mm) );
    
    mm = new int[][] { hr, qr, s, s, s, s };  
    firstPart = fuckingBitchReally( firstPart, 3, createMeasure(mm) );
    
    mm = new int[][] { dq, dq, q };    
    firstPart = fuckingBitchReally( firstPart, 4, createMeasure(mm) );
          
    mm = new int[][] { dq, dq, q };          
    firstPart = fuckingBitchReally( firstPart, 5, createMeasure(mm) );

    mm = new int[][] { e, e, s, s, e, e, s, s, e, e };    
    firstPart = fuckingBitchReally( firstPart, 6, createMeasure(mm) );  
  
    mm = new int[][] { q, q, q, q } ;    
    firstPart = fuckingBitchReally( firstPart, 7, createMeasure(mm) );  

    mm = new int[][]  { sr, s, s, s, sr, s, s, s, sr, s, s, s, sr, s, s, s };    
    firstPart = fuckingBitchReally( firstPart, 8, createMeasure(mm) );  

    mm = new int[][] { e, e, s, s, e, e, s, s, q };    
    firstPart = fuckingBitchReally( firstPart, 9, createMeasure(mm) );  

//second part


    int[][] secondPart = new int[10][SUBDIVISIONS];
    
    mm = new int[][]  { hr, e, e, qr } ;
    secondPart = fuckingBitchReally( secondPart, 0, createMeasure(mm) );
    
    mm =  new int[][]  { er, e, er, e, e, er, qr } ;
    secondPart = fuckingBitchReally( secondPart, 1, createMeasure(mm) );

    mm = new int[][] { er, e, er, e, e, er, er, s, s };
    secondPart = fuckingBitchReally( secondPart, 2, createMeasure(mm) );
    
    mm = new int[][] { hr, qr, s, s, s, s };  
    secondPart = fuckingBitchReally( secondPart, 3, createMeasure(mm) );
    
    mm = new int[][]  { dq, e, er, sr, s, s, s, s, s };    
    secondPart = fuckingBitchReally( secondPart, 4, createMeasure(mm) );
          
    mm = new int[][] { h, h };          
    secondPart = fuckingBitchReally( secondPart, 5, createMeasure(mm) );

    mm = new int[][]  { q, q, q, q };    
    secondPart = fuckingBitchReally( secondPart, 6, createMeasure(mm) );  
  
    mm = new int[][]  { dq, dq, q } ;    
    secondPart = fuckingBitchReally( secondPart, 7, createMeasure(mm) );  

    mm = new int[][] { er, e, er, e, er, e , er, e } ;    
    secondPart = fuckingBitchReally( secondPart, 8, createMeasure(mm) );  

    mm = new int[][]  { q, q, q, q } ;    
    secondPart = fuckingBitchReally( secondPart, 9, createMeasure(mm) );  
    
    
    int[][] thirdPart = new int[11][SUBDIVISIONS];
    
    mm = new int[][] { dq, dq, q } ;
    thirdPart = fuckingBitchReally( thirdPart, 0, createMeasure(mm) );
    
    mm =  new int[][]  { dq, e, e, er, e }  ;
    thirdPart = fuckingBitchReally( thirdPart, 1, createMeasure(mm) );

    mm = new int[][]  { dq, e, e, er, e };
    thirdPart = fuckingBitchReally( thirdPart, 2, createMeasure(mm) );
    
    mm = new int[][] { dq, dq, q };  
    thirdPart = fuckingBitchReally( thirdPart, 3, createMeasure(mm) );
    
    mm = new int[][]  { dq, dq, q };    
    thirdPart = fuckingBitchReally( thirdPart, 4, createMeasure(mm) );
          
    mm = new int[][] { dq, dq, sr, s, s, s };          
    thirdPart = fuckingBitchReally( thirdPart, 5, createMeasure(mm) );

    mm = new int[][]   { dq, dq, q } ;    
    thirdPart = fuckingBitchReally( thirdPart, 6, createMeasure(mm) );  
  
    mm = new int[][]   { dq, dq, q }  ;    
    thirdPart = fuckingBitchReally( thirdPart, 7, createMeasure(mm) );  

    mm = new int[][] { e, e, s, s, e, e, s, s, e, e } ;    
    secondPart = fuckingBitchReally( thirdPart, 8, createMeasure(mm) );  

    mm = new int[][]  { e, e, s, s, e, e, s, s, e, e } ;    
    thirdPart = fuckingBitchReally( thirdPart, 9, createMeasure(mm) );  

    mm = new int[][]   { dq, dq, q }  ;    
    thirdPart = fuckingBitchReally( thirdPart, 10, createMeasure(mm) );      
        
    
    //I will condense this into one for loop so that it is sane code but I am too fried to properly refactor 
  
  //create first part
  for (int i=0; i<firstPart.length; i++)
  {
    ArrayList<PlayerOffset> players = new ArrayList<PlayerOffset>(); 
    for (int j=0; j<network.getChairSize(0); j++)
    {
      //int offsetM, int offsetS, String addr, int chair, int part
      players.add( new PlayerOffset(j*6, j*2, "", j, 0) ); 
    }
    
    Measure measure = new Measure(1+i+startMeasure, players, firstPart[i], "Line A");     
    measures.add(measure); 
  }
    
  //create 2nd part  
  for (int i=0; i<secondPart.length; i++)
  {
    ArrayList<PlayerOffset> players = new ArrayList<PlayerOffset>(); 
    for (int j=0; j<network.getChairSize(1); j++)
    {
      //int offsetM, int offsetS, String addr, int chair, int part
      players.add( new PlayerOffset(j*6, j*2, "", j, 1) ); 
    }
    
    Measure measure = new Measure(1+i+startMeasure, players, secondPart[i], "Line B");  
    measures.add(measure); 
    
  }    
    
    
   Measure lastMeasure = new Measure(0, null, null, "", ""); 
    
  //create 3rd part  
  for (int i=0; i<thirdPart.length; i++)
  {
    ArrayList<PlayerOffset> players = new ArrayList<PlayerOffset>(); 
    for (int j=0; j<network.getChairSize(2); j++)
    {
      //int offsetM, int offsetS, String addr, int chair, int part
      players.add( new PlayerOffset(j*6, j*2, "", j, 2) ); 
    }
    
    Measure measure = new Measure(i+startMeasure, players, thirdPart[i], "Line C"); 
    measures.add(measure); 
    
     if (i == thirdPart.length-1)
     {
      lastMeasure = measure; 
     }
  }
  
  PlayerOffset player = lastMeasure.getPlayers().get(lastMeasure.getPlayers().size()-1); 
  return lastMeasure.getStartingMeasure() + player.getOffsetMeasures();
    
   
  }

    
    
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
  
  
 
  public int createPartIITest(int startMeasure)
  {    
    int[][] E1 = {dq, e, er, sr, s, s, s, s, s}; //Line E.1
    int[][] E2 = {e, e, s, s, e, er, e, er, e}; //Line E.2
    
    int[] e1Measure_offset = { 0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 };   
    int[] e1Measure_offset16 = { 0, 0, 0, 0, 0, 2, 0, 4, 0, 0, 8, 0, 0, 0 };
    int[] e1Parts = new int[e1Measure_offset16.length];
    int[] e1Chairs = new int[e1Measure_offset16.length];
    
    
    int partIndex = 0;
    int chairIndex = 0;

    for(int i=0; i < e1Measure_offset.length; i++)
    {
       e1Parts[i] = partIndex;
       e1Chairs[i] = i % network.getChairSize(partIndex);
       
         chairIndex++;
         if (chairIndex >= network.getChairSize(partIndex))
         {
           chairIndex = 0;
           partIndex++; 
           if (partIndex >= network.getPartSize()) 
           {
             partIndex = 0;
           }   
         }          
       
       
    }
    
    int E_1[] = createMeasure(E1); 
    List<PlayerOffset> E_1_players = createPlayers(e1Measure_offset, e1Measure_offset16, e1Chairs, e1Parts);
    Measure e1Measure  = new Measure(startMeasure, E_1_players, E_1, "Line E, Measure 1");         
    measures.add(e1Measure);    
    
    int E_2[] = createMeasure(E2); 
    Measure e2Measure = e1Measure.copy("Line E, Measure 2"); 
    e2Measure.incOneMeasure();
    e2Measure.setNotes(E_2); 
    measures.add(e2Measure);  

    return network.getPlayerCount() + startMeasure;    
    
  } 

 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 


     
  public void createPartII() //NOT USED RIGHT NOW.
  { 
    //Part II
    int[][] E1 = {dq, e, er, sr, s, s, s, s, s}; //Line E.1
    int[] e1Chairs = { 0, 1, 2, 0, 1, 2, 0,  1,  2,  3,  0,  1,  2,  0, };
    int[] e1Parts = { 0, 0, 0, 1, 1, 1, 2, 2,  2,  2,  0,  0,  0,  1, };
    int[] e1Measure_offset = { 0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 };   
    int[] e1Measure_offset16 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };    
    
    //create first measure of Part II
    int E_1[] = createMeasure(E1); 
    List<PlayerOffset> E_1_players = createPlayers(e1Measure_offset,e1Measure_offset16, e1Chairs, e1Parts);
    Measure e1Measure  = new Measure(25, E_1_players, E_1, "Line E, Measure 1");         
    measures.add(e1Measure);
    
    //this starts to go into unorthodox network connections so that we can have different people playing all at once, etc.  
    //starting measure: 41
    int[] e1Chairs_1 = { 2, 0, 1 };
    int[] e1Parts_1  = { 0, 1, 1 };
    int[] e1Measure_offset_1 = { 0, 1, 5 };
    int[] e1Measure_offset16_1 = { 0, 2, 0 };
    List<PlayerOffset> E_1_players_1 = createPlayers(e1Measure_offset_1, e1Measure_offset16_1, e1Chairs_1, e1Parts_1);
    Measure e1Measure_1  = new Measure(41, E_1_players_1, E_1, "Line E, Measure 1 Round Pt. 1");         
    measures.add(e1Measure_1);
    
    //starting measure: 41
    int[] e1Chairs_2 = { 1, 2, 2, 1, 1 };
    int[] e1Parts_2  = { 1, 1, 2, 1, 0 };
    int[] e1Measure_offset_2 = { 0, 0, 0, 0, 2 };
    int[] e1Measure_offset16_2 = { 0, 1, 2, 4, 6 };
    List<PlayerOffset> E_1_players_2 = createPlayers(e1Measure_offset_2, e1Measure_offset16_2, e1Chairs_2, e1Parts_2);
    Measure e1Measure_2  = new Measure(41, E_1_players_2, E_1, "Line E, Measure 1 Round Pt. 2");         
    measures.add(e1Measure_2);    

    //starting measure: 43
    int[] e1Chairs_3 = { 1, 2, 1 };
    int[] e1Parts_3  = { 2, 2, 0 };
    int[] e1Measure_offset_3 = { 0, 3, 4 };
    int[] e1Measure_offset16_3 = { 8, 0, 0 };
    List<PlayerOffset> E_1_players_3 = createPlayers(e1Measure_offset_3, e1Measure_offset16_3, e1Chairs_3, e1Parts_3);
    Measure e1Measure_3  = new Measure(43, E_1_players_3, E_1, "Line E, Measure 1 Round Pt. 3");         
    measures.add(e1Measure_3);    
    
    //create 2nd by copying the travel info & changing start measure and actual notes played
    int[][] E_2 = {e, e, s, s, e, er, e, er, e}; //Line E.2
    int[] E2 = createMeasure(E_2);
    
    Measure e2Measure = e1Measure.copy("Line E, Measure 2"); 
    e2Measure.incOneMeasure();
    e2Measure.setNotes(E2); 
    measures.add(e2Measure);    

  
    Measure e2Measure_1 = e1Measure_1.copy("Line E, Measure 2 Round Pt. 1"); 
    e2Measure_1.incOneMeasure();
    e2Measure_1.setNotes(E2); 
    measures.add(e2Measure_1);    
    
    Measure e2Measure_2 = e1Measure_2.copy("Line E, Measure 2 Round Pt. 2"); 
    e2Measure_2.incOneMeasure();
    e2Measure_2.setNotes(E2); 
    measures.add(e2Measure_2);       
    
    Measure e2Measure_3 = e1Measure_3.copy("Line E, Measure 2 Round Pt. 3"); 
    e2Measure_3.incOneMeasure();
    e2Measure_3.setNotes(E2); 
    measures.add(e2Measure_3);    
  }



 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 

  
  private int[] createMeasure(int[][] mm)
  {
    int[] measure = new int[16];
    int destPos = 0;
    for (int i=0; i<mm.length; i++)
    {
    System.arraycopy(mm[i], 0, measure, destPos, mm[i].length);
     destPos += mm[i].length;
    }
    return measure; 
  }

 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------   
  
  List<PlayerOffset> createPlayers(int[] measure_offset, int[] measure_offset16, int[] chairs, int[] parts)
  {   
      ArrayList<PlayerOffset> players = new ArrayList<PlayerOffset>(); 
      for( int i=0; i<chairs.length; i++)
      {
        TelephoneChair chair = network.getNode(parts[i], chairs[i]);
        PlayerOffset info = new PlayerOffset(measure_offset[i], measure_offset16[i], chair.getIP(), chairs[i], parts[i]); 
        players.add(info); 
      }
      return players;
  }

  //size of array OMFG I'm IDIOT!!!!!!!!!!!!
  /*
  private int getIntIntSize(int[][] mm)
  {
    int mm_size = 0;
    for( int i=0; i<mm.length; i++ )
    {
       mm_size = mm[i].length;
    }
    return mm_size;   
  }
  */
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
  
  public List<Measure> getMeasures() {
    return measures;
  }

}

