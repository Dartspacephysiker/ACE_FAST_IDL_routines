
IF KEYWORD_SET(DSTcutoff) THEN BEGIN

   plotPref = (N_ELEMENTS(plotPref) GT 0 ? plotPref : '' ) + $
              'Dst_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL) 

   IF KEYWORD_SET(smooth_dst) THEN BEGIN
      CASE smooth_dst OF
         1   : plotPref += 'sm-'
         ELSE: plotPref += 'sm_'+STRCOMPRESS(smooth_dst,/REMOVE_ALL)+'hr-'
      ENDCASE
      
   ENDIF

   paramPref = plotPref
   
ENDIF
