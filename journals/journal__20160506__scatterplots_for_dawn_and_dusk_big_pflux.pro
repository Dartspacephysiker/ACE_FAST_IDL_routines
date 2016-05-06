;2016/05/06
PRO JOURNAL__20160506__SCATTERPLOTS_FOR_DAWN_AND_DUSK_BIG_PFLUX

  do_despunDB = 1 ;this can create a lot of problems

  sTrans   = 40

  dawnOrbs = [3576,3577,3760,10832,12737,12778]
  duskOrbs = [1782,6120,13290]

  dawnFN   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--dawnward_IMF--scatterplots--bigpFlux.png'
  duskFN   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--duskward_IMF--scatterplots--bigpFlux.png'

  dir      = '/home/spencerh/Research/Cusp/ACE_FAST/journals/'
  dawnFile = 'May_5_16--NORTH--avg--1000-4180km--ABSmagc_GE_10--pFlux_GE_10--OMNI--GSM--dawnward__0stable__0.00mindelay__30.00Res__byMax-10.0.sav'
  duskFile = 'May_5_16--NORTH--avg--1000-4180km--ABSmagc_GE_10--pFlux_GE_10--OMNI--GSM--duskward__0stable__0.00mindelay__30.00Res__byMin10.0.sav'

  dawnTit  = 'Poynting flux GE 10, Dawnward IMF (By <= -10)'
  duskTit  = 'Poynting flux GE 10, Duskward IMF (By >= 10)'

  fList    = LIST(dawnFile,duskFile)
  orbList  = LIST(dawnOrbs,duskOrbs)
  outFList = LIST(dawnFN,duskFN)
  titList  = LIST(dawnTit,duskTit)

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF='--scatterplots_for_selected_dawnward_duskward_IMF_orbits'

  FOR i=0,N_ELEMENTS(outFList)-1 DO BEGIN

     color_list = !NULL

     PLOT_FAST_ORBIT_FROM_FASTLOC,orbList[i], $
                                  HEMI='NORTH', $
                                  /ADD_LINE, $
                                  /NO_SYMBOL, $
                                  OUT_MAP=map, $
                                  OUT_COLOR_LIST=color_list, $
                                  OUT_WINDOW=window
     
     
     PRINT,'Restoring ' + fList[i] + '...'
     RESTORE,dir+fList[i]
     
     temp_orbStrArrList  = LIST()
     FOR j=0,N_ELEMENTS(orbStrArr_list[0])-1 DO BEGIN
        test_orbStr      = orbStrArr_list[0,j]
        tmp_orbStrArr_i  = WHERE(orbList[i] EQ test_orbStr.orbit)
        IF tmp_orbStrArr_i[0] NE -1 THEN BEGIN
           temp_orbStrArrList.add,test_orbStr
        ENDIF
     ENDFOR

     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus, $
                                DO_DESPUNDB=do_despunDB, $
                                HEMI=hemi, $
                                OVERLAYAURZONE=overlayAurZone, $
                                /ADD_ORBIT_LEGEND, $
                                CENTERLON=centerLon, $
                                /OVERPLOT, $
                                IN_ORBSTRARR_LIST=temp_orbStrArrList, $
                                LAYOUT=layout, $
                                PLOTPOSITION=plotPosition, $
                                OUT_PLOT=out_plot, $
                                IN_MAP=map, $
                                CURRENT_WINDOW=window, $
                                PLOTSUFF=plotSuff, $
                                DBFILE=dbFile, $
                                COLOR_LIST=color_list, $
                                STRANS=sTrans, $
                                /SAVEPLOT, $
                                SPNAME=outFList[i], $
                                PLOTDIR=plotDir, $
                                /CLOSE_AFTER_SAVE, $
                                OUTPUT_ORBIT_DETAILS=output_orbit_details, $
                                OUT_ORBSTRARR_LIST=out_orbStrArr_list, $
                                PLOTTITLE=titList[i], $
                                _EXTRA = e
     
     
  ENDFOR


END