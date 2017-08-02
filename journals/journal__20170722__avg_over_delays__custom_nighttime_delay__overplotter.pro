;2017/07/19
PRO AVERAGE_H2DSTRUCTS_OVER_DELAYS,QUANTS=quants, $
                                   STABLEIMFSTRING=stableIMFString, $
                                   AVGSTRING=avgString, $
                                   BTMINSTR=btMinStr, $
                                   DELS=dels, $
                                   NDELAY=nDelay, $
                                   FINALDELSTR=finalDelStr, $
                                   ADDNIGHTSTR=addNightStr, $
                                   ORBRANGE=orbRange, $
                                   ALTITUDERANGE=altitudeRange, $
                                   DBSTR=dbStr, $
                                   PREFPREF=prefPref, $
                                   ANCILLARYSTR=ancillaryStr, $
                                   ORBPREF=orbPref, $
                                   KMPREF=kmPref, $
                                   CONFIGFILEDELAY=configFileDelay, $
                                   OUT_CONFFILEPREF=configFilePref, $
                                   FILEDIR=fileDir, $
                                   OUT_CONFIGFILE=configFile, $
                                   OUT_PARAMSTRINGPREF=paramStringPref, $
                                   OUT_TEMPFILEPREF=tempFilePref, $
                                   H2DAVGARR_LIST=H2DAvgArr_list, $
                                   H2DAVGMASKARR_LIST=H2DAvgMaskArr_list, $
                                   DATANAMEARR_LIST=DataNameArr_list, $
                                   SAVE_COOLFILES=save_coolFiles, $
                                   COOLFILE_LIST=coolFile_list, $
                                   OUT_CENTERSMLT=centersMLT, $
                                   OUT_CENTERSILAT=centersILAT, $
                                   CHECKOUTINDS=checkOutInds, $
                                   CHECKOUT_ESPECKERS=eSpeckers, $
                                   CHECKOUT_ALFDB=alfDB, $
                                   GETFILE_WITH_NIGHTDELAY=getfile_with_nightdelay, $
                                   USE_NEVENTS_NOT_NDELAY_FOR_DENOM=use_nEvents_not_nDelay_for_denom, $
                                   USE_AACGM=use_AACGM, $
                                   _EXTRA=e

  orbStr          = STRING(FORMAT='(A0,I0,"-",I0)',orbPref,orbRange[0],orbRange[1])
  altStr          = STRING(FORMAT='(I0,"-",I0,A0)',altitudeRange[0],altitudeRange[1],kmPref)

  superSuff = ''
  IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN
     superSuff += '-nEvDiv'
  ENDIF     

  hemi         = 'NORTH'
  IF KEYWORD_SET(use_AACGM) THEN hemi += '_AACGM'

  configFilePref = 'multi_PASIS_vars-' + dbStr + prefPref + $
                    altStr +  orbStr + '-' + hemi + '-' + $
                   ancillaryStr + avgString + $
                   '_' + stableIMFString + 'stable'
  filePref     = 'polarplots_' + prefPref +  $
                 altStr +  orbStr + '-' + hemi + '-' + $
                 ancillaryStr + avgString + $
                 '_' + stableIMFString + 'stable'
  fileSuff     = btMinStr + '-Ring'
  
  paramStringPref = filePref + finalDelStr + fileSuff + superSuff
  tempFilePref = fileDir + filePref + finalDelStr + fileSuff

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  nIMFOrient   = N_ELEMENTS(clockStrings)

  ;;Get configfile to make template array thing
  IF N_ELEMENTS(configFileDelay) EQ 0 THEN BEGIN
     configFileDelay = dels[0]
  ENDIF
  tmpDelayStr = STRING(FORMAT='("_",F0.1,"Del")',configFileDelay/60.) + addNightStr

  configFile = configFilePref + tmpDelayStr + fileSuff + '.sav'
  IF FILE_TEST(fileDir+configFile) THEN BEGIN
     RESTORE,fileDir+configFile
  ENDIF ELSE STOP

  ;; PASIS__MIMC_struct.binM = 0.75
  ;; PASIS__MIMC_struct.shiftM = 0.0
  ;; PASIS__MIMC_struct.binI = 2.0
  
  GET_H2D_BIN_AREAS,h2dAreas, $
                    CENTERS1=centersMLT, $
                    CENTERS2=centersILAT, $
                    BINSIZE1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.binLng : PASIS__MIMC_struct.binM*15.), $
                    BINSIZE2=PASIS__MIMC_struct.binI, $
                    MAX1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.maxLng : PASIS__MIMC_struct.maxM*15.), $
                    MAX2=PASIS__MIMC_struct.maxI, $
                    MIN1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.minLng : PASIS__MIMC_struct.minM*15.), $
                    MIN2=PASIS__MIMC_struct.minI, $
                    SHIFT1=(KEYWORD_SET(PASIS__MIMC_struct.use_Lng) ? PASIS__MIMC_struct.shiftLng : PASIS__MIMC_struct.shiftM*15.), $
                    SHIFT2=shiftI, $
                    EQUAL_AREA_BINNING=PASIS__alfDB_plot_struct.EA_binning
  ;; centersMLT /= 15.

  dayH2DInds     = WHERE(centersMLT GE 6*15.  AND centersMLT LT 18*15., $
                      nDayH2DInds, $
                      COMPLEMENT=nightH2DInds,NCOMPLEMENT=nNightH2DInds)

  ;;Get dayfile (and possibly custom nightfile),
  H2DAvgArr_list  = LIST()
  H2DAvgMaskArr_list = LIST()
  DataNameArr_list = LIST()
  IF KEYWORD_SET(save_coolFiles) THEN BEGIN
     coolFile_list = LIST()
  ENDIF
  FOREACH quant,quants,iQuant DO BEGIN

     FOREACH delay,dels,iDel DO BEGIN

        IF KEYWORD_SET(getfile_with_nightdelay) THEN BEGIN

           dayDelayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) + addNightStr
           nitDelayStr = STRING(FORMAT='("_",F0.1,"Del")',(delay+getfile_with_nightdelay)/60.) + addNightStr
           dayFile     = filePref + dayDelayStr + fileSuff
           nitFile     = filePref + nitDelayStr + fileSuff

           ;;Need these later
           delayStr    = dayDelayStr ;need this later
           fileName    = dayFile

           PRINT,"Day   file: ",dayFile + quant
           PRINT,"Night file: ",nitFile + quant
           
           IF FILE_TEST(fileDir+dayFile+quant + '.dat') THEN BEGIN
              RESTORE,fileDir+dayFile+quant + '.dat'
           ENDIF ELSE STOP

           dayH2DStrArr  = TEMPORARY(H2DStrArr)
           dayH2DMaskArr = TEMPORARY(H2DMaskArr)

           IF FILE_TEST(fileDir+nitFile+quant + '.dat') THEN BEGIN
              RESTORE,fileDir+nitFile+quant + '.dat'
           ENDIF ELSE STOP

           IF N_ELEMENTS(dayH2DStrArr) NE N_ELEMENTS(H2DStrArr) OR $
              N_ELEMENTS(dayH2DStrArr[0].data) NE N_ELEMENTS(H2DStrArr[0].data) THEN STOP

           FOR k=0,N_ELEMENTS(H2DStrArr)-1 DO BEGIN
              H2DStrArr[k].data[dayH2DInds]     = dayH2DStrArr[k].data[dayH2DInds]
              H2DMaskArr[k].data[dayH2DInds]    = dayH2DMaskArr[k].data[dayH2DInds]

              H2DStrArr[k].grossIntegrals.day   = dayH2DStrArr[k].grossIntegrals.day
              H2DStrArr[k].grossIntegrals.total = H2DStrArr[k].grossIntegrals.day + H2DStrArr[k].grossIntegrals.night
           ENDFOR

        ENDIF ELSE BEGIN

           delayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) + addNightStr
           fileName = filePref + delayStr + fileSuff
           PRINT,fileName + quant
           
           IF FILE_TEST(fileDir+fileName+quant + '.dat') THEN BEGIN
              RESTORE,fileDir+fileName+quant + '.dat'
           ENDIF ELSE STOP

        ENDELSE
        
        IF N_ELEMENTS(H2DStrArr[0].data) NE N_ELEMENTS(h2dAreas) THEN STOP

        IF iDel EQ 0 THEN BEGIN
           H2DAvgArr = H2DStrArr
           H2DAvgMaskArr = H2DMaskArr

           CASE 1 OF
              KEYWORD_SET(use_nEvents_not_nDelay_for_denom): BEGIN
                 H2DDivFacArr = REPLICATE({data:LONG(H2DMaskArr[0].data*0)},N_ELEMENTS(H2DAvgMaskArr))
              END
              ELSE: BEGIN
                 H2DDivFacArr = nDelay
              END
           ENDCASE

           FOR k=0,N_ELEMENTS(H2DAvgArr)-1 DO BEGIN

              H2DAvgArr[k].data = 0
              H2DAvgArr[k].grossIntegrals.day   = 0
              H2DAvgArr[k].grossIntegrals.night = 0
              H2DAvgArr[k].grossIntegrals.total = 0
              H2DAvgArr[k].grossIntegrals.custom[0] = 0
              H2DAvgArr[k].grossIntegrals.custom[1] = 0
              H2DAvgMaskArr[k].data = 255

           ENDFOR

        ENDIF

        FOREACH IMF,clockStrings,iIMF DO BEGIN

           ;;;ALDER

           ;; H2DAvgArr[iIMF].data                 += H2DStrArr[iIMF].data/nDelay
           ;; H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day/nDelay
           ;; H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night/nDelay
           ;; H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total/nDelay
           ;; H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]/nDelay
           ;; H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]/nDelay

           ;; H2DAvgMaskArr[iIMF].data = H2DAvgMaskArr[iIMF].data AND H2DMaskArr[iIMF].data

           ;;NYERE
           IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN

              H2DDivFacArr[iIMF].data += (H2DMaskArr[iIMF].data EQ 0.0)

              IF N_ELEMENTS(H2DStrArr[iIMF].data) NE N_ELEMENTS(H2DAvgArr[iIMF].data) THEN STOP

              H2DAvgArr[iIMF].data                 += H2DStrArr[iIMF].data
              H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day
              H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night
              H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total
              H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]
              H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]

           ENDIF ELSE BEGIN

              IF N_ELEMENTS(H2DStrArr[iIMF].data) NE N_ELEMENTS(H2DAvgArr[iIMF].data) THEN STOP
              
              H2DAvgArr[iIMF].data                 += H2DStrArr[iIMF].data/nDelay
              H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day/nDelay
              H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night/nDelay
              H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total/nDelay
              H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]/nDelay
              H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]/nDelay

           ENDELSE

           H2DAvgMaskArr[iIMF].data[WHERE( ( H2DAvgArr[iIMF].data GT 0.D )                                   OR $
                                           ( (H2DStrArr[iIMF].data GT 0.D) AND FINITE(H2DStrArr[iIMF].data)) )] = 0.

        ENDFOREACH

     ENDFOREACH

     IF KEYWORD_SET(use_nEvents_not_nDelay_for_denom) THEN BEGIN

        FOREACH IMF,clockStrings,iIMF DO BEGIN
           
           theseInds = WHERE(H2DDivFacArr[iIMF].data NE 0.D)
           
           H2DAvgArr[iIMF].data[theseInds] /= H2DDivFacArr[iIMF].data[theseInds]

           ;; H2DAvgMaskArr[iIMF].data = 

        ENDFOREACH

     ENDIF

     IF KEYWORD_SET(save_coolFiles) THEN BEGIN
        H2DStrArr  = H2DAvgArr
        H2DMaskArr = H2DAvgMaskArr
        tempFile   = filePref + finalDelStr + fileSuff + quant + '.dat'
        PRINT,"Saving to " + tempFile + ' ...'

        SAVE_ALFVENDB_TEMPDATA,TEMPFILE=fileDir+tempFile, $
                               H2DSTRARR=h2dStrArr, $
                               DATANAMEARR=dataNameArr,$
                               H2DMASKARR=h2dMaskArr, $
                               MAXM=PASIS__MIMC_struct.maxM, $
                               MINM=PASIS__MIMC_struct.minM, $
                               MAXI=PASIS__MIMC_struct.maxI, $
                               MINI=PASIS__MIMC_struct.minI, $
                               BINM=PASIS__MIMC_struct.binM, $
                               SHIFTM=PASIS__MIMC_struct.shiftM, $
                               BINI=PASIS__MIMC_struct.binI, $
                               DO_LSHELL=PASIS__MIMC_struct.do_lShell, $
                               REVERSE_LSHELL=PASIS__MIMC_struct.reverse_lShell,$
                               MINL=PASIS__MIMC_struct.minL, $
                               MAXL=PASIS__MIMC_struct.maxL, $
                               BINL=PASIS__MIMC_struct.binL,$
                               SAVEDIR=saveDir, $
                               PARAMSTR=paramString,$
                               CLOCKSTR=clockStr, $
                               PLOTMEDORAVG=plotMedOrAvg, $
                               STABLEIMF=PASIS__IMF_struct.stableIMF, $
                               HOYDIA=hoyDia, $
                               HEMI=hemi, $
                               OUT_TEMPFILE=out_tempFile

        coolFile_list.Add,tempFile
     ENDIF

     H2DAvgArr_list.Add,TEMPORARY(H2DAvgArr)
     H2DAvgMaskArr_list.Add,TEMPORARY(H2DAvgMaskArr)
     DataNameArr_list.Add,TEMPORARY(dataNameArr)

  ENDFOREACH

  IF KEYWORD_SET(checkOutInds) THEN BEGIN

     ;; LOAD_NEWELL_ESPEC_DB,eSpec,/NO_MEMORY_LOAD

     ;; mlts = (TEMPORARY(eSpec)).mlt
     CASE 1 OF
        KEYWORD_SET(eSpeckers): BEGIN

           dirDir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
           mltFile = 'espec_mlts.sav'
           typesFile = 'espec_types.sav'
           RESTORE,dirDir+mltFile
           RESTORE,dirDir+typesFile

           broads = WHERE((types.broad EQ 1) OR (types.broad EQ 2),nBroad)
           diffs  = WHERE(types.diffuse EQ 1,nDiffuse)
           monos  = WHERE(types.mono EQ 1 OR types.mono EQ 2,nDiffuse)
           
           myFile = 'eSpec_uniqInds_CHECK_BECAUSEYOUHAVENTYET.sav'

           IF FILE_TEST(dirDir+myFile) THEN BEGIN

              RESTORE,dirDir+myFile
              
              SKIPTHATBRO = 1
           ENDIF

        END        
        ELSE: BEGIN

           dirDir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
           myFile  = 'alfDB_uniqInds_CHECK_BECAUSEYOUHAVENTYET.sav'

           IF FILE_TEST(dirDir+myFile) THEN BEGIN

              RESTORE,dirDir+myFile

              SKIPTHATBRO = 1

              STOP
              
           ENDIF ELSE BEGIN
              
           @common__maximus_vars.pro
           IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
              LOAD_MAXIMUS_AND_CDBTIME
           ENDIF
           mlts = MAXIMUS__maximus.mlt

        ENDELSE

        END
     ENDCASE

     IF ~KEYWORD_SET(SKIPTHATBRO) THEN BEGIN

        allDayInds = WHERE(mlts GE 6  AND mlts LT 18, $
                           nAllDayInds, $
                           COMPLEMENT=allNightInds,NCOMPLEMENT=nAllNightInds)
        allCuspInds = WHERE(mlts GE 9.5  AND mlts LT 14.5, $
                           nAllCuspInds, $
                           COMPLEMENT=allNotCuspInds,NCOMPLEMENT=nAllNotCuspInds)
   
        dayIndsList = LIST()
        nitIndsList = LIST()
        FOREACH delay,dels,iDel DO BEGIN
   
           PRINT,"Delay ind: ",STRING(FORMAT='(I0,"/",I0)',iDel,N_ELEMENTS(dels)-1)
   
           FOREACH IMF,clockStrings,iIMF DO BEGIN
   
              IF KEYWORD_SET(getfile_with_nightdelay) THEN BEGIN
   
                 dayDelayStr = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) + addNightStr
                 nitDelayStr = STRING(FORMAT='("_",F0.1,"Del")',(delay+getfile_with_nightdelay)/60.) + addNightStr
   
                 dayConfigFile = configFilePref + dayDelayStr + fileSuff + '.sav'
                 IF FILE_TEST(fileDir+dayConfigFile) THEN BEGIN
                    RESTORE,fileDir+dayConfigFile
                 ENDIF ELSE STOP
   
                 CASE 1 OF
                    KEYWORD_SET(eSpeckers): BEGIN
                       theList = PASIS__indices__eSpec_list
                    END
                    KEYWORD_SET(alfDB): BEGIN
                       theList = PASIS__plot_i_list
                    END
                 ENDCASE
   
                 IF iDel EQ 0 THEN BEGIN
                    dayIndsList.Add,CGSETINTERSECTION(theList[iIMF],allDayInds)
                 ENDIF ELSE BEGIN
                    dayIndsList[iIMF] = CGSETUNION(dayIndsList[iIMF],CGSETINTERSECTION(allDayInds,theList[iIMF]))
                 ENDELSE
   
                 nitConfigFile = configFilePref + nitDelayStr + fileSuff + '.sav'
                 IF FILE_TEST(fileDir+nitConfigFile) THEN BEGIN
                    RESTORE,fileDir+nitConfigFile
                 ENDIF ELSE STOP
   
                 CASE 1 OF
                    KEYWORD_SET(eSpeckers): BEGIN
                       theList = PASIS__indices__eSpec_list
                    END
                    KEYWORD_SET(alfDB): BEGIN
                       theList = PASIS__plot_i_list
                    END
                 ENDCASE
   
                 IF iDel EQ 0 THEN BEGIN
                    nitIndsList.Add,CGSETINTERSECTION(theList[iIMF],allNightInds)
                 ENDIF ELSE BEGIN
                    nitIndsList[iIMF] = CGSETUNION(nitIndsList[iIMF],CGSETINTERSECTION(allNightInds,theList[iIMF]))
                 ENDELSE
   
              ENDIF ELSE BEGIN
   
                 STOP
   
              ENDELSE
              
           ENDFOREACH
   
        ENDFOREACH
   
     ENDIF

     PRINT,"Spence, check out these inds. Are they qualité? Do you need to spend a little extra time doing this and that?"
     CASE 1 OF
        KEYWORD_SET(eSpeckers): BEGIN
           
           totIndsList = LIST()
           broadIndsList = LIST()
           diffIndsList = LIST()
           FOR k=0,N_ELEMENTS(dayIndsList)-1 DO BEGIN
              totIndsList.Add,CGSETUNION(dayIndsList[k],nitIndsList[k],COUNT=nHjar)
              broadIndsList.Add,CGSETINTERSECTION(totIndsList[k],broads,COUNT=nBroadHjar)
              diffIndsList.Add,CGSETINTERSECTION(totIndsList[k],diffs,COUNT=nDiffHjar)
              PRINT,k,", ",nHjar,", ",nBroadHjar,", ",nDiffHjar
           ENDFOR
        END
        ELSE: BEGIN

           allAccelInds = WHERE(MAXIMUS__maximus.max_chare_losscone GE 80, $
                               nAllAccelInds, $
                               COMPLEMENT=allNotAccelInds,NCOMPLEMENT=nAllNotAccelInds)

           totIndsList              = LIST()
           accelIndsList            = LIST()
           cuspAccelIndsList        = LIST()
           cuspNotAccelIndsList     = LIST()
           notCuspAccelIndsList     = LIST()
           notCuspNotAccelIndsList  = LIST()
           FOR k=0,N_ELEMENTS(dayIndsList)-1 DO BEGIN
              totIndsList.Add,CGSETUNION(dayIndsList[k],nitIndsList[k],COUNT=nHjar)
              PRINT,k,", ",nHjar,", "

              cuspAccelIndsList.Add      ,CGSETINTERSECTION(CGSETINTERSECTION(totIndsList[k],allCuspInds),allAccelInds)
              cuspNotAccelIndsList.Add   ,CGSETINTERSECTION(CGSETINTERSECTION(totIndsList[k],allCuspInds),allNotAccelInds)
              notCuspAccelIndsList.Add   ,CGSETINTERSECTION(CGSETINTERSECTION(totIndsList[k],allNotCuspInds),allAccelInds)
              notCuspNotAccelIndsList.Add,CGSETINTERSECTION(CGSETINTERSECTION(totIndsList[k],allNotCuspInds),allNotAccelInds)
           ENDFOR

           PRINT,FORMAT='(A0,T20,A0,T40,A0,T60,A0,T80,A0)', $
                 "cuspAccel","cuspNotAccel","notCuspAccel","notCuspNotAccel","Tot (says dayInds)"

           FOR k=0,N_ELEMENTS(dayIndsList)-1 DO BEGIN
              PRINT,FORMAT='(I0,T20,I0,T40,I0,T60,I0,T80,I0," (",I0,")")', $
                    N_ELEMENTS(cuspAccelIndsList[k])      , $
                    N_ELEMENTS(cuspNotAccelIndsList[k])   , $
                    N_ELEMENTS(notCuspAccelIndsList[k])   , $
                    N_ELEMENTS(notCuspNotAccelIndsList[k]), $
                    N_ELEMENTS(cuspAccelIndsList[k])      + $
                    N_ELEMENTS(cuspNotAccelIndsList[k])   + $
                    N_ELEMENTS(notCuspAccelIndsList[k])   + $
                    N_ELEMENTS(notCuspNotAccelIndsList[k]), $
                    N_ELEMENTS(totIndsList[k])
              
           ENDFOR

           totallguys = LIST_TO_1DARRAY(totIndsList,/SORT,/WARN,/SKIP_NANS,/SKIP_NEG1_ELEMENTS)
           totallguys = totallguys[UNIQ(totallguys,SORT(totAllGuys))]
           ntotAll    = N_ELEMENTS(totAllGuys)

           cuspAccelInds           = CGSETINTERSECTION(CGSETINTERSECTION(totAllGuys,allCuspInds),allAccelInds)
           cuspNotAccelInds        = CGSETINTERSECTION(CGSETINTERSECTION(totAllGuys,allCuspInds),allNotAccelInds)
           notCuspAccelInds        = CGSETINTERSECTION(CGSETINTERSECTION(totAllGuys,allNotCuspInds),allAccelInds)
           notCuspNotAccelInds     = CGSETINTERSECTION(CGSETINTERSECTION(totAllGuys,allNotCuspInds),allNotAccelInds)
           
              PRINT,FORMAT='(I0,T20,I0,T40,I0,T60,I0,T80,I0," (",I0,")")', $
                    N_ELEMENTS(cuspAccelInds)      , $
                    N_ELEMENTS(cuspNotAccelInds)   , $
                    N_ELEMENTS(notCuspAccelInds)   , $
                    N_ELEMENTS(notCuspNotAccelInds), $
                    N_ELEMENTS(cuspAccelInds)      + $
                    N_ELEMENTS(cuspNotAccelInds)   + $
                    N_ELEMENTS(notCuspAccelInds)   + $
                    N_ELEMENTS(notCuspNotAccelInds), $
                    N_ELEMENTS(totAllGuys)


        ENDELSE
     ENDCASE

     CASE 1 OF
        KEYWORD_SET(eSpeckers): BEGIN

           eSpec_totIndsList = totIndsList
           SAVE,eSpec_totIndsList,broadIndsList,diffIndsList,dayIndsList,nitIndsList, $
                FILENAME=dirDir + myFile
        END
        ELSE: BEGIN
           SAVE,totindslist,accelindslist,cuspaccelindslist, $
                cuspnotaccelindslist,notcuspaccelindslist,notcuspnotaccelindslist, $
                dayIndsList,nitIndsList, $
                totallguys, $
                FILENAME=dirdir+myfile
        END
     ENDCASE


     STOP

  ENDIF

