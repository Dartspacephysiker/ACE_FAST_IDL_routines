PRO JOURNAL__20150604__boxplots_for_allIMF_dawn_dusk_nevents,MAXIND=maxInd


  ;************************************************************
  ;defaults
  defPref='Boxplots--Number_of_events--'
  defSuff='allIMF_dawn_dusk--'
  defDBFile='scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'
  defPlot_i_dir = 'plot_indices_saves/'

  allIMFF='PLOT_INDICES_20150604_allIMF_inds_for_KS_analysis--6-18MLTNorth_all_IMF--0stable--OMNI_GSM_Jun_4_15.sav'
  dawnF='PLOT_INDICES_20150604_dawnward_inds_for_KS_analysis--6-18MLTNorth_dawnward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
  duskF='PLOT_INDICES_20150604_duskward_inds_for_KS_analysis--6-18MLTNorth_duskward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
  
  dataProd=(TAG_NAMES(maximus))(maxInd)

  hoyDia= STRCOMPRESS(STRMID(SYSTIME(0), 4, 3),/REMOVE_ALL) + "_" + $
          STRCOMPRESS(STRMID(SYSTIME(0), 8,2),/REMOVE_ALL) + "_" + STRCOMPRESS(STRMID(SYSTIME(0), 22, 2),/REMOVE_ALL)
  ;************************************************************
  ;check keywords
  IF ~KEYWORD_SET(plot_i_dir) THEN plot_i_dir=defPlot_i_dir
  IF ~KEYWORD_SET(dbFile) THEN dbFile = defDBFile
  IF ~KEYWORD_SET(maxInd) THEN maxInd = 4       ;Magnetic Local Time is default

  IF ~KEYWORD_SET(lun) THEN lun=-1

  restore,dbFile
  curDBFile = dbFile

  PRINT,"Doing boxplots (without regard to orbit number) for maximus data prod ",dataProd

  ;************************************************************
  ;load up all indices files

  print,allIMFF
  restore,plot_i_dir+allIMFF
  ;; plot_i_allIMF=plot_i
  pi_list=list(plot_i)
  IF (curDBFile NE dbFile) THEN BEGIN
     PRINT,"Using conflicting databases!"
     PRINT,"CurrentDB: ",curDBFile
     PRINT,"Plot_i_DB: ",dbFile
  ENDIF
  curDBFile=dbFile

  print,dawnF
  restore,plot_i_dir+dawnF
  ;; plot_i_dawn=plot_i
  pi_list=pi_list+list(plot_i)
  IF (curDBFile NE dbFile) THEN BEGIN
     PRINT,"Using conflicting databases!"
     PRINT,"CurrentDB: ",curDBFile
     PRINT,"Plot_i_DB: ",dbFile
  ENDIF
  curDBFile=dbFile

  print,duskF
  restore,plot_i_dir+duskF
  ;; plot_i_dusk=plot_i
  pi_list=pi_list+list(plot_i)
  IF (curDBFile NE dbFile) THEN BEGIN
     PRINT,"Using conflicting databases!"
     PRINT,"CurrentDB: ",curDBFile
     PRINT,"Plot_i_DB: ",dbFile
  ENDIF
  curDBFile=dbFile

  ;************************************************************
  ;Make arrays of orbit and corresponding number of events

  ;; plot_i_list=LIST([plot_i_allIMF],$
  ;;             [plot_i_dawn],$
  ;;             [plot_i_dusk])
  minOrb=500
  maxOrb=15000
  orbArr = make_array(3,maxOrb-minOrb+1,2,/FLOAT) ;First dim: IMF condition [all_IMF,dawn,dusk] 
                                                  ;Second dim: Orbit number
                                                  ;Third dim: N events for that orbit and IMF condition

  ;************************************************************
  ;Find number of events per orbit for each IMF orientation

  FOR IMF_i=0,2 DO BEGIN
     i=0
     cur_plot_i = pi_list(IMF_i)
     FOR orbI=minOrb,maxOrb DO BEGIN        
        orbArr[IMF_i,i,0]=orbI
        temp_i=where(maximus.orbit(cur_Plot_i) EQ orbI)
        IF temp_i[0] NE -1 THEN orbArr[IMF_i,i,1]=n_elements(temp_i)
        i++
     ENDFOR
  ENDFOR
  

  ;************************************************************
  ;make boxplot data for number of events per orbit,including orbits with zero events
  ;; FOR j=0,2 DO BEGIN
  ;;    bpd_nepo_stats(j,*)=CREATEBOXPLOTDATA(REFORM(orbArr(j,*,1)), $
  ;;                                         MEAN_VALUES=bpd_nepo_extras.mean_values(j), $
  ;;                                         OUTLIER_VALUES=bpd_nepo_extras.outlier_values(j), $
  ;;                                         SUSPECTED_OUTLIER_VALUES=bpd_nepo_extras.suspected_outlier_values(j), $
  ;;                                         CI_VALUES=bpd_nepo_extras.CIVals(j))
  ;; ENDFOR

  bpd_nepo_stats=CREATEBOXPLOTDATA(TRANSPOSE([[REFORM(orbArr(0,*,1))],[REFORM(orbArr(1,*,1))],[REFORM(orbArr(2,*,1))]]), $
                                   MEAN_VALUES=bpd_nepo_means, $
                                   OUTLIER_VALUES=bpd_nepo_outs, $
                                   SUSPECTED_OUTLIER_VALUES=bpd_nepo_susOuts, $
                                   CI_VALUES=bpd_nepo_CIVals)
  
  IF bpd_nepo_outs EQ !NULL THEN bpd_nepo_outs = -1
  IF bpd_nepo_susOuts EQ !NULL THEN bpd_nepo_susOuts = -1
  
  bpd_nepo_extras={MEANS:TEMPORARY(bpd_nepo_means), $
                   OUTS:TEMPORARY(bpd_nepo_outs), $
                   SUSOUTS:TEMPORARY(bpd_nepo_susOuts), $
                   CIVALS:TEMPORARY(bpd_nepo_CIVals)}
  

  ;************************************************************
  ;make boxplot data for number of events per orbit, only counting orbits with AT LEAST ONE event
  ;get list of indices corresponding to orbits with at least one event

  nonzero_orbs_i_list=LIST(WHERE(orbArr(0,*,1) GT 0))
  FOR j=1,2 DO nonzero_orbs_i_list= nonzero_orbs_i_list + LIST(WHERE(orbArr(j,*,1) GT 0))

  ;; bpd_nepo_nz_extras={MEAN_VALUES:empty, $
  ;;                       OUTS:empty, $
  ;;                       SUSOUTS:empty, $
  ;;                       CIVALS:empty}

  ;; bpd_nepo_nz_stats=MAKE_ARRAY(3,5)

  ;; FOR j=0,2 DO BEGIN
  ;;    bpd_nepo_nz_stats(j,*)=CREATEBOXPLOTDATA(REFORM(orbArr(j,nonzero_orbs_i_list(j),1)), $
  ;;                                         MEAN_VALUES=bpd_nepo_nz_extras.mean_values(j), $
  ;;                                         OUTLIER_VALUES=bpd_nepo_nz_extras.outlier_values(j), $
  ;;                                         SUSPECTED_OUTLIER_VALUES=bpd_nepo_nz_extras.susOutlier_values(j), $
  ;;                                         CI_VALUES=bpd_nepo_nz_extras.CIVals(j))
  ;; ENDFOR
  
  bpd_nepo_nz_stats=CREATEBOXPLOTDATA(LIST([REFORM(orbArr(0,nonzero_orbs_i_list(0),1))],$
                                           [REFORM(orbArr(1,nonzero_orbs_i_list(1),1))],$
                                           [REFORM(orbArr(2,nonzero_orbs_i_list(2),1))]), $
                                      MEAN_VALUES=bpd_nepo_nz_means, $
                                      OUTLIER_VALUES=bpd_nepo_nz_outs, $
                                      SUSPECTED_OUTLIER_VALUES=bpd_nepo_nz_susOuts, $
                                      CI_VALUES=bpd_nepo_nz_CIVals)
  
  IF bpd_nepo_nz_outs EQ !NULL THEN bpd_nepo_nz_outs = -1
  IF bpd_nepo_nz_susOuts EQ !NULL THEN bpd_nepo_nz_susOuts = -1
  
  bpd_nepo_nz_extras={MEANS:TEMPORARY(bpd_nepo_nz_means), $
                      OUTS:TEMPORARY(bpd_nepo_nz_outs), $
                      SUSOUTS:TEMPORARY(bpd_nepo_nz_susOuts), $
                      CIVALS:TEMPORARY(bpd_nepo_nz_CIVals)}
  
  ;************************************************************
  ;make boxplot data for where events are happening without regard to orbit
  nEvTot=0
  FOR i=0,n_elements(pi_list)-1 DO nEvTot+=n_elements(pi_list(i))
  ;; bpd_nEv_extras={MEANS:empty, $
  ;;                       OUTS:empty, $
  ;;                       SUSOUTS:empty, $
  ;;                       CIVALS:empty}
  ;; bpd_nEv_extras={MEANS:empty, $
  ;;                       OUTS:MAKE_ARRAY(2,nEvTot), $
  ;;                       SUSOUTS:MAKE_ARRAY(2,nEvTot), $
  ;;                       CIVALS:empty}

  ;; bpd_nEv_stats=MAKE_ARRAY(3,5)

  ;; FOR j=0,2 DO BEGIN
  ;;    bpd_nEv_stats(j,*)=CREATEBOXPLOTDATA(maximus.(maxInd)(pi_list(j)), $
  ;;                                         MEAN_VALUES=bpd_nEv_extras.mean_values(j), $
  ;;                                         OUTLIER_VALUES=bpd_nEv_extras.outlier_values(j), $
  ;;                                         SUSPECTED_OUTLIER_VALUES=bpd_nEv_extras.susOutlier_values(j), $
  ;;                                         CI_VALUES=bpd_nEv_extras.CIVals(j))
  ;; ENDFOR

  bpd_nEv_stats=CREATEBOXPLOTDATA(LIST(maximus.(maxInd)(pi_list(0)),maximus.(maxInd)(pi_list(1)),maximus.(maxInd)(pi_list(2))), $
                                  MEAN_VALUES=bpd_nEv_means, $
                                  OUTLIER_VALUES=bpd_nEv_outs, $
                                  SUSPECTED_OUTLIER_VALUES=bpd_nEv_susOuts, $
                                  CI_VALUES=bpd_nEv_CIVals)


  IF bpd_nEv_outs EQ !NULL THEN bpd_nEv_outs = -1
  IF bpd_nEv_susOuts EQ !NULL THEN bpd_nEv_susOuts = -1

  bpd_nEv_extras={MEANS:TEMPORARY(bpd_nEv_means), $
                      OUTS:TEMPORARY(bpd_nEv_outs), $
                      SUSOUTS:TEMPORARY(bpd_nEv_susOuts), $
                      CIVALS:TEMPORARY(bpd_nEv_CIVals)}

                                       ;; MEANS=bpd_nEv_extras.mean_values(j), $
                                       ;; OUTS=bpd_nEv_extras.outlier_values(j), $
                                       ;; SUSOUTS=bpd_nEv_extras.susOutlier_values(j), $
                                       ;; CIVALS=bpd_nEv_extras.CIVals(j))

  ;************************************************************
  ;Make boxplots

  w_nepo = WINDOW(DIMENSIONS=[1200,600])

  bp_nepo = BOXPLOT(bpd_nepo_stats, XTITLE="IMF Orientation", YTITLE='Number of events per orbit', $
                   TITLE='Boxplot of Number of events per orbit (including orbits with 0 events)', $
                   FILL_COLOR='white', BACKGROUND_COLOR='linen',/CURRENT,LAYOUT=[2,1,1])
  bp_nepo_nz = BOXPLOT(bpd_nepo_nz_stats, XTITLE="IMF Orientation", YTITLE='Number of events per orbit', $
                   TITLE='Boxplot of Number of events per orbit (excluding orbits with 0 events)', $
                   FILL_COLOR='white', BACKGROUND_COLOR='linen',/CURRENT,LAYOUT=[2,1,2])

  w_nepo.save, defPref+'per_orbit--'+defSuff+hoyDia+'.png',RESOLUTION=300

  w_data = WINDOW(DIMENSIONS=[600,600])
  bp_nEv = BOXPLOT(bpd_nEv_stats, XTITLE='IMF Orientation', YTITLE='Number of events per orbit', $
                   TITLE='Boxplot of '+dataProd+' for varying IMF conditions', $
                   FILL_COLOR='white', BACKGROUND_COLOR='linen',/CURRENT)
  w_data.save, defPref+defSuff+hoyDia+'.png',RESOLUTION=300

  save,bpd_nEv_stats,bpd_nepo_nz_stats,bpd_nepo_stats,$
       bpd_nEv_extras,bpd_nepo_nz_extras,bpd_nepo_extras,$
       filename=defPref+'boxplot_params_and_statistics--'+defSuff+hoyDia+'.sav'

END