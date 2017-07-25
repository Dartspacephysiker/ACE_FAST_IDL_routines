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
                                   GETFILE_WITH_NIGHTDELAY=getfile_with_nightdelay, $
                                   _EXTRA=e

  orbStr          = STRING(FORMAT='(A0,I0,"-",I0)',orbPref,orbRange[0],orbRange[1])
  altStr          = STRING(FORMAT='(I0,"-",I0,A0)',altitudeRange[0],altitudeRange[1],kmPref)

  configFilePref = 'multi_PASIS_vars-' + dbStr + prefPref + $
                    altStr +  orbStr + '-NORTH_AACGM-' + $
                   ancillaryStr + avgString + $
                   '_' + stableIMFString + 'stable'
  filePref     = 'polarplots_' + prefPref +  $
                 altStr +  orbStr + '-NORTH_AACGM-' + $
                 ancillaryStr + avgString + $
                 '_' + stableIMFString + 'stable'
  fileSuff     = btMinStr + '-Ring'
  
  paramStringPref = filePref + finalDelStr + fileSuff 
  tempFilePref = fileDir + filePref + finalDelStr + fileSuff

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  nIMFOrient   = N_ELEMENTS(clockStrings)

  ;;Get configfile to make template array thing
  tmpDelayStr = STRING(FORMAT='("_",F0.1,"Del")',dels[0]/60.) + addNightStr

  configFile = configFilePref + tmpDelayStr + fileSuff + '.sav'
  IF FILE_TEST(fileDir+configFile) THEN BEGIN
     RESTORE,fileDir+configFile
  ENDIF ELSE STOP

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
           dayFile   = filePref + dayDelayStr + fileSuff
           nitFile = filePref + nitDelayStr + fileSuff

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

           H2DAvgArr[iIMF].data                 += H2DStrArr[iIMF].data/nDelay
           H2DAvgArr[iIMF].grossIntegrals.day   += H2DStrArr[iIMF].grossIntegrals.day/nDelay
           H2DAvgArr[iIMF].grossIntegrals.night += H2DStrArr[iIMF].grossIntegrals.night/nDelay
           H2DAvgArr[iIMF].grossIntegrals.total += H2DStrArr[iIMF].grossIntegrals.total/nDelay
           H2DAvgArr[iIMF].grossIntegrals.custom[0] += H2DStrArr[iIMF].grossIntegrals.custom[0]/nDelay
           H2DAvgArr[iIMF].grossIntegrals.custom[1] += H2DStrArr[iIMF].grossIntegrals.custom[1]/nDelay

           H2DAvgMaskArr[iIMF].data = H2DAvgMaskArr[iIMF].data AND H2DMaskArr[iIMF].data

        ENDFOREACH

     ENDFOREACH

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

  eSpec = 1
  alfDB = 0
  checkOutInds = 1
  IF KEYWORD_SET(checkOutInds) THEN BEGIN

     ;; LOAD_NEWELL_ESPEC_DB,eSpec,/NO_MEMORY_LOAD

     ;; mlts = (TEMPORARY(eSpec)).mlt
     dirDir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/journals/'
     mltFile = 'espec_mlts.sav'
     RESTORE,dirDir+mltFile
     allDayInds = WHERE(mlts GE 6  AND mlts LT 18, $
                        nAllDayInds, $
                        COMPLEMENT=allNightInds,NCOMPLEMENT=nAllNightInds)
     mlts = !NULL
     
     myFile = 'eSpec_uniqInds_CHECK_BECAUSEYOUHAVENTYET.sav'

     IF FILE_TEST(dirDir+myFile) THEN BEGIN
        RESTORE,dirDir+myFile
        PRINT,"Spence, check out these inds. Are they qualité? Do you need to spend a little extra time doing this and that?"
        STOP
        
     ENDIF

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
                 KEYWORD_SET(eSpec): BEGIN
                    IF iDel EQ 0 THEN BEGIN
                       dayIndsList.Add,CGSETINTERSECTION(PASIS__indices__eSpec_list[iIMF],allDayInds)
                    ENDIF ELSE BEGIN
                       dayIndsList[iIMF] = CGSETUNION(dayIndsList[iIMF],CGSETINTERSECTION(allDayInds,PASIS__indices__eSpec_list[iIMF]))
                    ENDELSE
                 END
                 ELSE: STOP
              ENDCASE

              nitConfigFile = configFilePref + nitDelayStr + fileSuff + '.sav'
              IF FILE_TEST(fileDir+nitConfigFile) THEN BEGIN
                 RESTORE,fileDir+nitConfigFile
              ENDIF ELSE STOP

              CASE 1 OF
                 KEYWORD_SET(eSpec): BEGIN
                    IF iDel EQ 0 THEN BEGIN
                       nitIndsList.Add,CGSETINTERSECTION(PASIS__indices__eSpec_list[iIMF],allNightInds)
                    ENDIF ELSE BEGIN
                       nitIndsList[iIMF] = CGSETUNION(nitIndsList[iIMF],CGSETINTERSECTION(allNightInds,PASIS__indices__eSpec_list[iIMF]))
                    ENDELSE
                 END
                 ELSE: STOP
              ENDCASE
           ENDIF ELSE BEGIN

              STOP

           ENDELSE
           
        ENDFOREACH

     ENDFOREACH

     STOP

  ENDIF

