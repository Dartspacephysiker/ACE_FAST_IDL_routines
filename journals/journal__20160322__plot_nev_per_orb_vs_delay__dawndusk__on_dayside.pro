;2016/03/21 Can you show me what it's all about?
PRO JOURNAL__20160322__PLOT_NEV_PER_ORB_VS_DELAY__DAWNDUSK__ON_DAYSIDE

  crossCorr_pref                 = "journal__20160322__CrossCorr_nev_per_orb_vs_delay--"
  outPlot_pref                   = "journal__20160322__plot_nev_per_orb_vs_delay--"
  outFile_dir                    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/journals/journal__20160322__nev_per_orb_and_crosscorrelation_savefiles/'

  nonstorm                       = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 66
  ;; maxILAT                        = 88
  ;; binILAT                        = 3.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -88
  ;; maxILAT                        = -66
  ;; binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Customize 'em!
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = [ 62, 62, 62, 62]
  ;; maxILAT                        = [ 78, 78, 78, 78]
  binILAT                        = 3.0
  minMLT                         = [ 8.25, 12.25,  8.25, 12.25]
  maxMLT                         = [11.75, 15.75, 11.75, 15.75]
  ;; binMLT                         = 1.0

  ;;Looks like Southern Hemi cells split around 11.25, and the important stuff is below -71 
  hemi                           = 'SOUTH'
  minILAT                        = -[ 78, 78, 78, 78]
  maxILAT                        = -[ 62, 62, 62, 62]
  ;; minILAT                        = [-83,-83,-83,-83]
  ;; maxILAT                        = [-71,-71,-71,-71]
  ;; binILAT                        = 3.0
  ;; minMLT                         = [ 7.0, 11.75,  7.0, 11.75]
  ;; maxMLT                         = [11.0, 15.75, 11.0, 15.75]
  ;; binMLT                         = 1.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; minMLT                         = [8.5,12.0]
  ;; maxMLT                         = [12.0,15.5]
  ;; binMLT                         = 0.5
  ;; shiftMLT                       = 0.25

  clockStr                       = ['dawnward','duskward']
  cell                           = ['Dawn cell','Dusk cell']
  ;; shiftMLT                       = 0.5

  ;;IMF condition stuff
  ;; stableIMF                      = 1
  byMin                          = 5
  do_abs_bymin                   = 1
  ;; bzMin                          = 0
  ;; bzMax                          = -1

  ;;DB stuff
  do_despun                      = 1

  altitudeRange                  = [1000,4175]

  ;; nDelays                        = 401*2 
  nDelays                        = 4001 
  delayArr                       = (INDGEN(nDelays,/LONG)-nDelays/2)*15

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; plot_i_list_list               = LIST()
  ;; fastloc_i_list_list            = LIST()
  title_list                     = LIST()
  nEvArrList                     = LIST()
  ;;loop over clockstrings, then cells
  FOR clock_i=0,N_ELEMENTS(clockStr)-1 DO BEGIN
     FOR mlt_i=0,N_ELEMENTS(cell)-1 DO BEGIN
        
        SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                   MINMLT=minMLT[mlt_i+2*clock_i],MAXMLT=maxMLT[mlt_i+2*clock_i], $
                                   BINMLT=binMLT, $
                                   SHIFTMLT=shiftMLT, $
                                   MINILAT=minILAT[mlt_i+2*clock_i],MAXILAT=maxILAT[mlt_i+2*clock_i],BINILAT=binILAT, $
                                   MIN_MAGCURRENT=minMC, $
                                   MAX_NEGMAGCURRENT=maxNegMC, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   DESPUNDB=despun, $
                                   HEMI=hemi, $
                                   BOTH_HEMIS=both_hemis, $
                                   DATADIR=dataDir, $
                                   PARAMSTRING=paramString, $
                                   PARAMSTRPREFIX=plotPrefix, $
                                   PARAMSTRSUFFIX=plotSuffix,$
                                   /DONT_CORRECT_ILATS, $
                                   HOYDIA=hoyDia,LUN=lun,_EXTRA=e
        
        SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr[clock_i], $
                                        ANGLELIM1=angleLim1, $
                                        ANGLELIM2=angleLim2, $
                                        ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                        BYMIN=byMin, $
                                        BZMIN=bzMin, $
                                        BYMAX=byMax, $
                                        BZMAX=bzMax, $
                                        DO_ABS_BYMIN=do_abs_byMin, $
                                        DO_ABS_BYMAX=do_abs_byMax, $
                                        DO_ABS_BZMIN=do_abs_bzMin, $
                                        DO_ABS_BZMAX=do_abs_bzMax, $
                                        BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                        PARAMSTRING=paramString, $
                                        PARAMSTR_LIST=paramString_list, $
                                        SATELLITE=satellite, $
                                        OMNI_COORDS=omni_Coords, $
                                        DELAY=delayArr, $
                                        /MULTIPLE_DELAYS, $
                                        STABLEIMF=stableIMF, $
                                        SMOOTHWINDOW=smoothWindow, $
                                        INCLUDENOCONSECDATA=includeNoConsecData, $
                                        LUN=lun
        
        plot_i_list                    = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delayArr,LUN=lun, $
                                                                                DBTIMES=cdbTime,dbfile=dbfile, $
                                                                                DESPUNDB=despun, $
                                                                                HEMI=hemi, $
                                                                                ORBRANGE=orbRange, $
                                                                                ALTITUDERANGE=altitudeRange, $
                                                                                CHARERANGE=charERange, $
                                                                                POYNTRANGE=poyntRange, $
                                                                                MINMLT=minMLT[mlt_i+2*clock_i],MAXMLT=maxMLT[mlt_i+2*clock_i], $
                                                                                BINM=binMLT, $
                                                                                SHIFTM=shiftMLT, $
                                                                                MINILAT=minILAT[mlt_i+2*clock_i], $
                                                                                MAXILAT=maxILAT[mlt_i+2*clock_i], $
                                                                                BINI=binILAT, $
                                                                                DO_LSHELL=do_lshell, $
                                                                                MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                                SMOOTHWINDOW=smoothWindow, $
                                                                                BYMIN=byMin,BZMIN=bzMin, $
                                                                                BYMAX=byMax,BZMAX=bzMax, $
                                                                                DO_ABS_BYMIN=do_abs_byMin, $
                                                                                DO_ABS_BYMAX=do_abs_byMax, $
                                                                                DO_ABS_BZMIN=do_abs_bzMin, $
                                                                                DO_ABS_BZMAX=do_abs_bzMax, $
                                                                                CLOCKSTR=clockStr[clock_i], $
                                                                                RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                                                                BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                                /MULTIPLE_DELAYS, $
                                                                                STABLEIMF=stableIMF, $
                                                                                DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                                OMNI_COORDS=omni_Coords, $
                                                                                OUT_OMNI_PARAMSTR=omni_paramStr, $
                                                                                ANGLELIM1=angleLim1, $
                                                                                ANGLELIM2=angleLim2, $
                                                                                HWMAUROVAL=HwMAurOval, $
                                                                                HWMKPIND=HwMKpInd, $
                                                                                NO_BURSTDATA=no_burstData)


        GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i_list,CLOCKSTR=clockStr[clock_i], ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                      ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                      BYMIN=byMin, $
                                      BYMAX=byMax, $
                                      BZMIN=bzMin, $
                                      BZMAX=bzMax, $
                                      DO_ABS_BYMIN=abs_byMin, $
                                      DO_ABS_BYMAX=abs_byMax, $
                                      DO_ABS_BZMIN=abs_bzMin, $
                                      DO_ABS_BZMAX=abs_bzMax, $
                                      MINMLT=minMLT[mlt_i+2*clock_i],MAXMLT=maxMLT[mlt_i+2*clock_i], $
                                      BINM=binMLT, $
                                      SHIFTM=shiftMLT, $
                                      MINILAT=minILAT[mlt_i+2*clock_i], $
                                      MAXILAT=maxILAT[mlt_i+2*clock_i], $
                                      BINI=binILAT, $
                                      SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                      HEMI=hemi, $
                                      DELAY=delayArr, $
                                      /MULTIPLE_DELAYS, $
                                      STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                      HWMAUROVAL=0,HWMKPIND=!NULL, $
                                      ;; MAKE_OUTINDSFILE=1, $
                                      OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                      ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                      ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                      FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                      BURSTDATA_EXCLUDED=burstData_excluded, $
                                      GET_FASTLOC_STRUCT=(N_ELEMENTS(fastLoc) EQ 0), $
                                      OUT_FASTLOC_STRUCT=fastLoc
        
        
        
        ;; plot_i_list_list.add,plot_i_list
        ;; fastLocInterped_i_list_list.add,fastLocInterped_i_list
        title_list.add,clockStr[clock_i]+'--minM_maxM__'+STRCOMPRESS(minMLT[mlt_i+2*clock_i],/REMOVE_ALL)+'_'+STRCOMPRESS(maxMLT[mlt_i+2*clock_i],/REMOVE_ALL)
        
        nEvArr=!NULL
        FOR i=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN 
           n=FLOAT(N_ELEMENTS(plot_i_list[i]))
           nOrbs=FLOAT(N_ELEMENTS(UNIQ(fastLoc.orbit[fastLocInterped_i_list[i]])))
           nEvArr=[nEvArr,n/nOrbs]
        ENDFOR
        nevArrList.add,nEvArr
     ENDFOR
  ENDFOR

  xRange    = [delayArr[0],delayArr[-1]]/60.
  yRangeMin = MIN(LIST_TO_1DARRAY(nEvArrList,/SKIP_NEG1_ELEMENTS,/WARN),MAX=yRangeMax)

  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                      NPLOTROWS=N_ELEMENTS(cell), $
                      COLUMN_NAMES=clockStr, $
                      ROW_NAMES=cell, $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.04, $
                      SPACE_FOR_ROW_NAMES=0.05, $
                      SPACE_FOR_COLUMN_NAMES=0.05, $
                      XTITLE='Delay (min)', $
                      YTITLE='N Events', $
                      CURRENT_WINDOW=window,/MAKE_NEW
  
  FOR i=0,N_ELEMENTS(nEvArrList)-1 DO BEGIN
     plot  = PLOT(delayArr/60.,nEvArrList[i], $
                  ;; TITLE=title_list[i], $
                  XRANGE=xRange, $
                  YRANGE=[yRangeMin,yRangeMax], $
                  CURRENT=window, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))
  ENDFOR

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  outPlot = outPlot_pref + hemi + "--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL)+"--"+omni_paramStr+'.png'
  PRINT,'saving ' + outPlot
  window.save,plotDir+outPlot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now cross-correlation analysis
  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=N_ELEMENTS(clockStr), $
                      NPLOTROWS=1, $
                      COLUMN_NAMES=clockStr, $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.04, $
                      SPACE_FOR_ROW_NAMES=0.05, $
                      SPACE_FOR_COLUMN_NAMES=0.05, $
                      XTITLE='N Lags ($\Delta$Lag = ' + STRCOMPRESS((delayArr[1]-delayArr[0])/60.,/REMOVE_ALL) + ' min)', $
                      YTITLE='Cross correlation', $
                      CURRENT_WINDOW=window_cc, $
                      /MAKE_NEW

  lags          = INDGEN(nDelays-2)-(nDelays-2)/2
  dawnward_ccor = C_CORRELATE(nEvArrList[0],nEvArrList[1],lags)
  duskward_ccor = C_CORRELATE(nEvArrList[2],nEvArrList[3],lags)

     plot  = PLOT(lags,dawnward_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([dawnward_ccor,duskward_ccor]),MAX([dawnward_ccor,duskward_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))
  
     plot  = PLOT(lags,duskward_ccor, $
                  XRANGE=[lags[0],lags[-1]], $
                  YRANGE=[MIN([dawnward_ccor,duskward_ccor]),MAX([dawnward_ccor,duskward_ccor])], $
                  CURRENT=window_cc, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))


     outPlot_CC= crossCorr_pref + +hemi+"--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL)+"--"+omni_paramStr+'.png'
     PRINT,'saving ' + outPlot_CC
     window_cc.save,plotDir+outPlot_CC

     outFile_dat = crossCorr_pref+hemi+"--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL)+"--"+omni_paramStr+'.sav'

     save,nEvArrList,delayArr,nDelays, $
          title_list, $
          lags,duskward_ccor,dawnward_ccor, $
          omni_paramStr,clockStr,cell, $
          hemi,minMLT,maxMLT,minILAT,maxILAT, $
          FILENAME=outFile_dir+outFile_dat

END
