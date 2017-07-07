;2017/07/07
PRO JOURNAL__20170707__THOSE_PLOTS_YOU_WERE_TELLING_JIM_ABOUT__HEMISPH_RATES

  COMPILE_OPT IDL2,STRICTARRSUBS

  fileDir      = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  ;; filePref     = 'polarplots_Dst_-50--upto90ILAT1500-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_19stable_'

  ;; filePref     = 'polarplots_Dst_-50--upto90ILAT300-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_'
  ;; plotPref     = 'polarplots_Dst_-50--upto90ILAT300-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_'

  filePref     = 'polarplots_Dst_-50--upto90ILAT750-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_'
  plotPref     = 'Dst_-50--upto90ILAT750-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_30.0Res_btMin1.0-'

  fileSuff     = 'Del_30.0Res_btMin1.0-Ring_tAvgd_'

  quants       = ['NoN-eNumFl','pF_pF','sptAvg_NoN-eNumFl_eF_LC_intg']
  divFacs      = [1.0D25,1.0D9,1.0D9]
  ;; niceNavn     = MAKE_ARRAY(3,/STRING)
  niceNavn     = ['Electron Precipitation (x10!U25!N/s)','Wave Energy Deposition (GW)','Electron Energy Deposition (GW)']
  nQuants      = N_ELEMENTS(quants)

  nDelay       = 13
  dels         = INDGEN(nDelay)*5
  delsStr      = STRING(FORMAT='(F0.1)',dels)

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  nIMFOrient   = N_ELEMENTS(clockStrings)

  dayIntegs    = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)
  nightIntegs  = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)
  totIntegs    = MAKE_ARRAY(nQuants,nIMFOrient,nDelay,/DOUBLE)

  ;;Plot opts
  justSaveEmAll = 1B
  stopEachTime  = 0B
  winDim       = [1000,900]
  cols         = ['red','blue','black']
  names        = ['Day','Night','Total']
  lStyles      = ['--','-','__']
  thicks       = [3.0,3.0,3.0]
  fontSize     = 18
  xTickFontSize = 14
  yTickFontSize = 14
  x1            = 0.1
  x2            = 0.95
  positionList  = LIST([x1,0.7,x2,0.95], $
                       [x1,0.35,x2,0.68], $
                       [x1,0.05,x2,0.33])


  FOREACH del,delsStr,iDel DO BEGIN

     fileName = filePref + del + fileSuff

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
           dayIntegs[iQuant,iIMF,iDel]   = H2DStrArr[iIMF].grossIntegrals.day
           nightIntegs[iQuant,iIMF,iDel] = H2DStrArr[iIMF].grossIntegrals.night
           totIntegs[iQuant,iIMF,iDel]    = H2DStrArr[iIMF].grossIntegrals.total

        ENDFOREACH

     ENDFOREACH

  ENDFOREACH

  FOR k=0,nQuants-1 DO BEGIN

     dayIntegs[k,*,*]   /= divFacs[k]
     nightIntegs[k,*,*] /= divFacs[k]
     totIntegs[k,*,*]   /= divFacs[k]

  ENDFOR

  ;;NOW PLOTS
  IF KEYWORD_SET(justSaveEmAll) THEN BEGIN
     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY
  ENDIF

  FOREACH IMF,clockStrings,iIMF DO BEGIN

     window    = WINDOW(DIMENSIONS=winDim,BUFFER=justSaveEmAll)
     plotDay   = MAKE_ARRAY(nQuants,/OBJ)
     plotNight = MAKE_ARRAY(nQuants,/OBJ)
     plotTot   = MAKE_ARRAY(nQuants,/OBJ)

     FOREACH quant,quants,iQuant DO BEGIN

        plotDay[iQuant] = PLOT(dels, $
                               dayIntegs[iQuant,iIMF,*], $
                               TITLE=iQuant EQ 0 ? IMF : '', $
                               XTITLE='Delay (min)', $
                               XSHOWTEXT=(iQuant EQ (nQuants-1) ? !NULL : 0), $
                               YTITLE=niceNavn[iQuant], $
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

        plotNight[iQuant] = PLOT(dels, $
                                 nightIntegs[iQuant,iIMF,*], $
                                 NAME=names[1], $
                                 COLOR=cols[1], $
                                 LINESTYLE=lStyles[1], $
                                 THICK=thicks[1], $
                                 ;; LAYOUT=[1,3,iQuant+1], $
                                 POSITION=positionList[iQuant], $
                                 /OVERPLOT)

        plotTot[iQuant] = PLOT(dels, $
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
                     POSITION=[0.3,0.45],/NORMAL)

        IF KEYWORD_SET(justSaveEmAll) THEN BEGIN
           tmpPlotName = plotPref+'INTEGS-'+IMF+'.png'
           PRINT,"Saving " + tmpPlotName + ' ...'
           window.Save,plotDir+tmpPlotName
        ENDIF

        IF KEYWORD_SET(stopEachTime) THEN STOP

        window.close
        OBJ_DESTROY,plotDay,plotNight,plotTot,window

  ENDFOREACH

  STOP
  
END