END

PRO JOURNAL__20170722__AVG_OVER_DELAYS__CUSTOM_NIGHTTIME_DELAY__OVERPLOTTER

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__overplot_vars.pro

  eSpeckers             = 0

  overplot_pFlux        = 1

  plotH2D_contour          = 1

  ;; myQuants              = '_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_broad'
  ;; OP_quants             = '_tAvgd_pF_pF'
  ;; OP_ancillaryStr       = 'cur_-1-1-NC-'
  ;; plotPref              = 'NC_pF_overlaid-'
  ;; contour__levels       = KEYWORD_SET(plotH2D_contour) ? [0,20,40,60,80,100] : !NULL
  ;; contour__percent      = KEYWORD_SET(plotH2D_contour) ? 1 : !NULL
  ;; ;; contour__nColors   = 8
  ;; contour__CTBottom     = 0
  ;; contour__CTIndex      = -49
  ;; gridColor             = 'gray'


  myQuants              = '_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_diff'
  OP_quants             = '_tAvgd_pF_pF'
  OP_ancillaryStr       = 'cur_-1-1-invNC-'
  plotPref              = 'invNC_pF_overlaid-'
  contour__levels       = KEYWORD_SET(plotH2D_contour) ? [0,25,50,75,100] : !NULL
  contour__percent      = KEYWORD_SET(plotH2D_contour) ? 1 : !NULL
  contour__nColors      = 8
  contour__CTBottom     = 0
  contour__CTIndex      = -60

  finalDelOnplotPref       = 1

  orbRange                 = [500,12670]
  altitudeRange            = [300,4300]

  save_coolFiles           = 1
  makePlots                = 1

  ;;Which files??
  DstCutoff                = -25
  stableIMFString          = '19'
  getfile_with_nightdelay  = 45*60
  dels                     = [0:30:5]*60

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

  IF KEYWORD_SET(add_night_delay) THEN BEGIN
     addNightStr  = STRING(FORMAT='("_",F0.1,"ntDel")',add_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr  = ''
  ENDELSE

  IF KEYWORD_SET(fixed_night_delay) THEN BEGIN
     addNightStr  = STRING(FORMAT='("_",F0.1,"ntDel_fix")',fixed_night_delay/60.) 
  ENDIF ELSE BEGIN
     addNightStr  = N_ELEMENTS(addNightStr) GT 0 ? addNightStr : ''
  ENDELSE

  custom_addNightStr    = ''
  IF KEYWORD_SET(getfile_with_nightdelay) THEN BEGIN
     custom_addNightStr = STRING(FORMAT='("_",F0.1,"ntDel_cstm")',getfile_with_nightdelay/60.) 
  ENDIF

  finalDelStr  = STRING(FORMAT='("_",I0,"-",I0,"Dels")',dels[0]/60.,dels[-1]/60.) + addNightStr + custom_addNightStr
  IF KEYWORD_SET(finalDelOnplotPref) AND KEYWORD_SET(plotPref) THEN BEGIN
     plotPref  = plotPref + finalDelStr
  ENDIF

  btMin        = 1.0
  btMinStr     = '_' + (KEYWORD_SET(abs_btMin) ? 'ABS' : '') $
                 + 'btMin' + STRING(btMin,FORMAT='(D0.1)')

  CASE 1 OF
     KEYWORD_SET(eSpeckers): BEGIN
        quants = ['broad','diff','mono']
        quants = '_tAvgd_' + ['NoN-eNumFl-all_fluxes_eSpec-2009_' + quants, $
                  'eFlux-all_fluxes_eSpec-2009_' + quants]
        dbStr  = 'eSpec-w_t-'
        prefPref = 'NWO--upto90-' + DstString
        ancillaryStr = '0sampT-'
        orbPref = "--orbs_"
        kmPref = "_km"
     END
     KEYWORD_SET(myQuants): BEGIN
        quants = myQuants
        dbStr  = 'eSpec-w_t-'
        prefPref = 'NWO--upto90-' + DstString
        ancillaryStr = '0sampT-'
        orbPref = "--orbs_"
        kmPref = "_km"
     END
     ELSE: BEGIN
        quants = '_tAvgd_' + ['NoN-eNumFl','pF_pF','sptAvg_NoN-eNumFl_eF_LC_intg']
        dbStr  = 'alfDB-w_t-'
        prefPref = DstString + '--upto90ILAT'
        ancillaryStr = 'cur_-1-1-'
        orbPref = "-orb_"
        kmPref = "km"
     END
  ENDCASE

  avgPackage = {quants           : quants, $
                stableIMFString  : stableIMFString, $
                avgString        : avgString, $
                btMinStr         : btMinStr, $
                dels             : dels, $
                nDelay           : nDelay, $
                finalDelStr      : finalDelStr, $
                addNightStr      : addNightStr, $
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
     GETFILE_WITH_NIGHTDELAY=getfile_with_nightdelay, $
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
                      finalDelStr      : finalDelStr, $
                      addNightStr      : addNightStr, $
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
        CHECKOUTINDS=checkOutInds, $
        GETFILE_WITH_NIGHTDELAY=getfile_with_nightdelay, $
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

