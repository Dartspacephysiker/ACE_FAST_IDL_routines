PRO GET_NEVENTPERMIN_PLOTDATA,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                              ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                              BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                              LOGNEVENTPERMIN=logNEventPerMin,NEVENTPERMINRANGE=nEventPerMinRange, $
                              HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                              MINMLT=minM,MAXMLT=maxM,BINMLT=binM, $
                              MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                              FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                              FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                              BURSTDATA_EXCLUDED=burstData_excluded, $
                              DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme
  
     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.
     h2dNEvPerMinStr={tmplt_h2dStr}
     h2dNEvPerMinStr.data=h2dStr[0].data
     h2dNonzeroNEv_i=WHERE(h2dStr[0].data NE 0,/NULL)

     ;Get the appropriate divisor for IMF conditions
     GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                HEMI='BOTH', DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                HWMAUROVAL=0,HWMKPIND=!NULL, $
                                MAKE_OUTINDSFILE=1,OUTINDSFILEBASENAME=outIndsBasename, $
                                FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                BURSTDATA_EXCLUDED=burstData_excluded

     ;; MAKE_FASTLOC_HISTO,TIMEHISTO=divisor,FASTLOC_INDS=fastLoc_inds, $
     MAKE_FASTLOC_HISTO,FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                        FASTLOC_INDS=fastLocInterped_i, OUTTIMEHISTO=divisor, $
                        MINMLT=minM,MAXMLT=maxM,BINMLT=binM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                        OUTFILEPREFIX=outIndsBasename,OUTFILESUFFIX=outFileSuffix, OUTDIR=fastLocOutputDir, $
                        OUTPUT_TEXTFILE=output_textFile

     ;output is in seconds, but we'll do minutes
     ;
     divisor = divisor(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
     h2dNEvPerMinStr.data(h2dNonzeroNEv_i)=h2dNEvPerMinStr.data(h2dNonzeroNEv_i)/divisor

     ;2015/04/09 TEMPORARILY skip the lines above because our fastLoc file currently only includes orbits 500-11000.
     ; This means that, according to fastLoc and maximus, there are events where FAST has never been!
     ; So we have to do some trickery
     ;; divisor_nonZero_i = WHERE(divisor GT 0.0)
     ;; h2dNonzeroNEv_i = cgsetintersection(divisor_nonZero_i,h2dNonzeroNEv_i)
     ;; divisor = divisor(h2dNonzeroNEv_i)/60.0 ;Only divide by number of minutes that FAST spent in bin for given IMF conditions
     ;; h2dNEvPerMinStr.data(h2dNonzeroNEv_i)=h2dNEvPerMinStr.data(h2dNonzeroNEv_i)/divisor

     logNEvStr=""
     IF KEYWORD_SET(logNEventPerMin) THEN logNEvStr="Log "
     h2dNEvPerMinStr.title= logNEvStr + 'N Events per minute'

     IF N_ELEMENTS(nEventPerMinRange) EQ 0 OR N_ELEMENTS(nEventPerMinRange) NE 2 THEN BEGIN
        IF N_ELEMENTS(logNEventPerMin) EQ 0 THEN h2dNEvPerMinStr.lim=[0,25] ELSE h2dNEvPerMinStr.lim=[1,ALOG10(25.0)]
     ENDIF ELSE h2dNEvPerMinStr.lim=nEventPerMinRange
     
     IF KEYWORD_SET(logNEventPerMin) THEN BEGIN 
        h2dNEvPerMinStr.data(where(h2dNEvPerMinStr.data GT 0,/NULL))=ALOG10(h2dNEvPerMinStr.data(where(h2dNEvPerMinStr.data GT 0,/null))) 
     ENDIF

     h2dStr=[h2dStr,h2dNEvPerMinStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,logNEvStr + "nEventPerMin"] 

END


