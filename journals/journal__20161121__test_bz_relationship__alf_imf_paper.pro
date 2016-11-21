;Here's how I've been running it:
;;JOURNAL__20161121__TEST_BZ_RELATIONSHIP__ALF_IMF_PAPER, $
;;  FILESDIR='/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/txtOutput/20161121/', $
;;  OMNI_FILE='OMNI_stats--bzSouthIntegs--AlfIMF--.sav',INTEG_FILE='integrals--bzSouth_paper--timeAvgd_NoNegs--LogpFlux--integrals.sav', $
;;  NH_INDS=[0:7], $
;;  SH_INDS=[8:15]
PRO JOURNAL__20161121__TEST_BZ_RELATIONSHIP__ALF_IMF_PAPER, $
   FILESDIR=filesDir, $
   OMNI_FILE=omni_file, $
   INTEG_FILE=integ_file, $
   NH_INDS=NH_inds, $
   SH_INDS=SH_inds, $
   USE_KAN_LEE=use_Kan_Lee

  COMPILE_OPT idl2

  IF N_ELEMENTS(use_Kan_Lee) EQ 0 THEN use_Kan_Lee  = 1

  IF KEYWORD_SET(OMNI_file) AND KEYWORD_SET(integ_file) THEN BEGIN
     bzStats = SETUP_STATS__BZ_RELATIONSHIP( $
               FILESDIR=filesDir, $
               OMNI_FILE=OMNI_file, $
               INTEG_FILE=integ_file, $
               NH_INDS=NH_inds, $
               SH_INDS=SH_inds)

     

  ENDIF

  ;;First run, delta_Bz = 2.5
  ;; CASE runNum OF
  ;;    1: BEGIN
  ;;       xVals  = [8.624,6.042,3.670,1.593,-1.598,-3.756,-6.024,-8.540]
  ;;       xStd    = 2*[0.711,0.699,0.704,0.596,0.590,0.708,0.694,0.709]
  ;;       NHIntegs = [1.01,.564,0.446,0.605,1.16,1.42,2.93,3.99]
  ;;       integErr = MAKE_ARRAY(N_ELEMENTS(xVals),VALUE=0,/FLOAT)
  ;;    END
  ;;    2: BEGIN
  ;;       ;;Second run, delta_Bz = 2.0,500 km to 4180 km
  ;;       xVals  = [8.909,6.867,4.899,3.006,1.297,-1.314,-3.048,-4.898,-6.822,-8.870]
  ;;       xStd    = 2*[0.578,0.575,0.574,0.573,0.468,0.469,0.575,0.572,0.564,0.570]
  ;;       NHIntegs = [1.14,0.669,0.486,0.482,0.582,0.993,1.23,1.83,3.26,6.06]

  ;;       KL_vals  = [0.000,0.000,0.000,0.000,0.000,0.543,1.301,2.130,3.015,3.831]
  ;;       KLStd    = [0.230,0.339,0.062,0.050,0.034,0.222,0.371,0.508,0.675,0.890]
  ;;    END
  ;; ENDCASE

  ;;The data
  xVals           = BzStats.bz.avg[NH_inds]
  xStd            = BzStats.bz.stdDev[NH_inds]

  NHIntegs        = BzStats.integs.day[NH_inds]+BzStats.integs.night[NH_inds]
  SHIntegs        = BzStats.integs.day[SH_inds]+BzStats.integs.night[SH_inds]

  integList       = LIST(TEMPORARY(NHIntegs),TEMPORARY(SHIntegs))

  integErr        = MAKE_ARRAY(N_ELEMENTS(xVals),VALUE=0,/FLOAT)

  ;;The stuff
  posBz           = WHERE(xVals GT 0,COMPLEMENT=negBz)

  xTitle          = 'Southward B!Dz!N (nT)'
  yTitle          = 'Integrated ' + ANSI_VALUE('Alfvénic') + 'Power (GW)' 

  fontSize        = 18

  IF KEYWORD_SET(use_Kan_Lee) THEN BEGIN
     xTitle       = 'v B!DT!Nsin!U2!N($\phi$!DIMF!N/2)'
     xVals        = BzStats.KL.avg[NH_inds]
     xStd        = BzStats.KL.stdDev[NH_inds]

     ;; negBz        = WHERE(xVals GT 0,COMPLEMENT=posBz)
     ;;The linear fit
     ;; negParams    = LINFIT(xVals[negBz],NHIntegs[negBz],YFIT=negFit)
     ;; negCorr      = LINCORR(xVals[negBz],NHIntegs[negBz],T_STAT=neg_t_stat)

  ENDIF

  sym             = ['D','tu']
  sym_thick       = 2.0
  thick           = 1.0
  transp          = 40
  ;; lineStyle       = ['--','-:']
  lineStyle       = ['-','-']

  eb_cs           = 0.2
  eb_lineStyle    = ['--','-:']

  window          = WINDOW(DIMENSIONS=[800,600])

  xRange          = KEYWORD_SET(use_Kan_Lee) ? MINMAX(xVals) : [-10,10]
  ;; yRange          = [0,(MINMAX(NHIntegs))[1]]
  ;; yRange          = runNum EQ 2 ? [0,6.7] : [0,4.2]
  yRange          = [0,6.7] ; [0,4.2]

  plotArr          = MAKE_ARRAY(6,/OBJ)
  plotInd          = 0


  BzPosCol         = ['Red' ,'Purple']
  BzNegCol         = ['Blue','Green']
  hemiArr          = ['NH','SH']
  N_hemis          = 2
  legInds          = !NULL
  FOR k=0,N_hemis-1 DO BEGIN

     ;;The linear fit
     negParams    = LINFIT(xVals[negBz],IntegList[k,negBz],YFIT=negFit)
     negCorr      = LINCORR(xVals[negBz],IntegList[k,negBz],T_STAT=neg_t_stat)

     hemiStr       = hemiArr[k]
     integs        = integList[k]

     plotArr[plotInd] = ERRORPLOT(xVals[posBz], $
                                  integs[posBz], $
                                  xStd[posBz], $
                                  integErr[posBz], $
                                  TITLE=title, $
                                  XTITLE=xTitle, $
                                  YTITLE=yTitle, $
                                  XRANGE=xRange, $
                                  YRANGE=yRange, $
                                  SYMBOL='Tu', $
                                  ERRORBAR_CAPSIZE=eb_cs, $
                                  ERRORBAR_LINESTYLE=eb_lineStyle[0], $
                                  SYM_THICK=sym_thick, $
                                  THICK=thick, $
                                  TRANSPARENCY=transp, $
                                  ;; LINESTYLE=KEYWORD_SET(use_Kan_Lee) ? 0 : lineStyle[0], $
                                  LINESTYLE=' ', $
                                  NAME=hemiArr[k] + ', B$_z$ > 0', $
                                  COLOR=BzPosCol[k], $
                                  FONT_SIZE=fontSize, $
                                  OVERPLOT=plotInd GT 0, $
                                  CURRENT=window)
     legInds = [legInds,plotInd]
     plotInd++


     plotArr[plotInd] = ERRORPLOT(xVals[negBz], $
                                  integs[negBz], $
                                  xStd[negBz], $
                                  integErr[negBz], $
                                  TITLE=title, $
                                  XTITLE=xTitle, $
                                  YTITLE=yTitle, $
                                  XRANGE=xRange, $
                                  YRANGE=yRange, $
                                  SYMBOL='Tu', $
                                  ERRORBAR_CAPSIZE=eb_cs, $
                                  ERRORBAR_LINESTYLE=eb_lineStyle[0], $
                                  SYM_THICK=sym_thick, $
                                  THICK=thick, $
                                  TRANSPARENCY=transp, $
                                  ;; LINESTYLE=KEYWORD_SET(use_Kan_Lee) ? ' ' : lineStyle[0], $
                                  LINESTYLE=' ', $
                                  ;; LINESTYLE=lineStyle[0], $
                                  NAME=hemiArr[k] + ', B$_z$ < 0', $
                                  ;; NAME=hemiArr[k], $
                                  COLOR=BzNegCol[k], $
                                  FONT_SIZE=fontSize, $
                                  /OVERPLOT, $
                                  CURRENT=window)
     legInds = [legInds,plotInd]
     plotInd++

     plotArr[plotInd] = PLOT(xVals[negBz], $
                             negFit, $
                             ;; TITLE=title, $
                             ;; XTITLE=xTitle, $
                             ;; YTITLE=yTitle, $
                             ;; XRANGE=[-10,10], $
                             ;; YRANGE=yRange, $
                             ;; SYMBOL='Tu', $
                             ;; SYM_THICK=sym_thick, $
                             ;; THICK=thick, $
                             ;; TRANSPARENCY=transp, $
                             LINESTYLE=KEYWORD_SET(use_Kan_Lee) ? 0 : lineStyle[0], $
                             ;; LINESTYLE=lineStyle[0], $
                             COLOR=BzNegCol[k], $
                             FONT_SIZE=fontSize, $
                             /OVERPLOT, $
                             CURRENT=window)

     plotInd++

     slopeString  = STRING(FORMAT='(A-10,T10,F7.3)',"slope  =",negParams[1])
     corrString   = STRING(FORMAT='(A-10,T10,F7.3)',"r      =",negCorr[0])
     tString      = STRING(FORMAT='(A-10,T10,F7.3)',"t-test =",neg_t_stat)

     slopeText    = TEXT(0.2,0.80-k*0.2, $
                         slopeString, $
                         /NORMAL, $
                         FONT_NAME='Courier', $
                         FONT_SIZE=18, $
                         TARGET=window, $
                         COLOR=BzNegCol[k])
     corrText     = TEXT(0.2,0.75-k*0.2, $
                         corrString, $
                         /NORMAL, $
                         FONT_NAME='Courier', $
                         FONT_SIZE=18, $
                         TARGET=plot, $
                         COLOR=BzNegCol[k])
     tText        = TEXT(0.2,0.70-k*0.2, $
                         tString, $
                         /NORMAL, $
                         FONT_NAME='Courier', $
                         FONT_SIZE=18, $
                         TARGET=plot, $
                         COLOR=BzNegCol[k])

  ENDFOR

  legend = LEGEND(TARGET=plotArr[legInds], $
                  /NORMAL)

  STOP

END
