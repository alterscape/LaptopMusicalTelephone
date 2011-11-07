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
    int E_1[] = createMeasure(E1); 
    List<PlayerOffset> E_1_players = createPlayersForE_1(E_1);
    Measure e1Measure  = new Measure(25, E_1_players, E_1, "Line E, Measure 1");         
    
    int[][] E_2 = {e, e, s, s, e, er, e, er, e}; //Line E.2
  
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
  
  
  List<PlayerOffset> createPlayersForE_1(int[] measure)
  {
      int[] chairs = { 0, 1, 2, 0, 1, 2, 0,  1,  2,  3,  0,  1,  2,  0, };
      int[] parts = { 0, 0, 0, 1, 1, 1, 2, 2,  2,  2,  0,  0,  0,  1, };
      int[] measure_offset = { 0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 };   
      int[] measure_offset16 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }; 
      
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