END

PRO JOURNAL__20170722__AVG_OVER_DELAYS__CUSTOM_NIGHTTIME_DELAY__OVERPLOTTER

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__overplot_vars.pro

  eSpeckers             = 1 ;DON'T set this if you only want to do overplotting
  eSpeck_numFl          = 1
  eSpeck_eFlux          = 0
  checkOutInds          = 1
  checkOut_alfDB        = 0
  checkOut_eSpeckers    = 1

  doBroadAndNC          = 0
  doDiffAndInvNC        = 0
  checkoutAllPF         = 1

  overplot_pFlux        = 1
  OP_checkOutInds       = 1

  plotH2D_contour       = 1

  use_AACGM             = 1

  use_nEvents_not_nDelay_for_denom = 1

  save_coolFiles           = 1
  makePlots                = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Who are you going to overplot with whom?
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  CASE 1 OF
     KEYWORD_SET(doBroadAndNC): BEGIN
        myQuants              = '_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_broad'
        OP_quants             = '_tAvgd_pF_pF'
        OP_ancillaryStr       = 'cur_-1-1-NC-'
        plotPref              = 'NC_pF_overlaid-'
        contour__levels       = KEYWORD_SET(plotH2D_contour) ? [0,20,40,60,80,100] : !NULL
        contour__percent      = KEYWORD_SET(plotH2D_contour) ? 1 : !NULL
        ;; contour__nColors   = 8
        contour__CTBottom     = 0
        contour__CTIndex      = -49
        gridColor             = 'gray'
     END
     KEYWORD_SET(doDiffAndInvNC): BEGIN
        myQuants              = '_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_diff'
        OP_quants             = '_tAvgd_pF_pF'
        OP_ancillaryStr       = 'cur_-1-1-invNC-'
        plotPref              = 'invNC_pF_overlaid-'
        contour__levels       = KEYWORD_SET(plotH2D_contour) ? [0,25,50,75,100] : !NULL
        contour__percent      = KEYWORD_SET(plotH2D_contour) ? 1 : !NULL
        contour__nColors      = 8
        contour__CTBottom     = 0
        contour__CTIndex      = -60
     END
     KEYWORD_SET(checkoutAllPF): BEGIN
  ;; For reguree pFlux, checking out inds
        myQuants              = '_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_broad'
        OP_quants             = '_tAvgd_pF_pF'
        OP_ancillaryStr       = 'cur_-1-1-'
        plotPref              = 'pF_overlaid-'
        contour__levels       = KEYWORD_SET(plotH2D_contour) ? [0,25,50,75,100] : !NULL
        contour__percent      = KEYWORD_SET(plotH2D_contour) ? 1 : !NULL
        contour__nColors      = 8
        contour__CTBottom     = 0
        contour__CTIndex      = -60
     END
  ENDCASE

  finalDelOnplotPref       = 1

  orbRange                 = [500,12670]
  altitudeRange            = [300,4300]

  ;;Which files??
  DstCutoff                = -25
  stableIMFString          = '14'

  stepEvery1               = 1B
  startDel                 = -5
  stopDel                  = 40
  add_nightDelay           = 50
  dels                     = [startDel:stopDel:(KEYWORD_SET(stepEvery1) ? 1 : 5)]*60
  configFileDelay          = 0*60

  btMin                    = 1.0

  show_integrals           = 0

  ;;Plot options
  plotH2D__kde             = KEYWORD_SET(plotH2D_contour)

  IF KEYWORD_SET(plotH2D_contour) THEN BEGIN
     plotPref += 'cont-'
  ENDIF
  IF KEYWORD_SET(plotH2D__kde) THEN BEGIN
     plotPref += 'kde-'
  ENDIF

  ;;OVERPLOT OPTIONS
  op_dir                   = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'

  ;; overplot_arr             = ['*eNumFl-all_fluxes_eSpec-2009_broad*','*tavgd_pf*']
  IF KEYWORD_SET(overplot_pFlux) THEN BEGIN
     OP_alfDB              = 1
     strLen                = STRLEN(myQuants) - (STRMID(myQuants,STRLEN(myQuants)-1,1) EQ '_') - (STRMID(myQuants,0,1) EQ '_')
     strBegin              = (STRMID(myQuants,0,1) EQ '_')
     tmpMyQuants           = STRMID(myQuants,strBegin,strLen)

     strLen                = STRLEN(OP_quants) - (STRMID(OP_quants,STRLEN(OP_quants)-1,1) EQ '_') - (STRMID(OP_quants,0,1) EQ '_')
     strBegin              = (STRMID(OP_quants,0,1) EQ '_')
     tmpOP_quants          = STRMID(OP_quants,strBegin,strLen)

     overplot_arr          = '*' + [tmpMyQuants,tmpOP_quants] + '*'
  ENDIF
  op_contour__levels       = [10,40,70]
  op_contour__percent      = 1
  op_plotRange             = [0.00,0.10]
  ;; op_contour__nColors   = 20
  ;; op_contour__CTIndex   = 
  ;; op_contour__CTBottom  = 


  nDelay                   = N_ELEMENTS(dels)

  fileDir                  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'

  IF KEYWORD_SET(DstCutoff) THEN BEGIN
     DstString    = 'Dst_' + STRCOMPRESS(DSTcutoff,/REMOVE_ALL)
     avgString    = 'avgnStorm'
  ENDIF ELSE BEGIN
     DstString    = ''
     avgString    = 'avg'
  ENDELSE

  ;; IF KEYWORD_SET(add_night_delay) THEN BEGIN
  ;;    addNightStr  = STRING(FORMAT='("_",F0.1,"ntDel")',add_night_delay/60.) 
  ;; ENDIF ELSE BEGIN
  ;;    addNightStr  = ''
  ;; ENDELSE

  ;; IF KEYWORD_SET(fixed_night_delay) THEN BEGIN
  ;;    addNightStr  = STRING(FORMAT='("_",F0.1,"ntDel_fix")',fixed_night_delay/60.) 
  ;; ENDIF ELSE BEGIN
  ;;    addNightStr  = N_ELEMENTS(addNightStr) GT 0 ? addNightStr : ''
  ;; ENDELSE

  addNightStr    = ''
  IF KEYWORD_SET(add_nightDelay) THEN BEGIN
     add_nightDelay *= 60
     addNightStr = STRING(FORMAT='("_",F0.1,"ntDel")',add_nightDelay/60.) 
  ENDIF

  finalDelStr  = STRING(FORMAT='("_",I0,"-",I0,"Dels")',dels[0]/60.,dels[-1]/60.) + addNightStr
  IF KEYWORD_SET(finalDelOnplotPref) AND KEYWORD_SET(plotPref) THEN BEGIN
     plotPref  = plotPref + finalDelStr
  ENDIF

  btMinStr     = '_' + (KEYWORD_SET(abs_btMin) ? 'ABS' : '') $
                 + 'btMin' + STRING(btMin,FORMAT='(D0.1)')

  orbPref = "-orb_"
  kmPref = "km"
  CASE 1 OF
     KEYWORD_SET(eSpeckers): BEGIN
        rawQuants = ['broad','diff','mono']

        quants = !NULL
        IF KEYWORD_SET(eSpeck_eFlux) THEN BEGIN
           quants = [quants,'_tAvgd_eFlux-all_fluxes_eSpec-2009_' + rawQuants]
        ENDIF
        IF KEYWORD_SET(eSpeck_numFl) THEN BEGIN
           quants = [quants,'_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_' + rawQuants]
        ENDIF
        ;; quants = ['broad','diff','mono']
        ;; quants = '_tAvgd_' + ['NoN-eNumFl-all_fluxes_eSpec-2009_' + quants, $
        ;;           'eFlux-all_fluxes_eSpec-2009_' + quants]
        dbStr  = 'eSpec-w_t-'
        prefPref = 'NWO-upto90-' + DstString
        ancillaryStr = '0sampT-'
     END
     KEYWORD_SET(myQuants): BEGIN
        quants = myQuants
        dbStr  = 'eSpec-w_t-'
        prefPref = 'NWO-upto90-' + DstString
        ancillaryStr = '0sampT-'
     END
     ELSE: BEGIN
        quants = '_tAvgd_' + ['NoN-eNumFl','pF_pF','sptAvg_NoN-eNumFl_eF_LC_intg']
        dbStr  = 'alfDB-w_t-'
        prefPref = DstString + '--upto90ILAT'
        ancillaryStr = 'cur_-1-1-'
     END
  ENDCASE

  avgPackage = {quants           : quants, $
                stableIMFString  : stableIMFString, $
                avgString        : avgString, $
                btMinStr         : btMinStr, $
                dels             : dels, $
                nDelay           : nDelay, $
                configFileDelay  : configFileDelay, $
                finalDelStr      : finalDelStr, $
                use_AACGM        : use_AACGM, $
                use_nEvents_not_nDelay_for_denom : use_nEvents_not_nDelay_for_denom, $
                ;; addNightStr      : addNightStr, $
                addNightStr      : '', $
                orbRange         : orbRange, $
                altitudeRange    : altitudeRange, $
                dbStr            : dbStr, $
                prefPref         : prefPref, $
                ancillaryStr     : ancillaryStr, $
                orbPref          : orbPref, $
                kmPref           : kmPref, $
                fileDir          : fileDir}

  AVERAGE_H2DSTRUCTS_OVER_DELAYS, $
     OUT_CONFFILEPREF=configFilePref, $
     OUT_CONFIGFILE=configFile, $
     OUT_PARAMSTRINGPREF=paramStringPref, $
     OUT_TEMPFILEPREF=tempFilePref, $
     H2DAVGARR_LIST=H2DAvgArr_list, $
     H2DAVGMASKARR_LIST=H2DAvgMaskArr_list, $
     DATANAMEARR_LIST=DataNameArr_list, $
     SAVE_COOLFILES=save_coolFiles, $
     COOLFILE_LIST=coolFile_list, $
     OUT_CENTERSMLT=centersMLT, $
     OUT_CENTERSILAT=centersILAT, $
     CHECKOUTINDS=checkOutInds, $
     CHECKOUT_ESPECKERS=checkOut_eSpeckers, $
     CHECKOUT_ALFDB=checkOut_alfDB, $
     GETFILE_WITH_NIGHTDELAY=add_nightDelay, $
     _EXTRA=avgPackage

  IF KEYWORD_SET(overplot_pFlux) THEN BEGIN
     
     OP_dbStr  = 'alfDB-w_t-'
     OP_prefPref = DstString + '--upto90ILAT'
     OP_orbPref = "-orb_"
     OP_kmPref = "km"

     OP_avgPackage = {quants           : OP_quants, $
                      stableIMFString  : stableIMFString, $
                      avgString        : avgString, $
                      btMinStr         : btMinStr, $
                      dels             : dels, $
                      nDelay           : nDelay, $
                      configFileDelay  : configFileDelay, $
                      finalDelStr      : finalDelStr, $
                      addNightStr      : '', $
                      use_AACGM        : use_AACGM, $
                      use_nEvents_not_nDelay_for_denom : use_nEvents_not_nDelay_for_denom, $
                      orbRange         : orbRange, $
                      altitudeRange    : altitudeRange, $
                      dbStr            : OP_dbStr, $
                      prefPref         : OP_prefPref, $
                      ancillaryStr     : OP_ancillaryStr, $
                      orbPref          : OP_orbPref, $
                      kmPref           : OP_kmPref, $
                      fileDir          : fileDir}

     AVERAGE_H2DSTRUCTS_OVER_DELAYS, $
        OUT_CONFFILEPREF=OP_configFilePref, $
        OUT_CONFIGFILE=OP_configFile, $
        OUT_PARAMSTRINGPREF=OP_paramStringPref, $
        OUT_TEMPFILEPREF=OP_tempFilePref, $
        H2DAVGARR_LIST=OP_H2DAvgArr_list, $
        H2DAVGMASKARR_LIST=OP_H2DAvgMaskArr_list, $
        DATANAMEARR_LIST=OP_DataNameArr_list, $
        SAVE_COOLFILES=save_coolFiles, $
        COOLFILE_LIST=OP_coolFile_list, $
        OUT_CENTERSMLT=oCentersMLT, $
        OUT_CENTERSILAT=oCentersILAT, $
        CHECKOUTINDS=OP_checkOutInds, $
        CHECKOUT_ESPECKERS=OP_eSpeckers, $
        CHECKOUT_ALFDB=OP_alfDB, $
        GETFILE_WITH_NIGHTDELAY=add_nightDelay, $
        _EXTRA=OP_avgPackage

  ENDIF

  ;;NOW PLOTS
  IF KEYWORD_SET(makePlots) THEN BEGIN

     ;;Restore configfile
     RESTORE,fileDir+configFile

     ;;set vars
     IF N_ELEMENTS(show_integrals) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'show_integrals', $
                    show_integrals,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotH2D_contour) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'plotH2D_contour', $
                    plotH2D_contour,/ADD_REPLACE
     ENDIF    

     IF N_ELEMENTS(plotH2D__kde) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'plotH2D__kernel_density_unmask', $
                    BYTE(plotH2D__kde),/ADD_REPLACE
     ENDIF       

     IF N_ELEMENTS(contour__levels) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__levels', $
                    contour__levels,/ADD_REPLACE
     ENDIF    

     IF N_ELEMENTS(contour__percent) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__percent', $
                    contour__percent,/ADD_REPLACE
     ENDIF   

     IF N_ELEMENTS(contour__CTBottom) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__CTBottom', $
                    contour__CTBottom,/ADD_REPLACE
     ENDIF  

     IF N_ELEMENTS(contour__CTIndex) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__CTIndex', $
                    contour__CTIndex,/ADD_REPLACE
     ENDIF   

     IF N_ELEMENTS(gridColor) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'gridColor', $
                    gridColor,/ADD_REPLACE
     ENDIF          

     IF N_ELEMENTS(contour__levels) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__levels', $
                    contour__levels,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__percent) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__percent', $
                    BYTE(contour__percent),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__nColors) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__nColors', $
                    BYTE(contour__nColors),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__CTIndex) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__CTIndex', $
                    FIX(contour__CTIndex),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__CTBottom) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'contour__CTBottom', $
                    FIX(contour__CTBottom),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotRange) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'plotRange', $
                    plotRange,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(OP_coolFile_list) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'overplot_file', $
                    fileDir+OP_coolFile_list[0],/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(overplot_arr) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'overplot_arr', $
                    overplot_arr,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__levels) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'op_contour__levels', $
                    op_contour__levels,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__percent) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'op_contour__percent', $
                    BYTE(op_contour__percent),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__nColors) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'op_contour__nColors', $
                    BYTE(op_contour__nColors),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__CTIndex) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'op_contour__CTIndex', $
                    FIX(op_contour__CTIndex),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__CTBottom) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'op_contour__CTBottom', $
                    FIX(op_contour__CTBottom),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_plotRange) GT 0 THEN BEGIN
        STR_ELEMENT,PASIS__alfDB_plot_struct,'op_plotRange', $
                    op_plotRange,/ADD_REPLACE
     ENDIF


     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF='/bonuses/'

     group_like_plots_for_tiling    = 1
     scale_like_plots_for_tiling    = 0
     adj_upper_plotlim_thresh       = 3    ;;Check third maxima
     adj_lower_plotlim_thresh       = 2    ;;Check minima

     tile__include_IMF_arrows = 0
     tile__cb_in_center_panel = 1
     cb_force_oobHigh         = 1
     labels_for_presentation  = 1
     suppress_gridLabels      = [0,1,1, $
                                 1,1,1, $
                                 1,1,1]

     SETUP_TO_RUN_ALL_CLOCK_ANGLES,multiple_IMF_clockAngles,clockStrings, $
                                   angleLim1,angleLim2, $
                                   IMFStr,IMFTitle, $
                                   BYMIN=byMin, $
                                   BYMAX=byMax, $
                                   BZMIN=bzMin, $
                                   BZMAX=bzMax, $
                                   BTMIN=btMin, $
                                   BTMAX=btMax, $
                                   BXMIN=bxMin, $
                                   BXMAX=bxMax, $
                                   CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
                                   CUSTOM_INTEG_MINM=minM_c, $
                                   CUSTOM_INTEG_MAXM=maxM_c, $
                                   CUSTOM_INTEG_MINI=minI_c, $
                                   CUSTOM_INTEG_MAXI=maxI_c, $
                                   /AND_TILING_OPTIONS, $
                                   GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                   TILE_IMAGES=tile_images, $
                                   TILING_ORDER=tiling_order, $
                                   N_TILE_COLUMNS=n_tile_columns, $
                                   N_TILE_ROWS=n_tile_rows, $
                                   TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
                                   TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
                                   TILEPLOTSUFF=plotSuff

     FOREACH quant,quants,iQuant DO BEGIN
   
        H2DStrArr   = h2dAvgArr_list[iQuant]
        dataNameArr = dataNameArr_list[iQuant]
        H2DMaskArr  = h2dAvgMaskArr_list[iQuant]

        paramString = (KEYWORD_SET(plotPref) ? plotPref : paramStringPref) + quant
        tempFile    = tempFilePref + quant + '.dat'
   
        ;; PRINT,fileName + quant
        
        IF ~FILE_TEST(tempFile) THEN STOP
        RESTORE,tempFile
   
        ;;Do we have any candidates for overplotting?
        IF KEYWORD_SET(PASIS__alfDB_plot_struct.overplot_file) AND KEYWORD_SET(PASIS__alfDB_plot_struct.overplot_arr) THEN BEGIN

           PRINT,'Checking for overplot stuff ...'




           IF ~KEYWORD_SET(OP__HAVE_VARS) THEN BEGIN
              SET_OVERPLOT_COMMON_VARS_FROM_FILE,PASIS__alfDB_plot_struct.overplot_file
           ENDIF

           match = 0

           FOR bk=0,N_ELEMENTS(PASIS__alfDB_plot_struct.overplot_arr[0,*])-1 DO BEGIN

              match += ( STRMATCH(STRUPCASE(dataNameArr[0]),STRUPCASE(PASIS__alfDB_plot_struct.overplot_arr[0,bk])) AND     $
                         STRMATCH(STRUPCASE(OP__dataNameArr[0]),STRUPCASE(PASIS__alfDB_plot_struct.overplot_arr[1,bk])))


           ENDFOR 

           CASE match OF
              0: sendit = 0
              1: sendit = 1
              ELSE: STOP
           ENDCASE
        ENDIF

        PLOT_ALFVENDB_2DHISTOS, $
           H2DSTRARR=H2DStrArr, $
           DATANAMEARR=dataNameArr, $
           H2DMASKARR=H2DMaskArr, $
           TEMPFILE=tempFile, $
           ALFDB_PLOT_STRUCT=PASIS__alfDB_plot_struct, $
           MIMC_STRUCT=PASIS__MIMC_struct, $
           PLOTDIR=plotDir, $
           PARAMSTR=paramString, $
           ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
           HEMI=PASIS__MIMC_struct.hemi, $
           CLOCKSTR=clockStr, $
           GRIDCOLOR=gridColor, $
           SUPPRESS_THICKGRID=suppress_thickGrid, $
           SUPPRESS_THINGRID=suppress_thinGrid, $
           SUPPRESS_GRIDLABELS=suppress_gridLabels, $
           SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
           SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
           SUPPRESS_MLT_NAME=suppress_MLT_name, $
           SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
           SUPPRESS_TITLES=suppress_titles, $
           LABELS_FOR_PRESENTATION=labels_for_presentation, $
           TILE_IMAGES=tile_images, $
           N_TILE_ROWS=n_tile_rows, $
           N_TILE_COLUMNS=n_tile_columns, $
           TILING_ORDER=tiling_order, $
           TILE__FAVOR_ROWS=tile__favor_rows, $
           TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
           TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
           TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
           TILEPLOTSUFF=tilePlotSuff, $
           TILEPLOTTITLE=tilePlotTitle, $
           NO_COLORBAR=no_colorbar, $
           EPS_OUTPUT=eps_output, $
           OVERPLOTSTR=KEYWORD_SET(sendit), $
           OVERPLOT_CONTOUR__LEVELS=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__levels') ? PASIS__alfDB_plot_struct.op_contour__levels : !NULL, $
           OVERPLOT_CONTOUR__PERCENT=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__percent') ? PASIS__alfDB_plot_struct.op_contour__percent : !NULL, $
           OVERPLOT_CONTOUR__NCOLORS=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__nColors') ? PASIS__alfDB_plot_struct.op_contour__nColors : !NULL, $
           OVERPLOT_CONTOUR__CTINDEX=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__CTIndex') ? PASIS__alfDB_plot_struct.op_contour__CTIndex : !NULL, $
           OVERPLOT_CONTOUR__CTBOTTOM=TAG_EXIST(PASIS__alfDB_plot_struct,'op_contour__CTBottom') ? PASIS__alfDB_plot_struct.op_contour__CTBottom : !NULL, $
           OVERPLOT_PLOTRANGE=TAG_EXIST(PASIS__alfDB_plot_struct,'op_plotRange') ? PASIS__alfDB_plot_struct.op_plotRange : !NULL, $
           CENTERS_MLT=centersMLT, $
           CENTERS_ILAT=centersILAT, $
           PREV_PLOT_I__LIMIT_TO_THESE=prev_plot_i__limit_to_these, $
           TXTOUTPUTDIR=txtOutputDir, $
           _EXTRA=PASIS__alfDB_plot_struct
   
     ENDFOREACH

  ENDIF

END

