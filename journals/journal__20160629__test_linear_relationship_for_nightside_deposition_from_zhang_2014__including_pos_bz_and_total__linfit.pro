;;2016/06/29
PRO JOURNAL__20160629__TEST_LINEAR_RELATIONSHIP_FOR_NIGHTSIDE_DEPOSITION_FROM_ZHANG_2014__INCLUDING_POS_BZ_AND_TOTAL__LINFIT

  inDir             = '/home/spencerh/Desktop/Spence_paper_drafts/2016/Alfvens_IMF/avg_IMF_conds/'
  inFile            = '20160628--test_linear_relationship_between_nightside_energy_deposition_and_bz_from_Zhang_2014--trimmed.txt'
  asciiTmpltFile    = '20160628--ascii_tmplt--relationship_tween_nightside_energy_dep.sav'
  datFile           = '20160628--data--relationship_tween_nightside_energy_dep.sav'


  outPlotNamePref   = 'Fig_8--Zhang_2014--integrated_hemispheric_power--including_total--linFit'
  ;; ;;Create ASCII template
  ;; ascii_tmplt    = ASCII_TEMPLATE(inDir+inFile)
  RESTORE,inDir+asciiTmpltFile
  ;; SAVE,ascii_tmplt,FILENAME=inDir+asciiTmpltFile

  ;; ;;Read ASCII
  g_pFlux           = READ_ASCII(inDir+inFile,TEMPLATE=ascii_tmplt)
  g_pFlux           = CREATE_STRUCT(g_pFlux,'TOTAL',g_pFlux.dayside+g_pFlux.nightside)
  SAVE,g_pFlux,FILENAME=inDir+datFile

  RESTORE,inDir+datFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Linear fits
  statWeights       = 0

  IF KEYWORD_SET(statWeights) THEN BEGIN
     weightSuff     = '--statWeights'
  ENDIF ELSE BEGIN
     weightSuff     = ''
  ENDELSE
  outPlotName       = outPlotNamePref + weightSuff + '.png'
  
  posInds           = WHERE(g_pFlux.bzAvg GT 0,nPos,NCOMPLEMENT=nNeg,COMPLEMENT=negInds)
  xVal              = g_pFlux.bzAvg
  xPos              = g_pFlux.bzAvg[posInds]
  xNeg              = g_pFlux.bzAvg[negInds]

  pNight            = g_pFlux.nightside/1.0e9
  pDay              = g_pFlux.dayside/1.0e9
  pTot              = g_pFlux.total/1.0e9

  IF KEYWORD_SET(statWeights) THEN BEGIN
     nightError     = 1./pNight
  ENDIF ELSE BEGIN
     nightError     = MAKE_ARRAY(N_ELEMENTS(pNight),VALUE=1)
  ENDELSE
  nightFitCoeff     = LINFIT(xVal,pNight, $
                             MEASURE_ERRORS=nightError, $
                             YFIT=nightFit)

  IF KEYWORD_SET(statWeights) THEN BEGIN
     nightPosError  = 1./pNight[posInds]
  ENDIF ELSE BEGIN
     nightPosError  = MAKE_ARRAY(N_ELEMENTS(pNight[posInds]),VALUE=1)
  ENDELSE
  nightPosFitCoeff  = LINFIT(xPos,pNight[posInds], $
                             MEASURE_ERRORS=nightPosError, $
                             YFIT=nightPosFit)
  nightPosName      = STRING(FORMAT='("Night fit (pos)",T16,": ",F0.3,"X+",F0.3)', $
                             nightPosFitCoeff[0], $
                             nightPosFitCoeff[1])

  IF KEYWORD_SET(statWeights) THEN BEGIN
     nightNegError  = 1./pNight[negInds]
  ENDIF ELSE BEGIN
     nightNegError  = MAKE_ARRAY(N_ELEMENTS(pNight[negInds]),VALUE=1)
  ENDELSE
  nightNegFitCoeff  = LINFIT(xNeg,pNight[negInds], $
                             MEASURE_ERRORS=nightNegError, $
                             YFIT=nightNegFit)
  nightNegName      = STRING(FORMAT='("Night fit (neg)",T16,": ",F0.3,"X",F0.3)', $
                             nightNegFitCoeff[0], $
                             nightNegFitCoeff[1])

  IF KEYWORD_SET(statWeights) THEN BEGIN
     dayError       = 1./pDay
  ENDIF ELSE BEGIN
     dayError       = MAKE_ARRAY(N_ELEMENTS(pDay),VALUE=1)
  ENDELSE
  dayFitCoeff       = LINFIT(xVal,pDay, $
                             MEASURE_ERRORS=dayPosError, $
                             YFIT=dayFit)
  
  IF KEYWORD_SET(statWeights) THEN BEGIN
     dayPosError    = 1./pDay[posInds]
  ENDIF ELSE BEGIN
     dayPosError    = MAKE_ARRAY(N_ELEMENTS(pDay[posInds]),VALUE=1)
  ENDELSE
  dayPosFitCoeff    = LINFIT(xPos,pDay[posInds], $
                             MEASURE_ERRORS=dayPosError, $
                             YFIT=dayPosFit)
  dayPosName        = STRING(FORMAT='("Day fit   (pos)",T16,": ",F0.3,"X+",F0.3)', $
                             dayPosFitCoeff[0], $
                             dayPosFitCoeff[1])

  IF KEYWORD_SET(statWeights) THEN BEGIN
     dayNegError    = 1./pDay[negInds]
  ENDIF ELSE BEGIN
     dayNegError    = MAKE_ARRAY(N_ELEMENTS(pDay[negInds]),VALUE=1)
  ENDELSE
  dayNegFitCoeff    = LINFIT(xNeg,pDay[negInds], $
                             MEASURE_ERRORS=dayNegError, $
                             YFIT=dayNegFit)
  dayNegName        = STRING(FORMAT='("Day fit   (neg)",T16,": ",F0.3,"X",F0.3)', $
                             dayNegFitCoeff[0], $
                             dayNegFitCoeff[1])

  IF KEYWORD_SET(statWeights) THEN BEGIN
     totalError     = 1./pTot
  ENDIF ELSE BEGIN
     totalError     = MAKE_ARRAY(N_ELEMENTS(pTot),VALUE=1)
  ENDELSE
  totalFitCoeff     = LINFIT(xVal,pTot, $
                             MEASURE_ERRORS=totalError, $
                             YFIT=totalFit)

  IF KEYWORD_SET(statWeights) THEN BEGIN
     totalPosError  = 1./pTot[posInds]
  ENDIF ELSE BEGIN
     totalPosError  = MAKE_ARRAY(N_ELEMENTS(pTot[posInds]),VALUE=1)
  ENDELSE
  totalPosFitCoeff  = LINFIT(xPos,pTot[posInds], $
                             MEASURE_ERRORS=totalPosError, $
                             YFIT=totalPosFit)
  totalPosName      = STRING(FORMAT='("Total fit (pos)",T16,": ",F0.3,"X+",F0.3)', $
                             totalPosFitCoeff[0], $
                             totalPosFitCoeff[1])

  IF KEYWORD_SET(statWeights) THEN BEGIN
     totalNegError  = 1./pTot[negInds]
  ENDIF ELSE BEGIN
     totalNegError  = MAKE_ARRAY(N_ELEMENTS(pTot[negInds]),VALUE=1)
  ENDELSE
  totalNegFitCoeff  = LINFIT(xNeg,pTot[negInds], $
                             MEASURE_ERRORS=totalNegError, $
                             YFIT=totalNegFit)
  totalNegName      = STRING(FORMAT='("Total fit (neg)",T16,": ",F0.3,"X",F0.3)', $
                             totalNegFitCoeff[0], $
                             totalNegFitCoeff[1])

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot options
  ;; title          = 'Hemispheric ' + ANSI_VALUE('Alfvénic') + ' Power'

  xTitle            = 'B!Dz!N (nT)'
  yTitle            = 'Integrated ' + ANSI_VALUE('Alfvénic') + 'Power (GW)' 

  ;; xRange         = [-8,0]
  ;; xRange         = [0,8]

  yError            = MAKE_ARRAY(N_ELEMENTS(xVal),VALUE=0,/FLOAT)
  ;; yMin           = ROUND_NTH_SIG_DIGIT(MIN([pDay,pNight]),1)
  ;; yMax           = ROUND_NTH_SIG_DIGIT(MAX([pDay,pNight]),2)
  ;; yMin           = ROUND_NTH_SIG_DIGIT(MIN(pTot),1)
  ;; yMax           = ROUND_NTH_SIG_DIGIT(MAX(pTot]),2)
  ;; yRange         = [yMin, $
  ;;                    yMax]
  yRange            = [0,2.8e9]/1.0e9

  fontSize          = 18
  legFontSize       = 10
  legFont           = 'Courier'

  sym               = ['td','tu','D']
  sym_thick         = 2.0
  thick             = 1.5
  transp            = 20
  ;; lineStyle         = ['-','-','-']
  lineStyle         = ['','','']
  fitLineStyle      = ['-','-','-']

  eb_cs             = 0.2
  eb_lineStyle      = ['--','-:','-.']

  ;;tdhe plot
  window            = WINDOW(DIMENSIONS=[1200,800])
  plotArr           = MAKE_ARRAY(9,/OBJ)
  
  plotArr[0]        = ERRORPLOT(xVal, $
                                pNight, $
                                g_pFlux.bzStdDev, $
                                yError, $
                                TITLE=title, $
                                XTITLE=xTitle, $
                                YTITLE=yTitle, $
                                XRANGE=xRange, $
                                YRANGE=yRange, $
                                SYMBOL=sym[0], $
                                ERRORBAR_CAPSIZE=eb_cs, $
                                ERRORBAR_LINESTYLE=eb_lineStyle[0], $
                                SYM_THICK=sym_thick, $
                                THICK=thick, $
                                TRANSPARENCY=transp, $
                                LINESTYLE=lineStyle[0], $
                                NAME='Nightside', $
                                COLOR='blue', $
                                FONT_SIZE=fontSize, $
                                CURRENT=window)

  plotArr[1]        = ERRORPLOT(xVal, $
                                pDay, $
                                g_pFlux.bzStdDev, $
                                yError, $
                                XRANGE=xRange, $
                                YRANGE=yRange, $
                                ERRORBAR_CAPSIZE=eb_cs, $
                                ERRORBAR_LINESTYLE=eb_lineStyle[1], $
                                SYMBOL=sym[1], $
                                SYM_THICK=sym_thick, $
                                THICK=thick, $
                                TRANSPARENCY=transp, $
                                LINESTYLE=lineStyle[1], $
                                NAME='Dayside', $
                                COLOR='red', $
                                FONT_SIZE=fontSize, $
                                CURRENT=window, $
                                /OVERPLOT)

  plotArr[2]        = ERRORPLOT(xVal, $
                                pTot, $
                                g_pFlux.bzStdDev, $
                                yError, $
                                XRANGE=xRange, $
                                YRANGE=yRange, $
                                ERRORBAR_CAPSIZE=eb_cs, $
                                ERRORBAR_LINESTYLE=eb_lineStyle[2], $
                                SYMBOL=sym[2], $
                                SYM_THICK=sym_thick, $
                                THICK=thick, $
                                TRANSPARENCY=transp, $
                                LINESTYLE=lineStyle[2], $
                                NAME='Total', $
                                COLOR='Black', $
                                FONT_SIZE=fontSize, $
                                CURRENT=window, $
                                /OVERPLOT)

  plotArr[3]        = PLOT(xPos, $
                           nightPosFit, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           ;; SYMBOL=sym[0], $
                           ;; SYM_THICK=sym_thick, $
                           THICK=thick, $
                           TRANSPARENCY=transp, $
                           LINESTYLE=fitLineStyle[0], $
                           NAME=nightPosName, $
                           COLOR='blue', $
                           FONT_SIZE=fontSize, $
                           CURRENT=window, $
                           /OVERPLOT)

  plotArr[4]        = PLOT(xPos, $
                           dayPosFit, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           ;; SYMBOL=sym[0], $
                           ;; SYM_THICK=sym_thick, $
                           THICK=thick, $
                           TRANSPARENCY=transp, $
                           LINESTYLE=fitLineStyle[1], $
                           NAME=dayPosName, $
                           COLOR='red', $
                           FONT_SIZE=fontSize, $
                           CURRENT=window, $
                           /OVERPLOT)

  plotArr[5]        = PLOT(xPos, $
                           totalPosFit, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           ;; SYMBOL=sym[0], $
                           ;; SYM_THICK=sym_thick, $
                           THICK=thick, $
                           TRANSPARENCY=transp, $
                           LINESTYLE=fitLineStyle[2], $
                           NAME=totalPosName, $
                           COLOR='black', $
                           FONT_SIZE=fontSize, $
                           CURRENT=window, $
                           /OVERPLOT)

  plotArr[6]        = PLOT(xNeg, $
                           nightNegFit, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           ;; SYMBOL=sym[0], $
                           ;; SYM_THICK=sym_thick, $
                           THICK=thick, $
                           TRANSPARENCY=transp, $
                           LINESTYLE=fitLineStyle[0], $
                           NAME=nightNegName, $
                           COLOR='blue', $
                           FONT_SIZE=fontSize, $
                           CURRENT=window, $
                           /OVERPLOT)

  plotArr[7]        = PLOT(xNeg, $
                           dayNegFit, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           ;; SYMBOL=sym[0], $
                           ;; SYM_THICK=sym_thick, $
                           THICK=thick, $
                           TRANSPARENCY=transp, $
                           LINESTYLE=fitLineStyle[1], $
                           NAME=dayNegName, $
                           COLOR='red', $
                           FONT_SIZE=fontSize, $
                           CURRENT=window, $
                           /OVERPLOT)

  plotArr[8]        = PLOT(xNeg, $
                           totalNegFit, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           ;; SYMBOL=sym[0], $
                           ;; SYM_THICK=sym_thick, $
                           THICK=thick, $
                           TRANSPARENCY=transp, $
                           LINESTYLE=fitLineStyle[2], $
                           NAME=totalNegName, $
                           COLOR='black', $
                           FONT_SIZE=fontSize, $
                           CURRENT=window, $
                           /OVERPLOT)

  legend            = LEGEND(TARGET=plotArr[0:-1], $
                             POSITION=[0.8,0.8], $
                             FONT_SIZE=legFontSize, $
                             FONT_NAME=legFont, $
                             ;; ALIGNMENT=0.5, $
                             ;; VERTICAL_ALIGNMENT=0.5, $
                             /NORMAL)


  PRINT,'Saving ' + outPlotName + ' ...'
  window.save,inDir+outPlotName


END
