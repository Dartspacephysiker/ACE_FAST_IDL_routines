;+
; NAME: KOLMOGOROV_SMIRNOV_NEVENTS
;
;
;
; PURPOSE: Perform a kolmogorov-smirnov statistical test to see whether our distribution of alfven events 
;           is significantly different from the original Chaston DB.
;
; CATEGORY: Are you serious? Everyone knows the answer to this.
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY: 2015/03/31
;                       Birth
;-

PRO KOLMOGOROV_SMIRNOV_NEVENTS,DBFILE=dbFile,DAYSIDE=dayside,NIGHTSIDE=nightside, $
                               CHARESCR=chareScr,ABSMAGCSCR=absMagcScr, $
                               PLOTPREFIX=plotPrefix,OUTFILESUFFIX=outFileSuffix, $
                               PLOT_I_FILE=plot_i_file, PLOT_I_DIR=plot_i_dir, $
                               PLOT2_I_FILE=plot2_i_file, $
                               KS_STATS_STRUCT=ks_stats, $
                               KS_STATS_FILENAME=ks_stats_filename, $
                               DO_CHASTDB=do_Chastdb
                           
  ; today
  hoyDia= STRCOMPRESS(STRMID(SYSTIME(0), 4, 3),/REMOVE_ALL) + "_" + $
          STRCOMPRESS(STRMID(SYSTIME(0), 8,2),/REMOVE_ALL) + "_" + STRCOMPRESS(STRMID(SYSTIME(0), 22, 2),/REMOVE_ALL)

  ;;defaults
  defDBFile = "scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav"
  defDartmouthdb_nEvents_I_file = 'PLOT_INDICES_for_nEvent_comparison--DartDB_02282015--North_all_IMF--wholecap--OMNI_GSM_Apr_2_15.sav'
  defHisto1_title = "Dartmouth DB"

  defChastDBFile = "/SPENCEdata/Research/Cusp/database/processed/maximus.dat"
  defChastondb_nEvents_I_file = 'PLOT_INDICES_for_nEvent_comparison--original_ChastDB--North_all_IMF--wholecap--OMNI_GSM_Apr_2_15.sav'
  defChastonDBTitle = "Chaston DB"

  defKS_stats_filename = 'ks_stats--nEvent_comparison--DartDB_ChastDB--' ;we add paramStr1 to this as well

  IF NOT KEYWORD_SET(outFileSuffix) THEN outFileSuffix = ""
  ;; outFileSuffix = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE_min10current"
  ;; outFileSuffix = "min10current"

  defPlotPrefix = ''
  
  defPlot_i_dir = 'plot_indices_saves/'

  defMaxHistoBins = 1000

  lun = -1 ;use stdout

  defMinM = 0
  defMaxM = 24
  ;; defBinM = 0.5
  defBinM = 1

  defMinI = 60
  defMaxI = 88
  defBinI = 3.0

  IF NOT KEYWORD_SET(minM) THEN minM = defMinM
  IF NOT KEYWORD_SET(maxM) THEN maxM = defMaxM
  IF NOT KEYWORD_SET(binM) THEN binM = defBinM

  IF NOT KEYWORD_SET(minI) THEN minI = defMinI
  IF NOT KEYWORD_SET(maxI) THEN maxI = defMaxI
  IF NOT KEYWORD_SET(binI) THEN binI = defBinI

  IF NOT KEYWORD_SET(maxHistoBins) THEN maxHistoBins = defMaxHistoBins

  ;**********************************
  ; set some defaults

  

  IF NOT KEYWORD_SET(plotPrefix) THEN plotPrefix = defPlotPrefix

  IF NOT KEYWORD_SET(dbFile) THEN BEGIN
     print,"Using def dB file, " + defDBFile
     dbFile=defDBFile
  ENDIF
  restore,defDBFile
  
  IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

  IF NOT KEYWORD_SET(ks_stats_filename) THEN BEGIN
     buildFileName = 1 ;make our own filename?
     ks_stats_filename = defKS_stats_filename ;add paramStr1 below
  ENDIF ELSE buildFilename = 0

  ;;****************************************
  ;;screen on maximus? YES

  IF NOT KEYWORD_SET(dbFile) THEN restore,defDBFile ELSE restore,dbFile
  
  IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

  ;;names of the POSSIBILITIES
  maxTags=tag_names(maximus)

  IF NOT KEYWORD_SET(plot_i_file) THEN BEGIN
     plot_i_file = defDartmouthdb_nEvents_I_file
  ENDIF

  restore,plot_i_dir+plot_i_file
  printf,lun,""
  printf,lun,"**********DATA SUMMARY FOR PLOT 1 FILE**********"
  printf,lun,"Plot_i_file: " + plot_i_file
  printf,lun,"DBFile: " + dbFile
  printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
  printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
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
         strtrim((N_ELEMENTS(plot_i))/DOUBLE(n_elements(maximus.orbit))*100.0,2) + "%"
  
  ;; maximus = resize_maximus(maximus,INDS=plot_i)
  comparison1_i = plot_i

  ;; outFileSuffix = "kolmogorov_smirnov--" + paramStr + outFileSuffix

  histo1_title = paramStr
  paramStr1 = paramStr
  
  IF (buildFileName) THEN ks_stats_filename = ks_stats_filename + paramStr1


  ;;****************************************
  ;;chastonDBfile

  ;restore ChastDB and rename maximus
  dartMaximus = maximus
  restore,defChastDBFile
  chastMaximus = maximus
  maximus = dartMaximus ; the ol' switcheroo

  IF NOT KEYWORD_SET(plot2_i_file) THEN BEGIN
     print,"Using default chastondb_nEvents_I_file, " + defChastondb_nEvents_I_file
     plot2_i_file = defChastondb_nEvents_I_file
     WAIT,0.5
     histo2_title = defChastonDBTitle
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(plot2_i_file) THEN BEGIN
        restore,plot_i_dir+plot2_i_file
        histo2_title = paramStr
     ENDIF
  ENDELSE

  IF KEYWORD_SET(plot2_i_file) THEN BEGIN
     restore,plot_i_dir+plot2_i_file
     printf,lun,""
     printf,lun,"**********DATA SUMMARY FOR "+histo2_title+"**********"
     printf,lun,"Plot_i_file: " + plot2_i_file
     printf,lun,"DBFile: " + dbFile
     printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
     printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
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
            strtrim((N_ELEMENTS(plot_i))/DOUBLE(n_elements(chastMaximus.orbit))*100.0,2) + "%"
     
     comparison2_i = plot_i
     paramStr2 = paramStr
     IF (buildFileName) THEN ks_stats_filename = ks_stats_filename + "--" + paramStr2 + outFileSuffix
  ENDIF

  ;;****************************************


  ;"Key" data products (I guess they're key)
  ;; print,maxTags(3)      ;alt
  ;; print,maxTags(6)      ;mag_current
  ;; print,maxTags(8)      ;elec_energy_flux
  ;; print,maxTags(12)     ;max_chare_losscone
  ;; print,maxTags(22)     ;delta_b
  ;; print,maxTags(23)     ;delta_e
  ;; print,maxTags(48)     ;pfluxEst
  ;; print,maxTags(4)      ;MLT
  ;; print,maxTags(5)      ;ILAT

  ;; optional
  ;; print,maxTags(21)     ;width_x
  ;; print,maxTags(20)     ;width.time
  
  ;; maxStructInd = [3,6]
  ;; maxStructInd = [3,6,8,12,22,23,48]
  ;; maxStructInd = [3,6,8,12,22,23,48,4,5]

  ;;IF KEYWORD_SET(do_ChastDB) THEN maxStructInd = [3,4] ELSE maxStructInd = [4,5]
  ;Remember that Chaston DB has indices 3 and 4 for MLT and ILAT, respectively
  maxStructInd = [4,5]

  nDataz = n_elements(maxStructInd)

  maxStructLims=make_array(n_elements(maxStructInd),2)

  ;; limits imposed by alfven_db_cleaner
  ;; maxStructLims[0,*] = [0,5000] ; alt
  ;; maxStructLims[1,*] = [-500,500] ; mag_current
  ;; maxStructLims[2,*] = [0,1e3] ; elec_energy_flux
  ;; maxStructLims[3,*] = [4,4e3] ; max_chare_losscone
  ;; maxStructLims[4,*] = [5,1e3] ; delta_b
  ;; maxStructLims[5,*] = [10,1e4] ; delta_e
  ;; maxStructLims[6,*] = [1e-5,10] ; pfluxEst--database has no imposed limit for pflux, but we impose one

  ;; maxStructLims[0,*] = [0,4300] ; alt
  ;; maxStructLims[1,*] = [-250,250] ; mag_current
  ;; maxStructLims[2,*] = [1e-3,100] ; elec_energy_flux
  ;; maxStructLims[3,*] = [4,4000] ; max_chare_losscone
  ;; maxStructLims[4,*] = [5,1000] ; delta_b
  ;; maxStructLims[5,*] = [10,10000] ; delta_e
  ;; maxStructLims[6,*] = [1e-5,0.1]  ; pfluxEst

  ;; maxStructLims[7,*] = [0,24] ; MLT
  ;; maxStructLims[8,*] = [60,84]  ; ILAT
  
  maxStructLims[0,*] = [minM,maxM] ; MLT
  maxStructLims[1,*] = [minI,maxI]  ; ILAT

  ;; now handle bin sizes

  maxStructBinSizes = make_array(n_elements(maxStructInd))

  maxStructBinSizes[0] = binM
  maxStructBinSizes[1] = binI
  
  ;; maxStructLog = MAKE_ARRAY(n_elements(maxStructInd), VALUE=0)
  ;; maxStructLog[2] = 1
  ;; maxStructLog[3] = 1
  ;; maxStructLog[4] = 1
  ;; maxStructLog[5] = 1
  ;; maxStructLog[6] = 1

  ; log it up
  ;; FOR k=0,n_elements(maxStructInd)-1 DO BEGIN
  ;;    IF maxStructLog[k] THEN BEGIN
  ;;       mS_k = (maxStructInd[k])
  ;;       maximus.(mS_k) = ALOG10(maximus.(mS_k))
  ;;       maxStructLims[k,*] = ALOG10(maxStructLims[k,*])
  ;;    ENDIF
  ;; ENDFOR

  ks_stats ={ks_statistic:make_array(nDataz,/DOUBLE), $
             pVal:make_array(nDataz,/DOUBLE), $
             dataProd:make_array(nDataz,/STRING), $
             histoBinSize:make_array(nDataz,/DOUBLE), $
             binLocs1:make_array(nDataz,maxHistoBins), $
             binLocs2:make_array(nDataz,maxHistoBins), $
             histoLims:make_array(nDataz,2,/DOUBLE), $
             histo1:make_array(nDataz,maxHistoBins), $
             histo2:make_array(nDataz,maxHistoBins), $
             cHisto1:make_array(nDataz,maxHistoBins), $
             cHisto2:make_array(nDataz,maxHistoBins), $
             nHistBins:make_array(nDataz), $
             paramStr1:paramStr1, $
             paramStr2:paramStr2}

  ; compare distributions in MLT and ILAT for comparison1_i and comparison2_i
  FOR i=0,nDataz-1 DO BEGIN

     mS_i = maxStructInd(i)
     cS_i = maxStructInd(i)-1
     ;; histo1 = histogram((maximus.(mS_i))(comparison1_i),binsize=maxStructBinSizes[i],MIN=maxStructLims[i,0],MAX=maxStructLims[i,1],OMAX=oMax1,omin=oMin1
     ;; histo2 = histogram((maximus.(mS_i))(comparison2_i),binsize=maxStructBinSizes[i],MIN=maxStructLims[i,0],MAX=maxStructLims[i,1],OMAX=oMax2,omin=oMin2

     ;histogram and histoplot the data
     ;PROBABILITY FUNCTION and OPROBABILITY give the CDF and a plot of the CDF scaled from 0 to 1, respectively
     cghistoplot,(maximus.(mS_i))(comparison1_i), $
                 BINSIZE=maxStructBinSizes[i], LOCATIONS = locations1, $
                 HISTDATA=histo1,PROBABILITY_FUNCTION=cHisto1,/OPROBABILITY, $
                 MININPUT=maxStructLims[i,0],MAXINPUT=maxStructLims[i,1], $
                 OMAX=oMax1,OMIN=oMin1, $
                 TITLE=histo1_title, $
                 OUTPUT="histo_cdf--"+plotPrefix+maxTags[mS_i]+"--"+histo1_title+".png"

     cghistoplot,(chastMaximus.(cS_i))(comparison2_i), $
                 BINSIZE=maxStructBinSizes[i], LOCATIONS = locations2, $
                 HISTDATA=histo2,PROBABILITY_FUNCTION=cHisto2,/OPROBABILITY, $
                 MININPUT=maxStructLims[i,0],MAXINPUT=maxStructLims[i,1], $
                 OMAX=oMax2,OMIN=oMin2, $
                 TITLE=histo2_title, $
                 OUTPUT="histo_cdf--"+plotPrefix+maxTags[mS_i]+"--"+histo2_title+".png"

     ;cumulative histograms
     ;just let cghistoplot make these for you--that routine does a better job
     ;; cHisto1 = TOTAL(histo1,/CUMULATIVE) / N_ELEMENTS(comparison1_i)
     ;; cHisto2 = TOTAL(histo2,/CUMULATIVE) / N_ELEMENTS(comparison2_i)

     ;perform the K-S test
     kstwo, histo1, histo2, KS_statistic, pVal

     ;num elements in these histos
     nHistBins = n_elements(histo1)

     ;populate the struct
     ks_stats.ks_statistic(i)=KS_statistic
     ks_stats.pVal(i)=pVal
     ks_stats.dataProd(i)=maxTags[mS_i]
     ks_stats.histoBinSize(i) = maxStructBinSizes(i)
     ks_stats.nHistBins(i) = nHistBins
     ks_stats.binLocs1(i,0:nHistBins -1) = locations1 + maxStructBinSizes(i)/2.0
     ks_stats.binLocs2(i,0:nHistBins -1) = locations2 + maxStructBinSizes(i)/2.0
     ks_stats.histo1(i,0:nHistBins -1) = histo1
     ks_stats.histo2(i,0:nHistBins -1) = histo2
     ks_stats.cHisto1(i,0:nHistBins -1) = cHisto1
     ks_stats.cHisto2(i,0:nHistBins -1) = cHisto2

     ;summary time
     printf,lun,'******KS SUMMARY FOR ' + maxTags(mS_i) + '******'
     printf,lun,''
     printf,lun,FORMAT='("N ELEMENTS, SET 1: ",T30,I0)',n_elements(comparison1_i)
     printf,lun,FORMAT='("N ELEMENTS, SET 2: ",T30,I0)',n_elements(comparison2_i)
     printf,lun,''
     printf,lun,FORMAT='("Data product: ",T30,A0)',maxTags(mS_i)
     printf,lun,FORMAT='("KS Statistic: ",T30,F0.8)',KS_statistic
     printf,lun,FORMAT='("P Value: ",T30,G11.3)',pVal

  ENDFOR

  printf,lun,"Saving " + ks_stats_filename+"--"+hoyDia+'.sav'
  save,ks_stats,filename=ks_stats_filename+"--"+hoyDia+'.sav'

END