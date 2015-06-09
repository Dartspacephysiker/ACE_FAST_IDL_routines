;2015/06/05

;This routine draws on resample_indices_based_on_orbit to do a Monte Carlo comparison of two
;sample distributions (possibly specified by plot indices files), generating a spread of KS
;statistics and p-values.

PRO MONTE_CARLO_COMPARE_DISTRIBUTIONS,plot1_i,plot2_i,MAXIMUS=maximus,N=N,MAXIND=maxInd, $
                                      PLOT1_I_FILE=plot1_i_file,PLOT2_I_FILE=plot2_i_file,PLOT_I_DIR=plot_i_dir,LUN=lun, $
                                      KS_PVAL_ARR=ks_pval_arr,MAXNSAMPPERORB=maxNSampPerOrb,REDUCENSAMPBYFACTOR=reduceNSampByFactor
  

  defDBFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'

  defPlot_i_dir = 'plot_indices_saves/'
  defPlot1_i_file='PLOT_INDICES_20150604_dawnward_inds_for_KS_analysis--6-18MLTNorth_dawnward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'
  defPlot2_i_file='PLOT_INDICES_20150604_duskward_inds_for_KS_analysis--6-18MLTNorth_duskward--0stable--OMNI_GSM_byMin_5.0_Jun_4_15.sav'

  defNResamples=100

  IF ~KEYWORD_SET(lun) THEN lun=-1
  IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir
  
  IF ~KEYWORD_SET(maxInd) THEN maxInd = 4       ;Magnetic Local Time is default

  IF NOT KEYWORD_SET(N) THEN BEGIN
     PRINT,"How am I supposed to know how many times you want this thing resampled?"
     PRINT,'Doing default: ' + STRCOMPRESS(defNResamples,/REMOVE_ALL) + ' resamples...'
     N=defNResamples
  ENDIF

  IF NOT KEYWORD_SET(plot1_i) AND NOT KEYWORD_SET(plot1_i_file) THEN BEGIN
     PRINT,"No plot indices provided!!!"
     PRINT,"Using default plot1_i_file: " + defPlot1_i_file
     plot1_i_file=defPlot1_i_file
  ENDIF 

  IF NOT KEYWORD_SET(plot2_i) AND NOT KEYWORD_SET(plot2_i_file) THEN BEGIN
     PRINT,"No plot indices provided!!!"
     PRINT,"Using default plot2_i_file: " + defplot2_i_file
     plot2_i_file=defplot2_i_file
  ENDIF 

  IF KEYWORD_SET(plot1_i_file) THEN BEGIN
     
     PRINT,""
     PRINT,"****************************************"
     PRINT,"Loading plot1 indices file: ",plot_i_dir+plot1_i_file
     restore,plot_i_dir+plot1_i_file
     plot1_i=plot_i
     
     IF maximus EQ !NULL THEN restore,dbFile ELSE PRINT,'Maximus already loaded!'
     
     printf,lun,""
     printf,lun,"**********DATA SUMMARY**********"
     printf,lun,"DBFile: " + dbFile
     printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
     printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
     ;; printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
     printf,lun,"Screening parameters: [Min] [Max]"
     printf,lun,"Mag current: " + strtrim(maxNEGMC,2) + " " + strtrim(minMC,2)
     printf,lun,"MLT: " + strtrim(minM,2) + " " + strtrim(maxM,2)
     printf,lun,"ILAT: " + strtrim(minI,2) + " " + strtrim(maxI,2)
     printf,lun,"Hemisphere: " + hemStr
     printf,lun,"IMF Predominance: " + clockStr
     printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
     printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)
     printf,lun,"Number of orbits used: " + strtrim(N_ELEMENTS(uniqueOrbs_ii),2)
     printf,lun,"Total number of events used: " + strtrim(N_ELEMENTS(plot_i),2)
     printf,lun,"Percentage of current DB used: " + $
            strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"
                                ;NOTE, sometimes percentage of current DB will be discrepant between
                                ;key_scatterplots_polarproj and get_inds_from_db because
                                ;key_scatterplots_polarproj actually resizes maximus

  ENDIF ELSE BEGIN
     IF NOT KEYWORD_SET(maximus) THEN BEGIN
        PRINT,"Maximus struct not provided in function call!"
        
        IF NOT KEYWORD_SET(dbFile) THEN dbFile = defDBFile
        PRINT,"Loading DBfile: ",dbFile
        RESTORE,dbFile
     ENDIF
  ENDELSE

  IF KEYWORD_SET(plot2_i_file) THEN BEGIN
     
     PRINT,""
     PRINT,"****************************************"
     PRINT,"Loading plot2 indices file: ",plot_i_dir+plot2_i_file
     restore,plot_i_dir+plot2_i_file
     plot2_i=plot_i

     printf,lun,""
     printf,lun,"**********DATA SUMMARY**********"
     printf,lun,"DBFile: " + dbFile
     printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
     printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
     ;; printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
     printf,lun,"Screening parameters: [Min] [Max]"
     printf,lun,"Mag current: " + strtrim(maxNEGMC,2) + " " + strtrim(minMC,2)
     printf,lun,"MLT: " + strtrim(minM,2) + " " + strtrim(maxM,2)
     printf,lun,"ILAT: " + strtrim(minI,2) + " " + strtrim(maxI,2)
     printf,lun,"Hemisphere: " + hemStr
     printf,lun,"IMF Predominance: " + clockStr
     printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
     printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)
     printf,lun,"Number of orbits used: " + strtrim(N_ELEMENTS(uniqueOrbs_ii),2)
     printf,lun,"Total number of events used: " + strtrim(N_ELEMENTS(plot_i),2)
     printf,lun,"Percentage of current DB used: " + $
            strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"
                                ;NOTE, sometimes percentage of current DB will be discrepant between
                                ;key_scatterplots_polarproj and get_inds_from_db because
                                ;key_scatterplots_polarproj actually resizes maximus
     
  ENDIF

  IF maximus EQ !NULL THEN BEGIN
     PRINT,"Invalid database file: No maximus structure was loaded..."
     PRINT,"Returning..."
     RETURN
  ENDIF

  resampled_plot1_i=RESAMPLE_INDICES_BASED_ON_ORBIT(plot1_i,maximus,N,MAXNSAMPPERORB=maxNSampPerOrb,REDUCENSAMPBYFACTOR=reduceNSampByFactor)
  resampled_plot2_i=RESAMPLE_INDICES_BASED_ON_ORBIT(plot2_i,maximus,N,MAXNSAMPPERORB=maxNSampPerOrb,REDUCENSAMPBYFACTOR=reduceNSampByFactor)

  ;;make KS array
  ks_pval_arr = MAKE_ARRAY(2,N,/DOUBLE)

  FOR j=0,N-1 DO BEGIN
     kstwo,maximus.(maxInd)(resampled_plot1_i(*,j)),maximus.(maxInd)(resampled_plot2_i(*,j)),D,pVal
     ks_pval_arr(0,j)=D
     ks_pval_arr(1,j)=pVal
  ENDFOR

  RETURN
END
