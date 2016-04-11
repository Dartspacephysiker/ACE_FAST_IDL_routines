PRO H2D_AVERAGE_OVER_DELAYS, $
   IMFCONDSTRARR=IMFCondStrArr, $
   HEMIARR=hemiArr, $
   CLOCKSTRARR=clockStrArr, $
   NDELARR=nDelArr, $
   IN_AVGTYPES=in_avgTypes, $
   OUT_AVGTYPES=out_avgTypes, $
   DESPUN=despun, $
   MASKMIN=maskMin, $
   MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
   DELAYDELTASEC=delayDeltaSec, $
   RESOLUTION_DELAY=delay_res, $
   BINOFFSET_DELAY=binOffset_delay, $
   DELAY_START=delay_start, $
   DELAY_STOP=delay_stop, $
   LOGAVG_THESE_INDS=logAvg_inds, $
   TIMEAVG_THESE_INDS=timeAvg_these_inds, $   
   DONT_LOGAVG_THESE_INDS=dont_logAvg_inds, $
   LOGPLOT_THESE_INDS=logPlot_inds, $
   DONT_LOGPLOT_THESE_INDS=dont_logPlot_inds, $
   LIM_FOR_LOGPLOT_INDS=logPlot_lims, $
   LIM_FOR_UNLOGPLOT_INDS=unlogPlot_lims, $
   PLOT_DATESTR=plot_dateStr, $
   DO_SUBTRACT_FILE=do_subtract_file, $
   SUBTRACT__IMFCONDSTRARR=subtract__IMFCondStrArr, $
   SUBTRACT__CLOCKSTRARR=subtract__clockStrArr, $
   SUBTRACT__NEWDATANAMEARR=subtract__newDataNameArr, $
   SUBTRACT__NEWTITLES=subtract__newTitles, $
   SUBTRACT__NEWDATALIMS=subtract__newDataLims, $
   FILEDIR=fileDir

  FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
     FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
        FOR iClock=0,N_ELEMENTS(clockStrArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN
              FOR iAvgType=0,N_ELEMENTS(in_avgTypes)-1 DO BEGIN
                 AVERAGE_H2DS_OVER_DELAYS, $
                    HEMI=hemiArr[iHemi], $
                    DESPUN=despun, $
                    MASKMIN=maskMin, $
                    MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
                    CLOCKSTR=clockStrArr[iClock], $
                    IMFCONDSTR=IMFCondStrArr[iCond], $
                    NDELAYS=nDelArr[iDel], $
                    DELAYDELTASEC=delayDeltaSec, $
                    RESOLUTION_DELAY=delay_res, $
                    BINOFFSET_DELAY=binOffset_delay, $
                    DELAY_START=delay_start, $
                    DELAY_STOP=delay_stop, $
                    IN_AVGTYPE=in_avgTypes[iAvgType], $
                    OUT_AVGTYPE=out_avgTypes[iAvgType], $
                    LOGAVG_THESE_INDS=logAvg_inds, $
                    TIMEAVG_THESE_INDS=timeAvg_these_inds, $   
                    DONT_LOGAVG_THESE_INDS=dont_logAvg_inds, $
                    LOGPLOT_THESE_INDS=logPlot_inds, $
                    DONT_LOGPLOT_THESE_INDS=dont_logPlot_inds, $
                    LIM_FOR_LOGPLOT_INDS=logPlot_lims, $
                    LIM_FOR_UNLOGPLOT_INDS=unlogPlot_lims, $
                    PLOT_DATESTR=plot_dateStr, $
                    FILEDIR=fileDir, $
                    OUT_FILENAME=out_fileName

                 IF KEYWORD_SET(do_subtract_file) THEN BEGIN
                    AVERAGE_H2DS_OVER_DELAYS, $
                       HEMI=hemiArr[iHemi], $
                       DESPUN=despun, $
                       MASKMIN=maskMin, $
                       MINAVGS_FOR_NOMASK=minAvgs_for_noMask, $
                       CLOCKSTR=subtract__clockStrArr[iClock], $
                       IMFCONDSTR=subtract__IMFCondStrArr[iCond], $
                       NDELAYS=nDelArr[iDel], $
                       DELAYDELTASEC=delayDeltaSec, $
                       RESOLUTION_DELAY=delay_res, $
                       BINOFFSET_DELAY=binOffset_delay, $
                       DELAY_START=delay_start, $
                       DELAY_STOP=delay_stop, $
                       IN_AVGTYPE=in_avgTypes[iAvgType], $
                       OUT_AVGTYPE=out_avgTypes[iAvgType], $
                       LOGAVG_THESE_INDS=logAvg_inds, $
                       TIMEAVG_THESE_INDS=timeAvg_these_inds, $   
                       DONT_LOGAVG_THESE_INDS=dont_logAvg_inds, $
                       LOGPLOT_THESE_INDS=logPlot_inds, $
                       DONT_LOGPLOT_THESE_INDS=dont_logPlot_inds, $
                       LIM_FOR_LOGPLOT_INDS=logPlot_lims, $
                       LIM_FOR_UNLOGPLOT_INDS=unlogPlot_lims, $
                       PLOT_DATESTR=plot_dateStr, $
                       FILEDIR=fileDir, $
                       OUT_FILENAME=out_subtractFileName

                    RESTORE,out_subtractFilename
                    h2dStrArr_subtract        = h2dStrArr
                    dataNameArr_subtract      = dataNameArr

                    RESTORE,out_fileName

                    nPlots                    = N_ELEMENTS(dataNameArr)-2

                    ;;check to make sure these are the same
                    IF ~ARRAY_EQUAL(dataNameArr_subtract,dataNameArr) THEN BEGIN
                       PRINT,"Beware! Supposedly the two quantities you're about to operate on aren't equal!"
                       STOP
                    ENDIF

                    mask_str_i       = WHERE(STRMATCH(h2dStrArr.title,'Histogram mask',/FOLD_CASE))
                    good_i = WHERE(h2dStrArr[mask_str_i].data LT 250)
                    FOR plot_i=0,nPlots DO BEGIN
                       ;;Do the subtraction!
                       IF h2dStrArr[plot_i].is_logged OR h2dStrArr_subtract[plot_i].is_logged THEN BEGIN
                          PRINT,"Beware! You're subtracting log quantities! What does that even mean?"
                          STOP
                       ENDIF
                       h2dStrArr[plot_i].data            = h2dStrArr[plot_i].data - h2dStrArr_subtract[plot_i].data
                       h2dStrArr[plot_i].do_posNeg_cb    = 1
                       h2dStrArr[plot_i].force_oobLow    = 1
                       h2dStrArr[plot_i].force_oobHigh   = 1

                       minDat = MIN(h2dStrArr[plot_i].data[good_i])
                       maxDat = MAX(h2dStrArr[plot_i].data[good_i])
                       medDat = MEDIAN(h2dStrArr[plot_i].data[good_i])
                       IF KEYWORD_SET(subtract__newDataNameArr) THEN dataNameArr[plot_i]     = subtract__newDataNameArr[plot_i]
                       IF KEYWORD_SET(subtract__newTitles)      THEN h2dStrArr[plot_i].title = subtract__newTitles[plot_i]
                       IF KEYWORD_SET(subtract__newDataLims)    THEN h2dStrArr[plot_i].lim   = subtract__newDataLims[*,plot_i]
                       PRINT,FORMAT='("This plot has been subtracted    :",T40,I0,T45,A0)',plot_i,h2dStrArr[plot_i].title
                       PRINT,FORMAT='("Min, max, med lim  : ",T20,G13.3,T35,G13.3,T50,G13.3)',h2dStrArr[plot_i].lim[0],h2dStrArr[plot_i].lim[1], $
                             MEDIAN(h2dStrArr[plot_i].lim)
                       PRINT,FORMAT='("Min, max, med data : ",T20,G13.3,T35,G13.3,T50,G13.3)',minDat,maxDat,medDat
   
                    ENDFOR
                    
                      SAVE_ALFVENDB_TEMPDATA,TEMPFILE=out_filename+'_subtract', $
                         H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
                         MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI, $
                         BINM=binM, $
                         SHIFTM=shiftM, $
                         BINI=binI, $
                         DO_LSHELL=do_lShell, $
                         REVERSE_LSHELL=reverse_lShell, $
                         MINL=minL,MAXL=maxL,BINL=binL,$
                         RAWDIR=rawDir,PARAMSTR=paramStr,$
                         CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg, $
                         SMOOTH_IMF=smooth_IMF, $
                         STABLEIMF=stableIMF, $
                         HOYDIA=hoyDia,HEMI=hemi, $
                         /QUIET, $
                         LUN=lun

                 ENDIF

              ENDFOR
           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR

END