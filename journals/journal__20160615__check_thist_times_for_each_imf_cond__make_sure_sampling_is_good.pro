;;2016/06/15 Making sure we were here often enough for the time averages in the IMF/Alfvén paper to be meaningful
PRO JOURNAL__20160615__CHECK_THIST_TIMES_FOR_EACH_IMF_COND__MAKE_SURE_SAMPLING_IS_GOOD
  
  COMPILE_OPT idl2

  RESTORE,'temp/polarplots_Jun_15_16--NORTH--despun--avg--a_la_Zhang_2014__0stable__0.00mindelay__30.00Res__0.00binOffset__btMin5.0--theRing_tHistDenom.dat'

  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               MAX1=24, $
                               MIN1=0, $
                               MAX2=86, $
                               MIN2=62, $
                               BINSIZE1=1.0, $
                               SHIFT1=0.5, $
                               BINSIZE2=3.0
  
  PRINT,centers[1,*,0],centers[0,*,0]

  ilats = REFORM(centers[1,*,0])
  mlts  = REFORM(centers[0,*,0])

  PRINT,FORMAT='("MLT",T10,"ILAT",T20,"tHistVal")'
  FOR i=0,N_ELEMENTS(h2dStrArr)-1 DO BEGIN
     FOR k=0,N_ELEMENTS(mlts)-1 DO BEGIN
        PRINT,FORMAT='(F6.2,T10,F6.2,T20,F7.2)',mlts[k],ilats[k],h2dStrArr[i].data[k,0]
     ENDFOR
     PRINT,""
  ENDFOR
END