;2016/03/21 Can you show me what it's all about?
PRO JOURNAL__20160321__PLOT_NEV_VS_DELAY__DAWNDUSK__ON_DAYSIDE

  nonstorm                       = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 66
  maxILAT                        = 88
  binILAT                        = 3.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -88
  ;; maxILAT                        = -66
  ;; binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; binMLT                         = 0.5
  ;; shiftMLT                       = 0.25

  clockStr                       = ['dawnward','duskward']

  cell                           = ['Dawn cell','Dusk cell']
  minMLT                         = [8.5,12.0]
  maxMLT                         = [12.0,15.5]
  binMLT                         = 1.0
  ;; shiftMLT                       = 0.5

  ;;IMF condition stuff
  ;; stableIMF                      = 1
  byMin                          = 4
  do_abs_bymin                   = 1
  ;; bzMin                          = 0
  bzMax                          = 1

  ;;DB stuff
  do_despun                      = 1

  altitudeRange                  = [1500,4175]

  ;;Delay stuff
  ;; delayArr                       = [-1500, -1440, -1380, -1320, -1260, $
  ;;                                   -1200, -1140, -1080, -1020,  -960, $
  ;;                                    -900,  -840,  -780,  -720,  -660, $
  ;;                                    -600,  -540,  -480,  -420,  -360, $
  ;;                                    -300,  -240,  -180,  -120,  -60,  $
  ;;                                       0,    60,   120,   180,   240, $
  ;;                                     300,   360,   420,   480,   540, $
  ;;                                     600,   660,   720,   780,   840, $
  ;;                                     900,   960,  1020,  1080,  1140, $
  ;;                                    1200,  1260,  1320,  1380,  1440, $
  ;;                                    1500]

  ;; nDelays                        = 71 
  ;; delayArr                       = (INDGEN(nDelays)-nDelays/2)*60

  ;; nDelays                        = 401*2 
  nDelays                        = 401*2 
  delayArr                       = (INDGEN(nDelays)-nDelays/2)*60

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  plot_i_list_list               = LIST()
  title_list                     = LIST()
  nEvArrList                     = LIST()
  ;;loop over clockstrings, then cells
  FOR clock_i=0,N_ELEMENTS(clockStr)-1 DO BEGIN
     FOR mlt_i=0,N_ELEMENTS(maxMLT)-1 DO BEGIN

  SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                             MINMLT=minMLT,MAXMLT=maxMLT, $
                             BINMLT=binMLT, $
                             SHIFTMLT=shiftMLT, $
                             MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                             MIN_MAGCURRENT=minMC, $
                             MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             DESPUNDB=despunDB, $
                             HEMI=hemi, $
                             BOTH_HEMIS=both_hemis, $
                             DATADIR=dataDir, $
                             PARAMSTRING=paramString, $
                             PARAMSTRPREFIX=plotPrefix, $
                             PARAMSTRSUFFIX=plotSuffix,$
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
                                                                                MINMLT=minMLT[mlt_i],MAXMLT=maxMLT[mlt_i], $
                                                                                BINM=binMLT, $
                                                                                SHIFTM=shiftMLT, $
                                                                                MINILAT=minILAT, $
                                                                                MAXILAT=maxILAT, $
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

        plot_i_list_list.add,plot_i_list
        title_list.add,clockStr[clock_i]+'--minM_maxM__'+STRCOMPRESS(minMLT[mlt_i],/REMOVE_ALL)+'_'+STRCOMPRESS(maxMLT[mlt_i],/REMOVE_ALL)
        
        nEvArr=!NULL
        FOR i=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN 
           n=N_ELEMENTS(plot_i_list[i]) 
           nEvArr=[nEvArr,n]
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
                      ;; SPACE_FOR_ROW_NAMES=0.05, $
                      ;; SPACE_FOR_COLUMN_NAMES=0.05, $
                      XTITLE='Delay (min)', $
                      YTITLE='N Events', $
                      CURRENT_WINDOW=window


  
  FOR i=0,N_ELEMENTS(nEvArrList)-1 DO BEGIN
     plot  = PLOT(delayArr/60.,nEvArrList[i], $
                  ;; TITLE=title_list[i], $
                  XRANGE=xRange, $
                  YRANGE=[yRangeMin,yRangeMax], $
                  ;; /HISTOGRAM, $
                  ;; XSHOWTEXT=0, $
                  ;; YSHOWTEXT=0, $
                  CURRENT=window, $
                  POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))
     
                  
  ENDFOR

  outFile = "journal__20160321__plot_nev_vs_delay--n_delays__"+STRCOMPRESS(nDelays,/REMOVE_ALL)+"--"+omni_paramStr+'.png'
  PRINT,'saving ' + outFile
  window.save,outFile

END
