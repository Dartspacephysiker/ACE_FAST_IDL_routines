FUNCTION RESAMPLE_INDICES_BASED_ON_ORBIT,plot_i,maximus,DBFILE=dbFile,FIXEDN=fixedN,MAXN=maxN,PLOT_I_FILE=plot_i_file,PLOT_I_DIR=plot_i_dir,LUN=lun

  IF ~KEYWORD_SET(lun) THEN lun=-1

  defDBFile='scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'
  defPlot_i_dir = 'plot_indices_saves/'

  IF NOT KEYWORD_SET(plot_i) AND NOT KEYWORD_SET(plot_i_file) THEN BEGIN
     PRINT,"No plot indices provided!!!"
     PRINT,"Returning..."
     RETURN
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(plot_i_file) THEN BEGIN

        IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

        PRINT,"Loading plot indices file: ",plot_i_dir+plot_i_file
        restore,plot_i_dir+plot_i_file
        printf,lun,""
        printf,lun,"**********DATA SUMMARY**********"
        print,lun,"DBFile: " + dbFile
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
        restore,dbFile

     ENDIF ELSE BEGIN
        IF NOT KEYWORD_SET(maximus) THEN BEGIN
           PRINT,"Maximus struct not provided in function call!"
           
           IF NOT KEYWORD_SET(dbFile) THEN dbFile = defDBFile
           PRINT,"Loading DBfile: ",dbFile
           RESTORE,dbFile
        ENDIF
     ENDELSE
  ENDELSE
  
  IF maximus EQ !NULL THEN BEGIN
     PRINT,"Invalid database file: No maximus structure was loaded..."
     PRINT,"Returning..."
     RETURN
  ENDIF
  
  ;get number of orbits, what those orbits are
  uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
  nOrbs=n_elements(uniqueOrbs_ii)
  IF KEYWORD_SET(plot_i_file) THEN printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."


  RETURN,resampled_plot_i

END