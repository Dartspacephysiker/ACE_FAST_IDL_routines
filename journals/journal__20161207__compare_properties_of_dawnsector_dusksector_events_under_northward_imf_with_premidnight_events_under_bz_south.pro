;;12/07/16
PRO JOURNAL__20161207__COMPARE_PROPERTIES_OF_DAWNSECTOR_DUSKSECTOR_EVENTS_UNDER_NORTHWARD_IMF_WITH_PREMIDNIGHT_EVENTS_UNDER_BZ_SOUTH, $
   POSTSCRIPT=PS

  COMPILE_OPT IDL2

  journal_name = 'JOURNAL__20161207__COMPARE_PROPERTIES_OF_DAWNSECTOR_DUSKSECTOR'

  indDir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/'
  indFile = '20161207--OMNI_FAST--indices.sav' 

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,/NO_MEMORY_LOAD
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,/NO_MEMORY_LOAD

  RESTORE,indDir+indFile

  IF (COMPARE_STRUCT(maximus.info,indsinfo.alfdb)).nDiff NE 0 THEN BEGIN
     PRINT,"WHAAAAAAATTTJJTJTJDSJDLTJSDLTK:JSTD JKLSD: LKJS"
     STOP
  ENDIF

  IF (COMPARE_STRUCT(fastLoc.info,indsinfo.fastLoc)).nDiff NE 0 THEN BEGIN
     PRINT,"WHAAAAAAATTTJJTJTJDSJDLTJSDLTK:JSTD JKLSD: LKJS"
     STOP
  ENDIF

  ;;The setup
  paramStrs      = LIST_TO_1DARRAY(out_paramstring_list)
  combInd_list   = LIST()
  nGot_list      = LIST()
  nTot_list      = LIST()
  clockStr_list  = LIST(['dawn-north','bzNorth','dusk-north'],['dawn-south','bzSouth','dusk-south'])

  regionName     = ['northIMF-dawnSector','southIMF-midnight']
  minM           = [ 6,-3]
  maxM           = [10, 1]

  minI           = [74,66]
  maxI           = [80,72]

  tHemiArr       = ['NORTH','SOUTH','BOTH']
  FOR k=0,N_ELEMENTS(tHemiArr)-1 DO BEGIN
     test           = STRPOS(STRUPCASE(paramStrs),'-'+tHemiArr[k])
     IF (WHERE(test GE 0))[0] NE -1 THEN BEGIN
        hemi     = tHemiArr[k]
        PRINT,"Got it: ",tHemiArr[k]
        BREAK
     ENDIF
  ENDFOR

  nSitiation     = N_ELEMENTS(clockStr_list)
  FOR k=0,nSitiation-1 DO BEGIN

     tmpClockStrs = clockStr_list[k]
     tmpNClock    = N_ELEMENTS(tmpClockStrs)

     tmp_i        = !NULL
     nGot         = !NULL
     nTot         = 0
     FOR l=0,tmpNClock-1 DO BEGIN
        tmpLoc   = STRPOS(STRUPCASE(paramStrs),STRUPCASE(tmpClockStrs[l]))
        clockInd = WHERE(tmpLoc GE 0,nClockInd)
        CASE nClockInd OF
           0: BEGIN
              PRINT,"Found no matches!"
              STOP
           END
           1: BEGIN
              tmp_i = [tmp_i,(out_plot_i_list[clockInd])[0]]
              nGot  = [nGot,N_ELEMENTS((out_plot_i_list[clockInd])[0])]
              nTot += nGot[-1]
              PRINT,FORMAT='("Loop ",I2,": Picked up ",I10," inds from out_plot_i_list for ",A10," IMF")', $
                    k,nGot[-1],tmpClockStrs[l]
           END
           ELSE: BEGIN
              PRINT,"Too many ..."
              STOP
           END
        ENDCASE

     ENDFOR
     PRINT,FORMAT='("Got ",I8," inds total for configuration #",I0)',nTot,k

     nTot_list.Add,TEMPORARY(nTot)
     nGot_list.Add,TEMPORARY(nGot)

     ;;Get MLT and ILAT restrictions
     mlt_i    = GET_MLT_INDS (maximus,minM[k],maxM[k])
     ilat_i   = GET_ILAT_INDS(maximus,minI[k],maxI[k],hemi)

     ;;Now combine
     region_i = CGSETINTERSECTION(mlt_i,ilat_i,NORESULT=-1,COUNT=nRegion)
     IF nRegion EQ 0 THEN STOP
     region_i = CGSETINTERSECTION(region_i,tmp_i,NORESULT=-1,COUNT=nRegion)
     IF nRegion EQ 0 THEN STOP
     PRINT,FORMAT='(A20," N inds: ",I0)',regionName[k],nRegion

     combInd_list.Add,TEMPORARY(region_i)
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plots
  plotType                         = 'window'
  IF KEYWORD_SET(PS) THEN plotType = 'PS'

  maxInd      = [[3:24],49,50]
  maxInd      = REFORM(maxInd,2,N_ELEMENTS(maxInd)/2)

  tmp         = maxInd[0,8]
  maxInd[0,8] = maxInd[0,4]
  maxInd[0,4] = tmp

  ;;swap width_x and delta_e
  tmp          = maxInd[0,10]
  maxInd[0,10] = maxInd[0,9]
  maxInd[0,9]  = tmp

  ;;swap ilat and pfluxest
  tmp          = maxInd[0, 1]
  maxInd[0,1]  = maxInd[0,11]
  maxInd[0,11] = tmp

  ;;swap elec_energy_flux and lshell
  tmp           = maxInd[1,1]
  maxInd[1,1]   = maxInd[1,2]
  maxInd[1,2]   = tmp

  doubleLoop = (TAG_NAMES(maximus))[maxInd]
  nDouble    = (plotType EQ 'PS' ? N_ELEMENTS(maxInd)/2 : 1)

  logMe    = BYTE(maxInd)
  logMe[*] = 0B

                                ;   0 ALT MLT
  logMe[*, 1] = 1B              ;   1 ILAT MAG_CURRENT
  logMe[*, 2] = 1B              ;   2 ESA_CURRENT ELEC_ENERGY_FLUX
  logMe[*, 3] = 1B              ;   3 INTEG_ELEC_ENERGY_FLUX EFLUX_LOSSCONE_INTEG
  logMe[*, 4] = 1B              ;   4 TOTAL_EFLUX_INTEG MAX_CHARE_LOSSCONE
  logMe[*, 5] = 1B              ;   5 MAX_CHARE_TOTAL ION_ENERGY_FLUX
  logMe[*, 6] = 1B              ;   6 ION_FLUX ION_FLUX_UP
  logMe[*, 7] = 1B              ;   7 INTEG_ION_FLUX INTEG_ION_FLUX_UP
  logMe[*, 8] = 1B              ;   8 CHAR_ION_ENERGY WIDTH_TIME
  logMe[*, 9] = 1B              ;   9 WIDTH_X DELTA_B
  logMe[*,10] = 1B              ;  10 DELTA_E SAMPLE_T

  FOR l=0,nDouble-1 DO BEGIN

     !P.MULTI = [0,2,2,0,0]
     CASE STRUPCASE(plotType) OF
        'PS': BEGIN
           SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF='/'+journal_name
           charSize = 0.8
           binSize  = 0.025
           plotName = STRING(FORMAT='(A0,"-",A0)',doubleloop[0,l],doubleloop[1,l])
           POPEN,plotDir+journal_name+'--'+plotName,XSIZE=7,YSIZE=7
        END
        ELSE: BEGIN
           WINDOW,0,XSIZE=800,YSIZE=800
        END
     ENDCASE

     FOR k=0,nSitiation-1 DO BEGIN
        
        IF logMe[0,l] THEN BEGIN
           tmpDat1  = ALOG10((maximus.(maxInd[0,l]))[combInd_list[k]])
           binSize1 = binSize
           title1   = 'LOG(' + doubleloop[0,l] + ') in ' + regionName[k]
        ENDIF ELSE BEGIN
           tmpDat1  = (maximus.(maxInd[0,l]))[combInd_list[k]]
           binSize1 = !NULL
           title1   = doubleloop[0,l] + ' in ' + regionName[k]
        ENDELSE

        IF logMe[1,l] THEN BEGIN
           tmpDat2  = ALOG10((maximus.(maxInd[1,l]))[combInd_list[k]])
           binSize2 = binSize
           title2   = 'LOG(' + doubleloop[1,l] + ') ' 
        ENDIF ELSE BEGIN
           tmpDat2  = (maximus.(maxInd[1,l]))[combInd_list[k]]
           binSize2 = !NULL
           title2   = doubleloop[1,l] 
        ENDELSE

        CGHISTOPLOT,tmpDat1, $
                    TITLE=title1, $
                    ;; TITLE='LOG(' + doubleloop[0,l] + ') in ' + regionName[k], $
                    CHARSIZE=charSize, $
                    BINSIZE=binSize1
        CGHISTOPLOT,tmpDat2, $
                    TITLE=title2, $
                    CHARSIZE=charSize, $
                    BINSIZE=binSize2

     ENDFOR

     CASE STRUPCASE(plotType) OF
        'PS': BEGIN
           PCLOSE
        END
        ELSE: BEGIN
        END
     ENDCASE

  ENDFOR

  STOP
END
