;2017/07/07
PRO JOURNAL__20170707__THOSE_PLOTS_YOU_WERE_TELLING_JIM_ABOUT__HEMISPH_RATES

  COMPILE_OPT IDL2,STRICTARRSUBS

  doDawnDuskPlots = 0
  doRegPlots      = 1

  include_ions    = 0

  orbRange        = [500,12670]
  altitudeRange   = [300,4300]

  minMC        = 1
  maxNegMC     = -1

  use_AACGM    = 1
  
  justSaveEmAll   = 1B
  stopEachTime    = 0B

  ;; nDelay       = 13 ;up to 60
  ;; nDelay       = 29 ;up to 120, starting at -20
  ;; dels         = (INDGEN(nDelay)-4)*5
  ;; dels            = [-15:70:5]
  ;; nDelay          = N_ELEMENTS(dels)

  DstCutoff    = -25
  stableIMF    = '9'
  ;; add_night_delay = 45*60
  dels         = [-30:90:5]*60

  nDelay          = N_ELEMENTS(dels)

  fileDir         = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'

  IF KEYWORD_SET(DstCutoff) THEN BEGIN
     DstString = (N_ELEMENTS(plotPref) GT 0 ? plotPref : '' ) + $
                 'Dst_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL)
     avgString = 'avgnStorm'
  ENDIF ELSE BEGIN
     DstString = ''
     avgString = 'avg'
  ENDELSE

  IF KEYWORD_SET(add_night_delay) THEN BEGIN
     addNightStr             = STRING(FORMAT='("_",F0.1,"ntDel")',add_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr             = ''
  ENDELSE

  IF KEYWORD_SET(fixed_night_delay) THEN BEGIN
     addNightStr             = STRING(FORMAT='("_",F0.1,"ntDel_fix")',fixed_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr             = N_ELEMENTS(addNightStr) GT 0 ? addNightStr : ''
  ENDELSE

  hemi         = 'NORTH'
  IF KEYWORD_SET(use_AACGM) THEN hemi += '_AACGM'

  finalDelStr     = STRING(FORMAT='("_",I0,"-",I0,"Dels")',dels[0]/60.,dels[-1]/60.) + addNightStr

  orbPref         = "-orb_"
  kmPref          = "km"

  orbStr          = STRING(FORMAT='(A0,I0,"-",I0)',orbPref,orbRange[0],orbRange[1])
  altStr          = STRING(FORMAT='(I0,"-",I0,A0)',altitudeRange[0],altitudeRange[1],kmPref)

  btMin        = 1.0
  btMinStr     = '_' + (KEYWORD_SET(abs_btMin) ? 'ABS' : '') $
                 + 'btMin' + STRING(btMin,FORMAT='(D0.1)')

  filePref     = 'polarplots_' + DstString + '--upto90ILAT' + altStr + orbStr + '-' + hemi + '-cur_-1-1-' + avgString + $
                 '_' + stableIMF + 'stable'
  fileSuff     = btMinStr + '-Ring'
  plotPref     = DstString + '--' + altStr + orbStr + '-' + hemi + '-cur_-1-1-' + avgString + $
                 '_' + stableIMF + 'stable_' + finalDelStr + btMinStr + '-'

  fileDir         = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'

  quants       = '_tAvgd_' + ['NoN-eNumFl','pF_pF','sptAvg_NoN-eNumFl_eF_LC_intg']
  divFacs      = [1.0D25,1.0D9,1.0D9]
  ;; niceNavn     = MAKE_ARRAY(3,/STRING)
  niceNavn     = ['Electron Precipitation (x10!U25!N/s)','Wave Energy Deposition (GW)','Electron Energy Deposition (GW)']

  ;;For three quantities
  xPlotPos      = [0.1,0.95]
  positionList = LIST([xPlotPos[0],0.7,xPlotPos[1],0.95], $
                      [xPlotPos[0],0.35,xPlotPos[1],0.68], $
                      [xPlotPos[0],0.05,xPlotPos[1],0.33])

  IF KEYWORD_SET(include_ions) THEN BEGIN
     quants    = [quants  ,'_tAvgd_sptAvg_NoN-iflux_IntgUp']
     divFacs   = [divFacs ,1.0D24]
     niceNavn  = [niceNavn,'Upflowing ions (x10!U24!N/s)']
     positionList = LIST([xPlotPos[0],0.74,xPlotPos[1],0.94], $
                         [xPlotPos[0],0.51,xPlotPos[1],0.72], $
                         [xPlotPos[0],0.28,xPlotPos[1],0.49], $
                         [xPlotPos[0],0.05,xPlotPos[1],0.26])
  ENDIF

  nQuants      = N_ELEMENTS(quants)

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  nIMFOrient   = N_ELEMENTS(clockStrings)

  dayIntegs    = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)
  nightIntegs  = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)
  totIntegs    = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)
  dawnIntegs   = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)
  duskIntegs   = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)

  ;;Plot opts
  winDim       = [1000,900]
  cols         = ['red','blue','black','orange','purple']
  names        = ['Day','Night','Total','Dawn','Dusk']
  lStyles      = ['--','-','__','--','-']
  thicks       = [3.0,3.0,3.0,3.0,3.0]
  fontSize     = 18
  xTickFontSize = 14
  yTickFontSize = 14
  legPos        = [0.95,0.75]

  FOREACH delay,dels,iDel DO BEGIN

     ;; fileName = filePref + del + fileSuff

        delayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) + addNightStr

        fileName = filePref + delayStr + fileSuff


     FOREACH quant,quants,iQuant DO BEGIN

        PRINT,fileName + quant
        
        IF FILE_TEST(fileDir+fileName+quant + '.dat') THEN BEGIN
           RESTORE,fileDir+fileName+quant + '.dat'
        ENDIF ELSE STOP

        ;; IF iDel EQ 0 THEN BEGIN
        ;;    niceNavn[iQuant] = H2DStrArr[0].title
        ;; ENDIF

        FOREACH IMF,clockStrings,iIMF DO BEGIN

           ;; dayIntegs[iQuant,iIMF,iDel]   = iIMF*iQuant*iDel
           ;; nightIntegs[iQuant,iIMF,iDel] = iIMF*iQuant*iDel
           dayIntegs[iQuant,iIMF,iDel]    = H2DStrArr[iIMF].grossIntegrals.day
           nightIntegs[iQuant,iIMF,iDel]  = H2DStrArr[iIMF].grossIntegrals.night
           totIntegs[iQuant,iIMF,iDel]    = H2DStrArr[iIMF].grossIntegrals.total
           dawnIntegs[iQuant,iIMF,iDel]   = H2DStrArr[iIMF].grossIntegrals.custom[0]
           duskIntegs[iQuant,iIMF,iDel]   = H2DStrArr[iIMF].grossIntegrals.custom[1]

        ENDFOREACH

     ENDFOREACH

  ENDFOREACH

  FOR k=0,nQuants-1 DO BEGIN

     dayIntegs[k,*,*]   /= divFacs[k]
     nightIntegs[k,*,*] /= divFacs[k]
     totIntegs[k,*,*]   /= divFacs[k]
     dawnIntegs[k,*,*]  /= divFacs[k]
     duskIntegs[k,*,*]  /= divFacs[k]

  ENDFOR

  ;;NOW PLOTS
  IF KEYWORD_SET(justSaveEmAll) THEN BEGIN
     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  ENDIF

  IF KEYWORD_SET(doRegPlots) THEN BEGIN

     FOREACH IMF,clockStrings,iIMF DO BEGIN
   
        window    = WINDOW(DIMENSIONS=winDim,BUFFER=justSaveEmAll)
        plotDay   = MAKE_ARRAY(nQuants,/OBJ)
        plotNight = MAKE_ARRAY(nQuants,/OBJ)
        plotTot   = MAKE_ARRAY(nQuants,/OBJ)
   
        FOREACH quant,quants,iQuant DO BEGIN
   
           plotDay[iQuant] = PLOT(dels/60., $
                                  dayIntegs[iQuant,iIMF,*], $
                                  TITLE=iQuant EQ 0 ? IMF : '', $
                                  XTITLE='Delay (min)', $
                                  XSHOWTEXT=(iQuant EQ (nQuants-1) ? !NULL : 0), $
                                  YTITLE=niceNavn[iQuant], $
                                  XSTYLE=3, $
                                  FONT_SIZE=fontSize, $
                                  XTICKFONT_SIZE=xTickFontSize, $
                                  YTICKFONT_SIZE=yTickFontSize, $
                                  NAME=names[0], $
                                  COLOR=cols[0], $
                                  LINESTYLE=lStyles[0], $
                                  THICK=thicks[0], $
                                  ;; LAYOUT=[1,3,iQuant+1], $
                                  POSITION=positionList[iQuant], $
                                  /CURRENT)
   
           plotNight[iQuant] = PLOT(dels/60., $
                                    nightIntegs[iQuant,iIMF,*], $
                                    NAME=names[1], $
                                    COLOR=cols[1], $
                                    LINESTYLE=lStyles[1], $
                                    THICK=thicks[1], $
                                    ;; LAYOUT=[1,3,iQuant+1], $
                                    POSITION=positionList[iQuant], $
                                    /OVERPLOT)
   
           plotTot[iQuant] = PLOT(dels/60., $
                                  totIntegs[iQuant,iIMF,*], $
                                  NAME=names[2], $
                                  COLOR=cols[2], $
                                  LINESTYLE=lStyles[2], $
                                  THICK=thicks[2], $
                                  ;; LAYOUT=[1,3,iQuant+1], $
                                  POSITION=positionList[iQuant], $
                                  /OVERPLOT)
   
       ENDFOREACH
        
       legend  = LEGEND(TARGET=[plotDay[-1],plotNight[-1],plotTot[-1]], $
                        POSITION=legPos,/NORMAL)
   
           IF KEYWORD_SET(justSaveEmAll) THEN BEGIN
              tmpPlotName = plotPref+'INTEGS-'+IMF+'-dayNightTot.png'
              PRINT,"Saving " + tmpPlotName + ' ...'
              window.Save,plotDir+tmpPlotName
           ENDIF
   
           IF KEYWORD_SET(stopEachTime) THEN STOP
   
           window.close
           OBJ_DESTROY,plotDay,plotNight,plotTot,window
   
     ENDFOREACH

  ENDIF

  IF KEYWORD_SET(doDawnDuskPlots) THEN BEGIN

     FOREACH IMF,clockStrings,iIMF DO BEGIN
   
        window    = WINDOW(DIMENSIONS=winDim,BUFFER=justSaveEmAll)
        plotDawn  = MAKE_ARRAY(nQuants,/OBJ)
        plotDusk = MAKE_ARRAY(nQuants,/OBJ)
   
        FOREACH quant,quants,iQuant DO BEGIN
   
           plotDawn[iQuant] = PLOT(dels/60., $
                                   dawnIntegs[iQuant,iIMF,*], $
                                   TITLE=iQuant EQ 0 ? IMF : '', $
                                   XTITLE='Delay (min)', $
                                   XSHOWTEXT=(iQuant EQ (nQuants-1) ? !NULL : 0), $
                                   XSTYLE=3, $
                                   YTITLE=niceNavn[iQuant], $
                                   FONT_SIZE=fontSize, $
                                   XTICKFONT_SIZE=xTickFontSize, $
                                   YTICKFONT_SIZE=yTickFontSize, $
                                   NAME=names[3], $
                                   COLOR=cols[3], $
                                   LINESTYLE=lStyles[3], $
                                   THICK=thicks[3], $
                                   ;; LAYOUT=[1,3,iQuant+1], $
                                   POSITION=positionList[iQuant], $
                                   /CURRENT)
           
           plotDusk[iQuant] = PLOT(dels/60., $
                                   duskIntegs[iQuant,iIMF,*], $
                                   NAME=names[4], $
                                   COLOR=cols[4], $
                                   LINESTYLE=lStyles[4], $
                                   THICK=thicks[4], $
                                   ;; LAYOUT=[1,3,iQuant+1], $
                                   POSITION=positionList[iQuant], $
                                   /OVERPLOT)
   
       ENDFOREACH
        
       legend  = LEGEND(TARGET=[plotDawn[-1],plotDusk[-1]], $
                        POSITION=legPos,/NORMAL)
   
           IF KEYWORD_SET(justSaveEmAll) THEN BEGIN
              tmpPlotName = plotPref+'INTEGS-'+IMF+'-dawnDusk.png'
              PRINT,"Saving " + tmpPlotName + ' ...'
              window.Save,plotDir+tmpPlotName
           ENDIF
   
           IF KEYWORD_SET(stopEachTime) THEN STOP
   
           window.close
           OBJ_DESTROY,plotDawn,plotDusk,window
   
     ENDFOREACH


  ENDIF

  STOP
  
END
