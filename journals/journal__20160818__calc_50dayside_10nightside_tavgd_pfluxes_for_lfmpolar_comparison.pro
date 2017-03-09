;;08/18/16
PRO JOURNAL__20160818__CALC_50DAYSIDE_10NIGHTSIDE_TAVGD_PFLUXES_FOR_LFMPOLAR_COMPARISON

  COMPILE_OPT IDL2,STRICTARRSUBS

  ILAT_restriction_on_stats = 1 ;;limit the range of ILATs considered in calculating medians, maxes, etc.

  dayIncreaseFactor   = 2.
  nightIncreaseFactor = 10.

  save_postScript     = 0

  IF KEYWORD_SET(save_postScript) THEN BEGIN
     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
     fileName     = plotDir+'pflux_tAvg--just_1997--Dayside_doubled__nightside_incr_1000percent'
  ENDIF

  inDir  = '/home/spencerh/Desktop/Spence_paper_drafts/2016/Alfvens_IMF/'

  ;; inFile = 'H2D_tAvgd_pflux--just_1997--1000-4180--NORTH--despun--avg--NO_IMF_CONSID--20160818.dat'
  inFile = 'H2D_tAvgd_pflux--just_1997--1000-4180--NORTH--despun--avg--NO_IMF_CONSID--20160818.dat'

  RESTORE,inDir+inFile

  ;;This one is tAvgd pFlux
  h2dStr  = h2dStrArr[0]
  h2dMask = h2dStrArr[1]

  h2dStr.lim = [0,1.1]

  ;; ;;We get binI,minI,maxI,binM,minM, etc., from the restored file so don't worry about it
  ;; binMLT = 0.75
  ;; binILAT = 2.0
  ;; minI   = 60
  ;; maxI   = 90

  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                                 CENTERS1=centersMLT,CENTERS2=centersILAT, $
                                 BINSIZE1=binM, BINSIZE2=binI, $
                                 MIN1=minM, MIN2=minI,$
                                 MAX1=maxM, MAX2=maxI,  $
                                 SHIFT1=shiftM,SHIFT2=shiftI, $
                                 OMIN1=Omin1, OMIN2=Omin2, $
                                 OMAX1=Omax1, OMAX2=Omax2,  $
                                 OBIN1=Obin1, OBIN2=Obin2, $
                                 NBINS1=nMLTBins, NBINS2=nILATBins, $
                                 BINEDGE1=Binedge1, BINEDGE2=Binedge2


  dayMLTsLower    = [6,9,10.5]
  dayMLTsHigher   = [18,15,15]
  nightMLTsLower  = [6,3,1.5]
  nightMLTsHigher = [18,21,21]
  nCheckOut       = N_ELEMENTS(dayMLTsLower)
  dayMedian       = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  nightMedian     = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  dayAvg          = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  nightAvg        = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  dayLogAvg       = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  nightLogAvg     = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  dayMax          = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)
  nightMax        = MAKE_ARRAY(nCheckOut,/FLOAT,VALUE=0.)

  notMasked_i     = WHERE(h2dMask.data LT 250,nMasked)

  binsize         = [0.5,0.5,0.5]
  maxVals         = [50,30,30]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Entire dayside, nightside
  FOR k=0,nCheckOut-1 DO BEGIN

     dayside_i   = WHERE(centersMLT GT dayMLTsLower[k] AND centersMLT LE dayMLTsHigher[k], $
                         nDayside)
     nightside_i = WHERE(centersMLT LE nightMLTsLower[k] OR centersMLT GT nightMLTsHigher[k], $
                         nNightside)

     IF KEYWORD_SET(ILAT_restriction_on_stats) THEN BEGIN
        PRINT,'*ILAT-restricted statistics*'
        ILAT_i      = WHERE(centersILAT GE 70 AND centersILAT LE 80,nILATBins)
        dayside_i   = CGSETINTERSECTION(dayside_i,ILAT_i)
        nightside_i = CGSETINTERSECTION(nightside_i,ILAT_i)
     ENDIF

     dayGood_i   = CGSETINTERSECTION(notMasked_i,dayside_i)
     nightGood_i = CGSETINTERSECTION(notMasked_i,nightside_i)

     dayNZ_i     = CGSETINTERSECTION(dayGood_i,WHERE(h2dStr.data GT 0))
     nightNZ_i   = CGSETINTERSECTION(nightGood_i,WHERE(h2dStr.data GT 0))

     dayMedian[k]     = MEDIAN(h2dStr.data[dayGood_i])
     nightMedian[k]   = MEDIAN(h2dStr.data[nightGood_i])

     dayAvg[k]     = MEAN(h2dStr.data[dayGood_i])
     nightAvg[k]   = MEAN(h2dStr.data[nightGood_i])

     dayLogAvg[k]     = 10.^(MEAN(ALOG10(h2dStr.data[dayNZ_i])))
     nightLogAvg[k]   = 10.^(MEAN(ALOG10(h2dStr.data[nightNZ_i])))

     dayMax[k]      = MAX(h2dStr.data[dayGood_i])
     nightMax[k]    = MAX(h2dStr.data[nightGood_i])

     PRINT,FORMAT='("Day   mean   : ",T30,F0.4)',dayAvg[k]
     PRINT,FORMAT='("Night mean   : ",T30,F0.4)',nightAvg[k]
     PRINT,''
     PRINT,FORMAT='("Day  logAvg  : ",T30,F0.4)',dayLogAvg[k]
     PRINT,FORMAT='("Night logAvg : ",T30,F0.4)',nightLogAvg[k]
     PRINT,''
     PRINT,FORMAT='("Day   median : ",T30,F0.4)',dayMedian[k]
     PRINT,FORMAT='("Night median : ",T30,F0.4)',nightMedian[k]
     PRINT,''
     PRINT,FORMAT='("Day   max    : ",T30,F0.4)',dayMax[k]
     PRINT,FORMAT='("Night max    : ",T30,F0.4)',nightMax[k]
     PRINT,''

     CGHISTOPLOT,ALOG10(h2dStr.data[dayNZ_i]),BINSIZE=binsize[k], $
                 MAXINPUT=0,MININPUT=-5.0, $
                 MAX_VALUE=maxVals[k]
     CGHISTOPLOT,ALOG10(h2dStr.data[nightNZ_i]),BINSIZE=binsize[k], $
                 MAXINPUT=0,MININPUT=-5.0, $
                 MAX_VALUE=maxVals[k]              

  ENDFOR

  ;; CGHISTOPLOT,centersMLT[nightside_i],BINSIZE=0.75

  ;; h2dStr.data
  PRINT,"Increasing dayside and nightside by appropriate factors ..."

  h2dStr.data[dayside_i]   = h2dStr.data[dayside_i]*dayIncreaseFactor
  h2dStr.data[nightside_i] = h2dStr.data[nightside_i]*nightIncreaseFactor

  IF KEYWORD_SET(save_postScript) THEN BEGIN
     PRINT,'Opening postscript file: ' + fileName
     PS_OPEN,fileName
  ENDIF

  SIMPLE_H2DPLOTTER_STEREOGRAPHIC,h2dStr, $
                                  INDATA=h2dStr.data, $
                                  H2DMASK=h2dMask, $
                                  POSTSCRIPT=save_postScript, $
                                  PLOT_ON_LOGSCALE=logScale, $
                                  UNLOG_LABELS=unlog_labels, $
                                  LABELFORMAT=labelFormat, $
                                  DO_MIDCB_LABEL=do_midCB_label, $
                                  MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                  SHIFTMLT=shiftM, $
                                  MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $                                    
                                  WHOLECAP=wholeCap,MIDNIGHT=midnight, $
                                  PLOTTITLE=plotTitle, MIRROR=mirror, $
                                  SHOW_PLOT_INTEGRAL=show_plotIntegral, $
                                  GRIDCOLOR=gridColor, $
                                  DEBUG=debug, $
                                  LOGAVGPLOT=logAvgPlot, $
                                  MEDIANPLOT=medianPlot, $
                                  CURRENT=current, $
                                  POSITION=position, $
                                  WINDOW_XPOS=xPos, $
                                  WINDOW_YPOS=yPos, $
                                  NO_COLORBAR=no_colorbar, $
                                  CB_LIMITS=cb_limits, $
                                  CB_FORCE_OOBLOW=cb_force_ooblow, $
                                  CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                                  OUT_H2D_DATA=h2dData
  


  IF KEYWORD_SET(save_postScript) THEN BEGIN
     PRINT,'Closing postscript file: ' + fileName
  ENDIF

  STOP

END
