;;12/26/16
;; alfDB_time   : 921.26111083335343
;; eSpecDB_time : 1598.5881
;; ratio        : 
PRO JOURNAL__20161226__AVAILABILITY_OF_SURVEYMODE_EPHEMERIS_VS_128SS_EPHEMERIS, $
   TOTTIME=totTime, $
   FOR_ESPEC_DBS=for_eSpec_DBs, $
   NEWELLED_CUSP=Newelled_cusp, $
   TYPENUMS=nums

  COMPILE_OPT IDL2

  ;; for_eSpec_DBs = 1

  dir        = '/home/spencerh/Desktop/'
  alfIMFFIle = 'Alfvens_IMF--inds--north_hemi--20161224.sav'
  eESAFile   = 'newellZhang2014--inds.sav'
  NCFile     = 'Alfvens_IMF--inds--north_hemi--newellthecusp--20161226.sav'

  CASE 1 OF
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        file = eESAFile
     END
     KEYWORD_SET(Newelled_cusp): BEGIN
        file = NCFile
     END
     ELSE: BEGIN
        file = alfIMFFile
     END
  ENDCASE

  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc, $
                                 fastLoc_times, $
                                 fastLoc_delta_t, $
                                 /NO_MEMORY_LOAD, $
                                 FOR_ESPEC_DBS=for_eSpec_DBs, $
                                 /FORCE_LOAD_ALL

  
  PRINT,"Restoring " + dir + file + ' ...'
  RESTORE,dir+File


  fastLoc_i = out_fastLoc_i_list[0]

  IF N_ELEMENTS(out_plot_i_list) GT 0 THEN BEGIN
     plot_i = out_plot_i_list[0]
  ENDIF

  IF N_ELEMENTS(out_i_eSpec_list) GT 0 THEN BEGIN
     i_eSpec = out_i_eSpec_list[0]
  ENDIF

  FOR k=0,N_ELEMENTS(out_fastLoc_i_list)-1 DO BEGIN
     fastLoc_i = CGSETUNION(fastLoc_i,out_fastLoc_i_list[k])

     IF N_ELEMENTS(out_plot_i_list) GT 0 THEN BEGIN
        plot_i = CGSETUNION(plot_i,out_plot_i_list[k])
     ENDIF

     IF N_ELEMENTS(out_i_eSpec_list) GT 0 THEN BEGIN
        i_eSpec = CGSETUNION(i_eSpec,out_i_eSpec_list[k])
     ENDIF

  ENDFOR

  totTime = TOTAL(fastLoc_delta_t[fastLoc_i])/60./60.

  PRINT,'N fastLoc inds  : ',N_ELEMENTS(fastLoc_i)
  PRINT,'N fastLoc uInds : ',N_ELEMENTS(UNIQ(fastLoc_i,SORT(fastLoc_i)))
  PRINT,'Tot fastLoc time: ',STRCOMPRESS(totTime,/REMOVE_ALL) + ' hrs'
  PRINT,''

  IF N_ELEMENTS(plot_i) GT 0 THEN BEGIN

     @common__maximus_vars.pro

     IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME
     ENDIF

     cusp_i = CGSETINTERSECTION(plot_i, $
                                WHERE(MAXIMUS__maximus.mlt GE 9.5 AND $
                                      MAXIMUS__maximus.mlt LE 14.5), $
                                COUNT=nCusp)

     PRINT,'N alfDB inds         : ',N_ELEMENTS(plot_i)
     PRINT,'N alfDB uInds        : ',N_ELEMENTS(UNIQ(plot_i,SORT(plot_i)))

     PRINT,'N alfDB 9.5-14.5 MLT : ',nCusp
     ;; PRINT,'Tot alfDB time: ',STRCOMPRESS(totTime,/REMOVE_ALL) + ' hrs'
     PRINT,''

  ENDIF

  PRINT,''

  IF N_ELEMENTS(i_eSpec) GT 0 THEN BEGIN
     PRINT,'N eSpec inds  : ',N_ELEMENTS(i_eSpec)
     PRINT,'N eSpec uInds : ',N_ELEMENTS(UNIQ(i_eSpec,SORT(i_eSpec)))
     ;; PRINT,'Tot alfDB time: ',STRCOMPRESS(totTime,/REMOVE_ALL) + ' hrs'
     PRINT,''

     eSpec_by_type = 1
     IF KEYWORD_SET(eSpec_by_type) THEN BEGIN
        @common__newell_espec.pro

        IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
           LOAD_NEWELL_ESPEC_DB
        ENDIF

        ;; i_eSpec = CGSETINTERSECTION(i_eSpec,WHERE(NEWELL__eSpec.mlt GE 9.5 AND NEWELL__eSpec.mlt LE 14.5))
        iCusp = CGSETINTERSECTION(i_eSpec,WHERE(NEWELL__eSpec.mlt GE 9.5 OR NEWELL__eSpec.mlt LE 14.5))

        b_ii  = WHERE((NEWELL__eSpec.broad[i_eSpec] EQ 1) OR $
                      (NEWELL__eSpec.broad[i_eSpec] EQ 2),nB)
        m_ii  = WHERE((NEWELL__eSpec.mono[i_eSpec] EQ 1) OR $
                      (NEWELL__eSpec.mono[i_eSpec] EQ 2),nM)
        d_ii  = WHERE((NEWELL__eSpec.diffuse[i_eSpec] EQ 1),nD)

        bC_ii = WHERE((NEWELL__eSpec.broad[iCusp] EQ 1) OR $
                      (NEWELL__eSpec.broad[iCusp] EQ 2),nB)
        mC_ii = WHERE((NEWELL__eSpec.mono[iCusp] EQ 1) OR $
                      (NEWELL__eSpec.mono[iCusp] EQ 2),nM)
        dC_ii = WHERE((NEWELL__eSpec.diffuse[iCusp] EQ 1),nD)

        PRINT,"N Broad : ",nB
        PRINT,"N Mono  : ",nM
        PRINT,"N Diff  : ",nD
        PRINT,''
        PRINT,"N Broad (9.5-14.5 MLT): ",nB
        PRINT,"N Mono  (9.5-14.5 MLT): ",nM
        PRINT,"N Diff  (9.5-14.5 MLT): ",nD

        nums = [nB,nM,nD]

     ENDIF


  ENDIF

END
