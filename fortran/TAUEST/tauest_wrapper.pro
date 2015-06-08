PRO tauest_wrapper, x, t, orbit, TOrA, detrend, nsimx, iseed7, cBias, $
   OUTFILE=outfile,DOSTREAKS=doStreaks,LUN=lun

  ;defaults
  defLun=54
  defTOrA='t'
  defDetrend='l'                    ;Default linear detrending
  defCbias='a'                      ;Default automatic bias correction

  defMaxDelay=5

  ;; defOutDir='/SPENCEdata/Research/Cusp/ACE_FAST/fortran/TAUEST/'
  defOutDir='./out/'
  defOutFilePref='tauest_data'
  defOutExt='.tmp'
  nL = string(10B)

  n = N_ELEMENTS(x)
  IF n NE N_ELEMENTS(t) THEN BEGIN
     PRINT,"Number of values in x and t don't match"
     PRINT,"Ending..."
     RETURN
  ENDIF

  IF ~KEYWORD_SET(orbit) THEN BEGIN
     PRINT,'No orbit number provided! Setting orbit=0...'
     orbit=0
  ENDIF

  IF ~KEYWORD_SET(lun) THEN lun=defLun

  IF NOT KEYWORD_SET(TOrA) THEN TOrA=defTOrA
  IF NOT KEYWORD_SET(detrend) THEN detrend=defDetrend
  IF NOT KEYWORD_SET(cBias) THEN cBias=defCBias

  IF KEYWORD_SET(doStreaks) THEN BEGIN
                                ; figure out streaks of data
     streak_end=where(shift(t,-1)-t GT defMaxDelay OR shift(t,-1)-t LT 0)
     streak_start=[0,(streak_end+1)(0:-2)]
     nStreaks = N_ELEMENTS(streak_start)
     
     PRINT,'There are ' + STRCOMPRESS(nStreaks,/REMOVE_ALL) + ' streaks in the data, assuming a max delay of ' $
           + STRCOMPRESS(defMaxDelay,/REMOVE_ALL) + ' sec between points.'
     
     nEvInStreak = MAKE_ARRAY(nStreaks,/INTEGER)
     nEvInStreak = streak_end-streak_start+1
     PRINT,FORMAT='("STREAK",T10,"START TIME",T25,"STOP TIME",T50,"N Points")'
     
     FOR j=0,nStreaks-1 DO BEGIN
        PRINT,FORMAT='(I0,T10,F0.5,T25,F0.5,T50,I0)',j,t(streak_start(j)),t(streak_end(j)),nEvInStreak(j)
     ENDFOR
     
     FOR j=0,nStreaks-1 DO BEGIN
        outFile=defoutDir+defOutFilePref+'_'+STRCOMPRESS(orbit,/REMOVE_ALL)+'_'+strCompress(j,/REMOVE_ALL)+defOutExt
        
        OPENW,lun,outFile,/GET_LUN
        
        FOR jj=0,nEvInStreak(j)-1 DO BEGIN
           t_temp=t(streak_start(j):streak_end(j))
           x_temp=x(streak_start(j):streak_end(j))
           ;; PRINTF,lun,FORMAT='(F0.4,T20,F0.4)',t(jj),x(jj)
           PRINTF,lun,FORMAT='(F0.4,T20,F0.4)',t_temp(jj),x_temp(jj)
        ENDFOR
        
        CLOSE,lun
        
                                ; run tauest1 on outFile
        SPAWN,'./tauest1 << EOF'+nL+outFile+nL+'EOF'+nL
        ;; SPAWN,'mv tauest1.tmp tauest1_'+STRCOMPRESS(orbit,/REMOVE_ALL)+'_'+strCompress(j,/REMOVE_ALL)+defOutExt

        ;; SPAWN,'./tauest2 << EOF'+nL+STRCOMPRESS(nEvInStreak(j),/REMOVE_ALL)+nL+TOrA+nL+detrend+
     ENDFOR

  ENDIF ELSE BEGIN

     IF NOT KEYWORD_SET(outFile) THEN outFile = defoutDir+defOutFilePref+defOutExt
     OPENW,lun,outFile,/GET_LUN
        
     FOR jj=0,n-1 DO BEGIN
        ;; PRINTF,lun,FORMAT='(F0.4,T20,F0.4)',t(jj),x(jj)
        PRINTF,lun,FORMAT='(F0.4,T20,F0.4)',t(jj),x(jj)
     ENDFOR

     CLOSE,lun

     SPAWN,'./tauest1 << EOF'+nL+outFile+nL+'EOF'+nL
     

  ENDELSE

  RETURN

END