;;2016/06/28
PRO JOURNAL__20160628__TEST_LINEAR_RELATIONSHIP_FOR_NIGHTSIDE_DEPOSITION_FROM_ZHANG_2014

  inDir           = '/home/spencerh/Desktop/Spence_paper_drafts/2016/Alfvens_IMF/avg_IMF_conds/'
  inFile          = '20160628--test_linear_relationship_between_nightside_energy_deposition_and_bz_from_Zhang_2014--trimmed.txt'
  asciiTmpltFile  = '20160628--ascii_tmplt--relationship_tween_nightside_energy_dep.sav'
  datFile         = '20160628--data--relationship_tween_nightside_energy_dep.sav'


  ;; ascii_tmplt  = ASCII_TEMPLATE(inDir+inFile)
  ;; RESTORE,inDir+asciiTmpltFile


  ;; zhang        = READ_ASCII(inDir+inFile,TEMPLATE=ascii_tmplt)
  ;; SAVE,zhang,FILENAME=inDir+datFile
  ;; SAVE,ascii_tmplt,FILENAME=inDir+asciiTmpltFile

  RESTORE,inDir+datFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot options
  ;; title           = 'Hemispheric ' + ANSI_VALUE('Alfvénic') + ' Power'

  xTitle          = 'Southward B!Dz!N (nT)'
  yTitle          = 'Integrated ' + ANSI_VALUE('Alfvénic') + 'Power (GW)' 

  ;; xRange          = [-8,0]
  xVal            = ABS(zhang.bzAvg)
  ;; xRange          = [0,8]

  yError          = MAKE_ARRAY(N_ELEMENTS(zhang.bzAvg),VALUE=0,/FLOAT)
  yMin            = ROUND_NTH_SIG_DIGIT(MIN([zhang.dayside_pflux,zhang.nightside_pflux]),1)
  yMax            = ROUND_NTH_SIG_DIGIT(MAX([zhang.dayside_pflux,zhang.nightside_pflux]),2)
  ;; yRange          = [yMin, $
  ;;                    yMax]
  yRange          = [0,1.5e9]/1.0e9

  fontSize        = 18

  sym             = ['D','tu']
  sym_thick       = 2.0
  thick           = 1.0
  transp          = 40
  ;; lineStyle       = ['--','-:']
  lineStyle       = ['-','-']

  eb_cs           = 0.2
  eb_lineStyle    = ['--','-:']

  ;;tdhe plot
  window          = WINDOW(DIMENSIONS=[800,600])
  plotArr         = MAKE_ARRAY(2,/OBJ)
  
  plotArr[0]      = ERRORPLOT(xVal, $
                              zhang.nightside_pFlux/1.0e9, $
                              zhang.bzStdDev, $
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

  plotArr[1]      = ERRORPLOT(xVal, $
                              zhang.dayside_pFlux/1.0e9, $
                              zhang.bzStdDev, $
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

  legend          = LEGEND(TARGET=plotArr[0:-1], $
                           POSITION=[0.4,0.7], $
                           FONT_SIZE=fontSize, $
                           ;; ALIGNMENT=0.5, $
                           ;; VERTICAL_ALIGNMENT=0.5, $
                           /NORMAL)


  window.save,inDir+'Zhang_2014--integrated_hemispheric_power.png'


END