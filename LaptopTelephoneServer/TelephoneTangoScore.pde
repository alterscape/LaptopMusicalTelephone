class TelephoneTangoScore
{
  ArrayList<Measure> measures;
  private final int playerNum = 10; 
  
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
     
  public void createPartIII(int startMeasure)
  {  
    
    //Part III
    int[][] F1 = { de, de, de, s, s, s, e, sr, s }; //Line F
    int[][] F2 = { er, de, de, er, e, sr, s, e }; //Line F
    int F_1[] = createMeasure(F1); 
    int F_2[] = createMeasure(F2); 
    
    
    final int motiveRepeat = 5; 
    ArrayList<PlayerOffset> playerMeasures = new ArrayList<PlayerOffset>();
    

    //create first player array & player
    for( int i=0; i<motiveRepeat; i++ )
      for( int partIndex=0; partIndex<network.getPartSize(); partIndex++ )
        for( int chairIndex=0; chairIndex<network.getChairSize(partIndex); chairIndex++ )
        {
            TelephoneChair chair = network.getNode(partIndex, chairIndex);
            playerMeasures.add( new PlayerOffset(i*2, 0, chair.getIP() , chairIndex, partIndex) );       
        }
    Measure measure1 =  new Measure(startMeasure, playerMeasures, F_1, "Line F, Measure 1");  
    Measure measure2 = measure1.copy("Line F, Measure 2"); 
    measure2.incOneMeasure();
    measure2.setNotes(F_2); 
    measures.add(measure1);
    measures.add(measure2);    
    
    
    for( int i=0; i<playerNum; i++ )
    {
      playerMeasures = new ArrayList(playerMeasures); 
      for( int j=0; j<motiveRepeat; j++ )
      {
         int index = i + ((j+1)%playerMeasures.size());
         PlayerOffset po = ( PlayerOffset ) playerMeasures.get( index ) ;
         ((PlayerOffset) playerMeasures.get(j)).setChairPart( po.getChair(), po.getPart() ); 
      }
      measure1 =  new Measure(startMeasure, playerMeasures, F_1, "Line F, Measure 1");  
      measure2 = measure1.copy("Line F, Measure 2"); 
      measure2.incOneMeasure();
      measure2.setNotes(F_2); 
      measures.add(measure1);
      measures.add(measure2);   
  
    }  
  }
  
  
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
  
  
  
  public void createPartI(int startMeasure)
  {
<<<<<<< HEAD
   /* 
=======
   /*
>>>>>>> 738c4498c5b4878ecf42af663592fc3a9614e374
   int firstHugeLongThing {   
    
    //line A
    //start m. 1
    { { sr, s, s, er, sr, er, e, er, e },
    { hr, qr, s, s, s, s },
    { sr, s, s, sr, er, q, hr },
    { dq, dq, q },
    { dq, dq, q },
    { q, q, q, q },
    { e, e, s, s, e, e, s, s, e, e },
    { q, q, q, q },
    { sr, s, s, s, sr, s, s, s, sr, s, s, s, sr, s, s, s },
    {e, e, s, s, q, q, s, s, q, q } },
    
    //line B
    //start m. 1    
    { { hr, e, e, qr },
    { er, e, er, e, e, er, qr },
    { er, e, er, e, e, er, er, s, s},
    { dr, e, er, sr, s, s, s, s, s },
    { e, e, s, s, e, er, e,  er},
    { h, h },
    { q, q, q, q },
    { dq, dq, q},
    { er, e, er, e, er, e , er, e},
    { q, q, q, q } },    
    
    //line C
    //start m. 0    
    { { dq, dq, q },
    { dq, e, e, er e },
    { dq, e, e, er, e },
    { dq, dq, q },
    { dq, dq, d },
    { dq, dq, sr, s, s, s },
    { dq, dq, q },
    { dq, dq, q },
    { e, e, s, s, e, e, s, s, e, e },
    { e, e, s, s, e, e, s, s, e, e } } };
    
    */
    
    
    //everyone plays this long piece of a thing once 
    for ( int i = 0; i<network.getPartSize(); i++ )
      for (int j =0; j<network.getChairSize(i); j++ )
      {
        
      }
*/

  }

    
    
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
  
  public void createPartIITest()
  {    
    int[][] E1 = {dq, e, er, sr, s, s, s, s, s}; //Line E.1
    int[][] E2 = {e, e, s, s, e, er, e, er, e}; //Line E.2
    
    int[] e1Measure_offset = { 0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 };   
    int[] e1Measure_offset16 = { 0, 0, 0, 0, 0, 2, 0, 4, 0, 0, 8, 0, 0, 0 };
    int[] e1Parts = new int[e1Measure_offset16.length];
    int[] e1Chairs = new int[e1Measure_offset16.length];
    
    for(int i=0; i < e1Measure_offset.length; i++)
    {
       int partIndex = i % network.getPartSize();
       e1Parts[i] = partIndex;
       e1Chairs[i] = i % network.getChairSize(partIndex);
    }
    
    int E_1[] = createMeasure(E1); 
    List<PlayerOffset> E_1_players = createPlayers(e1Measure_offset, e1Measure_offset16, e1Chairs, e1Parts);
    Measure e1Measure  = new Measure(0, E_1_players, E_1, "Line E, Measure 1");         
    measures.add(e1Measure);    
    
    int E_2[] = createMeasure(E2); 
    Measure e2Measure = e1Measure.copy("Line E, Measure 2"); 
    e2Measure.incOneMeasure();
    e2Measure.setNotes(E_2); 
    measures.add(e2Measure);      
    
  }

 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 

     
  public void createPartII()
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
    
    Measure e2Measure_3 = e1Measure_3.copy("Line E, Measure 2 Round Pt. 2"); 
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
  }*/
  
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
 //------------------------------------------------------------------------------------------------------------------------------ 
  
  public List<Measure> getMeasures() {
    return measures;
  }

}

