;2015/06/04
;This function is to be used as a way to check the statistical spread in our estimated centroids of
;Alfvénic wave activity and to get an idea in the spread of p values and KS statistics that can be
;generated within our database. In short, this is to be used to ensure that our scientific
;conclusions have some better footing than a single number or statistic.
;It is probably best used in the guts of a loop, where this thing is cranking out resampled plot indices

;Feeding this function a vector of M plot indices causes an array of MxN indices to be returned.

FUNCTION RESAMPLE_INDICES_BASED_ON_ORBIT,plot_i,maximus,N,DBFILE=dbFile,FIXEDN=fixedN,MAXN=maxN,MAXNSAMPPERORB=maxNSampPerOrb, $
PLOT_I_FILE=plot_i_file,PLOT_I_DIR=plot_i_dir,LUN=lun,REDUCENSAMPBYFACTOR=reduceNSampByFactor

  IF ~KEYWORD_SET(lun) THEN lun=-1

  defDBFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
  defPlot_i_dir = 'plot_indices_saves/'
  defNResamples=100

  IF NOT KEYWORD_SET(N) THEN BEGIN
     PRINT,"How am I supposed to know how many times you want this thing resampled?"
     N=defNResamples
  ENDIF

  IF NOT KEYWORD_SET(plot_i) AND NOT KEYWORD_SET(plot_i_file) THEN BEGIN
     PRINT,"No plot indices provided!!!"
     PRINT,"Returning..."
     RETURN,-1
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(plot_i_file) THEN BEGIN

        IF maximus EQ !NULL THEN restore,dbFile ELSE PRINT,'Maximus already loaded!'

        IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

        PRINT,"Loading plot indices file: ",plot_i_dir+plot_i_file
        restore,plot_i_dir+plot_i_file
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
  ENDELSE
  
  IF maximus EQ !NULL THEN BEGIN
     PRINT,"Invalid database file: No maximus structure was loaded..."
     PRINT,"Returning..."
     RETURN,-1
  ENDIF
  
  ;get number of orbits, what those orbits are
  IF NOT KEYWORD_SET(unique_orbs_ii) THEN BEGIN
     uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
     nOrbs=n_elements(uniqueOrbs_ii)
     IF KEYWORD_SET(plot_i_file) THEN printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."
  ENDIF

  ;************************************************************
  ;; Get all indices for a given orbit to prep for resampling

  ; First val by hand
  orbArr = make_array(nOrbs,2)
  orb_i_list = LIST(WHERE(maximus.orbit(plot_i) EQ (maximus.orbit(plot_i))(uniqueOrbs_ii(0))))
  
  orbArr[0,0] = (maximus.orbit(plot_i))(uniqueOrbs_ii(0))
  orbArr[0,1] = N_ELEMENTS(orb_i_list(0))

  ;; ;there should be no possibility of nulls here
  ;; FOR i=0,nOrbs-1 DO PRINT,WHERE(orb_i_list(i,*) EQ -1)
;
  FOR i=1,nOrbs-1 DO BEGIN
     orb_i_list.ADD,WHERE(maximus.orbit(plot_i) EQ (maximus.orbit(plot_i))(uniqueOrbs_ii(i))) ;get the indices
     
     orbArr[i,0] = (maximus.orbit(plot_i))(uniqueOrbs_ii(i))
     orbArr[i,1] = N_ELEMENTS(orb_i_list(i))
  ENDFOR

  ;************************************************************
  ;Now resample these
  orb_i_min_and_diff = MAKE_ARRAY(nOrbs,2)
  ;; resamplers = WHERE(orbArr[*,1] GT 1)

  FOR j=0,nOrbs-1 DO orb_i_min_and_diff[j,*]=[[min(orb_i_list(j))],[max(orb_i_list(j))-min(orb_i_list(j))+1]]

  ;; ;Generate N sets of resampled indices
  
  IF KEYWORD_SET(maxNSampPerOrb) THEN BEGIN
     sampTot=0
     FOR jj=0,nOrbs-1 DO BEGIN
        IF orbArr[jj,1] GT maxNSampPerOrb THEN orbArr[jj,1] = maxNSampPerOrb
        sampTot+=orbArr[jj,1]
     ENDFOR
     PRINT,'Hucking out ' + STRCOMPRESS(N_ELEMENTS(plot_i)-sampTot,/REMOVE_ALL) + " events based on maxNSampPerOrb requirement"
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(reduceNSampByFactor) THEN BEGIN
        sampTot=0
        FOR jj=0,nOrbs-1 DO BEGIN
           orbArr[jj,1] = CEIL(orbArr[jj,1]/reduceNSampByFactor)
           sampTot+=orbArr[jj,1]
        ENDFOR
        PRINT,'Hucking out ' + STRCOMPRESS(N_ELEMENTS(plot_i)-sampTot,/REMOVE_ALL) + " events based on maxNSampPerOrb requirement"
     ENDIF ELSE sampTot = N_ELEMENTS(plot_i)
  ENDELSE
  resampled_ii = MAKE_ARRAY(sampTot,N)
  
  FOR j=0,N-1 DO BEGIN
     
     ;; ; initialize resampled_ii
     IF orbArr[0,1] GT 1 THEN BEGIN 
        resampled_ii(0:orbArr[0,1]-1,j) = FIX(RANDOMU(seed,orbArr[0,1])*orb_i_min_and_diff[0,1])+orb_i_min_and_diff[0,0]
        cur_i=orbArr[0,1]
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(reduceNSampByFactor) THEN $
           resampled_ii(0,j) = FIX(RANDOMU(seed)*orb_i_min_and_diff[0,1])+orb_i_min_and_diff[0,0] $
        ELSE resampled_ii(0,j) = orb_i_list(0)
        cur_i=1
     ENDELSE
     
     ;; ;loop over the rest
     FOR jj=1,nOrbs-1 DO BEGIN
        IF orbArr[jj,1] GT 1 THEN BEGIN
           ;; print,"For orb " + STRCOMPRESS(orbArr[jj,0]) + ", adding " + strcompress(orbArr[jj,1],/REMOVE_ALL) + " elements to resampled i:"
           ;; print,FIX(RANDOMU(seed,orbArr[jj,1])*orb_i_min_and_diff[jj,1])+orb_i_min_and_diff[jj,0]
           resampled_ii(cur_i:cur_i+orbArr[jj,1]-1,j) = FIX(RANDOMU(seed,orbArr[jj,1])*orb_i_min_and_diff[jj,1])+orb_i_min_and_diff[jj,0]
           cur_i+=orbArr[jj,1]
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(reduceNSampByFactor) THEN $
              resampled_ii(cur_i,j) = FIX(RANDOMU(seed)*orb_i_min_and_diff[jj,1])+orb_i_min_and_diff[jj,0] $
           ELSE resampled_ii(cur_i,j) = orb_i_list(jj)
           cur_i++
           ;; print,cur_i
        ENDELSE
        
     ENDFOR
  ENDFOR


  RETURN,plot_i(resampled_ii)

END