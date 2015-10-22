;This pro uses output from plot_alfven_stats_imf_screening, either temp or raw, to do standalone plots
;The tempfile provides h2dStr,dataName,maxM,minM,maxI,minI,binM,binI,$
;                           rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemstr

;interp_polar_2dhist only needs clockstr and a structure with three members:
; temp.data: the actual data
; temp.title: name of the plot
; temp.lim;   limits of the data product

;note, last element of h2dStr is always histogram mask
;

PRO independent_polar_plot2dhist,temp_or_rawfile,histStructure,OUTPSFNAME=outPSFName

  ;delete postscripts if created
  DEL_PS=1

  IF FILE_TEST(temp_or_rawfile) THEN restore,temp_or_rawfile $
  ELSE BEGIN
     print,"Can't open file " + temp_or_rawfile
     print,"Quitting..."
     RETURN
  ENDELSE

  ;if the file restore worked, keep it moving
  IF NOT KEYWORD_SET(histStructure) THEN BEGIN
     IF h2dStr NE !NULL AND dataName NE !NULL THEN BEGIN
        FOR i=0,N_ELEMENTS(dataName)-1 DO BEGIN
           PRINT,FORMAT='(I0,T12,A0)',i,dataName[i]
        ENDFOR
        PRINT,"Which data product would you like to plot?"
        promptStr="(Select from " + strcompress(0,/remove_all) + " to " + strcompress(i,/remove_all) + ")"
        READ,data_i,PROMPT=promptStr
        histoStr=h2dStr[data_i]
     ENDIF ELSE BEGIN
        PRINT, "Either no h2dStr or no dataname var!! Can't plot..."
        RETURN
     ENDELSE
  ENDIF ELSE BEGIN
     PRINT,'Using user-supplied data structure...'
     histoStr=histStructure
     ;; IF ISA(histoStr,/ARRAY) THEN BEGIN
     ;;    histoStr={data:histoStr,title:"User-supplied data",lim:[min(histoStr),max(histoStr)]}
     ;; ENDIF
  ENDELSE

  ;do either postscript output or cgWindow here
  IF KEYWORD_SET(outPSFName) THEN BEGIN
     cgPS_Open, outPSFName 
  
     ploth2d_stereographic,histoStr,temp_or_rawfile,CLOCKSTR=clockStr,_extra=e 
  
  
     cgPS_Close 
     cgPS2Raster, outPSFName, /PNG, Width=800, DELETE_PS =DEL_PS
  ENDIF ELSE BEGIN
     cgWindow,'ploth2d_stereographic',histoStr,temp_or_rawfile,CLOCKSTR=clockStr,_extra=e
  ENDELSE

END