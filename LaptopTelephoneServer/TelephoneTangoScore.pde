class TelephoneTangoScore
{
  ArrayList<Measure> measures;
  
  //note durations for easy transcription
  private final int[] h = {1,0,0,0,0,0,0};
  private final int[] q = {1,0,0,0};
  private final int[] e = {1,0};
  private final int[] hr = {0,0,0,0,0,0,0,0};
  private final int[] dq = {1,0,0,0,0,0};
  private final int[] qr = {0,0,0,0};
  private final int[] er = {0,0};  
  private final int[] s =  {1};
  private final int[] sr = {0};
  private final int[] t332 = {1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0};

  public TelephoneTangoScore()
  {
    measures = new ArrayList<Measure>(); 
    
    //Part II
    int[][] E1 = {dq, e, er, sr, s, s, s, s, s}; //Line E.1
    int[] e1Chairs = { 0, 1, 2, 0, 1, 2, 0,  1,  2,  3,  0,  1,  2,  0, };
    int[] e1Parts = { 0, 0, 0, 1, 1, 1, 2, 2,  2,  2,  0,  0,  0,  1, };
    int[] e1Measure_offset = { 0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 };   
    int[] e1Measure_offset16 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };    
    
    //create first measure of Part II
    int E_1[] = createMeasure(E1); 
    List<PlayerOffset> E_1_players = createPlayers(e1Measure_offset16, e1Measure_offset, e1Chairs, e1Parts);
    Measure e1Measure  = new Measure(25, E_1_players, E_1, "Line E, Measure 1");         
    
    //create 2nd by copying the travel info & changing start measure and actual notes played
    int[][] E_2 = {e, e, s, s, e, er, e, er, e}; //Line E.2
    Measure e2Measure = e1Measure.copy("Line E, Measure 2"); 
    e2Measure.incOneMeasure();
    e2Measure.setNotes(createMeasure(E_2)); 
  
  }
  
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
  
  
  List<PlayerOffset> createPlayers(int[] measure_offset16, int[] measure_offset, int[] chairs, int[] parts)
  {   
      ArrayList<PlayerOffset> players = new ArrayList<PlayerOffset>(); 
      for( int i=0; i<chairs.length; i++)
      {
        PlayerOffset info = new PlayerOffset(measure_offset16[i], measure_offset[i], "", chairs[i], parts[i]); 
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
}

